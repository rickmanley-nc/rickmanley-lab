#To do:

- I combined 0+1 and 2+3. Next run should be 0+2.
- playbook that takes snapshots of vm names
- upload rickmanley-lab to github.
- update 1-bastion-prep.yml with git clone of rickmanley-lab repo.
- update 2-ovirt-vm-infra-deploy.yml with bastion's ssh key.
- chapter 3.8 docker storage setup.
docker_disk /dev/vdb
etcd_disk /dev/vdc
compare cloud_init_script : https://github.com/openshift/openshift-ansible-contrib/blob/master/reference-architecture/rhv-ansible/ovirt-infra-vars.yaml

and use their setup for vdb and vdc


- disable pre-checks (memory/storage constraints likely)
- what to do with lb.rnelson-demo.com?
- inventory
- os disks are currently 10G... do they need to be larger?
