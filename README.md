# terraform-projects-gcp
Terraform workspace for the production of child projects in the Lavender Bison
organization.

## Overview

Managing many Google Cloud Platform projects and Terraform workspaces is an
extremely difficult and time consuming process--even for the most mature
organizations. Terraform Cloud and Terraform Enterprise are a great solution,
but in most cases you're still in charge of setting up the workspaces. If
you're using the VCS-based process, you're even setting up the link to a Github
repository.

This repository serves to simplify the process of project creation and
provisioning by elevating all higher-privileged access to a single Terraform
workspace. Through the use of custom built modules, developers within the
organization can easily set up a complete project environment for their use
case in no time at all.

This Terraform workspace utilizes a GCS backend rather than Terraform Cloud or
Terraform Enterprise. There's not a real significant reason this is the case.
Mostly, the Terraform Cloud workspace would be configured as a locally run
backend anyways. A simple GCS backend works just as well, and is likely less
expensive.


## Creating New Projects



## First Time Setup

In order to set up this Terraform workspace to manage projects for your entire
organization, you must run the `bootstrap.sh` script. The `bootstrap.sh` script
creates the following resources:

* A Google Cloud Platform project to contain this workspace's Google Cloud Platform resources.
* A Google Cloud Storage bucket for Terraform state.
* A Google Cloud Platform service account with permissions to manage resources for this organization.

The `bootstrap.sh` script also inserts the key for the service account into the
secrets for this Github repository to support continuous deployment with Github
Actions.

`bootstrap.sh` is only required to be run once per organization.

### Permissions

To run the `bootstrap.sh` script, you'll need higher than normal privileges. This is justifiable
because this is really only a one-time setup kinda thing.

You'll need the following roles and 

* Google Cloud Organization-level Administrator
* Google Cloud Organization-level Billing Administrator
* Google Cloud Organization-level Project Creator
* Admin access on the repository this workspace is in to add a secret.

### Running `boostrap.sh`

You'll need the following command line tools.

* [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
* [Github CLI](https://cli.github.com/manual/installation)
* [yq](https://mikefarah.gitbook.io/yq/#install)

Once the Google Cloud SDK is installed, you'll also need the beta components.

```bash
gcloud components install beta
```

Make sure you log in on both tools.

```bash
gcloud auth login
    ...
gh auth login
    ...
```

Then run the script.

```bash
cd scripts/
./bootstrap.sh
```

