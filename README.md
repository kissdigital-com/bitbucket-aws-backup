# Bitbucket to AWS S3 backup

The script backups all your bitbucket repositories to AWS S3 bucket.

## Requirements

* AWS CLI has to be installed https://docs.aws.amazon.com/cli/latest/
* git command has to be installed
* Mac OS or Linux system

## Usage

`./bb.sh bb_username bb_password aws_key aws_secret aws_bucket`

* `bb_username` is your bitbucket username, you can find it here: https://bitbucket.org/account/settings/
* `bb_password` is your bitbucket app password, you can generate it here: https://bitbucket.org/account/settings/app-passwords/. The only permission required is "repositories:read"
* `bb_workspace` is a workspace name or uuid to backup
* `aws_key`, `aws_secret` are credentials of IAM user that has access to S3 bucket
* `aws_bucket` is a bucket name where the backup has to be stored, e.g. `kissdigital-bitbucket-backup`
