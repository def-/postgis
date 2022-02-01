#!/bin/bash
for i in **/*.sql; do
  echo "TESTING $i"
  bin/psql -c "drop database postgis_reg;"
  rm -r /tmp/pgis_reg
  PATH=/nfusr/dev-server/dfelsing/code/postgis/regress/bin/:$PATH ./run_test.pl $i
  cp /tmp/pgis_reg/test1_diff $i.diff
  sleep 10
done &> test.out
