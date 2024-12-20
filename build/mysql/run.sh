#!/bin/sh
set -ex

# Verifica e cria diretório de dados se não existir
if [ ! -d "/run/mysqld" ]; then
  mkdir -p /run/mysqld
fi

if [ ! -d "$MYSQL_DATA_DIRECTORY" ]; then
  echo 'MySQL data directory does not exist'
  echo "Creating MySQL data directory: $MYSQL_DATA_DIRECTORY"
  mkdir -p "$MYSQL_DATA_DIRECTORY"
fi

if [ ! -d "$MYSQL_LOG_DIRECTORY" ]; then
  echo 'MySQL log directory does not exist'
  echo "Creating MySQL log directory: $MYSQL_LOG_DIRECTORY"
  mkdir -p "$MYSQL_LOG_DIRECTORY"
fi

chown -R mysql:mysql $MYSQL_DATA_DIRECTORY
chown -R mysql:mysql $MYSQL_LOG_DIRECTORY

if [ -d "$MYSQL_DATA_DIRECTORY/mysql" ]; then
  echo 'Data directory already initialized'
  echo 'Starting server'
  exec /usr/sbin/mysqld --user=mysql --console --datadir="$MYSQL_DATA_DIRECTORY" 
else
  echo 'Initializing database'
  mysqld --initialize --user=root --datadir="$MYSQL_DATA_DIRECTORY" 
  echo 'Database initialized'

  if grep -q 'A temporary password is generated for root@localhost:' "$MYSQL_LOG_DIRECTORY"/mysql_error.log; then
    temp_password=$(grep 'A temporary password is generated for root@localhost:' "$MYSQL_LOG_DIRECTORY"/mysql_error.log | awk '{print $NF}')
  else
    echo 'Temporary password not found in MySQL startup log'
  fi
  
  # Inicia o servidor MySQL
  echo 'Starting server'
  /usr/sbin/mysqld --user=mysql --datadir="$MYSQL_DATA_DIRECTORY" &

  # Espera até que o MySQL esteja pronto
  sleep 5

  mysql -hlocalhost -uroot -p"$temp_password" --connect-expired-password <<EOF
  ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; 
  FLUSH PRIVILEGES;
EOF

  # Executa outros comandos SQL necessários
  mysql -hlocalhost -uroot -p"$MYSQL_ROOT_PASSWORD" <<EOF
  USE mysql;
  CREATE USER 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
  CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';
  CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
  GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
  GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
  GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'localhost' WITH GRANT OPTION;
  GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%' WITH GRANT OPTION;
  CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;
  GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' WITH GRANT OPTION;
  GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'localhost' WITH GRANT OPTION;
  FLUSH PRIVILEGES;
EOF
fi

# Aumenta o innodb_lock_wait_timeout antes da restauração
mysql -hlocalhost -uroot -p"$MYSQL_ROOT_PASSWORD" <<EOF
SET GLOBAL innodb_lock_wait_timeout = 600;
EOF

# Importa os dados, se disponíveis
if [ -f "/scripts/openmrs.sql" ]; then
  echo "Importando dados para o banco de dados $MYSQL_DATABASE"
  mysql -uroot -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" < /scripts/openmrs.sql

  # Executa esses alter tables para resolver problemas identificados durante a migração da plataforma 2.3.3 para 2.6.1
  mysql -hlocalhost -uroot -p"$MYSQL_ROOT_PASSWORD" <<EOF
  USE \`$MYSQL_DATABASE\`;
  START TRANSACTION;
  ALTER TABLE location MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
  ALTER TABLE patient_state MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
  ALTER TABLE patient_identifier MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
  ALTER TABLE orders MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
  ALTER TABLE reporting_report_design_resource MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
  ALTER TABLE users MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
  ALTER TABLE concept_reference_source MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
  ALTER TABLE concept_name MODIFY date_created DATETIME DEFAULT CURRENT_TIMESTAMP;
  SET GLOBAL innodb_lock_wait_timeout = 60;
  COMMIT;
EOF
fi

# Atualiza estatísticas das tabelas em lotes
echo "Atualizando estatísticas das tabelas em lotes"
BATCH_SIZE=10

# Função para executar ANALYZE TABLE em um lote de tabelas
run_analyze_batch() {
  local batch=("$@")
  local query=""

  for table in "${batch[@]}"; do
    query+="ANALYZE TABLE \`${table}\`; "
  done

  mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "USE \`${MYSQL_DATABASE}\`; ${query}"
}

# Obtenha a lista de tabelas
tables=$(mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -N -e "SELECT table_name FROM information_schema.tables WHERE table_schema = '${MYSQL_DATABASE}'")

# Converta a lista de tabelas em um array
tables_array=($tables)

# Processar as tabelas em lotes
total_tables=${#tables_array[@]}
for (( i=0; i<total_tables; i+=BATCH_SIZE )); do
  batch=("${tables_array[@]:i:BATCH_SIZE}")
  run_analyze_batch "${batch[@]}"
done

# Otimiza tabelas em lotes
echo "Otimização das tabelas em lotes"
run_optimize_batch() {
  local batch=("$@")
  local query=""

  for table in "${batch[@]}"; do
    query+="OPTIMIZE TABLE \`${table}\`; "
  done

  mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "USE \`${MYSQL_DATABASE}\`; ${query}"
}

# Processar as tabelas em lotes para otimização
for (( i=0; i<total_tables; i+=BATCH_SIZE )); do
  batch=("${tables_array[@]:i:BATCH_SIZE}")
  run_optimize_batch "${batch[@]}"
done

# Rebuild indexes em lotes
echo "Reconstruindo índices em lotes"
run_rebuild_indexes_batch() {
  local batch=("$@")
  local query=""

  for table in "${batch[@]}"; do
    query+="ALTER TABLE \`${table}\` ENGINE = InnoDB; "
  done

  mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "USE \`${MYSQL_DATABASE}\`; ${query}"
}

# Processar as tabelas em lotes para reconstrução de índices
for (( i=0; i<total_tables; i+=BATCH_SIZE )); do
  batch=("${tables_array[@]:i:BATCH_SIZE}")
  run_rebuild_indexes_batch "${batch[@]}"
done
