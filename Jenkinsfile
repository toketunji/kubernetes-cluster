pipeline {
    agent {
        node {
            label 'triJenkins'
        }
    }
      	stages {
          stage('checkout repo') {
            steps {
              git url: 'https://github.com/toketunji/kubernetes-cluster.git'
            }
          }
	
          stage('Install Kubernestes Cluster') {
            steps {
              ansiColor('xterm') {
                sh  """
                    sudo bash ./cluster_1.sh
                    """
              }
              }
            }
          }
}
