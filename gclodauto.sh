#!/bin/bash
        echo "This is Fadil's Gcloud Automation"
        echo "Authorizing fjemal01 for this project..."
        gcloud auth login Fadil.Jemal@seattlecolleges.edu --no-launch-browser
        echo "Enabling billing..."
        #gcloud alpha billing accounts projects link   nti-320 --account-id=00189B-E1F480-31B987
        #gcloud alpha billing accounts projects gcloud --billing-accoun=013283-D06D10-B9064D
        gcloud alpha billing projects link devops-203203 --billing-account=013283-D06D10-B9064D
        echo "Setting admin account-id..."
        gcloud config set account Fadil.Jemal@seattlecolleges.edu
        echo "Setting the project for Configuration..."
        #gcloud compute instances create projects/gcloud-170421
        
        gcloud config set project devops-203203
        echo "Setting zone/region for Configuration..."
        gcloud config set compute/zone us-west1-a
        gcloud config set compute/region us-west1
        echo "Creating firewall-rules..."
        gcloud compute firewall-rules create allow-http --description "Incoming http allowed." \
            --allow tcp:80
        gcloud compute firewall-rules create allow-ldap --description "Incoming ldap allowed." \
            --allow tcp:636
        gcloud compute firewall-rules create allow-postgresql --description "Posgresql allowed." \
            --allow tcp:5432
        gcloud compute firewall-rules create allow-nrpe --description "Allow nrpe communication." \
            --allow tcp:5666

            gcloud compute firewall-rules create allow-https --description "Incoming https allowed." \
            --allow tcp:443
        gcloud compute firewall-rules create allow-django --description "Django connection allowed." \
            --allow tcp:8000
        gcloud compute firewall-rules create allow-ftp --description "FTP Allowed." \
            --allow tcp:21
        echo "Creating the ldap server instance and running the install script..."
        echo "Creating the rsyslog server instance and running the install script..."
        gcloud compute instances create rsyslog \
           --image-family centos-7 \
           --image-project centos-cloud \
           --machine-type f1-micro \
           --scopes cloud-platform \
           #--metadata-from-file startup-script=/tmp/NTI-310/automation_scripts/rsyslog-auto \
           --metadata-from-file startup-script=\Users\Fadil\Desktop\Fadil\NTI-310\automation_scripts\rsyslog-auto \    
         echo "Creating the ldap server instance and running the install script..."
         gcloud compute instances create ldap-server \
           --image-family centos-7 \
           --image-project centos-cloud \
           --machine-type f1-micro \
           --scopes cloud-platform \
       # --metadata-from-file startup-script=/tmp/NTI-310/automation_scripts/ldap-server-auto \
           --metadata-from-file startup-script=\Users\Fadil\Desktop\Fadil\NTI-310\automation_scripts\ldap-server-auto \
echo "creating the nfs server and running the install script..."
        gcloud compute instances create nfs \
           --image-family centos-7 \
           --image-project centos-cloud \
           --machine-type f1-micro \
           --scopes cloud-platform \
    #--metadata-from-file startup-script=/tmp/NTI-310/automation_scripts/nfs-server-auto \
           --metadata-from-file startup-script=\Users\Fadil\Desktop\Fadil\NTI-310\automation_scripts\nfs-server-auto \
    echo "Creating the postgres server and running the install script..."
     gcloud compute instances create postgres \
           --image-family centos-7 \
           --image-project centos-cloud \
           --machine-type f1-micro \
           --scopes cloud-platform \
    #--metadata-from-file startup-script=/tmp/NTI-310/automation_scripts/postgres-server \
          --metadata-from-file startup-script=\Users\Fadil\Desktop\Fadil\NTI-310\automation_scripts\postgres-server \
echo "Creating the django server and running the install script..."
gcloud compute instances create django-server   \
          --image-family centos-7 \
          --image-project centos-cloud \
          --machine-type f1-micro \
          --scopes cloud-platform \
    #--metadata-from-file startup-script=/tmp/NTI-310/automation_scripts/django
          --metadata-from-file startup-script=\Users\Fadil\Desktop\Fadil\NTI-310\automation_scripts\django \
#        echo "Creating the nagios server and running the install script..."
#gcloud compute instances create nagios-server   \
 #         --image-family centos-7 \
  #        --image-project centos-cloud \
   #      --machine-type f1-micro \
    #     --scopes cloud-platform \
    ##--metadata-from-file startup-script=/tmp/NTI-310/automation_scripts/django
      #   --metadata-from-file startup-script=\Users\Fadil\Desktop\Fadil\automation_scripts\nagios-auto \
echo "Creating the nagios cacti server and running the install script..."
gcloud compute instances create cacti-server   \
        --image-family centos-7 \
        --image-project centos-cloud \
        --machine-type f1-micro \
        --scopes cloud-platform \
    #--metadata-from-file startup-script=/tmp/NTI-310/automation_scripts/django
        --metadata-from-file startup-script=\Users\Fadil\Desktop\Fadil\automation_scripts\cacti-auto \
echo "Creating the nagios rpm server and running the install script..."
gcloud compute instances create rpm-server  \
       --image-family centos-7 \
       --image-project centos-cloud \
       --machine-type f1-micro \
       --scopes cloud-platform \
    #--metadata-from-file startup-script=/tmp/NTI-310/automation_scripts/django
       --metadata-from-file startup-script=\Users\Fadil\Desktop\Fadil\automation_scripts\rpm-install     


#adds support for nagios monitoring

echo "Creating cfg file for the rpmbuild-server and uploading it to nagios1."

myusername="Fadil.Jemal"                   # set this to your username
mynagiosserver="nagios1"                   # set this to your nagios server name
mycactiserver="cacti-auto"                 # set ths to your cacti server name 
myreposerver="rpm-3"                       # set this to your repo server
mynagiosserverip="35.230.56.4"           # set this to the ip address of your nagios server

ip1=$(gcloud compute instances list | grep rpmbuild-server | awk '{print $4}')

./generate_config.sh rpmbuild-server $ip1              # code I gave you in a previous assignment that generates a nagios config

gcloud compute scp --recurse rpmbuild-server.cfg $myusername@$mynagiosserver:/etc/nagios/conf.d --zone us-west1-a

echo "Creating cfg file for the postgres and uploading it to nagios1."

myusername="Fadil.Jemal"                   # set this to your username
mynagiosserver="nagios2"                   # set this to your nagios server name"                      # set this to your nfs server
mycactiserver="cacti-auto"                 # set ths to your cacti server name 
myreposerver="rpm-3"                       # set this to your repo server
mynagiosserverip="35.230.56.4"           # set this to the ip address of your nagios server

ip2=$(gcloud compute instances list | grep postgres-server | awk '{print $4}')

./generate_config.sh postgres-server $ip2              # code I gave you in a previous assignment that generates a nagios config

gcloud compute scp postgres-server.cfg $myusername@$mynagiosserver:/etc/nagios/conf.d --zone us-west1-a

#ldap-server

echo "Creating cfg file for the ldap and uploading it to nagios1."

myusername="Fadil.Jemal"                     # set this to your username
mynagiosserver="nagios2"                     # set this to your nagios server name                                          
mycactiserver="cacti-auto"                 # set ths to your cacti server name 
myreposerver="rpm-3"                         # set this to your repo server
mynagiosserverip="35.230.56.4"             # set this to the ip address of your nagios server

ip3=$(gcloud compute instances list | grep ldap-server-auto | awk '{print $4}')

./generate_config.sh ldap-server-auto $ip3             # code I gave you in a previous assignment that generates a nagios config

gcloud compute scp ldap-server-auto.cfg $myusername@$mynagiosserver:/etc/nagios/conf.d --zone us-west1-a

echo "Creating cfg file for the nfs-server-auto and uploading it to nagios1."

myusername="Fadil.Jemal"                   # set this to your username
mynagiosserver="nagios2"                   # set this to your nagios server name
mycactiserver="cacti-auto"                 # set ths to your cacti server name 
myreposerver="rpm-3"                       # set this to your repo server
mynagiosserverip="35.230.56.4"           # set this to the ip address of your nagios server

ip4=$(gcloud compute instances list | grep nfs-server-auto | awk '{print $4}')

./generate_config.sh nfs-server-auto $ip4              # code I gave you in a previous assignment that generates a nagios config

gcloud compute scp nfs-server-auto.cfg $myusername@$mynagiosserver:/etc/nagios/conf.d --zone us-west1-a

echo "Creating cfg file for the postgres-server and uploading it to nagios1."

myusername="Fadil.Jemal"                         # set this to your username
mynagiosserver="nagios2"                     # set this to your nagios server name
mycactiserver="cacti-auto"                 # set ths to your cacti server name 
myreposerver="rpm-3"                       # set this to your repo server
mynagiosserverip="35.230.56.4"                   # set this to the ip address of your nagios server

ip5=$(gcloud compute instances list | grep postgres-server | awk '{print $4}')

./generate_config.sh postgres-server $ip5              # code I gave you in a previous assignment that generates a nagios config

gcloud compute scp postgres-server.cfg $myusername@$mynagiosserver:/etc/nagios/conf.d --zone us-west1-a


#django-server

echo "Creating cfg file for the django server and uploading it to nagios1."

myusername="Fadil.Jemal"                         # set this to your username
mynagiosserver="nagios2"                     # set this to your nagios server name
myreposerver="rpm-3"                       # set this to your repo server
mynagiosserverip="35.230.56.4"                   # set this to the ip address of your nagios server

ip6=$(gcloud compute instances list | grep django | awk '{print $4}')

./generate_config.sh django-server $ip6             # code I gave you in a previous assignment that generates a nagios config

gcloud compute scp django-server.cfg $myusername@$mynagiosserver:/etc/nagios/conf.d --zone us-west1-a

echo "Restarting nagios service on the nagios server."

gcloud compute scp Fadil.Jemal@nagios2: "sudo systemctl restart nagios"




