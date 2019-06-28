#!/bin/bash
DT=`date -d yesterday +%Y%m%d`
(
cd $HOME/mon/archives/
find . -iname "${DT}" |xargs zip -r ${DT}.zip -
find . -iname "${DT}" |xargs rm -rf
)
