#!/bin/bash

mkdir -p bugs/
current_moment=`date +"%d_%m_%y-%H_%M_%S"`
path="bugs/$current_moment"
mkdir -p $path
cp $1 $path/$1
ozc -c $1 2> $path/error.log
chmod 777 bugs/ -R
