#!/usr/bin/env bash
# validate-gates.sh
# Local dry-run of the gate-validation harness. For each fixture, temporarily
# stages it where the relevant gate scans, runs the check, and asserts the
# check FAILS (a fixture that passes means the gate is misconfigured).
#
# This is a convenience for local checking; the authoritative validation is
# running the fixtures through actual PRs against a protected branch (see
# validation-fixtures/README.md).
set -u
FIX=validation-fixtures
pass=0; fail=0

expect_fail() {  # name, command...
    local name="$1"; shift
    if "$@" >/dev/null 2>&1; then
        echo "  [MISCONFIGURED] $name : check PASSED on broken input (gate not guarding)"
        fail=$((fail+1))
    else
        echo "  [OK] $name : gate correctly blocked broken input"
        pass=$((pass+1))
    fi
}

echo "== clang-format gate =="
command -v clang-format >/dev/null && \
    expect_fail "format_violation" clang-format --dry-run --Werror "$FIX/format_violation.cpp" \
    || echo "  (clang-format not installed; skipped)"

echo "== cppcheck gate =="
command -v cppcheck >/dev/null && \
    expect_fail "lint_violation" cppcheck --enable=warning,style --error-exitcode=1 --std=c++17 -I include "$FIX/lint_violation.cpp" \
    || echo "  (cppcheck not installed; skipped)"

echo "== qmllint gate =="
command -v qmllint >/dev/null && \
    expect_fail "Broken.qml" qmllint --strict "$FIX/Broken.qml" \
    || echo "  (qmllint not installed; skipped)"

echo
echo "Summary: $pass gate(s) correctly blocked, $fail misconfigured."
[ "$fail" -eq 0 ] || exit 1
