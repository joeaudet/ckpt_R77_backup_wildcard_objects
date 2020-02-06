#!/bin/bash

#Script used to find, backup and archive all wildcard object files on an R77 MDS server,
#while preserving the original folder structure for possible reversion without
#needing to do a full snapshot restore. Used as part of an R77 to R80 upgrade
#where wildcard objects are in use
#
#ckpt_R77_backup_wildcard_objects.sh - jaudet@ans-llc.net
#
#v1 - 2020FEB05

# get CP environment
. /etc/profile.d/CP.sh

# check if script is running with root privileges
if [ ${EUID} -ne 0 ];then
  echo "Please run as admin"
  exit 1
fi

# remove lock
echo "Removing lock"
clish -c 'lock database override' > /dev/null

#define misc variables
WILDCARD_FILES_LISTING_NAME="wildcard_objects_listing.txt"
TEMPDIR=/tmp/$HOSTNAME-wildcard_objects_backup
OUTPUTDIR=/tmp
ARCHIVEFILENAME="wildcard_object_files_backup-$HOSTNAME-$DATE.tar.gz"


#Create temp directory to backup files into if doesn't exist. If exists, do nothing
if [ -d $TEMPDIR ]
then
    echo "Directory $TEMPDIR exists."
else
    echo "Error: Directory $TEMPDIR does not exists - creating"
    mkdir $TEMPDIR
fi

#Create an array where we will store the results of every 'objects_5_0.C' file we find on the MDS server
function find_files_for_backup() {
  WILDCARD_FILES=()
    while IFS=  read -r -d $'\0'; do
      WILDCARD_FILES+=("$REPLY")
      done < <(find / -name "objects_5_0.C" -print0)
echo "All wildcard object files found and stored in an array"
}

#Make backup copies
function backup_wilcard_object_files() {
  for file in "${WILDCARD_FILES[@]}"
  do
    #Append the current filenamee and path to a text file for rollback purposes, store it in the same directory the script is run from
    echo $file >> "${PWD}/${WILDCARD_FILES_LISTING_NAME}"

    #Set some variables, and backup all of the files while retaining the original folder structure
    DIR=$(dirname "${file}")
    DSTDIR="${TEMPDIR}/${DIR}"
    #Check if file exists, if so create a new directory within the TEMPDIR folder to store a copy of the file in
    [ -f $file ] && mkdir -p ${DSTDIR}
    #Check if the file exists, if so make a backup copy of the file
    [ -f $file ] && cp ${file} ${DSTDIR}
    #echo $DSTDIR
  done
echo "All wildcard object files backed up and listed in file ${PWD}/${WILDCARD_FILES_LISTING}"
}

#Execute the find and backup functions
find_files_for_backup
backup_wilcard_object_files

#Create archive of the backed up files
tar czf $OUTPUTDIR/$ARCHIVEFILENAME $TEMPDIR/
