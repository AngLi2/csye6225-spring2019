echo "Enter your stack name:"
read name

echo "Will create ec2 instance from image id: $imageId"
echo "your stack name is :" $name

# echo "Enter your target networking stack name:"
# read network
# echo "your networking stack name is:" $network

imageId=`aws ec2 describe-images --owners self --query "Images[?Description=='Centos AMI for CSYE 6225 - Spring 2019'].ImageId" --output text`
vpcId=`aws ec2 describe-tags --filters "Name=value,Values=*-vpc" --query "Tags[0].ResourceId" --output text`
webappSecurityGroup=`aws ec2 describe-tags --filters "Name=value,Values=*-WebAppSecurityGroup" --query "Tags[0].ResourceId" --output text`
webappSubnetId=`aws ec2 describe-tags --filters "Name=value,Values=*-WebAppSubnet" --query "Tags[0].ResourceId" --output text`
dbSecurityGroup=`aws ec2 describe-tags --filters "Name=value,Values=*-WebAppDBSecurityGroup" --query "Tags[0].ResourceId" --output text`
dbSubnetId=`aws ec2 describe-tags --filters "Name=value,Values=*-DBSubnet" --query "Tags[0].ResourceId" --output text`
dbSubnetGroup=`aws ec2 describe-tags --filters "Name=value,Values=*-dbSubnetGroup" --query "Tags[0].ResourceId" --output text`

aws cloudformation create-stack --stack-name $name --template-body file://csye6225-cf-application.json --parameters ParameterKey=StackName,ParameterValue=$name ParameterKey=AMIInageId,ParameterValue=$imageId ParameterKey=VPCId,ParameterValue=$vpcId ParameterKey=AppSubNetId,ParameterValue=$webappSubnetId ParameterKey=DbSubNetId,ParameterValue=$dbSubnetId ParameterKey=AppSecurityGroupId,ParameterValue=$webappSecurityGroup ParameterKey=DBSecurityGroupId,ParameterValue=$dbSecurityGroup
aws cloudformation wait stack-create-complete --stack-name $name
echo "Stack $name successfully created"