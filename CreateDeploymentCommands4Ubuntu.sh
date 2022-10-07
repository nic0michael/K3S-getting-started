#!/bin/sh

#nano CreateDeploymentCommands4Ubuntu.sh
#chmod 775 CreateDeploymentCommands4Ubuntu.sh
#./CreateDeploymentCommands4Ubuntu.sh > make-master-and-worker-nodes.txt

LOGIN_USER1="tonia"
LOGIN_USER2="nickm"
LOGIN_USER3="nickm"


MASTER_NODE_IP="10.154.2.113"
FIRST_WORKER_NODE_IP="10.154.2.93"
SECOND_WORKER_NODE_IP="10.154.2.97"


MASTER_NODE_NAME="tiger.loseyourip.com"
FIRST_WORKER_NODE_NAME="kudu.loseyourip.com"
SECOND_WORKER_NODE_NAME="lion.loseyourip.com"

#You need to change this token after the installation of the master node has been creaated
MASTER_TOKEN="k3s_token="K101fd8ba79ac56ad5c615267b43a3d52e2706c4632796ec049e29bf2165dec658d::server:00e58ab05f737514ff0cb3e8d5cee9e6"

MASTER_NODE_URL="https://$MASTER_NODE_IP:6443"
echo "DONT EDIT THIS FILE IT IS GENERATED BY THE SHELL SCRIPT"
echo "## K3S_Master_node_and_worker_nodes_create_commands_for_Ubuntu.txt ##"
echo "\n"
echo "#################"
echo "# PREREQUISITES #"
echo "#################"
echo "Download Ubuntu Server 18.04"
echo "Install three VM instances in VirtualBox with these IP Addresses:"
echo "1. ${MASTER_NODE_IP} for the Master Node"
echo "2. ${FIRST_WORKER_NODE_IP} for the First Worker Node"
echo "3. ${SECOND_WORKER_NODE_IP} for the Second Worker Node"
echo "\n"
echo "Use DynuDNS (https://www.dynu.com/en-US/ControlPanel) create three DDNS services :"
echo "1. ${MASTER_NODE_NAME} pointing to IP Address: ${MASTER_NODE_IP} for the Master Node"
echo "2. ${FIRST_WORKER_NODE_NAME} pointing to IP Address: ${FIRST_WORKER_NODE_IP} for the First Worker Node"
echo "3. ${SECOND_WORKER_NODE_NAME} pointing to IP Address: ${SECOND_WORKER_NODE_IP} for the Second Worker Node"
echo "\n"
echo "######################"
echo "# Create Master node #"
echo "######################"
echo "ssh $LOGIN_USER1@$MASTER_NODE_IP"
echo "sudo su -"
echo "/usr/local/bin/k3s-killall.sh"
echo "/usr/local/bin/k3s-agent-uninstall.sh"
echo "/usr/local/bin/k3s-uninstall.sh"
echo "\n"
echo "node_ip=\"$MASTER_NODE_IP\""
echo "node_name=\"$MASTER_NODE_NAME\""
echo "curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC=\"--node-ip \${node_ip}\" K3S_NODE_NAME=\${node_name} sh -"
echo "\n"
echo "##################################"
echo "# First Update Master Token here #"
echo "##################################"
echo "cat /var/lib/rancher/k3s/server/node-token"
echo "Update the token in this file"
echo "\n"

echo "############################"
echo "# Create First Worker Node #"
echo "############################"
echo "ssh $LOGIN_USER4@$FIRST_WORKER_NODE_IP"
echo "sudo su -"
echo "/usr/local/bin/k3s-killall.sh"
echo "/usr/local/bin/k3s-uninstall.sh"
echo "/usr/local/bin/k3s-agent-uninstall.sh"
echo "\n"
echo "k3s_token=\"$MASTER_TOKEN\""
echo "k3s_url=\"$MASTER_NODE_URL\""
echo "node_ip=\"$FIRST_WORKER_NODE_IP\""
echo "node_name=\"$FIRST_WORKER_NODE_NAME\""
echo "curl -sfL https://get.k3s.io | K3S_URL=\${k3s_url} K3S_TOKEN=\${k3s_token} K3S_NODE_IP=\${node_ip} K3S_NODE_NAME=\${node_name} sh -"
echo "\n"

echo "############################"
echo "# Create Second Worker Node #"
echo "############################"
echo "ssh $LOGIN_USER5@$SECOND_WORKER_NODE_IP"
echo "sudo su -"
echo "/usr/local/bin/k3s-killall.sh"
echo "/usr/local/bin/k3s-uninstall.sh"
echo "/usr/local/bin/k3s-agent-uninstall.sh"
echo "\n"
echo "k3s_token=\"$MASTER_TOKEN\""
echo "k3s_url=\"$MASTER_NODE_URL\""
echo "node_ip=\"$SECOND_WORKER_NODE_IP\""
echo "node_name=\"$SECOND_WORKER_NODE_NAME\""
echo "curl -sfL https://get.k3s.io | K3S_URL=\${k3s_url} K3S_TOKEN=\${k3s_token} K3S_NODE_IP=\${node_ip} K3S_NODE_NAME=\${node_name} sh -"
echo "############################"
echo "\n"
echo "ssh $LOGIN_USER1@$MASTER_NODE_IP"
echo "sudo su -"
echo "kubectl get nodes"
echo "\n"
echo "#######################"
echo "# Destroy all servers #"
echo "#######################"
echo "ssh $LOGIN_USER1@$MASTER_NODE_IP"
echo "sudo su -"
echo "/usr/local/bin/k3s-killall.sh"
echo "/usr/local/bin/k3s-uninstall.sh"
echo "/usr/local/bin/k3s-agent-uninstall.sh"
echo "\n"
echo "ssh $LOGIN_USER4@$FIRST_WORKER_NODE_IP"
echo "sudo su -"
echo "/usr/local/bin/k3s-killall.sh"
echo "/usr/local/bin/k3s-uninstall.sh"
echo "/usr/local/bin/k3s-agent-uninstall.sh"
echo "\n"
echo "ssh $LOGIN_USER5@$SECOND_WORKER_NODE_IP"
echo "sudo su -"
echo "/usr/local/bin/k3s-killall.sh"
echo "/usr/local/bin/k3s-uninstall.sh"
echo "/usr/local/bin/k3s-agent-uninstall.sh"
