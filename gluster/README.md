
#Notes for deployment

Steps on client:
- mount -t glusterfs gluster-1.rnelson-demo.com:/ganesha /mnt/client/
- cd /mnt/client/
- mkdir -p directory1/subdirectory1
- mkdir -p directory2/subdirectory2
- touch directory1/subdirectory1/file-{1..5}
- touch directory2/subdirectory2/file-{6..10}
- touch directory1/file-{11..15}
- touch directory2/file-{16..20}


On gluster-1:
/var/run/gluster/shared_storage/nfs-ganesha/exports/export.ganesha.conf

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

/usr/libexec/ganesha/ganesha-ha.sh --refresh-config /var/run/gluster/shared_storage/nfs-ganesha/ ganesha
Then restart nfs-ganesha on all gluster nodes
