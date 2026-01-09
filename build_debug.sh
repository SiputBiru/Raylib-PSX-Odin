#!/bin/bash

mkdir -p bin/linux

odin run src -out:bin/linux/blackhole -debug -show-timings
