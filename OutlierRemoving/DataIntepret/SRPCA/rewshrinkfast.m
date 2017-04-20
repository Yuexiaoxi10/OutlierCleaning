function [A, resto]=rewshrinkfast(D,t,weights,restin);
[m,n]=size(D);
mn=min(m,n);
restin=min(restin,mn);
if(restin>0.2*mn)
    [U S V]=svd(D);
    S=S(:,1:restin);
else
    %[U S V]=svds(D,restin);
    %[U S V]=lansvd(D,restin);
    
    [U S V]=svd(D);
    S=S(:,1:restin);
end

%%%%this portion uses propack
%[U S V]=lansvd(D,restin);

szz=size(S,1);
St=rewsoftthr(S,t,weights(1:szz,1:restin));
A=U(:,1:szz)*St*V(:,1:restin)';
resto=sum(diag(St)>0);%sum(diag(S-St)>=diag(t*weights(1:szz,1:restin)));
if(restin-resto==1)
    resto=restin;
elseif(resto==0)
    resto=1;
elseif(resto==restin)
    resto=restin+1;
end