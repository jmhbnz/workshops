Output sneakernet-transfer.gif

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
Ctrl+L
Show
Type `HIGHSIDE_BASTION_IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=disco-bastion-server" | jq -r '.Reservations[0].Instances[0].PrivateIpAddress')`
Enter 1
Sleep 4s
Type `ssh -t -i disco_key ec2-user@$PREP_SYSTEM_IP "ssh -t -i disco_key ec2-user@$HIGHSIDE_BASTION_IP"`
Enter 3
Sleep 4s


Type `sudo mkfs -t xfs /dev/nvme1n1`
Enter 1
Sleep 2s
Type `sudo mkdir /mnt/high-side`
Enter 1
Sleep 2s
Type `sudo mount /dev/nvme1n1 /mnt/high-side`
Enter 1
Sleep 2s
Type `sudo chown ec2-user:ec2-user /mnt/high-side`
Enter 3
Sleep 4s
Type `exit`
Enter 1
Sleep 2s

Type `ssh -t -i disco_key ec2-user@$PREP_SYSTEM_IP "rsync -avP -e 'ssh -i disco_key' /mnt/high-side ec2-user@$HIGHSIDE_BASTION_IP:/mnt"`
Enter 1
Sleep 30
