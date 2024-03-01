#!/bin/bash

array=$1

echo ${array} | perl -pe 's/\b(\d+)(?{$q=$1+1})(?:,(??{$q})\b(?{$p=$q++})){2,}/$1-$p/g'
