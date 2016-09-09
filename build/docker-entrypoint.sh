#!/usr/bin/env bash
set -e

if [ "$1" = 'appserver' ]; then
  
  export DBACCESS_SERVER=${DBACCESS_SERVER:-${DBACCESS_PORT_7890_TCP_ADDR}}
  export DBACCESS_ALIAS=${DBACCESS_ALIAS:-protheus}

  /bin/sed 's/{{DBACCESS_SERVER}}/'"${TOP_SERVER}"'/'      -i /totvs11/microsiga/protheus/bin/appserver/appserver.ini
  /bin/sed 's/{{DBACCESS_ALIAS}}/'"${TOP_ALIAS}"'/'        -i /totvs11/microsiga/protheus/bin/appserver/appserver.ini

#  export LICENSE_SERVER=${LICENSE_SERVER:-127.0.0.1}
#  export LICENSE_SERVER_PORT=${LICENSE_SERVER_PORT:-5555}

#  /bin/sed 's/{{LICENSE_SERVER}}/'"${LICENSE_SERVER}"'/' -i /opt/totvs/dbaccess/multi/dbaccess.ini
#  /bin/sed 's/{{LICENSE_SERVER_PORT}}/'"${LICENSE_SERVER_PORT}"'/' -i /opt/totvs/dbaccess/multi/dbaccess.ini

  until echo -n > /dev/tcp/$DBACCESS_SERVER/7890
  do
      echo "Esperando serviço do dbaccess..."
      sleep 0.5
  done

  exec "/totvs11/microsiga/protheus/bin/appserver/appsrvlinux"

fi

exec "$@"
