# Gluster + Ansible Demo

This is sourced from John Call and Mike Flannery's Gluster Ansible Demo, and repurposed for my RHHI homelab.

## Instructions

Deploy and Prep from laptop / control node:

1. ansible-playbook -u root 1-gluster-demo-deploy.yml -k
2. ansible-playbook -u root 2-gluster-demo-prep.yml -k
3. Manually create Windows10 node. Steps in the "To Do" section below.

Run demo from gluster-1:

4. ansible-playbook 3-gluster-demo.yml

## Reset
Reset playbook does not fully function yet. In the meantime, revert to a snapshot after deploy and prep.



## To Do
- Add group_vars. Currently user flannery, hostnames, and disk labels are hard coded.
 - Change hostnames to gluster-1-workshop, gluster-2-workshop, gluster-3-workshop
- Create Win10 system for samba testing during demo
  - Upload Win10 ISO
  - New VM: 4GB RAM, 2 CPU, 15 GB disk (bootable), add ovirtmgmt network, change timezone
  - During install, boot from WIN10 iso, change to RHV agent tools iso to select the virtio scsi driver, change back to Win10 iso to finish install.
  - Once installed, change cd to RHV agent tools and run the application to install the network and spice drivers
  - Create template
- add RHV snapshot playbook to directory to automatically take a snap after deployment and configuration.
- add restore from snapshot playbook
