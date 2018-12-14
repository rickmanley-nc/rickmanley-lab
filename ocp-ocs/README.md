#To do:

- deploy idm to have ldap provider for ocp
- clean up ovirt-vm-infra-vars.yml
- have play in 1-ovirt-vm-infra-deploy that copies root ssh key from bastion to all ocp nodes. This way we can just run 0 and 1 playbook from laptop (no need to run 0 from laptop... then switch to bastion to run 1)
- playbook that takes snapshots of vm names
- playbook that unregisters vms and then deletes them
- etcd_disk setup?
- disable pre-checks (memory/storage constraints likely)
- what to do with lb.rnelson-demo.com?
- inventory
- os disks are currently 10G... do they need to be larger?
