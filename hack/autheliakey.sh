#!/bin/sh

kubectl -n security exec -it \
  $(kubectl -n security get pod -l "app.kubernetes.io/name=authelia" -o jsonpath='{.items[0].metadata.name}') \
  -- authelia crypto hash generate pbkdf2 --variant sha512 --random --random.length 72 --random.charset rfc3986
