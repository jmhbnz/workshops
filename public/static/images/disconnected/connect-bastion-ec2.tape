Output connect-bastion-ec2.gif

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

Type `HIGHSIDE_BASTION_IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=disco-bastion-server" | jq -r '.Reservations[0].Instances[0].PrivateIpAddress')`
Enter 1 Sleep 4s
Type `echo $HIGHSIDE_BASTION_IP`
Enter 1 Sleep 2s

Type `PREP_SYSTEM_IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=disco-prep-system" | jq -r '.Reservations[0].Instances[0].PublicIpAddress')`
Enter 1 Sleep 4s
Type `scp -i disco_key disco_key ec2-user@$PREP_SYSTEM_IP:/home/ec2-user/disco_key`
Enter 3 Sleep 4s

Type `ssh -i disco_key ec2-user@$PREP_SYSTEM_IP "echo HIGHSIDE_BASTION_IP=$(echo $HIGHSIDE_BASTION_IP) > highside.env"`
Enter 3 Sleep 4s

Type `ssh -t -i disco_key ec2-user@$PREP_SYSTEM_IP "ssh -t -i disco_key ec2-user@$HIGHSIDE_BASTION_IP"`
Enter 1 Sleep 10s
