docker logs -f xyz-platform 2>&1 | awk '
  /messages_list: \[/ {
    match($0, /^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}/)
    if (RSTART > 0) {
      ts = substr($0, RSTART, RLENGTH)
    } else {
      ts = "NO_TIMESTAMP"
    }
    in_block=1
    block=""
    next
  }

  in_block {
    block = block $0 "\n"
    if ($0 ~ /^\s*\]/) {
      in_block=0
      if (block ~ /"role": ?\{[^}]*"user"/) {
        print "--- USER MESSAGE DETECTED --- [" ts "]"
        print block
        print "--- END ---\n"
      }
    }
  }

