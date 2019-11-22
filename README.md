# Kots Sentry Demo

This is a working demo for packaging Sentry as a Kots application.

## Quick Start

1. Create a new Kots application in the [Replicated Vendor Portal](https://vendor.replicated.com)

* Create a new application and name it (by default this is a KOTS application, other schedulers are available if needed). 
* Select the 'Releases' tab of the vendor portal, click "create release," delete the default yaml files and upload all the files from the `manifests` directory of this repo.  These files include plain Kubernetes yaml for sample app (Sentry), along with the following Kots-specific yaml specs:

    * replicated-app.yaml - specifies application title and icon, for display in the kots admin console
    * preflight.yaml - specifies tests to run against the target cluster, prior to deployment of the app
    * support-bundle.yaml - specifies how custom diagnostic info should be collected, analyzed, and displayed
    * application.yaml - specifies the application link URLs (from the Kubernetes App SIG: https://github.com/kubernetes-sigs/application)
    * config.yaml - specifies the configuration options in the Replicated config DSL.
    
* Create a release, and promote that release to a deployment channel

2. Create a customer and download an application license

* Select the Customers option on the left menu, create a new customer, and assign the customer to a channel.
* Select the Channels option from the left menu, and review the 'Install' command, which will show `your-app-slug` and a Replicated URL to install with Kots.

3. Install the Kots kubectl plugin on your workstation

```shell
curl https://kots.io/install | bash
```

4. Test the deployment:

* Choose `your-namespace` which will be the namespace for every component of the deployed application and the kots admin console

```shell
kubectl kots install your-app-slug
```
* You will be prompted to provide a namespace to install into as well as a password (to control access to the admin console), and then to connect to http://localhost:8800 , where you can login with the password you just specified, and then upload the customer license.

5. Clean up

```shell
kubectl delete ns your-namespace
```
