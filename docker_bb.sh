#!/bin/sh

#simple validation

if [ ! -z "$BB_USERNAME" ]; then
    xbb_user=$BB_USERNAME
else
    echo "ERROR: Provide BB_USERNAME env"
    exit
fi

if [ ! -z "$BB_PASSWORD" ]; then
    xbb_pass=$BB_PASSWORD
else
    echo "ERROR: Provide BB_PASSWORD env"
    exit
fi

if [ ! -z "$BB_WORKSPACE" ]; then
    xbb_workspace=$BB_WORKSPACE
else
    echo "ERROR: Provide BB_WORKSPACE env"
    exit
fi

if [ ! -z "$AWS_KEY" ]; then
    xaws_key=$AWS_KEY
else
    echo "ERROR: Provide AWS_KEY env"
    exit
fi

if [ ! -z "$AWS_SECRET" ]; then
    xaws_secret=$AWS_SECRET
else
    echo "ERROR: Provide AWS_SECRET env"
    exit
fi

if [ ! -z "$AWS_BUCKET" ]; then
    xaws_bucket=$AWS_BUCKET
else
    echo "ERROR: Provide AWS_BUCKET env"
    exit
fi

/opt/bb/bb.sh $xbb_user $xbb_pass $xbb_workspace $xaws_key $xaws_secret $xaws_bucket

