# simple-secret-rotation

A CloudFormation stack for rotating a simple AWS SecretsManager secret.

## Description

Creates a rotation schedule to rotate a secret that doesn't need to be synchronised with any external service, such as a secret key for a web app used for signing cookies.

To deploy from this git repo, install and configure the AWS CLI and set the SECRET_ARN and SCHEDULE_EXPRESSION environment variables before running:

```
make deploy
```
