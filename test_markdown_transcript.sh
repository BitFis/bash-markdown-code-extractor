#!/usr/bin/env bats
# test the transcript script

. ${BATS_TEST_DIRNAME}/_common
@load markdown_transcript

print_test_lines() {
    for i in "${lines[@]}"; do
      echo "$i"
    done
    echo -e "===\nlines ${#lines[@]}"
}

@test "Test transcript_markdown run commands of markdown in code box" {
    DRY_RUN=1
    run transcript_markdown ${BATS_TEST_DIRNAME}/test_assets/simple.md
    unset DRY_RUN

    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "> echo match 1" ]
    [ "${#lines[@]}" -eq 4 ]
}

@test "Test transcript_markdown run complex markdown" {
    DRY_RUN=1
    function command_exists() { echo "Hello"; }
    run transcript_markdown ${BATS_TEST_DIRNAME}/test_assets/complex.md
    unset DRY_RUN

    print_test_lines

    [[ ${#lines[@]} -eq 6 ]]
    for i in "${lines[@]}"; do
      [[ "$i" = "> echo \"Add me\"" ]]
    done
}

@test "Test transcript_markdown run invalid markdown and echo line on command failed" {
    run transcript_markdown ${BATS_TEST_DIRNAME}/test_assets/invalid_bash.md

    [[ "${lines[0]}" = "> echo Still run" ]]
    [[ "${lines[1]}" = "Still run" ]]
    [[ "${lines[2]}" = "> fails" ]]
    [[ "${#lines[@]}" -eq 5 ]]

    # expect command not found error
    [[ "$status" -eq 127 ]]
}

@test "Test transcript_markdown printing comments" {
    run transcript_markdown ${BATS_TEST_DIRNAME}/test_assets/comments.md

    [[ "${lines[0]}" = "# echo match 1" ]]
    [[ "${#lines[@]}" -eq 4 ]]
    [[ "$status" -eq 0 ]]
}

@test "Test transcript_markdown conditional by running pre and post" {
    DRY_RUN=1
    run transcript_markdown ${BATS_TEST_DIRNAME}/test_assets/conditional.md
    unset DRY_RUN

    [[ "$status" -eq 0 ]]
    [[ "${lines[0]}" = "> echo Before Block" ]]
    [[ "${lines[1]}" = "> echo Before Block 2" ]]
    [[ "${lines[-2]}" = "> echo After Block" ]]
    [[ "${lines[-1]}" = "> echo After Block 2" ]]
}

@test "Test transcript_markdown if argument given, run only block with argument and no other block" {
    DRY_RUN=1
    run transcript_markdown "${BATS_TEST_DIRNAME}/test_assets/conditional.md" version
    unset DRY_RUN

    [[ ${#lines[@]} -eq 1 ]]
    [[ "${lines[0]}" = "> echo \"show version\"" ]]
}

@test "Test transcript_markdown complex conditional, run multiple blocks with different args order" {
    DRY_RUN=1
    run transcript_markdown "${BATS_TEST_DIRNAME}/test_assets/conditional.md" version all
    unset DRY_RUN

    [[ ${#lines[@]} -eq 2 ]]
}

@test "Test transcript_markdown conditional module, run code block only if provided condition is true" {
    DRY_RUN=1
    EXTERNAL_ENV="linux-gnu"
    run transcript_markdown "${BATS_TEST_DIRNAME}/test_assets/conditional.md"
    unset DRY_RUN

    [[ "${lines[-1]}" = "> echo \$EXTERNAL_ENV is linux-gnu" ]]
}

@test "Test transcript_markdown run block always from location where transcript_markdown was called" {
    local last_loc=$(pwd)
    cd ${BATS_TEST_DIRNAME}/test_assets
    run transcript_markdown "${BATS_TEST_DIRNAME}/test_assets/location.md"
    cd $last_loc

    echo ${lines[3]}
    echo ${lines[7]}

    [[ "${lines[3]}" = "${lines[7]}" ]]
}

@test "Preview which processors have been run" {
    cd ${BATS_TEST_DIRNAME}/test_assets
    DEBUG=1
    run transcript_markdown "${BATS_TEST_DIRNAME}/test_assets/simple_conditional.md"
    unset DEBUG
    cd $last_loc

    echo \$\{lines[0]\}: ${lines[0]}

    [[ "${lines[0]}" =~ ^"run processor:" ]]
}

@test "After run, location is restored to when the script was called from" {
    skip "TODO - prevent possible bugs"
}

@test "Test transcript_markdown run if command does not exist" {
    skip "TODO - module extension"
}

@test "Test transcript_markdown run only a few commands" {
    skip "TODO"
    # this works only, if a new command.logs file is created
#    function jumpto
# {
#    label=$1
#    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
#    eval "$cmd"
#    exit
#}
}
