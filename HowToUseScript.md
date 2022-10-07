# How to use CreateDeploymentCommands4Ubuntu.sh script

## Generate the Shell Script
Run the folowing commands
```
touch CreateDeploymentCommands4Ubuntu.sh
chmod 775 CreateDeploymentCommands4Ubuntu.sh
nano CreateDeploymentCommands4Ubuntu.sh
```
Paste the content of this file there
https://github.com/nic0michael/K3S-getting-started/blob/master/CreateDeploymentCommands4Ubuntu.sh

Press Ctrl X

Press Y

Press Enter

## Run the Shell Script
Run this command this way:
```
./CreateDeploymentCommands4Ubuntu.sh > make-master-and-worker-nodes.txt
```

## Display the generated File
To display the generated file run this command:
```
catmake-master-and-worker-nodes.txt
```
