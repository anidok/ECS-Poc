#!/usr/bin/env bash

set +x -e


STACK_NAME="mywebapp-ecs-poc-infrastructure"
STAGE="dev"
AWS_REGION="us-east-1"
TEMPLATE_FILE="cloudformation/mywebapp-ecs-cluster.yml"
ALB_INSTALL="yes"
ECS_AMI_ID="ami-007571470797b8ffa" # AWS optimized AMI for ECS bases on Amazon Linux 2

SECURITY_INGRESS_CIDR_IP="172.31.0.0/16" #default vpc
SUBNET_IDS="subnet-255ea12a,subnet-378ce418" #default vpc
VPC_ID="vpc-b7cadbcf" #default vpc
IS_PUBLIC_IP="true"  # required for default vpc

# SECURITY_INGRESS_CIDR_IP="10.0.0.0/26" #myPOC vpc
# SUBNET_IDS="subnet-06fe1c780795cff23,subnet-0ef16beded87766e2" #myPOC vpc
# VPC_ID="vpc-0f0b1f37aa4541467" #myPOC vpc
# IS_PUBLIC_IP="false"  # myPOC VPC was configured to handle this

# SECURITY_INGRESS_CIDR_IP="172.16.0.0/16" #test vpc
# SUBNET_IDS="subnet-0814707766ead6436,subnet-0d9468468a601e1f8" #test vpc
# VPC_ID="vpc-0dc1165b5cbe13694"  #test vpc

stack_parameters="EcsAmiId=$ECS_AMI_ID SecurityIngressCidrIp=$SECURITY_INGRESS_CIDR_IP SubnetIds=$SUBNET_IDS VpcId=$VPC_ID ALBInstall=$ALB_INSTALL IsPublicIp=$IS_PUBLIC_IP"

aws cloudformation deploy --region $AWS_REGION --template-file $TEMPLATE_FILE \
    --no-fail-on-empty-changeset \
    --parameter-overrides $stack_parameters \
    --capabilities CAPABILITY_NAMED_IAM --stack-name $STACK_NAME-$STAGE
