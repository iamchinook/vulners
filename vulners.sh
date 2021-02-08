#!/bin/bash
ip=$1
mac=$2
fecha=`date +"%m%H%M%b%y"`
ruta="cd /var/www/html/bash"
ruta=$(cd /var/www/html/bash)
listar=$(ls | grep $mac)
if [[ $listar == 1 ]];
then
rm -r $mac
fi
mkdir /var/www/html/bash/$mac
cd bash/$mac
nmap -sV -Pn -oX $mac --script vulners $ip
sed -i 's/file:\/\/\/usr\/bin\/..\/share\/nmap\/nmap.xsl/..\/ciber.xsl/g' $mac
sed -i "4c\<nmaprun startstr='${fecha^^}'>" $mac
sed -i '5d' $mac
xsltproc $mac -o $mac.html
wkhtmltoimage --width 800 $mac.html $mac.png
rm $mac
rm $mac.html
