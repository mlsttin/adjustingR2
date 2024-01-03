function [Xtr , Xte, Ytr , Yte] = split_training_and_test(scoreZ,Y, indTR,indTE)
    Xtr         = scoreZ(indTR,:);     Xte   = scoreZ(indTE,:);
    mXtr        = mean(Xtr);         
    Xtr         = Xtr - mXtr;       Xte = Xte - mXtr;      
    Xtr         = [Xtr ones( size(Xtr,1) ,1 )]; Xte = [Xte ones( size(Xte,1) ,1 )];
    Ytr         = Y(indTR,:);          Yte = Y(indTE,: );
    Yte         = Yte - mean(Ytr);     Ytr = Ytr - mean(Ytr);     
