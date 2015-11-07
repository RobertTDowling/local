#!/bin/sh

du --apparent-size -B 1MB -s ~/* ~/.[A-z]* | sort -n
