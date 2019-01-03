# RHHI HomeLab

This guide focuses on deploying a 3-node Red Hat Hyperconverged Infrastructure (RHHI), fully functioning with little to no additional configuration needed through Ansible Playbooks, all under 1 hour.

From pressing power button on all 3 systems, the OS install + Ansible Playbooks takes `0hr58m30s`

## Requirements for "Control Node"

I'm using my laptop (Fedora) as the control node. The following /etc/ansible/hosts file is used:

  *link to laptop-configure ansible-hosts file*

## Remaining tasks to complete:
- Document the following:
  - /etc/ansible/hosts on the Ansible control node
  - Ensure python-ovirt-engine-sdk4 is on control node
- test without /etc/hosts failed. Test again (use ip addr for gluster network)
- convert gdeploy conf file to playbook
- document ovirt-image-template / automate the install from galaxy and execution.
- tag taxonomy

## Nice to have:
- The SYS-E200-8D systems require an OOB license to be able to use the Redfish APIs through a Redfish enabled firmware.
