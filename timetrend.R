###################################
## analyze time trends           ##
### vis-a-vis  treaties          ##
###################################

rm(list=ls())


#universe of cases
universe <- read.csv("c:/projects/treaties/lanni07/natives/universe/universecases.csv")
universed <- gsub("\\/","-", universe$Date)
universe$Date <-  as.Date(universed, format="%m-%d-%Y")

#pull in pca estimates
load(file="c:/projects/treaties/nonames/AJPSreplicationfiles/pca01ajpsrep.rdata")
rot<- stringpcaAJPSrep@rotated

require(RPMG)
repca <- RESCALE(rot,nx1=0, nx2=1, minx=min(rot),maxx=max(rot))

#bind with date
bd <- data.frame(dates=universe$Date, rpca = as.numeric(repca), types= universe$Type)
bdo <- bd[order(bd[,1]),]

#do trend test
#   assume data is monthly (over 595 months!)

require(tis)
#wrong start date, but doesn't matter
#   for current purposes
ts.dat <-tis(bdo[,2], start=c(2000,1), freq=12) 

#do formal test
#non-parametric Spearman test 
#    between the observations and time
require(pastecs)
ttdat<-trend.test(ts.dat)

#get breakpoints
require(strucchange)
bp.ind <- breakpoints(ts.dat ~ 1)
#pull and report best fitting model
best.fit <- bdo[bp.ind$breakpoints,c(1,2)]


#plot of time series
cols <- as.character(bdo$types)
cols[which(bdo$types%in%c("Operable","Ratified Agreement"))] <-"green"
cols[which(bdo$types%in%c("Rejected by Congress"))] <-"red"
cols[which(bdo$types%in%c("Unratified treaty"))] <- "purple"

shapes <- as.character(bdo$types)
shapes[which(bdo$types%in%c("Operable","Ratified Agreement"))] <- 21
shapes[which(bdo$types%in%c("Rejected by Congress"))] <- 24
shapes[which(bdo$types%in%c("Unratified treaty"))] <- 22

## main plot
plot.it.out<-function()
{
par(bg='cornsilk1')
scaled <-bdo$rpca
plot(bdo$dates, scaled, pch=as.numeric(shapes),  type="p",col="black", bg= as.character(cols), cex=1.5,lwd=.5)
abline(v=as.Date("1871-01-01"),lty=3, ylab="")

lines(bdo$dates, bdo$rpca, col="gray50")
points(bdo$dates, bdo$rpca, pch=as.numeric(shapes),  type="p",col="black", bg= as.character(cols), cex=1.5)

#put spline on
xx <- lowess(bdo$dates,bdo$rpca)$x
yy <- lowess(bdo$dates, bdo$rpca)$y

lines(xx, yy, lwd=2)

legend("topright", pch=c(21,24,22), pt.bg=c("green","red","purple"), col="black", legend=c("valid, ratified",
"rejected","unratified"),pt.cex=1.5)


#detrend the rotated pca scores
res <- resid(lm(bdo[,2]~seq(bdo[,2])))
#plot(bdo[,1], res, type="l")
}


#plot with change points
plot.break<-function()
{
par(bg='cornsilk1')
scaled <-bdo$rpca
plot(bdo$dates, scaled, pch=as.numeric(shapes),  type="p",col="black", bg= as.character(cols), cex=1.5,lwd=.5)

lines(bdo$dates, bdo$rpca, col="gray90")
points(bdo$dates, bdo$rpca, pch=as.numeric(shapes),  type="p",col="gray50", bg="gray90", cex=1.5)
#break points
abline(v=best.fit[,1],lwd=4, col="black")

#get segment lowess
bps <- bp.ind$breakpoints
bpts<-c(1,bps,nrow(bdo))
for(i in 1:(length(bpts)-1))
{
y1 <- lowess(bdo$dates[bpts[i]:bpts[i+1]], bdo[bpts[i]:bpts[i+1],2])$y
x1 <- lowess(bdo$dates[bpts[i]:bpts[i+1]], bdo[bpts[i]:bpts[i+1],2])$x
lines(x1,y1,lwd=2, col="red")
text(x=mean(bdo$dates[bpts[i]:bpts[i+1]]),y=0.0,
label=round(mean(bdo[bpts[i]:bpts[i+1],2]),d=3),cex=1.5)
}



}


#plot residualized values
plot.res <-function()
{
par(bg='cornsilk1')
res <- resid(lm(bdo[,2]~seq(bdo[,2])))
plot(bdo[,1], res,ylab="residuals",type="n")

#lines for pre1871 trs
lines(bdo[bdo[,1]<"1871-01-01",1],res[bdo[,1]<"1871-01-01"],col="darkgreen")

#lines for post1871 trs
lines(bdo[bdo[,1]>"1871-01-01",1],res[bdo[,1]>"1871-01-01"],col="blue")

abline(lm(res~bdo[,1]),col="red",lwd=3)
abline(v=as.Date("1871-06-06"),lty=3)
}




cat("\n plot.it.out() to see main graphic\n\n")
