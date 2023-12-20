Output launch-bastion-ec2.gif

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
Sleep 5s
Ctrl+L
Show

Type `PRIVATE_SUBNET=$(aws ec2 describe-subnets | jq '.Subnets[] | select(.Tags[].Value=="Private Subnet - disco").SubnetId' -r)`
Enter 1
Sleep 4s
Type `echo $PRIVATE_SUBNET`
Enter 1
Sleep 2s
Type `SG_ID=$(aws ec2 describe-security-groups --filters "Name=tag:Name,Values=disco-sg" | jq -r '.SecurityGroups[0].GroupId')`
Enter 1
Sleep 4s
Type `echo $SG_ID`
Enter 3
Sleep 2s


Type `aws ec2 run-instances --image-id $(cat ami.txt) \`
Enter 1
Type `  --count 1 --instance-type t3.large \`
Enter 1
Type `  --key-name disco-key \`
Enter 1
Type `  --security-group-ids $SG_ID \`
Enter 1
Type `  --subnet-id $PRIVATE_SUBNET \`
Enter 1
Type `  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=disco-bastion-server}]" \`
Enter 1
Type `  --block-device-mappings "DeviceName=/dev/sdh,Ebs={VolumeSize=50}"`
Enter 1

Sleep 10s
