### ckpt_R77_backup_wildcard_objects
Check Point script used to find, backup and archive all wildcard object files on an R77 MDS server, while preserving the original folder structure for possible reversion without needing to do a full snapshot restore. Used as part of an R77 to R80 upgrade where wildcard objects are in use

### Script Setup
1. SSH into R77 MDS server
1. Enter EXPERT mode
1. Copy file [ckpt_R77_backup_wildcard_objects.sh](https://raw.githubusercontent.com/joeaudet/ckpt_R77_backup_wildcard_objects/master/ckpt_R77_backup_wildcard_objects.sh) to /home/admin on R77 MDS server
   ```
   curl_cli -k https://raw.githubusercontent.com/joeaudet/ckpt_R77_backup_wildcard_objects/master/ckpt_R77_backup_wildcard_objects.sh  > /home/admin/ckpt_R77_backup_wildcard_objects.sh
   ```
1. chmod the script to be executable
   ```
   chmod u+x /home/admin/ckpt_R77_backup_wildcard_objects.sh
   ```
