pipeline {
    agent {
        node { label 'docker-custodian' }
    }
    stages {
        stage('Validate') {
            steps {
                sh 'custodian validate custodian.yml'
            }
        }
        stage('test') {
            steps {
                withAWS(credentials: 'exasol-aws-maintenance', region: 'eu-west-1') {
                    sh 'c7n-org run -c accounts-test.yml -s output -u  custodian.yml'
                }
            }
        }
        stage('dryrun') {
            steps {
                withAWS(credentials: 'exasol-aws-maintenance', region: 'eu-west-1') {
                    sh 'c7n-org run -c accounts-test.yml -s output -u  custodian.yml --dryrun'
                }
            }
        }
        
        stage('run') {
            steps {
                withAWS(credentials: 'exasol-aws-maintenance', region: 'eu-west-1') {
                    sh 'c7n-org run -c accounts-test.yml -s output -u  custodian.yml'
                }
            }
        }
        stage('clean-old-functions') {
            steps {
                withAWS(credentials: 'exasol-aws-maintenance', region: 'eu-west-1') {
                    sh 'c7n-org run-script -c accounts-test.yml -s .  "python mugc.py -c custodian.yml" '
                }
            }
        }
        
    }
}


