#!/home/freundt/usr/bin/Rscript --vanilla

library(readxl)
library(data.table)

args <- commandArgs(trailingOnly=TRUE)

rdxlsx <- function(fn, ...)
{
	as.data.table(read_excel(fn, ...))[, file.name:=fn][]
}

x <- rbindlist(lapply(args, rdxlsx), use.names=TRUE, fill=TRUE)
fwrite(x, "/dev/stdout", sep="\t", na="", quote=FALSE)
