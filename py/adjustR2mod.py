import numpy as np
# authors: Agustin Lage Castellanos and Giancarlo Valente
#          a.lagecastellanos@maastrichtuniversity.nl giancarlo.valente@maastrichtuniversity.nl

def adjustR2(Xtr, ytr, lI=None, Xte=None, yte=None):
    # Xtr  n x p training X data
    # ytr  n x 1 training y data
    # lI   p x p regularization matrix
    # Xte  n x p test X data: if not present the last two output arguments are zero
    # yte  n x p test y data
    # Set default values if not provided
    if  lI is None:
        lI = np.zeros((Xtr.shape[1], Xtr.shape[1]))
    if Xte is None:
        Xte = Xtr
        yte = ytr
    # Define important matrices
    ntr = Xtr.shape[0]
    nte, p = Xte.shape
    Cte = np.eye(nte) - (1./nte) * np.ones((nte, 1)) @ np.ones((1, nte))  # Centering out-of-sample data
    Ctr = np.eye(ntr) - (1./ntr) * np.ones((ntr, 1)) @ np.ones((1, ntr))  # Centering in-sample data
    Xplus = np.linalg.solve(Xtr.T @ Xtr + lI, Xtr.T)
    Htr = Xtr @ Xplus  # Hat matrix in-sample
    Hte = Xte @ Xplus  # Hat matrix out-of-sample
    Rtr = Xtr - Htr @ Xtr
    Rte = Xte - Hte @ Xtr

    # Get R2in and R2out
    etr = ytr - Htr @ ytr  # residuals in-sample
    ete = yte - Hte @ ytr  # residuals out-of-sample
    R2in = 1 - np.sum(etr**2) / np.sum(ytr.T @ Ctr @ ytr)  # R2 in-sample
    R2o  = 1 - np.sum(ete**2) / np.sum(yte.T @ Cte @ yte)  # R2 out-of-sample

    # Constants for R2in: see Table 2
    K = -Htr @ Htr.T + 2 * Htr
    kop = np.trace(K) / ntr  # optimism
    ksh = -np.trace(Rtr.T @ Rtr) / np.trace(Xtr.T @ Ctr @ Xtr)  # shrinkage in-sample

    # Constants for R2out: see Table 2
    kpess = -np.trace(Hte.T @ Hte) / nte  # pessimism
    kshO = -np.trace(Rte.T @ Rte) / np.trace(Xte.T @ Cte @ Xte)  # shrinkage out-of-sample

    # Adjusting estimates
    R2inadj = (R2in - kop) / (1 - kop + ksh)  # Eq 22
    R2oadj = (R2o - kpess) / (1 - kpess + kshO)  # Eq 21

    # If no out-of-sample is needed
    if Xte is None:
        R2oadj = 0
        R2o    = 0

    return R2inadj, R2in, R2oadj, R2o