rm(list=ls())

source("../lib/lazy.subset.R")

filename="../data/dummy1.csv"
r.idx <- c(2,4,5)
c.idx <- c(4,5,6)

cat("\n", "-- Lazy subsetting by row", "\n")
p <- lazy.subset.by.row(r.idx, filename)
t <- read.table(file=p$pipe, sep=",", header=FALSE)
t

cat("\n", "-- Lazy subsetting by column", "\n")
p <- lazy.subset.by.column(c.idx, filename, sep=",")
t <- read.table(file=p$pipe, sep=",", header=FALSE)
t

cat("\n", "-- Lazy subsetting by row and column", "\n")
p <- lazy.subset(filename=filename, r.idx=r.idx, c.idx=c.idx, sep=",")
t <- read.table(file=p$pipe, sep=",", header=FALSE)
t
