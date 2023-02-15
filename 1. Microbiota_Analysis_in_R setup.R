---
title: "Microbiota Analysis in R setup"
output: html_document
---

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install(version = "3.10")
BiocManager::install("phyloseq")



library("ape")
library("dplyr")
library("ggplot2")
library("gplots")
library("lme4")
library("phangorn")
library("phyloseq")
library("plotly")
library("tidyr")
library("vegan")
library("VennDiagram")

setwd("C:/Users/xcwol_000/Downloads")

# OTU table (shared file)
OTU = read.table("analysis.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.shared", header=TRUE, sep="\t")

# Taxonomy of each OTU
tax = read.table("analysis.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.0.03.cons.taxonomy", header=TRUE, sep="\t")

# Metadata. Since we made this in Excel, not mothur, we can use the "row.names" modifier to automatically name the rows by the values in the first column (sample names)
metainvsimpson = read.table("invsimpson.analysis.opti_mcc.groups.ave-std.summary.txt", header=TRUE, sep="\t")

metashannon = read.table("shannon.analysis.opti_mcc.groups.ave-std.summary", header=TRUE, sep="\t")

row.names(metainvsimpson) = metainvsimpson$group
row.names(metashannon) = metashannon$group
row.names(OTU) = OTU$Group
