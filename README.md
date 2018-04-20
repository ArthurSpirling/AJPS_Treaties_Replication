# AJPS_Treaties_Replication
Replication materials for Spirling (2011)

This repo includes key materials for replicating my paper,

"US Treaty-Making with American Indians: Institutional Change and Relative Power, 1784--1911", *American Journal of Political Science*, Vol 56, No 1, 84--97

In particular, you will find
- `pca01ajpsrep.rdata` which is the 'main' PCA scaled data for the treaties (specifically, in an object called `stringpcaAJPSrep`.  This was created via the file `kpcastuff01.R`
- `timetrend.R` produces the main change point results and plots.  Here, `plot.break()` should yield the relevant paper result.

Warning: there are several packages/dependencies that I haven't checked in some years (in particular, in terms of the `tm` package and `kernlab`).  So that may require some local attention!
