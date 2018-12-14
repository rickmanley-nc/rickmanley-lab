#To do:

- playbook that takes snapshots of vm names
- playbook that unregisters vms and then deletes them
- chapter 3.8 docker storage setup.
docker_disk /dev/vdb
etcd_disk /dev/vdc
compare cloud_init_script : https://github.com/openshift/openshift-ansible-contrib/blob/master/reference-architecture/rhv-ansible/ovirt-infra-vars.yaml

and use their setup for vdb and vdc


- disable pre-checks (memory/storage constraints likely)
- what to do with lb.rnelson-demo.com?
- inventory
- os disks are currently 10G... do they need to be larger?
