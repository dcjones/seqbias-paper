#!/bin/sh

# Beacuse the makefile is fucking hopeless.


export TEXINPUTS=.:bioinformatics:
export BSTINPUTS=.:bioinformatics:

TEX=pdflatex
BIB=bibtex


$TEX seqbias-paper.tex
$BIB seqbias-paper
$TEX seqbias-paper.tex
$TEX seqbias-paper.tex



