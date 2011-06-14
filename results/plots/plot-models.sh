#!/bin/sh



for f in `ls ../20110610/dot/*.dot`
do
    g="model."`basename $f | sed s/dot/svg/`
    echo "$f -> $g"
    ./plot-dg.py --output=$g $f
done
