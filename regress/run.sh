#!/bin/bash
for i in **/*.sql; do
  echo "TESTING $i"
  #bin/psql -c "drop database postgis_reg;"
  rm -r /tmp/pgis_reg
  PATH=$PWD/bin/:/usr/pgsql-11/bin:$PATH POSTGIS_SCRIPTDIR=/usr/pgsql-11/share/contrib/postgis-3.1 ./run_test.pl $i || sleep 10
  cp /tmp/pgis_reg/test_1_diff $i.diff
done &> test.out
