
sudo apt-get install default-jdk tomcat7 ant git unzip tomcat7-admin 

#OpenDJ
#Download and ftp over opendj_2.6.0-1_all.deb
dpkg -i /tmp/opendj_2.6.0-1_all.deb
sudo /opt/opendj/setup --cli

# OpenAM
cp /etc/default/tomcat7 /etc/default/tomcat7.orig
sed -i 's/JAVA_OPTS="-Djava.awt.headless=true -Xmx128m -XX:+UseConcMarkSweepGC"/JAVA_OPTS="-Djava.awt.headless=true -server -XX:MaxPermSize=256m -Xmx2048m -XX:+UseConcMarkSweepGC"/g' /etc/default/tomcat7
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
