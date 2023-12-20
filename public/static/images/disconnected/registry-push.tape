Output registry-push.gif

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
Type `#SG_ID=$(aws ec2 describe-security-groups --filters "Name=tag:Name,Values=disco-sg" | jq -r '.SecurityGroups[0].GroupId')`
Enter 1
Sleep 1s
Type `#PUBLIC_SUBNET=$(aws ec2 describe-subnets | jq '.Subnets[] | select(.Tags[].Value=="Public Subnet - disco").SubnetId' -r)`
Enter 1
Sleep 5s
Type `PREP_SYSTEM_IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=disco-prep-system" | jq -r '.Reservations[0].Instances[0].PublicIpAddress')`
Enter 1
Sleep 2s

Type `HIGHSIDE_BASTION_IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=disco-bastion-server" | jq -r '.Reservations[0].Instances[0].PrivateIpAddress')`
Enter 1
Sleep 4s
Type `ssh -t -i disco_key ec2-user@$PREP_SYSTEM_IP "ssh -t -i disco_key ec2-user@$HIGHSIDE_BASTION_IP"`
Enter 3
Sleep 4s
Ctrl+L
Sleep 4s
Show

Type `sudo cp /mnt/high-side/oc /usr/local/bin/`
Enter 1
Sleep 2s
Type `sudo cp /mnt/high-side/oc-mirror /usr/local/bin/`
Enter 1
Sleep 4s

Enter 3
Type `oc mirror --from=/mnt/high-side/mirror_seq1_000000.tar --dest-skip-tls docker://$(hostname):8443`
Enter 1
Sleep 30s
