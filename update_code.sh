#!/bin/sh

wget https://pqc-hqc.org/doc/hqc-submission_2025-02-19.zip
unzip hqc-submission_2025-02-19.zip -x Hardware_Implementation/* **README Supporting_Documentation/*
rm hqc-submission_2025-02-19.zip

# rename all .cpp files to .c
for cppfile in Reference_Implementation/*/src/*.cpp
do
	cfile=${cppfile%.cpp}.c
	mv "$cppfile" "$cfile"
done

# avoid NTL dependency by using GF(2^X) arithmetic from the "additional" implementation
for addfile in Additional_Implementation/*/src/gf2x.c
do
	reffile=Reference_Implementation${addfile#Additional_Implementation}
	cp "$addfile" "$reffile"
done

rm -r Additional_Implementation

# restructure by scheme instead of by implementation
for subdir in *_Implementation/*
do
	scheme=${subdir#*/}
	impl=${subdir%/*}
	mkdir -p "$scheme"
	mv "$impl/$scheme" "$scheme/$impl"
done

rmdir *_Implementation
