#!/bin/dash

# This script will test grip-init

PATH="$PATH:$(pwd)"

test_dir="$(mktemp -d)"
cd "$test_dir" || exit 1

expected_output="$(mktemp)"
actual_output="$(mktemp)"

trap 'rm "$expected_output" "$actual_output" -rf "$test_dir"' INT HUP QUIT TERM EXIT

# Test to check correct usage of grip-init
# Should print "usage: grip-init" to stderr with exit status 1
2041 grip-init unneccessary_arg > "$expected_output" 2>&1
exp_exit_code=$(echo $?)
grip-init unneccessary_arg > "$actual_output" 2>&1
actual_exit_code=$(echo $?)

if [ "$exp_exit_code" -eq "$actual_exit_code" ] && [ "$exp_exit_code" -eq 1 ]
then
        if diff -Z "$actual_output" "$expected_output"
        then
                echo "Test 1 - Incorrect usage - passed"
        else
                echo "Test 1 - Incorrect usage - failed"
        fi
else
        echo "Test 1 - Incorrect usage - failed"
fi

# Test to check successful initialisation of .grip
# Should print "Initialised empty grip repository in .grip" to stdout with exit status 0
2041 grip-init > "$expected_output" 2>&1
exp_exit_code=$(echo $?)
rm -rf .grip
grip-init > "$actual_output" 2>&1
actual_exit_code=$(echo $?)
rm -rf .grip

if [ "$exp_exit_code" -eq "$actual_exit_code" ] && [ "$exp_exit_code" -eq 0 ]
then
        if diff -Z "$actual_output" "$expected_output"
        then
                echo "Test 2 - Initialised .grip - passed"
        else
                echo "Test 2 - Initialised .grip - failed"
        fi
else
        echo "Test 2 - Initialised .grip - failed"
fi
