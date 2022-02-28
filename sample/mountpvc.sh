#!/bin/sh

# FIXME: parameterize namespace and pvc name

kubectl run -n test-restore -i --rm --tty ubuntu --overrides='
{
  "apiVersion": "v1",
  "spec": {
    "automountServiceAccountToken": false,
    "containers": [
      {
        "image": "ubuntu:20.04",
        "name": "ubuntu",
        "stdin": true,
        "stdinOnce": true,
        "tty": true,
        "volumeMounts": [{
          "mountPath": "/backup",
          "name": "backup"
        }]
      }
    ],
    "volumes": [{
      "name":"backup",
      "persistentVolumeClaim":{
        "claimName": "ceph-test-pvc"
      }
    }]
  }
}
' --image=ubuntu:22.04 --restart=Never -- bash
