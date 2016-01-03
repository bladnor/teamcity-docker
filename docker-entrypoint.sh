#!/bin/bash
set -e

mkdir -p $TEAMCITY_DATA_PATH/lib/jdbc $TEAMCITY_DATA_PATH/config
if [ ! -f "$TEAMCITY_DATA_PATH/lib/jdbc/$POSTGRES_JDBC_DRIVER" ];
then
    echo "Downloading postgress JDBC driver..."
    wget -P $TEAMCITY_DATA_PATH/lib/jdbc http://jdbc.postgresql.org/download/$POSTGRES_JDBC_DRIVER
fi

echo "Starting teamcity..."
chown -R $TEAMCITY_USER:$TEAMCITY_USER $TEAMCITY_DATA_PATH
chown -R $TEAMCITY_USER:$TEAMCITY_USER /opt/TeamCity
exec gosu $TEAMCITY_USER /opt/TeamCity/bin/teamcity-server.sh run