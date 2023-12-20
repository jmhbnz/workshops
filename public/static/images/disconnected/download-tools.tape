Output download-tools.gif

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
Type `echo $PREP_SYSTEM_IP`
Enter 1
Sleep 2s
Type `ssh -i ~/disco_key ec2-user@$PREP_SYSTEM_IP`
Enter 1
Sleep 3s
Ctrl+L
Sleep 2s
Show


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
Enter 1
Sleep 2s
Type `cd /mnt/high-side`
Enter 1
Sleep 8s

Type `curl https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux.tar.gz -L -o oc.tar.gz`
Enter 1 Sleep 10s
Type `tar -xzf oc.tar.gz oc && rm -f oc.tar.gz`
Enter 1 Sleep 2s
Type `sudo cp oc /usr/local/bin/`
Enter 1 Sleep 4s

Type `curl https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/oc-mirror.tar.gz -L -o oc-mirror.tar.gz`
Enter 1 Sleep 10s
Type `tar -xzf oc-mirror.tar.gz && rm -f oc-mirror.tar.gz`
Enter 1 Sleep 2s
Type `chmod +x oc-mirror`
Enter 1 Sleep 2s
Type `sudo cp oc-mirror /usr/local/bin/`
Enter 1 Sleep 4s

Type `curl https://mirror.openshift.com/pub/openshift-v4/clients/mirror-registry/latest/mirror-registry.tar.gz -L -o mirror-registry.tar.gz`
Enter 1 Sleep 10s
Type `tar -xzf mirror-registry.tar.gz`
Enter 1 Sleep 2s
Type `rm -f mirror-registry.tar.gz`
Enter 1 Sleep 4s

Type `curl https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-install-linux.tar.gz -L -o openshift-installer.tar.gz`
Enter 1 Sleep 10s
Type `tar -xzf openshift-installer.tar.gz openshift-install`
Enter 1 Sleep 2s
Type `rm -f openshift-installer.tar.gz`
Enter 1 Sleep 4s
