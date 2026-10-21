#!/usr/bin/env perl
#
# Shape linter for drafts written by checklist-writer and test-case-creator.
# It only inspects structure (headings, bullets, tables, dropdowns, trace IDs);
# whether the content is any good is still a human call.
#
#   perl validate-output.pl --mode checklist|test-case|combined \
#        [--require-trace ID]... DRAFT.md
#
# Exit codes: 0 = shape OK, 1 = problems listed on STDERR, 2 = bad arguments.
# Regression tests for this script: perl test-validate-output.pl

use strict;
use warnings;
use utf8;

binmode STDOUT, ':encoding(UTF-8)';
binmode STDERR, ':encoding(UTF-8)';

my $USAGE = "usage: $0 --mode checklist|test-case|combined [--require-trace ID]... DRAFT.md\n";

# Literal headings the templates promise, in the order they must appear.
my $H_EXPLORE  = '--- Exploratory testing';
my $H_GENERIC  = '## 1. Generic checklist checks';
my $H_RC       = '--- RC-TESTING';
my $H_AC       = '## 2. Acceptance Criteria Coverage Test Cases';
my $H_EXPECTED = '## 3. Expected Edge Case Test Cases';
my $H_OPTIONAL = '## 4. Optional Edge Case Test Cases';
my $H_MANUAL   = '## 5. Proposed Manual Test Cases for Verification Evidence';

my $DROPDOWN_CONSTRAINTS = '<details><summary>Constraints and human decisions</summary>';
my $DROPDOWN_AUTOMATION  = '<details><summary>Automation references</summary>';

my $MIN_GENERIC_ITEMS = 20;
my $STATUS_PREFIX     = qr/^\* \*\*(?:Applicable|Not applicable|Needs evidence) —\*\*/;
my $MAX_PLACEHOLDERS_SHOWN = 5;

my ($mode, $draft_path, @trace_ids) = read_arguments(@ARGV);
my $draft = read_draft($draft_path);

my @problems;
push @problems, checklist_problems($draft)  if $mode ne 'test-case';
push @problems, test_case_problems($draft)  if $mode ne 'checklist';
push @problems, dropdown_problems($draft);
push @problems, placeholder_problems($draft);
push @problems, map { "Traceability ID not found in draft: $_" }
                grep { index($draft, $_) < 0 } @trace_ids;

if (@problems) {
    print STDERR "ERROR: $_\n" for @problems;
    exit 1;
}
print "OK: $mode draft has the expected structure ($draft_path)\n";
exit 0;

# ---------------------------------------------------------------------------

sub read_arguments {
    my @args = @_;
    my ($chosen_mode, $path, @ids);
    while (defined(my $arg = shift @args)) {
        if    ($arg eq '--mode')          { $chosen_mode = shift @args }
        elsif ($arg eq '--require-trace') { push @ids, shift @args }
        elsif (!defined $path)            { $path = $arg }
        else                              { usage_error() }
    }
    usage_error() unless defined $path
        && defined $chosen_mode
        && $chosen_mode =~ /\A(?:checklist|test-case|combined)\z/;
    return ($chosen_mode, $path, grep { defined } @ids);
}

sub usage_error {
    print STDERR $USAGE;
    exit 2;
}

sub read_draft {
    my ($path) = @_;
    open my $fh, '<:encoding(UTF-8)', $path or do {
        print STDERR "ERROR: cannot open $path: $!\n";
        exit 2;
    };
    my $content = do { local $/; <$fh> };
    close $fh;
    return $content;
}

# True when every marker is found, each one after the end of the previous.
sub in_sequence {
    my ($text, @markers) = @_;
    my $cursor = 0;
    for my $marker (@markers) {
        my $hit = index $text, $marker, $cursor;
        return 0 if $hit < 0;
        $cursor = $hit + length $marker;
    }
    return 1;
}

# Non-blank lines between the first $from marker and the next $to marker.
sub lines_between {
    my ($text, $from, $to) = @_;
    return () unless $text =~ /\Q$from\E(.*?)\Q$to\E/s;
    return grep { /\S/ } split /\n/, $1;
}

sub checklist_problems {
    my ($text) = @_;
    my @found;

    push @found, 'Checklist headings are missing or not in the template order.'
        unless in_sequence($text, $H_EXPLORE, $H_GENERIC, $H_RC,
                                  $H_AC, $H_EXPECTED, $H_OPTIONAL, $H_MANUAL);

    my @generic = lines_between($text, $H_GENERIC, $H_RC);
    push @found, "Generic baseline has fewer than $MIN_GENERIC_ITEMS items."
        if @generic < $MIN_GENERIC_ITEMS;
    push @found, map { "Generic item has no Applicable / Not applicable / Needs evidence status: $_" }
                 grep { $_ !~ $STATUS_PREFIX } @generic;

    my @scenario_sections = ([$H_AC, $H_EXPECTED], [$H_EXPECTED, $H_OPTIONAL], [$H_OPTIONAL, $H_MANUAL]);
    for my $pair (@scenario_sections) {
        my ($heading, $next) = @$pair;
        my @rows = lines_between($text, $heading, $next);
        push @found, "Section '$heading' has no scenarios." unless @rows;
        push @found, map { "Scenario line does not begin with '*': $_" }
                     grep { !/^\*/ } @rows;
    }
    return @found;
}

sub test_case_problems {
    my ($text) = @_;
    my @found;

    push @found, "Missing a '## Test Case Title:' heading."
        if index($text, '## Test Case Title:') < 0;
    push @found, "Missing a '**Test Case ID:**' line."
        if index($text, '**Test Case ID:**') < 0;

    my @lines = split /\n/, $text;
    my $table_count = 0;
    my $i = 0;
    while ($i < @lines) {
        my $header = $lines[$i];
        unless ($header =~ /Step Description/ && $header =~ /Step Result/) {
            $i++;
            next;
        }
        $table_count++;
        my $header_line_no = $i + 1;
        $i += 2;    # jump over the header and its |---| separator
        my $row_count = 0;
        while ($i < @lines && $lines[$i] =~ /^\s*\|/) {
            my @cells = table_cells($lines[$i]);
            my $complete = @cells >= 3 && !grep { $_ eq '' } @cells[0 .. 2];
            push @found, 'Step row at line ' . ($i + 1) . ' is missing a number, action, or result.'
                unless $complete;
            $row_count++;
            $i++;
        }
        push @found, "Step table starting at line $header_line_no has no step rows."
            unless $row_count;
    }
    push @found, "No step table with 'Step Description' and 'Step Result' columns."
        unless $table_count;
    return @found;
}

sub table_cells {
    my ($row) = @_;
    $row =~ s/^\s*\|//;
    $row =~ s/\|\s*$//;
    return map { my $c = $_; $c =~ s/^\s+//; $c =~ s/\s+$//; $c } split /\|/, $row, -1;
}

sub dropdown_problems {
    my ($text) = @_;
    my @found;
    push @found, 'Expected the constraints dropdown followed by the automation dropdown.'
        unless in_sequence($text, $DROPDOWN_CONSTRAINTS, $DROPDOWN_AUTOMATION);
    push @found, 'Nothing may follow the closing </details> of the automation dropdown.'
        unless $text =~ m{</details>\s*\z};
    return @found;
}

sub placeholder_problems {
    my ($text) = @_;
    my @left_over = $text =~ m~
        ( < (?! /? (?:details|summary|br) \b ) [^>\n]+ >   # <angle placeholder>, except allowed HTML
        | \{\{ [^}\n]+ \}\}                                  # {{mustache placeholder}}
        )
    ~gx;
    return () unless @left_over;
    my $last = $#left_over < $MAX_PLACEHOLDERS_SHOWN - 1 ? $#left_over : $MAX_PLACEHOLDERS_SHOWN - 1;
    return 'Template placeholders still present: ' . join(', ', @left_over[0 .. $last]);
}
