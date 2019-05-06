# Deploy IdM on RHHI

This repo is refactored from the IdM repo to deploy on a libvirt network.

1. Update group_vars/all
2. Update control's ansible hosts with correct idm group
2. ansible-playbook deploy.yml
3. ansible-playbook -u root main.yml -k
