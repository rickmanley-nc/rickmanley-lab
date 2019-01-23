# Deploy and Configure Satellite 6.4

This repo is still a ***WIP***, as it is being refactored from the Satellite repo that deploys it on a libvirt network. The intention for this repo is to have a separate physical server instead of a VM. Once I get the $ for another physical server, I'll redo the deployment playbook.


## Requirements and Steps

- OPTIONAL - Deploy IdM server from https://github.com/rickmanley-nc/rickmanley-lab/tree/master/idm
- Create an Activation Key (https://access.redhat.com/management/activation_keys) and add 1 Satellite subscription to it. Call the Activation Key "ak-satellite"
- Create a Subscription Allocation (https://access.redhat.com/management/subscription_allocations) and at least 1 Red Hat Enterprise Linux subscription to it.
  - Download the Subscription Manifest, via the Export Manifest button, and rename it to 'manifest-USERNAME-6.4.zip', where 'USERNAME' is your username
- Update `group_vars/all`
- Execute the following command to fully deploy and configure Satellite:
  - `wget -qO- https://github.com/rickmanley-nc/satellite/raw/master/run.sh | bash`
- Execute the following command to fully deploy and configure Satellite with integration to an existing IdM server:
  - `wget -qO- https://github.com/rickmanley-nc/satellite/raw/master/run-idm-integrated.sh | bash`


## Gotchas!

- Once you have your manifest, you'll need to verify which subscriptions are attached to the activation keys in `roles/activation-keys/tasks/main.yml`. We're using hammer output to search for the RHEL Server Premium and EPEL subscriptions. This can be restructured to search for any other subscriptions by changing the '--search' argument.

- If the playbook fails, it is not idempotent yet. You will likely need to delete the deployed VM and kick of the playbook again. Some of this is due to improper tagging, some because there's not a 'hammer' module, and some due to not having the correct conditionals. The 'check-for-existing-satellite' role is not used as effectively as it could, and that's something I'm currently working on.


## Roles

- check-for-existing-satellite
- hostname
- firewall
- etc-hosts
- register
- install-satellite
- configure-satellite
- install-satellite-idm-integrated
- configure-satellite-idm-integrated
- manifest
- domain
- openscap
- sync-plan
- lazy-sync
- lifecycle-environments
- product-repo-RHEL7
- product-repo-EPEL7
- ccv-RHEL7-EPEL7
- product-repo-EAP7
- ccv-RHEL7-EAP7
- activation-keys
- provision-libvirt
- ansible-tower-sync-prep

## Remaining Items to Complete

- Go goferless: https://access.redhat.com/articles/3154811
- Need to manually update Remote Execution on subnet. Hammer commands do not currently exist and there is no API: https://bugzilla.redhat.com/show_bug.cgi?id=1370460, http://projects.theforeman.org/issues/15249, http://projects.theforeman.org/issues/21231
- Need to manually update Compute Profiles to point to correct libvirt network, and storage point for VM disk. Hammer commands do not currently exist, and there is no API: https://projects.theforeman.org/issues/6344

## License

Red Hat, the Shadowman logo, Ansible, and Ansible Tower are trademarks or registered trademarks of Red Hat, Inc. or its subsidiaries in the United States and other countries.

All other parts of this project are made available under the terms of the [MIT License](LICENSE).
