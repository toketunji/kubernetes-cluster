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
               withEnv(['PATH+EXTRA=/usr/sbin:/usr/bin:/sbin:/bin']) {
                sh  """
                    sudo ./cluster_1.sh
                    """
              }
              }
            }
          }
}
}
