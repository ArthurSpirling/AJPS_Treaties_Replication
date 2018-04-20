#estimate 1d kpca of treaties



rm(list=ls())

#load package
library(tm)

m<-Sys.time()

treatiesV<-Corpus(DirSource("c:/treaties/nonames/justdocsVCUT"),
readerControl=list(reader=readPlain,language="en",load=F))

treatiesA<-Corpus(DirSource("c:/treaties/nonames/justdocsACUT"),
readerControl=list(reader=readPlain,language="en",load=F))

treatiesR<-Corpus(DirSource("c:/treaties/nonames/justdocsRCUT"),
readerControl=list(reader=readPlain,language="en",load=F))

treatiesU<-Corpus(DirSource("c:/treaties/nonames/justdocsUCUT"),
readerControl=list(reader=readPlain,language="en",load=F))

set.seed(2)

sampV<-treatiesV#only those signed BEFORE 1871 -- not including "z" class etc.
sampA<-treatiesA[1:77]#post 1871 treaties (but drop last one--- from 1954): think of treating as ending in 1914
sampR<-treatiesR#all rejected--incl post 71
sampU<-treatiesU#as it happens, all signed before 1871

corp<-c(sampV,sampA,sampR,sampU)

require(kernlab)

stringkern <- stringdot(type="string",length=5)

stringpcaAJPSrep<-kpca(corp,kernel=stringkern,
kpar = list(sigma = 0.1), features = 1, 
    th = 1e-4, na.action = na.omit)

save(stringpcaAJPSrep, file="c:/treaties/nonames/AJPSreplicationfiles/pca01ajpsrep.rdata")
