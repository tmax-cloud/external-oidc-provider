node {
    def gitHubBaseAddress = "github.com"
    def gitExternalOidcProviderAddress = "${gitHubBaseAddress}/tmax-cloud/external-oidc-provider.git"
    def buildDir = "/var/lib/jenkins/workspace/external-oidc-provider"
    def version = "${params.majorVersion}.${params.minorVersion}.${params.tinyVersion}.${params.hotfixVersion}"
    def imageTag = "b${version}"
    def globalVersion = "external-oidc-provider:b${version}"
    def githubUserName = "ck-jenkins"
    def githubUserToken = "${params.githubUserToken}"
    def userEmail = "taegeon_woo@tmax.co.kr"

    stage('git pull from external-oidc-provider') {
    	git branch: "${params.buildBranch}",
        credentialsId: '${githubUserName}',
        url: "http://${gitExternalOidcProviderAddress}"

        sh "git checkout ${params.buildBranch}"
        sh "git fetch --all"
        sh "git reset --hard origin/${params.buildBranch}"
        sh "git pull origin ${params.buildBranch}"
    }

    stage('Dockerfile image build & push'){
        sh "sudo docker build --tag tmaxcloudck/external-oidc-provider:${imageTag} ."
        sh "sudo docker tag tmaxcloudck/external-oidc-provider:${imageTag} tmaxcloudck/external-oidc-provider:latest"
        sh "sudo docker push tmaxcloudck/external-oidc-provider:${imageTag}"
        sh "sudo docker push tmaxcloudck/external-oidc-provider:latest"
        sh "sudo docker rmi tmaxcloudck/external-oidc-provider:${imageTag}"
    }

    stage('git push'){
        sh "git checkout ${params.buildBranch}"
        sh "git add -A"

        sh (script:'git commit -m "[Distribution] External-Oidc-Provider- ${version} " || true')
        sh "git tag v${version}"

        sh "git remote set-url origin https://${githubUserToken}@github.com/tmax-cloud/external-oidc-provider.git"

        sh "sudo git push -u origin +${params.buildBranch}"
        sh "sudo git push origin v${version}"

        sh "git fetch --all"
        sh "git reset --hard origin/${params.buildBranch}"
        sh "git pull origin ${params.buildBranch}"

    }

	stage('clear repo'){
        sh "sudo rm -rf *"
    }
}



