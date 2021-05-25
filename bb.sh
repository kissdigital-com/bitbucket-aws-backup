#!/bin/bash
#Author Adam Kubiczek based on Jobin Joseph work
#Keep It Simple, Stupid!

#Bitbucket credentials
bbuser=$1 # Bitbucket Username
bbpass=$2 # Bitbucket Password
bbworkspace=$3 # Bitbucket workspace (name or uuid in {uuid})

#AWS S3 credentials
AWS_ACCESS_KEY=$4
AWS_SECRET=$5
awsBucket=$6

#git clone mode: https or ssh
mode=https

fname=`date +%F_%H_%M`

bitbucket_get_urls () {
    rm -f backups/bitbucket.1

    for page in {1..4} ; do
        curl --user $bbuser:$bbpass "https://api.bitbucket.org/2.0/repositories/"$bbworkspace"/?pagelen=100&page="$page >> backups/bitbucket.1
    done

    tr , '\n' < backups/bitbucket.1 > backups/bitbucket.2
    tr -d '"{}[]' < backups/bitbucket.2 > backups/bitbucket.3

    #Processing
    if [ "$mode" == 'ssh' ]
    then
        cat backups/bitbucket.3 |grep -i "git@bitbucket.org:" |cut -d" " -f3 >backups/bitbucket.4
    elif [ "$mode" == 'https' ]
    then
        cat backups/bitbucket.3 |grep -i " clone: href:" |cut -d" " -f4 >backups/bitbucket.4
    else
        echo "Invalid $mode mode"
        exit 1
    fi

    #Randomize repositories order
    sort -R backups/bitbucket.4 >backups/bitbucket_url_list

    #Clean up
    rm -f backups/bitbucket.1
    rm -f backups/bitbucket.2
    rm -f backups/bitbucket.3
    rm -f backups/bitbucket.4
}

bb_backup () {
    rm -rf `cat backups/VERSION`
    echo backups/$fname > backups/VERSION
    mkdir backups/$fname

    #configure GIT_ASKPASS
    printf "#!/bin/sh\n" > backups/git_askpass
    printf "echo $bbpass\n" >> backups/git_askpass
    chmod +x backups/git_askpass

    cd backups/$fname

    #clone
    for repo in `cat ../bitbucket_url_list` ; do
        if [ "$mode" == 'ssh' ]
        then
            repoFolder=$(echo $repo | cut -d"/" -f2)
        else
            repoFolder=$(echo $repo | cut -d"/" -f5)
        fi

        echo "========== Cloning $repo into $repoFolder =========="
        GIT_ASKPASS=../git_askpass git clone --mirror $repo $repoFolder
        AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY AWS_SECRET_ACCESS_KEY=$AWS_SECRET aws s3 sync ./$repoFolder s3://$awsBucket/$fname/$repoFolder/
        rm -fR ./$repoFolder
    done

    cd ../..
    rm backups/VERSION
    rm backups/git_askpass
}

#Backup Starts here
mkdir ./backups

if [ -z "$5" ]
then
    echo "Usage: $0 bb_username bb_password bb_workspace aws_key aws_secret aws_bucket"
else
    bitbucket_get_urls
    bb_backup
    rm -f bitbucket_url_list
fi

exit 0
