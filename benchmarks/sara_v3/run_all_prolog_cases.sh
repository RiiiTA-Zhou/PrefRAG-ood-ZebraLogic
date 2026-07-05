#!/bin/bash
case_directory=cases
for file in $case_directory/*.pl
do
    echo $file
    prolog $file
done
