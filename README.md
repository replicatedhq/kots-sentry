# Kots Sentry Demo


This is a working demo for packaging Sentry as a Kots application. 


## Installing the example

There is a license file in this repo that can be used to install Sentry with KOTS from the perspective of an end user. For an existing cluster install, simply point `kubectl` at your cluster, then follow the steps:

1. Install the `kots` plugin:

```shell
curl -fsSL https://kots.io/install | bash
```

2. Run `kubectl kots install` from your workstation:

```shell
kubectl kots install sentry-pro
```

You'll be walked through a few questions as kots sets up the cluster. Once the UI is launched on `localhost:8800`, you can proceed to configure the instance. Again, you can use [the license file in this repo](./KOTS-license-example-sentry-pro.yaml) to install the instance.


3. Clean up

When you're done, you can clean up by deleting the namespace you selected during installation.

```shell
kubectl delete ns your-namespace
```

## Packaging your own app

To get started developing your own version of Sentry (or any Kubernetes app) on KOTS, check out the [quickstart guide](https://kots.io/vendor/guides/quickstart)

