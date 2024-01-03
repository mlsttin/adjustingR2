srng                  = rng('default'); %restart random number generator seed
if(exist('p')) b      = randn(p+1,1); S             = eye(p); end % betas are fixed
for it = 1:nsteps
    disp(['iteration ' ,num2str(it)])
    switch simtype % for different simulations the indepdent variable changes: ntr, ntre, p, and lambda
        case 'R2vsNtr'                  
            n     = narray(it);              
        case 'R2vsNte'                                       
            nTE   = narray(it); 
        case 'R2vsModeldim'
            p      = parray(it); S   = eye(p);        % covariance matrix increases dimensionality if indep variable is p
            narray = parray; 
        case 'R2vslambdas'
            lambdaOPT       = lambdas(it); narray = lambdas;
    end
%%    
    for itrep = 1:nrep % loop across repetitions (voxels)        
        switch simtype
            case 'R2vsModeldim' % if independent variable is p, the betas increases at each iteration
            if(itrep == 1 & it == 1)           b0 = randn(p+1,1); end;     % first iteration from the first simulation b0 is created
            if(itrep == 1) b       = [b0(1:end-1) ; randn( (p - length(b0)+1),1);b0(end)]; end % the increased
        end
        %% create data
        [X,Y, Xtest,Ytest, e, etest] = create_data(n,nTE,p,b,S,snrSEL);
        %% R2 decomposition for training and test data
        lambdaI    = lambdaOPT*eye(p+1);
        [Tirr(it,itrep) ,  Topt(it,itrep) ,  Tcov(it,itrep) ,  Tsh(it,itrep) ,    Residuals(it,itrep)   ]    = R2decomp_in_sample(X,Y, e,b, lambdaI);
        [TirrO(it,itrep),  Tpess(it,itrep) , TcovO(it,itrep),  TshO(it,itrep) ,   ResidualsO(it,itrep)  ]    = R2decomp_out_of_sample(X,Xtest,Y,Ytest,e, etest,b, lambdaI);
        %% R2 adjustment
        [R2adj(it,itrep), R2tr(it,itrep), R2outAdj(it,itrep), R2te(it,itrep)]  =  adjustR2(X,Y,lambdaI,Xtest,Ytest );
    end
end
%% check algebra and save
disp(['Checking R2 decompostion ' , num2str( max(abs(Residuals(:)))) ,' ', num2str(max(abs(ResidualsO(:))))])
save([outputfolder,filesep,outputfile],'R2tr','Tirr','Topt','R2adj','TirrO','Tpess','TcovO','narray','simtype','R2outAdj','R2te','p','n','nTE','nrep','Tsh','TshO','Tcov','lambdaOPT');