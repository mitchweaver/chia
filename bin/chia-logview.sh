#!/bin/sh
#
# keep track of important log messages
#

tail -F \
~/.chia/mainnet/log/debug.log | \
grep -i \
-e 'eligible' \
-e 'updated peak' \
-e 'signage point' \
-e 'end of slot' \
-e 'updated wallet peak' \
-e 'sub slot'
