# terraform-projects-gcp
Terraform workspace for the production of child projects in the Lavender Bison
organization.

## Overview

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

