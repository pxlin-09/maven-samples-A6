pipeline {
  agent any
  tools { 
      maven 'DHT_MVN' 
      jdk 'DHT_SENSE' 
  }
  environment {
    BAD_COMMIT = '198644632661c67b6c32f59e9047c11a70685e15'
    GOOD_COMMIT = '98ac319c0cff47b4d39a1a7b61b4e195cfa231e5'
  }
  stages {
    stage('Checkout Repository') {
      steps {
        // Fetch all branches and commit history so that Jenkins has the complete repository.
        checkout([
          $class: 'GitSCM',
          branches: [[name: 'refs/heads/master']],
          doGenerateSubmoduleConfigurations: false,
          extensions: [
            [$class: 'CloneOption', shallow: false, noTags: false, depth: 0]
          ],
          submoduleCfg: [],
          userRemoteConfigs: [[
            url: 'https://github.com/pxlin-09/maven-samples-A6.git',
            refspec: '+refs/heads/*:refs/remotes/origin/*'
          ]]
        ])
      }
    }

    stage('Prepare Command Script') {
      steps {
        writeFile file: 'command.sh', text: '''
          #!/bin/bash
          mvn clean test
          status=$?
          if [ $status -eq 0 ]; then
            exit 0
          else
            exit 1
          fi
        '''
        sh 'chmod +x command.sh'
      }
    }

    stage('Run Git Bisect') {
      steps {
        sh '''
          git bisect start $BAD_COMMIT $GOOD_COMMIT
          git bisect run ./command.sh
          git bisect reset
        '''
      }
    }
  }
}
