#gluster deployment with nfs-ganesha + cache drive
##Assumptions
This deployment assumes the following:
- The `1-gluster-deploy.yml` playbook is run from a control node, and accomplishes the following:
  - deploys 7 VMs (6 Gluster servers and 1 Gluster client)
  - The 6 Gluster server VMs have 2 additional disks attached, for a total of 3 (vda, vdb, and vdc)
  - registering with Customer Portal
  - enabling repos
  - configuring ssh-keys
  - configuring known_hosts
- Make sure to update any variables, hostnames, sizes, etc within each playbook. In the future, I may update this repo with a group_vars/all file to have 1 location for variables.



##General Steps:
1. Ensure that the Control Node's `/etc/ansible/hosts` file includes the following:
```
[gluster]
gluster-[1:6].rnelson-demo.com
```
2. Deploy the infrastructure from the Control Node: `ansible-playbook 1-gluster-deploy.yml`
3. Once deployed, log into `gluster-1.rnelson-demo.com` and ensure that the `/etc/ansible/hosts` file includes the following:
```
[gluster]
gluster-[1:6].rnelson-demo.com
```
4. Deploy the Gluster cluster and configure NFS Ganesha from `gluster-1.rnelson-demo.com`: `gdeploy -c 2-gdeploy-ganesha.conf`
5. Configure the cache drive (by default, vdc) from `gluster-1.rnelson-demo.com`: `gdeploy -c 3-gdeploy-cache.conf`



##Exporting a subdirectory
###Prepare the filesystem from the client:
- mkdir /mnt/client
- mount -t glusterfs gluster-1.rnelson-demo.com:/ganesha /mnt/client/
- cd /mnt/client/
- mkdir -p directory1/subdirectory1
- mkdir -p directory2/subdirectory2
- touch directory1/subdirectory1/file-{1..5}
- touch directory2/subdirectory2/file-{6..10}
- touch directory1/file-{11..15}
- touch directory2/file-{16..20}


###Create a subdirectory export on gluster-1.rnelson-demo.com:
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
      Disable_ACL = true;
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
      Disable_ACL = true;
      Squash="No_root_squash";
      Pseudo="/ganesha/directory1";
      Protocols = "3", "4" ;
      Transports = "UDP","TCP";
      SecType = "sys";
     }
```
After updating/creating the exports, run the following on `gluster-1.rnelson-demo.com`:
```
/usr/libexec/ganesha/ganesha-ha.sh --refresh-config /var/run/gluster/shared_storage/nfs-ganesha/ ganesha
```
Now restart nfs-ganesha on all gluster nodes.
- ansible gluster -a "service nfs-ganesha restart"
