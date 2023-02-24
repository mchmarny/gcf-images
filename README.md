# gcf-images

When you deploy GCF function, that code (stored in GCS bucket), will be automatically built by GCB into a container image and pushed into Artifact Registry. GCF runs that image when your function is invoked. More about that process [here](https://cloud.google.com/functions/docs/building).

This repo creates a basic image for each one of the 2nd generation runtimes supported in GCF using sample function code outlined in the [Create and deploy a Cloud Function](https://cloud.google.com/functions/docs/create-deploy-gcloud) doc which references following sample repos: 

* Node.js - `github.com/GoogleCloudPlatform/nodejs-docs-samples.git`
* Python  - `github.com/GoogleCloudPlatform/python-docs-samples.git`
* Go      - `github.com/GoogleCloudPlatform/golang-samples.git`
* Java    - `github.com/GoogleCloudPlatform/java-docs-samples.git`
* C#      - `github.com/GoogleCloudPlatform/dotnet-docs-samples.git`
* Ruby    - `github.com/GoogleCloudPlatform/ruby-docs-samples.git`
* PHP     - `github.com/GoogleCloudPlatform/php-docs-samples.git`

Each one of the samples is deployed with the multiple runtimes (e.g. `nodejs18`, `nodejs16`, or `nodejs14`). Some of the above mentioned samples no longer deploy to the older runtimes so there is a "legacy" [src](./src) folder which contains local code samples.

Images created by GCF resulting from deployment of these functions can be found in Artifact Registry under `gcf-artifacts` registry (`us-west1` region by default). The name of the image follows the `daily--<runtime>` convention (e.g. `daily--nodejs18`, `daily--python311`, or `daily--go120`).

> Note the double `--`. GCF injects additional `-` for each one found in the function name. So function `daily-go120` becomes `daily--go120` container image.

The latest image created by GCF as a result of [daily deployment schedule](.github/workflows/daily.yaml) in this repo are available in the `us-west1-docker.pkg.dev/cloudy-labz/gcf-artifacts` registry:

```shell 
docker pull us-west1-docker.pkg.dev/cloudy-labz/gcf-artifacts/daily--go120:latest
```

## setup 

To setup your own instance of this project. First, fork this repo and clone it locally, then deploy the OIDC provider into your GCP project: 

> This repo uses OpenID Connect to grant the HitHub Actions th necessary rights to deploy function without the need for service accounts keys. More about OIDC on GCP [here](https://cloud.google.com/identity-platform/docs/web/oidc). 


```shell
make setup
```

When prompted, provide: 

* `project_id` - the ID of your GCP project (e.g. `your-project-id`)
* `git_repo` - the name of your forked github repo (e.g. `your-github-username/your-repo-name`)

The output will include the parameters you will need to update in [fn-deploy.yaml](.github/workflows/fn-deploy.yaml). Find the `provider`, and `user` input parameters and update them to the values returned by setup:

```yaml
provider:
    description: 'Workload Identity Provider'
    required: false
    type: string
    default: '<PROVIDER_ID>'
user:
    description: 'Workload Identity User'
    required: false
    type: string
    default: '<SA_EMAIL>'
```

The workflow is currently set to execute every 11 hours. If you want change that, alter the schedule at the top of [daily.yaml](.github/workflows/daily.yaml). 

```yaml
on:
  schedule:
    - cron: '0 */11 * * *'
```

To test, simply commit your changes and push your changes. In addition to the above described schedule, the workflow will also execute on each main branch push. 

## cleanup

To delete all the resources created by Terraform in your GCP project: 

```shell
make destroy
```

## disclaimer

This is my personal project and it does not represent my employer. While I do my best to ensure that everything works, I take no responsibility for issues caused by this code.