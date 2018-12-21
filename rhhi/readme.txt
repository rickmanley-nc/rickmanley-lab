#From pressing power button on all 3 systems, the OS install + 1-prep.yml + wizard install + 4-network.yml takes 1hr07m30s


Things to do:
- document kickstart (add 'ansible' user)
- convert gdeploy conf to playbook with variables
- test 3-engine after copying in gdeploy conf into cockpit directory
- document ovirt-image-template / automate the install from galaxy and execution.



Notes on limitations:
- The SYS-E200-8D systems require an OOB license to be able to use the Redfish APIs through a Redfish enabled firmware.
