#setwd('C://data/work/regcca/R2/codes4submission/R')
# authors: Agustin Lage Castellanos and Giancarlo Valente
#          a.lagecastellanos@maastrichtuniversity.nl giancarlo.valente@maastrichtuniversity.nl

setwd('C://Users//giancarlo.valente//OneDrive - Maastricht University//R2 Project//codes4submission//R');
source('adjustR2.R') # load function
nsteps    <- 20      # defing number of steps
nrep      <- 200      # define number of repetitons
ntr_array <- floor(seq(50, 100, length.out = nsteps)) # array of training set size
nte_array <- rep(500, nsteps) # array of test set size (constant in this example)
p         <- 10               # number of features
b         <- rnorm(p)         # model coefficients
s         <- 10#5                # noise scaling
lI        <- 1e0*diag(p) #1e0*diag(p)      # regularization parameter

R2inadj <- matrix(0, nrow = nrep, ncol = nsteps)
R2in    <- matrix(0, nrow = nrep, ncol = nsteps)
R2oadj  <- matrix(0, nrow = nrep, ncol = nsteps)
R2o     <- matrix(0, nrow = nrep, ncol = nsteps)

for (it in 1:nsteps){         # loop across training set sizes
  for(itr in 1:nrep){         # loop across repetitions
    ntr    <- ntr_array[it]   # number of training data points
    nte    <- nte_array[it]   # number of test     data points
    Xtr    <- matrix(rnorm(ntr * p), ntr, p)  # generate training data
    Xte    <- matrix(rnorm(nte * p), nte, p)  # generate test      data
    etr    <- s * rnorm(ntr)                  # generate training noise
    ete    <- s * rnorm(nte)                  # generate test    noise
    ytr    <- Xtr %*% b + etr                 # generate training responses
    yte    <- Xte %*% b + ete                 # generate test    responses
    # R2 adjustment
    result <- adjustR2(Xtr, ytr, lI, Xte, yte)
    R2in[itr,it]<-result$R2in;   R2inadj[itr,it]<-result$R2inadj;
    R2o[itr,it] <-result$R2o;     R2oadj[itr,it]  <-result$R2oadj;
  }
}
# average across repetitions    
R2in = colMeans(R2in); R2inadj = colMeans(R2inadj);
R2o  = colMeans(R2o); R2oadj   = colMeans(R2oadj);

# create figure
X11();par(bg = "white")
# Plot in-sample R2
par(mfrow = c(1, 2))  # 1 row, 2 columns
plot(ntr_array,   R2in,  type = "l", col = "blue", lwd = 2, xlab = "training set size", ylab = "R2", main = "in-sample",ylim = c(-0.5,1))
lines(ntr_array,  R2inadj, col = "red", lwd = 2)
legend("topright", legend = c("Rin", "Rinadj"), col = c("blue", "red"), lwd = 2)
# Plot out-of-sample R2
plot(ntr_array,  R2o,  type = "l",    col = "blue", lwd = 2, xlab = "training set size", ylab = "R2", main = "out-of-sample",,ylim = c(-0.5,1))
lines(ntr_array, R2oadj, col = "red", lwd = 2)
legend("topright", legend = c("Ro", "Roadj"), col = c("blue", "red"), lwd = 2)
