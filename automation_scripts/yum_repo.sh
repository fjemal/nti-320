#!/bin/bash
# this is a script to add a yum repo on a given server.

#ip="104.154.86.19"                                                    # Please replace with your own IP
#gcloud compute instances create INSTANCE 

ip=$(gcloud compute instances list | grep yumrepo | awk '{print $4}') # will dynamically add ip address

echo "[fjemalrepo]

name=fjemalrepo nti-320 - $basearch

baseurl=http://$ip/centos/7/extras/x86_64/Packages/

enabled=1

gpgcheck=0

" >> /etc/yum.repos.d/nti-320.repo                                  
                                                                    # Now that the repo is added, list all repos and make sure
                                                                    # it shows up without error
yum repolist

isokay=`yum search "fjemalrepo nti-320" | grep "fjemalrepo NTI-320"`

if [ -z "$isokay" ]; then
   echo "There's somthing wrong with your repo... check yum repolist to see if it shows up then try installing a package"
else
   echo "All is well and we found your test package: $isokay"   
fi
                                                     
