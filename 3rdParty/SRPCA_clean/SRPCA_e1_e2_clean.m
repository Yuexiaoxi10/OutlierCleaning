function [hopt eopt e2opt]=SRPCA_e1_e2_clean(d,lambda,lambda2,mask)
%%%%this version tries to utilize the partial svd for further speed



N=length(d);


sc=norm(d,2);
d=d/sc;

n=round(N/2);
m=N-n+1;


rho=1.05;
regul=1e-2;

weights=1./(ones(n,1)+regul);
WM=[diag(weights),zeros(n-m,n);zeros(m-n,n)];



%%%create the structure matrix -------------------------------------------
%%%SH (for hankel structures)

%%%step 1) let structure forcing vector is vec varying size depending on the
%%%structure for hankel and toeplitz it is m+n-1 length vector

vec=[1:n+m-1];

%%step 2) let V be the structure matrix created using vec

V=hankel(vec(1:n),vec(n:n+m-1));

%%step 3)let vec2 be the vectorized version of the structure matrix

vec2=V(:);

%%step 4) these number will represent the linear indeces for matlab arrays
%%sor them to get the corresponding permuation

[Vinp,Vout] = sort(vec2);

%%%step 5) create the structure forcing matrix S with the correct dimensions
%%%for the hankel structure it is m*n x (m+n-1) sized matrix

Sh=zeros(n*m,n+m-1);

%%%step 6) use the permuations to build the structure forcing matrix

Sh(Vout+(Vinp-1)*n*m) = 1;

%%%This is it!!! step 2 and step 3 can be changed if necessary to force
%%%different structures or combinations of them

%%%create the structure matrix -------------------------------------------





%%%these are for speed up
Shs=sparse(Sh);

Hproj=geninv(eye(N)+full(Shs'*Shs));
Hprojs=sparse(Hproj);



Hind=zeros(n,m);
Hind(:)=[1:n*m];



for(ii=1:3)
    re=n;
    mu=1e-3;
    loopcount=0;
    
    hopt=1.1*d;
    eopt=zeros(N,1);
    e2opt=zeros(N,1);
    jopt=Sh*hopt;
    y1opt=0*d;
    y2opt=0*jopt;
    
  10;  
    while((norm(d-hopt-eopt-e2opt)/sqrt(length(d))>1e-5 || norm(jopt-Sh*hopt)/sqrt(length(jopt))>1e-5 ) && loopcount<1000)
        loopcount=loopcount+1;
        
        
        Temph=full(Shs*hopt-y2opt/mu);
                
        [Temp re]=rewshrinkfast(Temph(Hind),1/mu,WM,re);
        
        %[loopcount norm(Tempzz-Temp,'fro')]
        %val0=lagrangian(d,jopt,hopt,nopt,eopt,e2opt,y1opt,y2opt,y3opt,mu,Sh,Sq,v0,A,n,lambda,lambda2);
        jopt=Temp(:);
        %val1=lagrangian(d,jopt,hopt,nopt,eopt,e2opt,y1opt,y2opt,y3opt,mu,Sh,Sq,v0,A,n,lambda,lambda2);
        %val0-val1
        v1=d-eopt-e2opt+y1opt/mu;
        v2=jopt+y2opt/mu;
        hopt=full(Hprojs*(v1+Shs'*v2));
        %val2=lagrangian(d,jopt,hopt,nopt,eopt,e2opt,y1opt,y2opt,y3opt,mu,Sh,Sq,v0,A,n,lambda,lambda2);
        %val1-val2
        
        eopt=rewsoftthr(d-hopt-e2opt+y1opt/mu,lambda/mu,mask);
        %val3=lagrangian(d,jopt,hopt,nopt,eopt,e2opt,y1opt,y2opt,y3opt,mu,Sh,Sq,v0,A,n,lambda,lambda2);
        %val2-val3
        %end

        
        

        
        v4=d-hopt-eopt+y1opt/mu;
        e2opt=(mu/(mu+lambda2))*v4;
        
        
        
        y1opt=y1opt+mu*(d-hopt-eopt-e2opt);
        y2opt=y2opt+mu*full(jopt-Shs*hopt);
        
        mu=rho*mu;
        
        %[norm(d-A*hopt-eopt-e2opt)/sqrt(length(d)) norm(jopt-Sh*hopt)/sqrt(length(jopt)) norm(nopt-Sq*hopt-v0)/sqrt(length(nopt))]
        
    end
    loopcount
    weights=1./(svd(jopt(Hind))+regul);
    WM=[diag(weights),zeros(n-m,n);zeros(m-n,n)];
    
    
end

jopt=sc*jopt;
hopt=sc*hopt;
d=sc*d;
eopt=sc*eopt;
e2opt=sc*e2opt;




