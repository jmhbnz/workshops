Output launch-prep-ec2.gif

Require echo

Set Shell "bash"
Set FontSize 32
Set Width 1920
Set Height 800

Hide
Type `cd`
Enter 1
Type `SBP_PATH=/home/james/Downloads/sbp`
Enter 1
Type `source /home/james/Downloads/sbp/sbp.bash`
Enter 1
Type `SG_ID=$(aws ec2 describe-security-groups --filters "Name=tag:Name,Values=disco-sg" | jq -r '.SecurityGroups[0].GroupId')`
Enter 1
Sleep 1s
Type `PUBLIC_SUBNET=$(aws ec2 describe-subnets | jq '.Subnets[] | select(.Tags[].Value=="Public Subnet - disco").SubnetId' -r)`
Enter 1
Ctrl+L
Sleep 5s
Show

Type `aws ec2 run-instances --image-id "ami-092b43193629811af" \`
Enter 1
Type `  --count 1 --instance-type t3.micro \`
Enter 1
Type `  --key-name disco-key \`
Enter 1
Type `  --security-group-ids $SG_ID \`
Enter 1
Type `  --subnet-id $PUBLIC_SUBNET \`
Enter 1
Type `  --associate-public-ip-address \`
Enter 1
Type `  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=disco-prep-system}]" \`
Enter 1
Type `  --block-device-mappings "DeviceName=/dev/sdh,Ebs={VolumeSize=50}"`
Enter 1

Sleep 10s
