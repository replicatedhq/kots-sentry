# Kots Sentry Demo

This is a working demo for packaging Sentry as a Kots application.

## Quick Start

1. Install kots using plugin:

```shell
curl https://kots.io/install | bash
```

2. Test the deployment (without a license):

```shell
kubectl kots pull replicated://sentry-enterprise --local-path ./manifests --shared-password password --rootdir ./built
kubectl apply -k built/sentry-enterprise/overlays/midstream
```

3. Connect to the admin console:

```shell
kubectl kots admin-console
```

4. Clean up

```shell
kubectl delete -k built/sentry-enterprise/overlays/midstream
```
