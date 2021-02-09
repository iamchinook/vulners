#!/bin/bash
ip_list=$1
mac_list=$2
# Separa el string y crea los arrays ips y macs
ips=(${ip_list//,/ })
macs=(${mac_list//,/ })

fecha=`date +"%m%H%M%b%y"`
ruta="cd /var/www/html/bash"
ruta=$(cd /var/www/html/bash)
i=0

# Borrado de carpetas si existen, sino las crea
for mac in "${macs[@]}"
do
    i=$((i+1))
    if [ -d /var/www/html/bash/$mac ];
    then
    rm -r /var/www/html/bash/$mac
    fi
    mkdir -m 777 /var/www/html/bash/$mac
    cd /var/www/html/bash/$mac
done

# Recorre Array y realiza nmap # xsltproc transforma la salida a html # wkhtmltoimage transforma html a png
for (( c=0; c<$i; c++ ))
do  
    nmap -sV -Pn -oX "${macs[$c]}" --script vulners "${ips[$c]}"
    sed -i 's/file:\/\/\/usr\/bin\/..\/share\/nmap\/nmap.xsl/..\/ciber.xsl/g' "${macs[$c]}"
    sed -i "4c\<nmaprun startstr='${fecha^^}'>" "${macs[$c]}"
    sed -i '5d' "${macs[$c]}"
    xsltproc "${macs[$c]}" -o "${macs[$c]}".html
    wkhtmltoimage --width 800 "${macs[$c]}".html "${macs[$c]}".png
    rm "${macs[$c]}"
    rm "${macs[$c]}".html
    chown -r "${macs[$c]}"
done



