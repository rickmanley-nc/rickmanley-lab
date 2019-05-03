# 6 node gluster deployment with nfs-ganesha + cache drive
## Caveat

This repo is meant to demonstrate how to deploy 6 Gluster nodes that have a volume configured for NFS-Ganesha while using an extra drive for an LVM cache. In this specific repo, I'm ***deploying*** on top of RHHI-V (RHV + Gluster). It is meant just as a demonstration purpose and is not meant to be deployed on RHHI in this manner.

The `2-gdeploy-ganesha.conf` and `3-gdeploy-cache.conf` files can still be used for physical node deployments, which is the intention of this repo.

## Assumptions

This deployment assumes 3 block devices are being used on each node (vda, vdb, and vdc). The `1-gluster-deploy.yml` playbook is run from a control node, and accomplishes the following:
  - deploys 7 nodes on RHHI (6 Gluster servers and 1 Gluster client)
  - registers with Customer Portal
  - enables correct repositories
  - configures ssh-keys
  - configures known_hosts

Make sure to update any variables, hostnames, sizes, etc within each playbook. In the future, I may update this repo with a `group_vars/all` file to have 1 location for variables, but this is not a priority at the moment.

## Gotchas

Resetting the environment is still being tested. Testing the `ganesha_destroy.conf`, we found that the line for the gluster_shared_storage was still in `/etc/fstab`. I believe we need to add a `lineinfile` module to the `0-reset.yml` playbook to ensure that line gets deleted.

The 'corosync', 'pacemaker', and 'nfs-ganesha' daemons have been enabled to run at boot. This is ***not*** the default behavior. Enabling them to run at boot is good practice for HA, but it may not be the desired behavior for your use case. If you choose to disable these at boot, the following commands can be run on a node to get it joined back into the cluster and exporting the share:

- pcs status
- pcs cluster start #### --all should be added if we're starting the pcs cluster on EVERY node.
- Wait for `pcs status` to report all resources up and running
- ansible gluster -a "systemctl restart nfs-ganesha"

Last gotcha... I noticed some lag on a node rebooting where the 'nfs-ganesha' daemon did not initialize properly. Restarting the daemon fixed this... looks like a timing issue on bootup. Perhaps `_netdev` option would resolve this.

## General Steps:
1. Ensure that the Control Node's `/etc/ansible/hosts` file includes the following:
```
[gluster-nfs]
gluster-[1:6].rnelson-demo.com

[gluster-client]
gluster-client.rnelson-demo.com
```
2. Update activation_key, rhn_org_id, and org_id.
3. Deploy the infrastructure from the Control Node: `ansible-playbook -u root 1-gluster-deploy.yml -k`
4. Once deployed, log into `gluster-1.rnelson-demo.com` and ensure that the `/etc/ansible/hosts` file also includes the following:
```
[gluster-nfs]
gluster-[1:6].rnelson-demo.com
```
5. Deploy the Gluster cluster and configure NFS Ganesha from `gluster-1.rnelson-demo.com`: `gdeploy -c 2-gdeploy-ganesha.conf`
6. Configure the cache drive (by default, vdc) from `gluster-1.rnelson-demo.com`: `gdeploy -c 3-gdeploy-cache.conf`
7. Enable corosync and pacemaker to start on boot:
```
ansible gluster-nfs -u root -a "systemctl enable corosync"
ansible gluster-nfs -u root -a "systemctl enable pacemaker"
ansible gluster-nfs -u root -a "systemctl enable nfs-ganesha"
```
8. ***only for troubleshooting*** If you need to reset the environment:
  - `gdeploy -c ganesha_destroy.conf`
  - `ansible-playbook 0-reset.yml`
  - Remove line from /etc/fstab referencing nfs-ganesha volume. This should be added to the ganesha_destroy or reset playbook.

## Exporting a subdirectory
### Prepare the filesystem from the client:
- mkdir /mnt/ganesha
- mount -t glusterfs gluster-1.rnelson-demo.com:/ganesha /mnt/ganesha/
- mkdir -p /mnt/ganesha/directory1/subdirectory1
- mkdir -p /mnt/ganesha/directory2/subdirectory2
- touch /mnt/ganesha/directory1/subdirectory1/file-{1..5}
- touch /mnt/ganesha/directory2/subdirectory2/file-{6..10}
- touch /mnt/ganesha/directory1/file-{11..15}
- touch /mnt/ganesha/directory2/file-{16..20}
- umount /mnt/ganesha

### Create 2 additional entries for subdirectory exports on gluster-1.rnelson-demo.com:
The `/var/run/gluster/shared_storage/nfs-ganesha/exports/export.ganesha.conf` file contains the exports. You can create separate export files, and reference them with 'include' lines in the original export file, but this example is a configuration of having all exports defined within one file:
```
[root@gluster-1 exports]# cat export.ganesha.conf
EXPORT{
      Export_Id = 2;
      Path = "/ganesha";
      FSAL {
           name = GLUSTER;
           hostname="localhost";
          volume="ganesha";
           }
      Access_type = RW;
      Disable_ACL = false;  # to allow NFS ACLs
      Squash="No_root_squash";
      Pseudo="/ganesha";
      Protocols = "3", "4" ;
      Transports = "UDP","TCP";
      SecType = "sys";
     }

EXPORT{
      Export_Id = 3;
      Path = "/ganesha/directory1";
      FSAL {
           name = GLUSTER;
           hostname="localhost";
          volume="ganesha";
	  volpath="/directory1";
           }
      Access_type = RW;
      Disable_ACL = false;  # to allow NFS ACLs
      Squash="No_root_squash";
      Pseudo="/ganesha/directory1";
      Protocols = "3", "4" ;
      Transports = "UDP","TCP";
      SecType = "sys";
     }

EXPORT{
      Export_Id = 4;
      Path = "/ganesha/directory2";
      FSAL {
           name = GLUSTER;
           hostname="localhost";
          volume="ganesha";
          volpath="/directory2";
           }
      Access_type = RW;
      Disable_ACL = false;  # to allow NFS ACLs
      Squash="No_root_squash";
      Pseudo="/ganesha/directory2";
      Protocols = "3", "4" ;
      Transports = "UDP","TCP";
      SecType = "sys";
      client {
              clients = 192.168.1.174;  # IP of the client.
              access_type = "RO"; # Read-only permissions
              Protocols = "3"; # Allow only NFSv3 protocol.
              anonymous_uid = 1440;
              anonymous_gid = 72;
       }
     }
```
After updating/creating the exports, run the following on `gluster-1.rnelson-demo.com`:
```
/usr/libexec/ganesha/ganesha-ha.sh --refresh-config /var/run/gluster/shared_storage/nfs-ganesha/ ganesha
```
You'll get some errors similar to below... these can be ignored as we'll be restarting the nfs-ganesha daemon on all nodes. This block is just informational:
```
Refresh-config failed on gluster-2. Please check logs on gluster-2
Refresh-config failed on gluster-3. Please check logs on gluster-3
Refresh-config failed on gluster-4. Please check logs on gluster-4
Refresh-config failed on gluster-5. Please check logs on gluster-5
Refresh-config failed on gluster-6. Please check logs on gluster-6
Refresh-config failed on localhost.
```
Now restart nfs-ganesha on all gluster nodes. This step should be tested more.
- ansible gluster-nfs -a "systemctl restart nfs-ganesha"

Verify that the mounts show up:
- showmount -e gluster-3.rnelson-demo.com

### Testing from gluster-client:
This should **succeed**:
- mount -t nfs -o vers=4.0 gluster-1.rnelson-demo.com:/ganesha/directory1/ /mnt/ganesha/
This should **fail** because vers=4.0 is not allowed on directory2:
- mount -t nfs -o vers=4.0 gluster-1.rnelson-demo.com:/ganesha/directory2/ /mnt/ganesha/
This should **succeed**:
- mount -t nfs -o vers=3 gluster-1.rnelson-demo.com:/ganesha/directory2/ /mnt/ganesha/
This should **fail** because the export enforces this client to only be read-only
- touch /mnt/ganesha/test.txt
