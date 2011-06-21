#!/bin/sh

# Beacuse the makefile is fucking hopeless.


export TEXINPUTS=.:bioinformatics:
export BSTINPUTS=.:bioinformatics:

TEX=latex
BIB=bibtex


$TEX seqbias-paper.tex
$BIB seqbias-paper
$TEX seqbias-paper.tex
$TEX seqbias-paper.tex

dvipdf seqbias-paper.dvi

