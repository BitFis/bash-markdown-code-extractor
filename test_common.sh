#!/usr/bin/env bats
# test common functions

EXPECED_CURRENT_DIR=$(pwd)

. ${BATS_TEST_DIRNAME}/_common

print_test_lines() {
    for i in "${lines[@]}"; do
      echo "$i"
    done
    echo -e "===\nlines ${#lines[@]}"
}

# testing @exec
@test "Test @exec running command with @exec" {
    run @exec "echo Hello World"
    [ "${lines[1]}" = "Hello World" ]
}

@test "Test @exec running command and printing executed command" {
    run @exec "echo Hello World"
    [ "${lines[0]}" = "> echo Hello World" ]
}

@test "Test @exec set DRY_RUN and command will not be executed" {
    DRY_RUN=1
    run @exec echo Hello World
    unset DRY_RUN

    [ "${lines[0]}" = "> echo Hello World" ]
    [ "${#lines[@]}" -eq 1 ]
}

@test "Test @exec successful if DEBUG set commands are logged" {
    DEBUG=1
    run @exec "echo Hello World"
    unset DEBUG
    [ -f "${EXPECED_CURRENT_DIR}/commands.log" ]
    log_content=$(cat ${EXPECED_CURRENT_DIR}/commands.log)
    echo $log_content
    expected="cd $(pwd)
echo Hello World"
    echo $expected
    [ "$log_content" = "$expected" ]
}

@test "Test @exec no commands.log file exists if DEBUG is not set" {
    unset DEBUG
    run @exec "echo Hello World"
    [ ! -f "${EXPECED_CURRENT_DIR}/commands.log" ]
}

@test "Test @exec define variable with @exec" {
    @exec OPENSSL_VERSION=OpenSSL_1_1_1g-quic-draft-29
    [ "$OPENSSL_VERSION" = "OpenSSL_1_1_1g-quic-draft-29" ]
}

@test "Test @exec wait for input if DEBUG_STEPS is set" {
    DEBUG_STEPS=1
    # overwrite read for debug
    read () { echo $@; }
    run @exec "echo Hello World"
    unset DEBUG_STEPS

    echo ${lines[1]}
    [[ "${lines[1]}" =~ "Run command? [y/n]" ]]
}

# @script_dir
@test "Test @script_dir will return directory of script" {
    run @script_dir
    [ "$output" = "${BATS_TEST_DIRNAME}" ]
}

# @workdir
@test "Test @workdir getting default workdir" {
    unset WORKDIR
    run @workdir

    # expected ./data
    expected="$( cd "${BATS_TEST_DIRNAME}/../data" >/dev/null 2>&1 && pwd )"

    [ "$output" = "$expected" ]
}

@test "Test @workdir getting custom workdir" {
    WORKDIR="/hello/world"
    run @workdir

    [ "$output" = "/hello/world" ]
}

@test "Test @workdir setting workdir by passing the location" {
    unset WORKDIR
    @workdir "/hello/world"
    run @workdir

    # check output changed
    [ "$output" = "/hello/world" ]
}

# @exec_dir
@test "Test @exec_dir will return directory from where script was executed even if dir changed" {
    cd /
    run @run_dir
    [ "$output" == "${EXPECED_CURRENT_DIR}" ]
}

# test @run_on_missing
@test "Test @run_on_missing if command is missing run provided function" {
    run @run_on_missing not_set_command echo "Hello World"

    [[ "${lines[0]}" =~ "not found" ]]
    [ "${lines[1]}" = "Hello World" ]
}

@test "Test @run_on_missing command is found, no output" {
    run @run_on_missing exec echo "Not Run"
    [ "$output" = "" ]
}

teardown() {
    rm -rf ${EXPECED_CURRENT_DIR}/commands.log
}
