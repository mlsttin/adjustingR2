adjustR2 <- function(Xtr, ytr, lI = NULL, Xte = NULL, yte = NULL) {
  # Xtr  n x p training X data
  # ytr  n x 1 training y data
  # lI   p x p regularization matrix
  # Xte  n x p test X data: if not present the last two output arguments are zero
  # yte  n x p test y data
  # Check if lI is provided, otherwise set it to 0
  if (is.null(lI)) {
    lI <- matrix(0, ncol = ncol(Xtr), nrow = ncol(Xtr))
  }
  
  # If Xte and yte are not provided, set them to Xtr and ytr
  if (is.null(Xte)) {
    Xte <- Xtr
    yte <- ytr
  }
  
  # Define important matrices
  ntr <- nrow(Xtr)
  nte <- nrow(Xte)
  
  Cte <- diag(nte) - (1/nte) * matrix(1, nrow = nte, ncol = 1) %*% matrix(1, nrow = 1, ncol = nte)
  Ctr <- diag(ntr) - (1/ntr) * matrix(1, nrow = ntr, ncol = 1) %*% matrix(1, nrow = 1, ncol = ntr)
  
  Xplus <- solve(t(Xtr) %*% Xtr + lI) %*% t(Xtr)
  
  Htr <- Xtr %*% Xplus
  Hte <- Xte %*% Xplus
  
  Rtr <- Xtr - Htr %*% Xtr
  Rte <- Xte - Hte %*% Xtr
  
  # Get R2in and R2out
  etr <- ytr - Htr %*% ytr
  ete <- yte - Hte %*% ytr
  
  R2in <- 1 - sum(etr^2) / sum(t(ytr) %*% Ctr %*% ytr)
  R2o  <- 1 - sum(ete^2) / sum(t(yte) %*% Cte %*% yte)
  
  # Constants for R2in: see Table 2
  K   <- -Htr %*% t(Htr) + 2 * Htr
  kop <- sum(diag(K)) / ntr
  
  ksh <- -sum(diag(t(Rtr) %*% Rtr)) / sum(t(Xtr) %*% Ctr %*% Xtr)
  
  # Constants for R2out: see Table 2
  kpess <- -sum(diag(t(Hte) %*% Hte)) / nte
  kshO  <- -sum(diag(t(Rte) %*% Rte)) / sum(t(Xte) %*% Cte %*% Xte)
  
  # Adjusting estimates
  R2inadj <- (R2in - kop) / (1 - kop + ksh)
  R2oadj <- (R2o - kpess) / (1 - kpess + kshO)
  
  # If no out-of-sample is needed
  if (is.null(Xte)) {
    R2oadj <- 0
    R2o <- 0
  }
  
  return(list(R2inadj = R2inadj, R2in = R2in, R2oadj = R2oadj, R2o = R2o))
}

# Example usage:
# Set your Xtr, ytr, and optionally lI, Xte, yte
# result <- adjustR2(Xtr, ytr, lI, Xte, yte)
# print(result)