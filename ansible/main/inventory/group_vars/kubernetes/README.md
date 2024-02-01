Configuring K3S to use Harbor as a pull-through cache
=====================================================

The file `harbor.sops.yaml` in this folder contains an encrypted version of a
value for the k3s_registries: key used by the k3s installer role. The contents
are, approximately as follows. I've encrypted the file so that I can use the
FQDN of the harbor server without leaking it.


    # Set up docker registry mirrors using the on-prem harbor pull-through cache.
    k3s_registries:
        mirrors:
            docker.io:
                endpoint:
                    - https://harbor/v2/docker.io
            k8s.gcr.io:
                endpoint:
                    - https://harbor/v2/k8s.gcr.io
            quay.io:
                endpoint:
                    - https://harbor/v2/quay.io
            gcr.io:
                endpoint:
                    - https://harbor/v2/gcr.io
            ghcr.io:
                endpoint:
                    - https://harbor/v2/ghcr.io
            public.ecr.aws:
                endpoint:
                    - https://harbor/v2/public.ecr.aws
            registry.k8s.io:
                endpoint:
                    - https://harbor/v2/registry.k8s.io
