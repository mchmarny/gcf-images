# gcf-images

Utility repo to deploy a function for each one of the main 2nd generation runtimes supported in GCF using function code from the sample repos for each language outlined in https://cloud.google.com/functions/docs/create-deploy-gcloud:

* Node.js - `github.com/GoogleCloudPlatform/nodejs-docs-samples.git`
* Python  - `github.com/GoogleCloudPlatform/python-docs-samples.git`
* Go      - `github.com/GoogleCloudPlatform/golang-samples.git`
* Java    - `github.com/GoogleCloudPlatform/java-docs-samples.git`
* C#      - `github.com/GoogleCloudPlatform/dotnet-docs-samples.git`
* Ruby    - `github.com/GoogleCloudPlatform/ruby-docs-samples.git`
* PHP     - `github.com/GoogleCloudPlatform/php-docs-samples.git`

Each one of the samples is deployed with multiple runtimes (e.g. `nodejs18`, `python311`, or `go120`). For complete list of deployed runtimes for each see [daily.yaml](.github/workflows/daily.yaml). 

Images created by GCF resulting from deployment of these functions can be found in Artifact Registry under registry `gcf-artifacts`. The name of the image follows the `daily-<runtime>` convention (e.g. `daily-nodejs18`, `daily-python311`, or `daily-go120`)

> The [src](src) contains code samples for older runtimes for which the official GCP samples no longer deploy. 

## setup 

> You only need to setup this repo if you want to setup your own instance. The images created by GCF as a result of this repo are available in `us-west1-docker.pkg.dev/cloudy-labz/gcf-artifacts`

This repo uses OpenID Connect to grant the HitHub Actions th necessary rights to deploy function without the need for service accounts keys. More about OIDC on GCP [here](https://cloud.google.com/identity-platform/docs/web/oidc). 

To setup this repo in your GCP project: 

```shell
make setup
```

When prompted, provide: 

* `project_id` - the ID of your GCP project (e.g. `my-project-id`)
* `git_repo` - the name of the github repo (e.g. `username/repo-name`)

The output will include the parameters you will need to set in [fn-deploy.yaml](.github/workflows/fn-deploy.yaml). Update the current default values in the input section of that workflow:

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

The workflow is currently set to execute every 11 hours. If you want change that, alter the schedule at the top of [daily.yaml](.github/workflows/daily.yaml)

```yaml
on:
  schedule:
    - cron: '0 */11 * * *'
```

## cleanup

```shell
make destroy
```

## disclaimer

This is my personal project and it does not represent my employer. While I do my best to ensure that everything works, I take no responsibility for issues caused by this code.