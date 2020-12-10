#!/usr/bin/env bash

# Check for root access
if [ "$EUID" -ne 0 ]
then
    echo "Please run this script with sudo"
    exit
fi

# Check for or create sysadmin research directory
[ ! -d /home/sysadmin/research ] && mkdir /home/sysadmin/research
echo "created ~/research directory"

# Copy files from instructor archive user to sysadmin research directory
cp -R /home/instructor/Documents/research/* /home/sysadmin/research
echo "copied needed files to ~/research"

# Correct ownership and permissions on the sysadmin research directory
chown -R sysadmin:sysadmin /home/sysadmin/research/
chmod -R 0644 /home/sysadmin/research/
echo "set owner and permissions"

# Copy over the motd file
cp /home/instructor/research/motd /etc/

# Install needed packages 
apt -y install john chkrootkit lynis &> /dev/null

echo "Completed setup for day 2"
#!/usr/bin/env bash

# Check for root access
if [ "$EUID" -ne 0 ]
then
    echo "Please run this script with sudo"
    exit
fi

# Change apache2 port
sed -i 's~\<Listen 80\>~Listen 8080~g' /etc/apache2/ports.conf

# Start needed processes
systemctl start vsftpd xinetd dovecot apache2 smbd

# Set SUID bit for the `find` command
chmod u+s $(which find)

# Set user with erroneous UID
sed -i 's~^adam:x:.*~adam:x:0:0:/home/adam:/bin/sh~g' /etc/passwd

echo "Completed setup for day 3"