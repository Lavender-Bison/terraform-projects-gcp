#!/bin/bash
#
# Script generated with Argbash.
#
# ARG_POSITIONAL_SINGLE([organization-id],[The organization to bootstrap.],[])
# ARG_POSITIONAL_SINGLE([project-id],[The project to create to house the resources for this Terraform workspace.],[])
# ARG_POSITIONAL_SINGLE([github-repository],[The Github repository to insert the Terraform service account key at.],[])
# ARG_HELP([Bootstrap an organization for the management of projects through Terraform.])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.9.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info
# Generated online by https://argbash.io/generate

die() {
    local _ret="${2:-1}"
    test "${_PRINT_HELP:-no}" = yes && print_help >&2
    echo "$1" >&2
    exit "${_ret}"
}

begins_with_short_option() {
    local first_option all_short_options='h'
    first_option="${1:0:1}"
    test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
# THE DEFAULTS INITIALIZATION - OPTIONALS

print_help() {
    printf '%s\n' "Bootstrap an organization for the management of projects through Terraform."
    printf 'Usage: %s [-h|--help] <organization-id> <project-id> <github-repository>\n' "$0"
    printf '\t%s\n' "<organization-id>: The organization to bootstrap."
    printf '\t%s\n' "<project-id>: The project to create to house the resources for this Terraform workspace."
    printf '\t%s\n' "<github-repository>: The Github repository to insert the Terraform service account key at."
    printf '\t%s\n' "-h, --help: Prints help"
}

parse_commandline() {
    _positionals_count=0
    while test $# -gt 0; do
        _key="$1"
        case "$_key" in
        -h | --help)
            print_help
            exit 0
            ;;
        -h*)
            print_help
            exit 0
            ;;
        *)
            _last_positional="$1"
            _positionals+=("$_last_positional")
            _positionals_count=$((_positionals_count + 1))
            ;;
        esac
        shift
    done
}

handle_passed_args_count() {
    local _required_args_string="'organization-id', 'project-id' and 'github-repository'"
    test "${_positionals_count}" -ge 3 || _PRINT_HELP=yes die "FATAL ERROR: Not enough positional arguments - we require exactly 3 (namely: $_required_args_string), but got only ${_positionals_count}." 1
    test "${_positionals_count}" -le 3 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect exactly 3 (namely: $_required_args_string), but got ${_positionals_count} (the last one was: '${_last_positional}')." 1
}

assign_positional_args() {
    local _positional_name _shift_for=$1
    _positional_names="_arg_organization_id _arg_project_id _arg_github_repository "

    shift "$_shift_for"
    for _positional_name in ${_positional_names}; do
        test $# -gt 0 || break
        eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
        shift
    done
}

parse_commandline "$@"
handle_passed_args_count
assign_positional_args 1 "${_positionals[@]}"

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash
set -e

# Check proper tools are installed.
echo "Checking that the Google Cloud SDK and the Github CLI are installed."

if ! which gcloud &>/dev/null; then
    echo "The 'gcloud' command must be installed to use this script."
    exit -1
fi

if ! which gh &>/dev/null; then
    echo "The 'gh' command must be installed to use this script."
    exit -1
fi

# Check if the bootstrap project already exists. Create it if it doesn't exist.
echo "Checking if the specified bootstrap project already exists."

ret=0
gcloud projects describe $_arg_project_id >/dev/null || ret=$?
if [ $ret -ne 0 ]; then
    echo "Project $_arg_project_id does not exist. Creating now."
    gcloud projects create $_arg_project_id --organization $_arg_organization_id >/dev/null
else
    echo "Bootstrap project $_arg_project_id already exists."
fi

echo "Linking the first billing account in the organization."
billing_account_id=$(gcloud beta billing accounts list --format "value(ACCOUNT_ID)" | head -n 1)
gcloud beta billing projects link $_arg_project_id --billing-account $billing_account_id >/dev/null
echo "Linked billing account ${billing_account_id}."

gcloud config set project $_arg_project_id >/dev/null

# Enable the APIs required for a Terraform projects workspace.
echo "Enabling APIs required for project management."
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable serviceusage.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable storage.googleapis.com

# Create a service account if one doesn't exist already
echo "Checking if a service account for the Terraform workspace already exists."
ret=0
gcloud iam service-accounts describe projects-terraform-workspace@${_arg_project_id}.iam.gserviceaccount.com >/dev/null || ret=$?
if [ $ret -ne 0 ]; then
    echo "No service account configured for the Terraform workspace. Creating now."
    gcloud iam service-accounts create projects-terraform-workspace --display-name "Terraform Projects GCP Service Account" --description "The service account utilized by the Terraform workspace for managing Google Cloud Platform resources." >/dev/null
else
    echo "Service account projects-terraform-workspace@${_arg_project_id}.iam.gserviceaccount.com already exists."
fi

# Create a Google Cloud Storage bucket for Terraform state.
echo "Creating a Google Cloud Storage bucket if one doesn't exist."
project_number=$(gcloud projects describe $_arg_project_id --format "value(projectNumber)")

ret=0
gsutil ls gs://${project_number}-tfstate/ >/dev/null || ret=$?
if [ $ret -ne 0 ]; then
    echo "No bucket for Terraform state. Creating now."
    gsutil mb -b on -l US --pap enforced -p $_arg_project_id gs://${project_number}-tfstate >/dev/null
else
    echo "Bucket gs://${project_number}-tfstate already exists."
fi

echo "Granting the Terraform workspace service account projects-terraform-workspace@${_arg_project_id}.iam.gserviceaccount.com objectAdmin on the Terraform state bucket gs://${project_number}-tfstate."
gsutil iam ch serviceAccount:projects-terraform-workspace@${_arg_project_id}.iam.gserviceaccount.com:objectAdmin gs://${project_number}-tfstate >/dev/null

echo "Granting other organization level roles to the Terraform workspace service account."
for ROLE in "roles/resourcemanager.projectCreator" "roles/resourcemanager.projectDeleter" "roles/resourcemanager.organizationAdmin" "roles/billing.admin"; do
    echo "Enabling $ROLE for the Terraform workspace service account at the organization level."
    gcloud organizations add-iam-policy-binding $_arg_organization_id --member="serviceAccount:projects-terraform-workspace@${_arg_project_id}.iam.gserviceaccount.com" --role $ROLE >/dev/null
done

echo "Creating a service account key to run the Terraform workspace with."
echo "Deleting all existing service account keys for the Terraform workspace service account."
gcloud iam service-accounts keys list --iam-account=projects-terraform-workspace@${_arg_project_id}.iam.gserviceaccount.com --managed-by=user --format="value(KEY_ID)" |
    tr '\n' '\0' |
    xargs -0 -I {} gcloud iam service-accounts keys delete {} --iam-account=projects-terraform-workspace@${_arg_project_id}.iam.gserviceaccount.com

echo "Creating new key."
gcloud iam service-accounts keys create ../projects-terraform-workspace-key.json --iam-account=projects-terraform-workspace@${_arg_project_id}.iam.gserviceaccount.com

echo "Setting key on the Github repository."
base64 -in ../projects-terraform-workspace-key.json | gh secret set -R $_arg_github_repository SA_KEY

echo "Setting bucket on the Github repository."
gh secret set -R $_arg_github_repository TF_BUCKET -b "${project_number}-tfstate"

echo "Setting project ID on the Github repository."
gh secret set -R $_arg_github_repository PROJECT_ID -b $_arg_project_id

# ] <-- needed because of Argbash
