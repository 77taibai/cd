#!/bin/bash

uname -a

cat > /cloudreve/pgbouncer.ini <<-EOF
[databases]
$DB_NAME = host=$DB_HOST port=$DB_PORT dbname=$DB_NAME

[pgbouncer]
listen_port = 37721
listen_addr = 127.0.0.1
auth_type = md5
auth_file = /cloudreve/userlist.txt
logfile = /cloudreve/pgbouncer.log
pidfile = /cloudreve/pgbouncer.pid
admin_users = postgres
stats_users = pgmon
max_client_conn = 80
default_pool_size = 20
reserve_pool_size = 5
dns_max_ttl = 15
EOF

cat > /cloudreve/userlist.txt <<-EOF
"$DB_USER" "$DB_PASSWORD"
EOF

echo "PgBouncer配置文件创建完毕"

touch /cloudreve/pgbouncer.log

chmod 777 /cloudreve/pgbouncer.log

echo "PgBouncer依赖文件创建完毕"

pgbouncer --version

#pgbouncer -d -u nobody /cloudreve/pgbouncer.ini

#pgbouncer -R -d -u nobody /cloudreve/pgbouncer.ini

echo "PgBouncer开始运行"

pgbouncer -R -u nobody /cloudreve/pgbouncer.ini

cat > /cloudreve/conf.ini <<-EOF
[System]
Debug = false
Mode = master
Listen = :5212
SessionSecret = DR3c3K0P6ei6rLJDm8ffNdV4uLs2jAXnOvWDmmDPW7C5KhYtuRijM6N6x8KJMqcc
HashIDSalt = 4brAt3NOAOmNo79S0OoU3BADYVRSrrEuRbrudTSLPDHNQ25C2UN3cwsPfJMA0wUr
[Database]
Type = postgres
Port = 37721
User = $DB_USER
Password = $DB_PASSWORD
Host = 127.0.0.1
Name = $DB_NAME
TablePrefix = cd
Charset = utf8
EOF

chmod +x /cloudreve/cloudreve

echo "准备运行Cloudreve"

#./cloudreve
