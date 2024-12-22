#!/bin/dash

PATH="$PATH:$(pwd)"

test_dir="$(mktemp -d)"
cd "$test_dir" || exit 1

expected_output="$(mktemp)"
actual_output="$(mktemp)"

trap 'rm "$expected_output" "$actual_output" -rf "$test_dir"' INT HUP QUIT TERM EXIT

# Test to commit files when grip does not exist
# Should print "grip-commit: error: grip repository directory .grip not found" to stderr with exit status 1
2041 grip-commit "-m" a > "$expected_output" 2>&1
exp_exit_code=$(echo $?)
grip-commit "-m" a > "$actual_output" 2>&1
actual_exit_code=$(echo $?)

if [ "$exp_exit_code" -eq "$actual_exit_code" ] && [ "$exp_exit_code" -eq 1 ]
then
        if diff -Z "$actual_output" "$expected_output"
        then
                echo "Test 1 - Committing with no grip repository - passed"
        else
                echo "Test 1 - Committing with no grip repository - failed"
        fi
else
        echo "Test 1 - Committing with no grip repository - failed"
fi