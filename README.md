# Bitbucket to AWS S3 backup

The script backups all your bitbucket repositories to AWS S3 bucket.

## Requirements

* AWS CLI has to be installed https://docs.aws.amazon.com/cli/latest/
* git command has to be installed
* Mac OS or Linux system

## Usage

### CLI
`./bb.sh bb_username bb_password bb_workspace aws_key aws_secret aws_bucket`

* `bb_username` is your bitbucket username, you can find it here: https://bitbucket.org/account/settings/
* `bb_password` is your bitbucket app password, you can generate it here: https://bitbucket.org/account/settings/app-passwords/. The only permission required is "repositories:read"
* `bb_workspace` is a workspace name or uuid to backup
* `aws_key`, `aws_secret` are credentials of IAM user that has access to S3 bucket
* `aws_bucket` is a bucket name where the backup has to be stored, e.g. `kissdigital-bitbucket-backup`


### Docker

Build docker image: `docker build ./Dockerfile`
Run: `docker run --env-file='.env' <image_id>` where .env contains required credentials:
* `BB_USERNAME=value`
* `BB_PASSWORD=value`
* `BB_WORKSPACE=value`
* `AWS_KEY=value`
* `AWS_SECRET=value`
* `AWS_BUCKET=value`

### Kubernetes

CronJob template (warning: do not contains valid image):

```
kind: CronJob
apiVersion: batch/v1
metadata:
  name: bitbucket-aws-backup
  namespace: bitbucket-aws-backup
spec:
  schedule: 13 1 * * *
  concurrencyPolicy: Allow
  suspend: false
  jobTemplate:
    metadata:
      creationTimestamp: null
    spec:
      template:
        metadata:
          creationTimestamp: null
        spec:
          containers:
            - name: bitbucket-aws-backup
              image: <image>
              env:
                - name: BB_USERNAME
                  value: fill or take from secret
                - name: BB_PASSWORD
                  value: fill or take from secret
                - name: BB_WORKSPACE
                  value: fill or take from secret
                - name: AWS_KEY
                  value: fill or take from secret
                - name: AWS_SECRET
                  value: fill or take from secret
                - name: AWS_BUCKET
                  value: fill or take from secret
              imagePullPolicy: Always
          restartPolicy: Never
          terminationGracePeriodSeconds: 30
          dnsPolicy: ClusterFirst
          securityContext: {}
          schedulerName: default-scheduler
  successfulJobsHistoryLimit: 4
  failedJobsHistoryLimit: 2
```




