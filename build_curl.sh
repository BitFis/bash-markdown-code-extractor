#!/bin/bash

. $( dirname "${BASH_SOURCE[0]}" )/_common
@load markdown_transcript

cd $(@workdir)

transcript_markdown "$(@workdir)/../docs/build-curl.md"
