#!/bin/bash
. /root/env.sh

echo 'begin backup script.'
/usr/local/bin/ruby /app/scripts/backup.rb
echo 'end backup script.'
