#!/usr/bin/env bash

username=$1
message=$2
mentions=$3

curl http://0.0.0.0:1337/katter/messages \
  -X POST \
  -H "Content-Type: application/json" \
  -d @- << EOF
    {
      "username": "$username",
      "message": "$message",
      "mentions": $mentions
    }
EOF
