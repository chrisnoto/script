#!/bin/bash
a="ls | wc -l"
b="wc -l <(ls)"
eval $a
eval $b
