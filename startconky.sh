#!/bin/bash

if [ $# -ne 1 ] ; then
    echo "Usage: $0 ScriptIdentifier"
    echo -e "\tdefault: Default conkyrc"
    echo -e "\tclock: Big clock"
    echo -e "\tclock2: Big clock on right side"
    echo -e "\told: old and deprecated conkyrc (first one)"
    exit $E_NO_ARGS
fi

input=$1
conkyrc=("basic.conkyrc" "big_clock.conkyrc" "big_clock.conkyrc" "conkyrc_basic" "conkyrc_port")

case "$input" in
  default)  index=0 ; scriptcount=1 ;;
  clock)    index=1 ; scriptcount=1 ;;
  clock2)   index=2 ; scriptcount=1 ;;
  old)      index=3 ; scriptcount=2 ;;
esac

echo "Starte Conky-Skripte..."
for i in $(seq 1 ${scriptcount});
do
    conky -c ~/.conkyscripts/${conkyrc[index]} -q &
    index=$((${index}+1))
done
echo "...done"
