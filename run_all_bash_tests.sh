#!/bin/bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo Run all tests

#./test_common.sh
./test_markdown_transcript.sh
