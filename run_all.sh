#!/bin/bash
echo "=== KEY GENERATION ==="
if [ ! -f ./ssh_keys/aws_vpn_key ]
then
    ssh-keygen -b 4096 -f ./ssh_keys/aws_vpn_key -C "AWS VPN" -q -N ""
fi

echo "=== TERRAFORM ==="
terraform init
export TF_VAR_ip_address=$(curl --no-progress-meter -4 ifconfig.co)/32
terraform apply -auto-approve

# Wait for elastic ip allocation
sleep 20

echo "=== ANSIBLE ==="
ansible-playbook -i hosts openvpn.yml
