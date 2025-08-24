#!/data/data/com.termux/files/usr/bin/bash
set -e

echo -e "\e[1;34m[*] Updating packages...\e[0m"
pkg update -y
pkg upgrade -y

echo -e "\e[1;34m[*] Finished updating packages...\e[0m"
sleep 5

echo -e "\e[1;34m[*] Installing LAMP packages...\e[0m"
pkg install apache2 php php-apache phpmyadmin mariadb -y

echo -e "\e[1;34m[*] Finishing installing LAMP packages...\e[0m"
sleep 5

echo -e "\e[1;34m[*] INSTALLED: Apache2 php php-apache phpmyadmin mariadb...\e[0m"
sleep 3

echo -e "\e[1;34m[*] Backing up ../usr/etc/apache2/httpd.conf ...\e[0m"

cp /data/data/com.termux/files/usr/etc/apache2/httpd.conf /data/data/com.termux/files/usr/etc/apache2/httpd.conf.bak
sleep 2

cp /data/data/com.termux/files/usr/etc/apache2/httpd.conf.bak /data/data/com.termux/files/home/httpd.conf.bak
sleep 2

rm /data/data/com.termux/files/usr/etc/apache2/httpd.conf
sleep 2

echo -e "\e[1;34m[*] Configuring ../usr/etc/apache2/httpd.conf ...\e[0m"

cat << EOF > /data/data/com.termux/files/usr/etc/apache2/httpd.conf
ServerRoot "/data/data/com.termux/files/usr"
#Listen 12.34.56.78:80
Listen 8080
LoadModule php_module libexec/apache2/libphp.so
LoadModule mpm_prefork_module libexec/apache2/mod_mpm_prefork.so
LoadModule authn_file_module libexec/apache2/mod_authn_file.so
LoadModule authn_core_module libexec/apache2/mod_authn_core.so
LoadModule authz_host_module libexec/apache2/mod_authz_host.so
LoadModule authz_groupfile_module libexec/apache2/mod_authz_groupfile.so
LoadModule authz_user_module libexec/apache2/mod_authz_user.so
LoadModule authz_core_module libexec/apache2/mod_authz_core.so
LoadModule access_compat_module libexec/apache2/mod_access_compat.so
LoadModule auth_basic_module libexec/apache2/mod_auth_basic.so
LoadModule reqtimeout_module libexec/apache2/mod_reqtimeout.so
LoadModule include_module libexec/apache2/mod_include.so
LoadModule filter_module libexec/apache2/mod_filter.so
LoadModule mime_module libexec/apache2/mod_mime.so
LoadModule log_config_module libexec/apache2/mod_log_config.so
LoadModule env_module libexec/apache2/mod_env.so
LoadModule headers_module libexec/apache2/mod_headers.so
LoadModule setenvif_module libexec/apache2/mod_setenvif.so
LoadModule version_module libexec/apache2/mod_version.so
LoadModule slotmem_shm_module libexec/apache2/mod_slotmem_shm.so
LoadModule unixd_module libexec/apache2/mod_unixd.so
LoadModule status_module libexec/apache2/mod_status.so
LoadModule autoindex_module libexec/apache2/mod_autoindex.so
<IfModule !mpm_prefork_module>
	#LoadModule cgid_module libexec/apache2/mod_cgid.so
</IfModule>
<IfModule mpm_prefork_module>
	#LoadModule cgi_module libexec/apache2/mod_cgi.so
</IfModule>
LoadModule negotiation_module libexec/apache2/mod_negotiation.so
LoadModule dir_module libexec/apache2/mod_dir.so
LoadModule userdir_module libexec/apache2/mod_userdir.so
LoadModule alias_module libexec/apache2/mod_alias.so
LoadModule rewrite_module libexec/apache2/mod_rewrite.so
<IfModule unixd_module>
</IfModule>
ServerAdmin you@example.com
<Directory />
    AllowOverride none
    Require all denied
</Directory>
DocumentRoot "/data/data/com.termux/files/usr/share/apache2/default-site/htdocs"
<Directory "/data/data/com.termux/files/usr/share/apache2/default-site/htdocs">
    Options Indexes FollowSymLinks
    AllowOverride None
    # Controls who can get stuff from this server.
    Require all granted
</Directory>
<IfModule dir_module>
    DirectoryIndex index.php
</IfModule>
<Files ".ht*">
    Require all denied
</Files>
ErrorLog "var/log/apache2/error_log"
LogLevel warn
<IfModule log_config_module>
    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common
    <IfModule logio_module>
      # You need to enable mod_logio.c to use %I and %O
      LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
    </IfModule>
    CustomLog "var/log/apache2/access_log" common
    #CustomLog "var/log/apache2/access_log" combined
</IfModule>
<IfModule alias_module>
    # Example:
    # Redirect permanent /foo http://www.example.com/bar
    ScriptAlias /cgi-bin/ "/data/data/com.termux/files/usr/lib/cgi-bin/"
</IfModule>
<IfModule cgid_module>
</IfModule>
<Directory "/data/data/com.termux/files/usr/lib/cgi-bin">
    AllowOverride None
    Options None
    Require all granted
</Directory>
<IfModule headers_module>
    RequestHeader unset Proxy early
</IfModule>
<IfModule mime_module>
    TypesConfig etc/apache2/mime.types
    AddType application/x-compress .Z
    AddType application/x-gzip .gz .tgz
</IfModule>
# Configure mod_proxy_html to understand HTML4/XHTML1
<IfModule proxy_html_module>
Include etc/apache2/extra/proxy-html.conf
</IfModule>
<IfModule ssl_module>
SSLRandomSeed startup builtin
SSLRandomSeed connect builtin
</IfModule>
<FilesMatch \.php$>
SetHandler application/x-httpd-php
</FilesMatch>
#  Load config files from the config directory 'conf.d'.
Include etc/apache2/conf.d/*.conf
Include etc/apache2/extra/php_module.conf
EOF
sleep 2

echo -e "\e[1;34m[*] Saving Configuration...\e[0m"
sleep 3

echo -e "\e[1;34m[*] Configuring php_module.conf...\e[0m"
touch /data/data/com.termux/files/usr/etc/apache2/extra/php_module.conf
sleep 2

echo -e "\e[1;34m[*] Generating info.php file...\e[0m"
cat << EOF > /data/data/com.termux/files/usr/share/apache2/default-site/htdocs/info.php
<?php
phpinfo();
?>
EOF
sleep 2

echo -e "\e[1;34m[*] Generating index.php file...\e[0m"
cat << 	EOF > /data/data/com.termux/files/usr/share/apache2/default-site/htdocs/index.php
<?php
phpinfo();
?>
EOF
sleep 2

echo -e "\e[1;34m[*] Stoping httpd ...\e[0m"
pkill httpd || true
sleep 2

echo -e "\e[1;34m[*] Starting httpd ...\e[0m"
httpd &
sleep 2

echo -e "\e[1;34m[*] Testing httpd, http://127.0.0.1:8080\info.php ...\e[0m"
sleep 10

echo -e "\e[1;34m[*] Installing necessary packages to automate mySQL installation...\e[0m"
pkg install tmux -y
sleep 4

echo -e "\e[1;34m[*] tmux new-session -d -s mysql 'mysqld_safe' ...\e[0m"
tmux new-session -d -s mysqlserv 'mysqld_safe'
sleep 2

echo -e "\e[1;34m[*] 'mysqld_safe' Running in the background ...\e[0m"
sleep 2

echo -e "\e[1;34m[*] Building Database ...\e[0m"
sleep 2

# Prompt for root password
while true; do
    read -s -p "Enter root password: " ROOTPASS
    echo
    read -s -p "Confirm root password: " ROOTPASS2
    echo

    if [ "$ROOTPASS" = "$ROOTPASS2" ]; then
        echo "Passwords match!"
        break
    else
        echo "Error: Passwords do not match. Please try again."
    fi
done


echo "Securing MariaDB installation and setting up phpBB database..."
sleep 2

mysql -u root <<EOF
-- Set root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOTPASS}';

-- Remove anonymous users
DELETE FROM mysql.user WHERE User='';

-- Disallow root remote login
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

-- Remove test database
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

-- Reload privileges
FLUSH PRIVILEGES;

-- Create phpBB database
CREATE DATABASE IF NOT EXISTS phpbb;

-- Create admin user with same password as root
CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY '${ROOTPASS}';

-- Grant admin full access to phpBB
GRANT ALL PRIVILEGES ON phpbb.* TO 'admin'@'localhost';

-- Reload privileges again
FLUSH PRIVILEGES;
EOF

if [ $? -eq 0 ]; then
    echo "✅ MariaDB secured and phpBB database/user created successfully!"
else
    echo "❌ Something went wrong. Try running again."
    exit 1
fi

echo -e "\e[1;34m[*] Installing WGET...\e[0m"
pkg install wget -y
sleep 3

echo -e "\e[1;34m[*] Downloading phpbb ...\e[0m"
wget https://download.phpbb.com/pub/release/3.3/3.3.15/phpBB-3.3.15.zip
sleep 3

echo -e "\e[1;34m[*] Unzipping phpbb ...\e[0m"
unzip /data/data/com.termux/files/home/phpBB-3.3.15.zip
sleep 2

echo -e "\e[1;34m[*] Copying to ../usr/share/apache2/default-site/htdocs ...\e[0m"
cp -r /data/data/com.termux/files/home/phpBB3/* /data/data/com.termux/files/usr/share/apache2/default-site/htdocs
sleep 2

echo -e "\e[1;34m[*] Cleaning up ...\e[0m"
rm /data/data/com.termux/files/home/phpBB-3.3.15.zip
rm -r /data/data/com.termux/files/home/phpBB3
sleep 2

cat <<'MSG'

========================================
✅ LAMP + phpBB Setup Complete
----------------------------------------
 Database: phpbb
 User:     admin
 Password: (the one you set)
 URL:      http://127.0.0.1:8080
 
 Instructions:
 * Go to http://127.0.0.1:8080 in your
   browser.
 * Select install tab, click Install 
 * Enter form data, to log in to phpBB
   'submit' button.
 * IMPORTANT PART: Set Installation data
 ⚠️DB server hostname or DSN: 127.0.0.1 ⚠️
 DB server port:  leave blank
 DB username :     admin
 DB password : (password that you set)
 DB name :         phpbb
 
 The rest of the install should be easy!
 
 ONE LAST THING: remove install dirctory ⚠️
 rm -r ../usr/share/apache2/default-site/htdocs/install
 
========================================

MSG

sleep 30
