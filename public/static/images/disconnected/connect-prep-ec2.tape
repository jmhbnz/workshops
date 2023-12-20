Output connect-prep-ec2.gif

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

Type `PREP_SYSTEM_IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=disco-prep-system" | jq -r '.Reservations[0].Instances[0].PublicIpAddress')`
Enter 1
Sleep 2s
Type `echo $PREP_SYSTEM_IP`
Enter 1
Sleep 1s
Type `ssh -i ~/disco_key ec2-user@$PREP_SYSTEM_IP`
Enter 1
Sleep 10s
