  # Create a cluster in AWS that has HA masters.  This cluster
  # will be setup with an internal networking in a private VPC.
  # A bastion instance will be setup to provide instance access.

AWS_IMAGE="${OS:-ami-7c491f05}"

#aws s3 mb s3://tealorganisation.tk-state --region eu-west-1

export KOPS_STATE_STORE="s3://tealorganisation.tk-state"
#export KOPS_FEATURE_FLAGS=AlphaAllowGCE

  
  VPC=$(aws ec2 describe-vpcs --filters Name=tag:Name,Values=tealorganisation.tk-staging-vpc --query 'Vpcs[].VpcId' | grep vpc | sed 's/"//g' | awk '{print $1}')
  PRIVATE_SUBNET=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=tealorganisation.tk-staging-sn-private-a" | grep SubnetId | awk '{print $2}' | sed 's/"//g' | awk -F, '{print $1}')
  PUBLIC_SUBNET=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=tealorganisation.tk-staging-sn-public-a" | grep SubnetId | awk '{print $2}' | sed 's/"//g' | awk -F, '{print $1}')

kops create cluster \
  --name staging.tealorganisation.tk \
  --cloud aws \
  --zones eu-west-1a \
  --node-count 2 \
  --node-size t2.micro \
  --master-count 1 \
  --master-size t2.medium \
  --master-zones eu-west-1a \
  --dns-zone tealorganisation.tk \
  --networking weave \
  --cloud-labels "Team=Dev,Owner=Admin" \
  --topology private \
  --kubernetes-version 1.10.7 \
  --state s3://tealorganisation.tk-state \
  --image $AWS_IMAGE \

kops update cluster staging.tealorganisation.tk --yes

sleep 5m

kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

kubectl create -f /home/toketunji/kube-dashboard-access.yaml

kubectl -n kube-system get secret

a=$(kubectl -n kube-system get secret | grep kubernetes-dashboard-token* | awk '{print $1}')

echo "copy the token for your use"

kubectl -n kube-system describe secret $a

kubectl proxy &

echo -e "\e[34m****access the dashboard via http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/\e[0m"

xdg-open http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy
