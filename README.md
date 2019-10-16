Cloud Custodian Policies

Requirements:

1. Jenkins installation with plugins:
    a) Pipeline: AWS Steps
    b) Docker plugin
2. Technical user in AWS with create Lambda permissions
3. Dockerhub account to publish Docker image
4. Github Enterprise technical user
5. Allow access to AWS API (api.amazon.com) from Docker agent


Installation

1. Build Dockerimage from Dockerfile
2. Setup docker Agent template in Jenkins with following details:
    a) Labels: docker-custodian
    b) Name: docker-custodian
    c) Remote File System Root: /home/custodian
    d) User: custodian
3. Create build with pipeline script from SCM using git@github.exasol.com:devops/cloudcustodian.git 


Usage:

1. Commit the changes in master branch 
2. New policies should be added in custodian.yml file
3. Run the build


Explenation of pipeline :

1. Declarative: Checkout SCMB: uild first downloads the files from github master branch repository 
2. Validate: Updated custodian.yml policy files is validated for errors
3. Test: Policy is deployed in aws-im-dev environment for testing
4. Dryrun: Policy is dryruned through all accounts 
5. Run: Policy is deployed in all envrionment
6. clean-old-functions: Old lambda functions which are not part for custodian.yml files are removed/deleted

...
