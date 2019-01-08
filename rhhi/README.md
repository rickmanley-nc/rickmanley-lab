# RHHI HomeLab

This guide focuses on deploying a 3-node Red Hat Hyperconverged Infrastructure (RHHI) through Ansible Playbooks, fully functioning with little to no additional configuration needed, all within 1.5 hour.

## Assumptions
The kickstart files set up the OS disk (`sda`), and leave the creation of the other partitions `sda4` and `sda5` for the `1-prep.yml` playbook. These Supermicro servers don't have a lot of room in them for another 2.5" drive, so I elected to just use a larger `sda` disk and partition it out. If you have a different disk layout than what's described below, you'll want to modify the device names within `group_vars/all`.

Storage:
- /dev/sda is 500GiB and will store the following:
  - /dev/sda1 - 256 MiB - /boot/efi
  - /dev/sda2 - 1024 MiB - /boot
  - /dev/sda3 - 45 GiB - Operating System
  - /dev/sda4 - 69 GiB - engine volume
  - /dev/sda5 - 335 GiB - ssdvmstore volume
  - /dev/nvme0n1 - 225 GiB - nvmevmstore volume

## Requirements
Update your variable declarations in `group_vars/all.bak` and rename this to `group_vars/all`.

Update your control node's ansible/hosts file to include the following, the 1-prep.yml playbook relies on the "rhhi" group to deploy root's ssh keys:

`[rhhi]
rhhi[1:3].rnelson-demo.com`


Update 1-prep.yml 'personal' tag tasks.


os-disk: /dev/sda3 (LVM)
engine: /dev/sda4
ssdvmstore: /dev/sda5


## Remaining tasks to complete:
- Document the following:
  - Ensure python-ovirt-engine-sdk4 is on control node
- test without /etc/hosts failed. Test again (use ip addr for gluster network)
- convert gdeploy conf file to playbook
- document ovirt-image-template / automate the install from galaxy and execution.
- tag taxonomy

## Nice to have:
- The SYS-E200-8D systems require an OOB license to be able to use the Redfish APIs through a Redfish enabled firmware.
