#From pressing power button on all 3 systems, the OS install + 1-prep.yml + wizard install + 4-network.yml takes 1hr07m30s


[Fri Dec 21 13:19:48] [rnelson@laptop ~/git/rickmanley-lab/rhhi]
$ ansible-playbook -u root 2-storage.yml
[Fri Dec 21 13:33:44] [rnelson@laptop ~/git/rickmanley-lab/rhhi]


Things to do:
- document the following:
 - rhhi-1-ks.cfg
 - /etc/ansible/hosts on the Ansible control node (ssh keys generated based off of RHHI group within hosts)
- test without /etc/hosts (use ip addr for gluster network)
- convert gdeploy conf file to playbook
- document ovirt-image-template / automate the install from galaxy and execution.
- tag taxonomy
- variable layout

Nice to have:
- Automate ks.cfg creation, similar to Satellite repo


Notes on limitations:
- The SYS-E200-8D systems require an OOB license to be able to use the Redfish APIs through a Redfish enabled firmware.
