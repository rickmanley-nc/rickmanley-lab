# Deploy IdM on RHHI

This repo is refactored from the IdM repo to deploy on a libvirt network.

1. Update group_vars/all
2. Update control's ansible hosts with correct idm group
3. ansible-playbook deploy.yml
4. ansible-playbook -u root main.yml -k


## Need to do

Create a playbook that populates the database with:
- users and ssh keys (if available)
- groups
- sudo mapping or adding users to local wheel group
- RBAC and HBAC for lab environment
