sudo apt-get install slapd ldap-utils
echo "dn: cn=config
changetype: modify
replace: olcLogLevel
olcLogLevel: stats" > logging.ldif
sudo ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f logging.ldif


# OpenAM
sudo apt-get install tomcat7
sudo apt-get install default-jdk
sudo apt-get install ant git unzip
sudo apt-get install tomcat7-admin 
cp /etc/tomcat7/tomcat-users.xml /etc/tomcat7/tomcat-users.xml.orig
echo 'JAVA_OPTS="-Djava.awt.headless=true -server -XX:MaxPermSize=256m -Xmx1024m"' | cat - /etc/init.d/tomcat7 > temp && mv temp /etc/init.d/tomcat7
sudo chmod 755 /etc/init.d/tomcat7
echo "
<?xml version='1.0' encoding='utf-8'?>
<tomcat-users>
  <role rolename=\"tomcat\"/>
  <role rolename=\"manager-gui\"/>
  <role rolename=\"manager-script\"/>
  <role rolename=\"manager-jmx\"/>
  <role rolename=\"manager-status\"/>
  <role rolename=\"admin-gui\"/>
  <role rolename=\"admin-script\"/>
  <user username=\"memhamwan\" password=\"memhamwan\" roles=\"manager-gui,manager-script,manager-jmx,manager-status,admin-gui\"/>
</tomcat-users>" > /etc/tomcat7/tomcat-users.xml
# Please manually copy the zip to /tmp
unzip /tmp/OpenAM-12.0.0.zip
mv /tmp/openam/OpenAM-12.0.0.war /var/lib/tomcat7/webapps/openam.war
chown -R tomcat7:tomcat7 /usr/share/tomcat7
service tomcat7 restart
