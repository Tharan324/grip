#!/bin/dash

PATH="$PATH:$(pwd)"

test_dir="$(mktemp -d)"
cd "$test_dir" || exit 1

expected_output="$(mktemp)"
actual_output="$(mktemp)"

trap 'rm "$expected_output" "$actual_output" -rf "$test_dir"' INT HUP QUIT TERM EXIT

echo 1 > a

# Test to add files when grip does not exist
# Should print "grip-add: error: grip repository directory .grip not found" to stderr with exit status 1
2041 grip-add a > "$expected_output" 2>&1
exp_exit_code=$(echo $?)
grip-add a > "$actual_output" 2>&1
actual_exit_code=$(echo $?)

if [ "$exp_exit_code" -eq "$actual_exit_code" ] && [ "$exp_exit_code" -eq 1 ]
then
        if diff -Z "$actual_output" "$expected_output"
        then
                echo "Test 1 - Adding with no grip repository - passed"
        else
                echo "Test 1 - Adding with no grip repository - failed"
        fi
else
        echo "Test 1 - Adding with no grip repository - failed"
fi

# Test to add files that do not exist
# Should print "grip-add: error: can not open 'b'" to stderr with exit status 1
2041 grip-init > "$expected_output" 2>&1
2041 grip-add b > "$expected_output" 2>&1
exp_exit_code=$(echo $?)
rm -rf .grip
grip-init  > "$actual_output" 2>&1
grip-add b > "$actual_output" 2>&1
actual_exit_code=$(echo $?)
rm -rf .grip

if [ "$exp_exit_code" -eq "$actual_exit_code" ] && [ "$exp_exit_code" -eq 1 ]
then
        if diff -Z "$actual_output" "$expected_output"
        then
                echo "Test 2 - File does not exist - passed"
        else
                echo "Test 2 - File does not exist - failed"
        fi
else
        echo "Test 2 - File does not exist - failed"
fi

# Test to add files with invalid names
# Should print "grip-add: error: invalid filename '@b-file'" to stderr with exit status 1
2041 grip-init > "$expected_output" 2>&1
2041 grip-add @b-file > "$expected_output" 2>&1
exp_exit_code=$(echo $?)
rm -rf .grip
grip-init  > "$actual_output" 2>&1
grip-add @b-file > "$actual_output" 2>&1
actual_exit_code=$(echo $?)
rm -rf .grip


if [ "$exp_exit_code" -eq "$actual_exit_code" ] && [ "$exp_exit_code" -eq 1 ]
then
        if diff -Z "$actual_output" "$expected_output"
        then
                echo "Test 3 - Invalid filename - passed"
        else
                echo "Test 3 - Invalid filename - failed"
        fi
else
        echo "Test 3 - Invalid filename - failed"
fi

# Test to add files successfully for the first time
# Should print nothing and exit with status 0
2041 grip-init > "$expected_output" 2>&1
2041 grip-add a > "$expected_output" 2>&1
exp_exit_code=$(echo $?)
rm -rf .grip
grip-init  > "$actual_output" 2>&1
grip-add a > "$actual_output" 2>&1
actual_exit_code=$(echo $?)
rm -rf .grip

if [ "$exp_exit_code" -eq "$actual_exit_code" ] && [ "$exp_exit_code" -eq 0 ]
then
        if diff -Z "$actual_output" "$expected_output"
        then
                echo "Test 4 - Successful add of new file - passed"
        else
                echo "Test 4 - Successful add of new file - failed"
        fi
else
        echo "Test 4 - Successful add of new file - failed"
fi

# Test to add files successfully after modifications
# Should print nothing and exit with status 0
2041 grip-init > "$expected_output" 2>&1
2041 grip-add a > "$expected_output" 2>&1
echo 2 > a
2041 grip-add a > "$expected_output" 2>&1
exp_exit_code=$(echo $?)
rm -rf .grip
echo 1 > a
grip-init  > "$actual_output" 2>&1
grip-add a > "$actual_output" 2>&1
echo 2 > a
grip-add a > "$actual_output" 2>&1
actual_exit_code=$(echo $?)
rm -rf .grip

if [ "$exp_exit_code" -eq "$actual_exit_code" ] && [ "$exp_exit_code" -eq 0 ]
then
        if diff -Z "$actual_output" "$expected_output"
        then
                echo "Test 5 - Successful add of modified file - passed"
        else
                echo "Test 5 - Successful add of modified file - failed"
        fi
else
        echo "Test 5 - Successful add of modified file - failed"
fi

# Test to add files successfully after deletion
# Should print nothing and exit with status 0
echo 1 > a
2041 grip-init > "$expected_output" 2>&1
2041 grip-add a > "$expected_output" 2>&1
rm a
2041 grip-add a > "$expected_output" 2>&1
exp_exit_code=$(echo $?)
rm -rf .grip
echo 1 > a
grip-init  > "$actual_output" 2>&1
grip-add a > "$actual_output" 2>&1
rm a
grip-add a > "$actual_output" 2>&1
actual_exit_code=$(echo $?)
rm -rf .grip

if [ "$exp_exit_code" -eq "$actual_exit_code" ] && [ "$exp_exit_code" -eq 0 ]
then
        if diff -Z "$actual_output" "$expected_output"
        then
                echo "Test 6 - Successful add of deleted file - passed"
        else
                echo "Test 6 - Successful add of deleted file - failed"
        fi
else
        echo "Test 6 - Successful add of deleted file - failed"
fi

# Test to add several files with changes
# Should print nothing and exit with status 0
echo 1 > a
2041 grip-init > "$expected_output" 2>&1
2041 grip-add a > "$expected_output" 2>&1
rm a
echo 2 > b
echo c > c
2041 grip-add a b c > "$expected_output" 2>&1
exp_exit_code=$(echo $?)
rm -rf .grip
echo 1 > a
grip-init  > "$actual_output" 2>&1
grip-add a > "$actual_output" 2>&1
rm a
echo 2 > b
echo c > c
grip-add a b c > "$actual_output" 2>&1
actual_exit_code=$(echo $?)
rm -rf .grip

if [ "$exp_exit_code" -eq "$actual_exit_code" ] && [ "$exp_exit_code" -eq 0 ]
then
        if diff -Z "$actual_output" "$expected_output"
        then
                echo "Test 7 - Successful add of several changes - passed"
        else
                echo "Test 6 - Successful add of several changes - failed"
        fi
else
        echo "Test 6 - Successful add of several changes - failed"
fi