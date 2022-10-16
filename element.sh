#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then
  if  [[ $1 =~ ^[0-9]+$ ]]
  then
    QUERY_RESULT=$($PSQL "SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements, properties, types WHERE elements.atomic_number = properties.atomic_number AND properties.type_id = types.type_id AND elements.atomic_number = $1")
  else
    QUERY_RESULT=$($PSQL "SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements, properties, types WHERE elements.atomic_number = properties.atomic_number AND properties.type_id = types.type_id AND (name = '$1' or symbol='$1')")
  fi

  echo $QUERY_RESULT | while IFS=" | " read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do
      if [[ -z $QUERY_RESULT ]]
        then
          echo "I could not find that element in the database."
        else
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      fi
    done
else
  echo "Please provide an element as an argument."
fi
