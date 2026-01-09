#!/bin/bash

OUT_DIR="bin/linux"
EXE_NAME="Raylib-PSX-Odin"


mkdir -p $OUT_DIR

if [ ! -d "$OUT_DIR/shaders" ]; then 
    mkdir -p $OUT_DIR/shaders
    cp shaders/* $OUT_DIR/shaders/
fi

if [ ! -d "$OUT_DIR/assets" ]; then 
    mkdir -p $OUT_DIR/assets
    cp assets/* $OUT_DIR/assets/
fi

if [ -f "$OUT_DIR/$EXE_NAME" ]; then
    rm "$OUT_DIR/$EXE_NAME"
fi

odin build src -show-timings -out:$OUT_DIR/$EXE_NAME
