function [Jopt Topt valCost rankEst aopt eopt]=rHPCA_weight_reweighted_simpler_2D(D,lambda,mask);
%%%SRPCA Code for 2D vectors
%%%written by Mustafa Ayazoglu 2012

[m,n]=size(D);


sc=1;%norm(D,2);

D=D;%/sc;


w=1./([1:min(m/2,n)-1, min(m/2,n)*ones(1,m/2-n), min(m/2,n)*ones(1,n-m/2) min(m/2,n):-1:1]);
w=w.*mask;
W=hankel(w(1:m/2),w(m/2:end));

W=[W;W];


rho=1.5;
regul=1e-2;

weights=1./(~(0*svd(D))+regul);
WM=[diag(weights),zeros(m,n-m);zeros(m-n,n)];
DF=norm(D,'fro');


%%%create the structure matrix -------------------------------------------

%%%step 1) let structure forcing vector is vec varying size depending on the
%%%structure for hankel and toeplitz it is m+n-1 length vector

vec=[1:(m+2*n-2)];

%%step 2) let V be the structure matrix created using vec

V=[hankel(vec(1:m/2),vec(m/2:n+m/2-1)); hankel(vec(n+m/2:n+m-1),vec(n+m-1:m+2*n-2))];

%%step 3)let vec2 be the vectorized version of the structure matrix

vec2=V(:);

%%step 4) these number will represent the linear indeces for matlab arrays
%%sor them to get the corresponding permuation

[Vinp,Vout] = sort(vec2);

%%%step 5) create the structure forcing matrix S with the correct dimensions
%%%for the hankel structure it is m*n x (m+n-1) sized matrix

S=zeros(m*n,m+2*n-2);

%%%step 6) use the permuations to build the structure forcing matrix

S(Vout+(Vinp-1)*m*n) = 1;

%%%This is it!!! step 2 and step 3 can be changed if necessary to force
%%%different structures or combinations of them

%%%create the structure matrix -------------------------------------------

%%%matrix that is required at LSQ iterations
%S=sparse(S);
%SS=pinv(2*S);
Sz=sparse(S);
SS=geninv(2*S);
SSz=sparse(SS);

aopt=1;
aopt_old=2;

%while(norm(aopt-aopt_old)>0.01)
for(ii=1:2)    
    aopt_old=aopt;
    
   
    loopcount=0;
    
    aopt=full(1.1*0.5*SSz*D(:));%1.1*[D(:,1); D(end,2:end)'];
    eopt=zeros(m+2*n-2,1);
    Jopt=D;
    Topt=D*0;
    Y1opt=D*0;
    Y2opt=0*D;%/max(norm(D),(1/lambda)*norm(D(:),'inf'));
    Y3opt=D*0;
    mu=1e-1;%norm(Jopt)/10000;
    
    %%%TEMP MATRICES FOR RESHAPE
    Se=zeros(m,n);
    Sa=zeros(m,n);
    Sa(:)=S*aopt;
    Se(:)=S*eopt;
    
    %%%

    while((norm(D(:)-Sa(:)-Se(:),'fro')/DF>10e-5 || norm(Jopt(:)-Sa(:),'fro')>10e-5 || norm(Topt(:)-Se(:),'fro')>10e-5 ) && loopcount<1000)
        %tic;
        loopcount=loopcount+1;
 %       tic;
        Jopt=rewshrink(Sa-Y1opt/mu,1/mu,WM);   %%%HERE TO DO REWEIGHTED HEURISTIC WE NEED DO DO REWEIGHTED SHRINKAGE
%        ttt=toc;
        

        aopt=full(SSz*(D(:)-Se(:)+Y2opt(:)/mu+Jopt(:)+Y1opt(:)/mu));

        Sa(:)=full(Sz*aopt);

        
        Topt=rewsoftthr(Se-Y3opt/mu,lambda/mu,W);
        

        eopt=full(SSz*(D(:)-Sa(:)+Y2opt(:)/mu+Topt(:)+Y3opt(:)/mu));

        Se(:)=full(Sz*eopt);

                
        Y1opt(:)=Y1opt(:)+mu*(Jopt(:)-Sa(:));
        Y2opt(:)=Y2opt(:)+mu*(D(:)-Sa(:)-Se(:));
        Y3opt(:)=Y3opt(:)+mu*(Topt(:)-Se(:));

        mu=rho*mu;
        
    end
    weights0=weights;
    weights=1./(svd(Jopt)+regul);
    WM=[diag(weights),zeros(m,n-m);zeros(m-n,n)];
   
end

Jopt=sc*Jopt;
Topt=sc*Topt;

valCost=(1)*sum(weights0.*svd(Jopt))+(lambda)*norm(W(:).*Topt(:),1);
rankEst=sum(weights0.*svd(Jopt));
55;


