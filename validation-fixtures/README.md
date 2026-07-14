# Validation Fixtures — prove each CI gate BLOCKS

These files are **intentionally broken**. Each trips exactly one CI gate. Use
them to prove your pipeline *guards* (blocks bad code), not just that it *runs*.

They are **excluded from the normal build** (not referenced by any CMakeLists),
so they never break your baseline. The workflow is:

1. Baseline on `develop` is green (skeleton passes all gates).
2. For each fixture, create a throwaway branch, copy the fixture into the place
   the gate scans, open a PR, and **confirm the PR is blocked** by that gate.
3. Delete the throwaway branch. Do NOT merge fixtures.

| Fixture | Gate it should trip | How to use |
|---------|--------------------|------------|
| `format_violation.cpp` | clang-format | copy into `src/`, PR → format check fails |
| `lint_violation.cpp` | clang-tidy / cppcheck | copy into `src/`, build with analysis → fails |
| `failing_test.cpp` | CTest | replace a test body, PR → test check fails |
| `Broken.qml` | qmllint | copy into `qml/`, PR → qmllint check fails |
| `warning_violation.cpp` | warnings-as-errors (build) | copy into `src/`, build → compile error |

Expected result for every one: **the PR cannot be merged** because a required
status check is red. If any fixture merges cleanly, that gate is NOT configured
correctly — fix the pipeline before real development starts.
