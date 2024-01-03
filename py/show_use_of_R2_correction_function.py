# -*- coding: utf-8 -*-
"""
Created on Mon Dec 11 15:51:37 2023
@author: A.Lagecastellanos AND Giancarlo Valente
"""

import numpy as np
import matplotlib.pyplot as plt
import sys
sys.path.append("C://data/work/regcca/R2/codes4submission/py")
import adjustR2mod as adjustR2mod

# simple code showing the use of the R2 adjusment function
nsteps    = 20; # defing number of steps
nrep      = 50; # define number of repetitons
ntr_array = np.floor(np.linspace(50, 500, nsteps)) # array of training set size
nte_array = np.full(nsteps, 500)  # array of test set size (constant in this example)
p         = 10 # number of features
b         = np.random.randn(p) # model coefficients
s         = 5 # noise scaling
lI        = 1e0 * np.eye(p); # regularization parameter

R2inadj = np.zeros((nrep, nsteps))
R2in    = np.zeros((nrep, nsteps))
R2oadj  = np.zeros((nrep, nsteps))
R2o     = np.zeros((nrep, nsteps))

for it in range(nsteps):              # loop across training set sizes
    for itr in range(nrep):           # loop across repetitions
        ntr = int(ntr_array[it])      # number of training data points
        nte = int(nte_array[it])      # number of test     data points
        Xtr = np.random.randn(ntr, p) # generate training data
        Xte = np.random.randn(nte, p) # generate test data
        etr = s * np.random.randn(ntr)# generate training noise
        ete = s * np.random.randn(nte)# generate test noise
        ytr = np.dot(Xtr, b) + etr    # generate training responses
        yte = np.dot(Xte, b) + ete    # generate test responses
        # R2 adjustment
        R2inadj[itr, it], R2in[itr, it], R2oadj[itr,it], R2o[itr,it]  = adjustR2mod.adjustR2(Xtr, ytr, lI, Xte, yte)
       
# average across repetitions    
R2inadj = np.mean(R2inadj, axis=0) ; R2in = np.mean(R2in, axis=0)
R2oadj  = np.mean(R2oadj, axis=0) ;  R2o  = np.mean(R2o, axis=0)

# Create a figure
fig = plt.figure(figsize=(10, 5), facecolor='white')
# Plot in-sample R2
plt.subplot(221)
plt.plot(ntr_array, R2in, linewidth=2)
plt.plot(ntr_array, R2inadj, linewidth=2)
plt.xlabel('training set size')
plt.ylabel('R2')
plt.title('in-sample')
plt.legend(['Rin', 'Rinadj'])

# Plot out-of-sample R2
plt.subplot(222)
plt.plot(ntr_array, R2o, linewidth=2)
plt.plot(ntr_array, R2oadj, linewidth=2)
plt.xlabel('training set size')
plt.ylabel('R2')
plt.title('out-of-sample')
plt.legend(['Ro', 'Roadj'])
# Adjust layout to prevent subplot overlap
plt.tight_layout()
# Show the plot
plt.show()   