---
apiVersion: v1
kind: Namespace
metadata:
  name: security
---
apiVersion: v1
kind: Secret
metadata:
  name: onepassword-connect-credentials-secret
  namespace: security
data:
  1password-credentials.json: op://Homelab/1password/OP_CREDENTIALS_JSON
---
apiVersion: v1
kind: Secret
metadata:
  name: onepassword-connect-vault-secret
  namespace: security
stringData:
  OP_CONNECT_TOKEN: op://Homelab/1password/OP_CONNECT_TOKEN
