#!/bin/bash

. $( dirname "${BASH_SOURCE[0]}" )/_common
@load markdown_transcript

cd $( dirname "${BASH_SOURCE[0]}" )

DEBUG_STEPS=1

transcript_markdown ./test_assets/simple.md
