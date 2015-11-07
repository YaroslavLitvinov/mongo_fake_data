#!/bin/bash

#expects 
#param1: schema file,
#param2: number of records as input
#param3: dbanme
#param4: collection name

if [ "$#" -ne 4 ]; 
    then echo "Expected 4 params"
    exit
fi

BASEPATH=../../../..

cat gen_template_begin.js > gens.js
cat $1 >> gens.js
cat gen_template_end.js >> gens.js

cd node_modules/json-schema-faker/node_modules/faker

foo=`mktemp`
touch $foo
mongoimport -d $3 -c $4 --drop --file $foo

for i in `seq 1 $2`;
do
    node $BASEPATH/gens.js | sed -e 's@\[Object\]@\[\]@g' | mongoimport -d $3 -c $4 --type json --jsonArray 
    echo Loaded record: $i
done


