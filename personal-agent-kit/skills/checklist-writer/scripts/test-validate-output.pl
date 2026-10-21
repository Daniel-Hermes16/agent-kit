#!/usr/bin/env perl
#
# Regression tests for validate-output.pl. Run from anywhere:
#   perl test-validate-output.pl
#
# Each case starts from one well-formed combined draft, applies a single
# breaking edit, and checks both the exit status and the reported reason.

use strict;
use warnings;
use utf8;
use File::Temp qw(tempfile);
use FindBin qw($Bin);
use Test::More;

binmode Test::More->builder->$_, ':encoding(UTF-8)' for qw(output failure_output);

my $VALIDATOR = "$Bin/validate-output.pl";

sub good_draft {
    my $baseline = join "\n", map { "* **Applicable —** Generic baseline check number $_" } 1 .. 20;
    return <<"DRAFT";
--- Exploratory testing
* Poke around the new settings screen with unusual data.

## 1. Generic checklist checks
$baseline

--- RC-TESTING
* Re-check areas touched by merge conflict resolution.

## 2. Acceptance Criteria Coverage Test Cases
* Verify that the settings screen opens from the profile menu. (Traceability: AC-1)

## 3. Expected Edge Case Test Cases
* Verify that the screen restores after the app returns from background. (Traceability: AC-1)

## 4. Optional Edge Case Test Cases
* Verify that double-tapping the menu entry opens one screen only. (Traceability: AC-1)

## 5. Proposed Manual Test Cases for Verification Evidence
## Test Case Title: Settings screen opens from the profile menu

**Test Case ID:** TC-42-01
**Source:** DEMO-42
**Platform:** iOS
**Traceability:** AC-1

| # | Step Description | Step Result |
| ---: | --- | --- |
| 1 | Open the profile menu and tap Settings. | The settings screen is shown. |

<details><summary>Constraints and human decisions</summary>

No additional constraints or human decisions identified from the available evidence

</details>

<details><summary>Automation references</summary>

No additional automation references identified from the available evidence

</details>
DRAFT
}

# Writes the draft beside this script (never the system temp dir); File::Temp
# deletes it at exit. Returns the exit code and combined STDOUT/STDERR.
sub run_validator {
    my ($draft, @args) = @_;
    my ($fh, $path) = tempfile('validate-test-XXXXXX', DIR => $Bin, SUFFIX => '.md', UNLINK => 1);
    binmode $fh, ':encoding(UTF-8)';
    print {$fh} $draft;
    close $fh;
    my $output = qx{"$^X" "$VALIDATOR" @{[ map { "'$_'" } @args, $path ]} 2>&1};
    return ($? >> 8, $output);
}

sub swap_dropdowns {
    my ($text) = @_;
    $text =~ s/(Constraints and human decisions|Automation references)/
        $1 eq 'Automation references' ? 'Constraints and human decisions' : 'Automation references'/ge;
    return $text;
}

# [ name, edit, expected exit (0 or 'fail'), message pattern, validator args ]
my @cases = (
    [ 'accepts a valid combined output',
      sub { $_[0] }, 0, qr/^OK: combined/m,
      qw(--mode combined --require-trace AC-1) ],
    [ 'reports missing traceability',
      sub { $_[0] }, 'fail', qr/Traceability ID not found in draft: AC-2/,
      qw(--mode combined --require-trace AC-2) ],
    [ 'reports an incomplete step result',
      sub { (my $t = $_[0]) =~ s/\| The settings screen is shown\. \|/| |/; $t },
      'fail', qr/Step row at line \d+ is missing/,
      qw(--mode combined --require-trace AC-1) ],
    [ 'reports a missing scenario bullet',
      sub { (my $t = $_[0]) =~ s/^\* (Verify that double-tapping)/$1/m; $t },
      'fail', qr/Scenario line does not begin with '\*'/,
      qw(--mode combined --require-trace AC-1) ],
    [ 'reports a generic item without an evidence status',
      sub { (my $t = $_[0]) =~ s/^\* \*\*Applicable —\*\* (Generic baseline check number 7)$/* $1/m; $t },
      'fail', qr/Generic item has no .* status/,
      qw(--mode checklist) ],
    [ 'reports dropdowns out of order',
      \&swap_dropdowns, 'fail', qr/constraints dropdown followed by the automation dropdown/,
      qw(--mode combined) ],
    [ 'reports an unresolved template placeholder',
      sub { (my $t = $_[0]) =~ s/opens one screen only/opens <expected outcome>/; $t },
      'fail', qr/Template placeholders still present: <expected outcome>/,
      qw(--mode combined) ],
);

plan tests => scalar @cases;

for my $case (@cases) {
    my ($name, $edit, $expect, $pattern, @args) = @$case;
    my ($code, $output) = run_validator($edit->(good_draft()), @args);
    my $status_ok = $expect eq 'fail' ? $code == 1 : $code == $expect;
    ok($status_ok && $output =~ $pattern, $name)
        or diag("exit=$code\n$output");
}
