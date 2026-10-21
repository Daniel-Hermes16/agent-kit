#!/usr/bin/env bash
# skill-lint.sh — deterministic checks for one agent skill folder.
#
# Usage: bash skill-lint.sh <skill-folder> [denylist-file]
#   <skill-folder>   folder that contains SKILL.md
#   [denylist-file]  optional private file, one extended regex per line, of
#                    terms that must not appear (names, keys, internal hosts).
#                    Keep it outside the skill folder.
#
# Prints PASS / WARN / FAIL lines and a RESULT summary.
# Exit code: 0 when there is no FAIL, 1 otherwise, 2 on usage error.
# Portable to bash 3.2 and BSD/GNU userlands.

set -u

dir="${1:-}"
deny="${2:-}"
if [ -z "$dir" ] || [ ! -d "$dir" ]; then
  echo "usage: bash skill-lint.sh <skill-folder> [denylist-file]" >&2
  exit 2
fi
dir="${dir%/}"
skill="$dir/SKILL.md"
folder="$(basename "$dir")"
fails=0
warns=0

pass() { echo "PASS  $1"; }
warn() { echo "WARN  $1"; warns=$((warns + 1)); }
fail() { echo "FAIL  $1"; fails=$((fails + 1)); }

if [ ! -f "$skill" ]; then
  fail "SKILL.md exists: not found in $dir"
  echo "RESULT: $fails FAIL, $warns WARN"
  exit 1
fi
pass "SKILL.md exists"

# --- frontmatter -----------------------------------------------------------
first="$(head -n 1 "$skill")"
fm_end="$(awk 'NR>1 && /^---[[:space:]]*$/ {print NR; exit}' "$skill")"
if [ "$first" != "---" ] || [ -z "$fm_end" ]; then
  fail "frontmatter: SKILL.md must start with a '---' block"
  fm=""
else
  pass "frontmatter block present (lines 1-$fm_end)"
  fm="$(sed -n "2,$((fm_end - 1))p" "$skill")"
fi

name="$(printf '%s\n' "$fm" | awk -F': *' '/^name:/ {print $2; exit}' | tr -d '"'"'"' ')"
if [ -z "$name" ]; then
  fail "#1 name: missing"
else
  len=${#name}
  if ! printf '%s' "$name" | grep -Eq '^[a-z0-9]+(-[a-z0-9]+)*$'; then
    fail "#1 name: '$name' is not lowercase kebab-case"
  elif [ "$len" -gt 64 ]; then
    fail "#1 name: '$name' is $len chars (max 64)"
  elif [ "$name" != "$folder" ]; then
    fail "#1 name: '$name' does not match folder '$folder'"
  else
    pass "#1 name: '$name' ($len chars, matches folder)"
  fi
fi

desc_line="$(printf '%s\n' "$fm" | grep -E '^description:' | head -n 1)"
desc="$(printf '%s\n' "$fm" | awk '
  /^description:/ {on=1; sub(/^description:[[:space:]]*[>|]?-?[[:space:]]*/, ""); print; next}
  on && /^[A-Za-z_][A-Za-z0-9_-]*:/ {on=0}
  on {print}
' | tr '\n' ' ')"
if [ -z "$desc_line" ]; then
  fail "#2 description: missing"
else
  if printf '%s' "$desc_line" | grep -Eq '^description:[[:space:]]*>'; then
    pass "K1 description uses a folded '>' block"
  else
    warn "K1 description: not a folded 'description: >' block"
  fi
  if printf '%s' "$desc" | grep -Eqi 'use (it )?when|use this when'; then
    pass "#2 description has a 'Use when' clause"
  else
    fail "#2 description: no 'Use when…' clause"
  fi
  quoted="$(printf '%s' "$desc" | grep -Eo '"[^"]{3,}"' | wc -l | tr -d ' ')"
  if [ "$quoted" -ge 2 ]; then
    pass "#3 description lists $quoted quoted trigger phrases"
  elif [ "$quoted" -eq 1 ]; then
    warn "#3 description lists only 1 quoted trigger phrase"
  else
    fail "#3 description: no quoted trigger phrases"
  fi
fi

# --- length ----------------------------------------------------------------
lines="$(wc -l < "$skill" | tr -d ' ')"
if [ "$lines" -lt 500 ]; then
  pass "#8 length: $lines lines"
else
  fail "#8 length: $lines lines (must be under 500)"
fi

# --- sections --------------------------------------------------------------
has_heading() { grep -Eqi "^#{2,3} .*($1)" "$skill"; }

ap_count="$(awk '
  /^#{2,3} / { on = (tolower($0) ~ /anti-pattern|anti pattern|don.t/) ; next }
  on && /^[[:space:]]*([-*]|[0-9]+\.)[[:space:]]/ {n++}
  END {print n+0}
' "$skill")"
if ! has_heading 'anti-pattern|anti pattern'; then
  fail "#6 anti-patterns: no anti-patterns section"
elif [ "$ap_count" -lt 2 ]; then
  fail "#6 anti-patterns: only $ap_count item(s)"
else
  pass "#6 anti-patterns: $ap_count items"
fi

if has_heading 'output'; then pass "#7 output section present"; else fail "#7 output: no output section"; fi
if has_heading 'workflow|steps|mode'; then pass "K1 workflow/steps section present"; else warn "K1 no workflow/steps section"; fi
if has_heading 'input|stop'; then pass "K1 inputs/stop-conditions section present"; else warn "K1 no inputs/stop-conditions section"; fi
if has_heading 'self-check|self check|before delivering'; then pass "K1 self-check section present"; else warn "K1 no self-check section"; fi
if has_heading 'reference'; then pass "K1 references section present"; else warn "K1 no references section"; fi

# --- folder hygiene --------------------------------------------------------
bad=""
for entry in "$dir"/* "$dir"/.[!.]*; do
  [ -e "$entry" ] || continue
  base="$(basename "$entry")"
  case "$base" in
    SKILL.md|references|scripts|assets) ;;
    *) bad="$bad $base" ;;
  esac
done
if [ -n "$bad" ]; then
  fail "K2 folder hygiene: unexpected entries:$bad"
else
  pass "K2 folder hygiene: only SKILL.md + allowed folders"
fi

# --- relative links (outside code fences) ----------------------------------
broken=0
md_files="$(find "$dir" -type f -name '*.md')"
for f in $md_files; do
  fdir="$(dirname "$f")"
  links="$(awk '
    /^[[:space:]]*(```|~~~)/ {fence = !fence; next}
    !fence {print}
  ' "$f" | grep -Eo '\]\([^)[:space:]]+\)' | sed -E 's/^\]\(//; s/\)$//')"
  for link in $links; do
    case "$link" in
      http://*|https://*|mailto:*|\#*) continue ;;
    esac
    target="${link%%#*}"
    [ -z "$target" ] && continue
    if [ ! -e "$fdir/$target" ]; then
      echo "      broken link in ${f#"$dir"/}: $link"
      broken=$((broken + 1))
    fi
  done
done
if [ "$broken" -eq 0 ]; then
  pass "K2 relative links resolve"
else
  warn "K2 $broken relative link(s) do not resolve (fine only if the target is created elsewhere in the library)"
fi

# --- secrets and personal data ---------------------------------------------
secret_re='ghp_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,}|AKIA[0-9A-Z]{16}|xox[baprs]-[A-Za-z0-9-]{10,}|BEGIN [A-Z ]*PRIVATE KEY|(password|passwd|secret|token|api[_-]?key)[[:space:]]*[:=][[:space:]]*["'"'"'][^"'"'"'<$]{8,}["'"'"']'
if grep -rnEI "$secret_re" "$dir" >/dev/null 2>&1; then
  fail "K4 possible secret found:"
  grep -rnEI "$secret_re" "$dir" | sed 's/^/      /'
else
  pass "K4 no secret-like strings"
fi

pii_re='[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}|/(Users|home)/[A-Za-z0-9._-]+/|[Cc]:\\Users\\'
if grep -rnEI "$pii_re" "$dir" >/dev/null 2>&1; then
  warn "K4 possible email address or absolute home path (check for personal data):"
  grep -rnEI "$pii_re" "$dir" | sed 's/^/      /'
else
  pass "K4 no email addresses or absolute home paths"
fi

# --- private denylist --------------------------------------------------------
if [ -n "$deny" ]; then
  if [ ! -f "$deny" ]; then
    fail "K4 denylist: file not found: $deny"
  elif grep -rniEI -f "$deny" "$dir" >/dev/null 2>&1; then
    fail "K4 denylist terms found:"
    grep -rniEI -f "$deny" "$dir" | sed 's/^/      /'
  else
    pass "K4 denylist: no matches"
  fi
else
  warn "K4 no denylist given; run with a private denylist before sharing"
fi

echo "RESULT: $fails FAIL, $warns WARN"
[ "$fails" -eq 0 ]
