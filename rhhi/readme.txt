From pressing power button on all 3 systems, the OS install + 1-prep.yml + wizard install + 4-network.yml takes 1hr07m30s


upload ISOs:
 - Win 10
 - RHEL 7.6

upload kvm image:
 - RHEL 7.6 KVM Guest

create template:
 - Win10
 - RHEL7.6
 - Satellite?


Create openshift 5 node:
- 1 master
- 1 infra
- 3 app node (1 pinned to each hypervisor?)
