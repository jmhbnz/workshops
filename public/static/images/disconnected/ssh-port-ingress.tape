Output ssh-port-ingress.gif

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
Ctrl+L
Sleep 4s
Show

Type `aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0`
Enter 1
Sleep 4s
