# VolSync Template

## Flux Kustomization

This requires `components` and `postBuild` configured on the Flux Kustomization

```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: &app plex
  namespace: flux-system
spec:
  # ...
  components:
    - ../../../../components/volsync
  # ...
  postBuild:
    substitute:
      APP: *app
      VOLSYNC_CAPACITY: 5Gi
```

## Required `postBuild` vars:

- `APP`: The application name
- `VOLSYNC_CAPACITY`: The PVC size

## Optional `postBuild` vars:

- TBD
