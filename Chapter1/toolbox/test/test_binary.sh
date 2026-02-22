#!/usr/bin/env bash
set -u

BIN="./_build/default/bin/main.exe"

pass=0
fail=0

dune build

run_test() {
  local name="$1"
  local expected="$2"
  local actual="$3"

  if [ "$actual" = "$expected" ]; then
    printf 'PASS: %s\n' "$name"
    pass=$((pass + 1))
  else
    printf 'FAIL: %s\n' "$name"
    printf '  expected: %s\n' "$expected"
    printf '  actual:   %s\n' "$actual"
    fail=$((fail + 1))
  fi
}

if [ ! -x "$BIN" ]; then
  echo "Building binary..."
  dune build || exit 1
fi

sum_out="$(printf '1\n2\n3\n' | "$BIN" sum_list)"
run_test "sum_list sums stdin integers" "Answer: 6" "$sum_out"

grep_out="$(printf 'apple\nbanana\napricot\n' | "$BIN" grep ap)"
run_test "grep filters substring matches" $'Answer: \napple\napricot' "$grep_out"

dedup_out="$(printf '1\n1\n2\n3\n3\n3\n4\n4\n2\n2\n' | "$BIN" remove_duplicates)"
run_test "remove_duplicates removes sequential duplicates" "Answer:  1 2 3 4 2" "$dedup_out"

first_neg_out="$("$BIN" find_first_negative '1 3 -2 4')"
run_test "find_first_negative finds first negative" "Answer: Some 2" "$first_neg_out"

none_neg_out="$("$BIN" find_first_negative '1 2 3 4')"
run_test "find_first_negative no negative case (current behavior)" "Answer: Some None" "$none_neg_out"

printf '\nResult: %d passed, %d failed\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
