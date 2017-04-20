function [D_est, hopt, eopt, e2opt]=SRPCA_e1_e2_clean_md(D,lambda,lambda2,mask)
% This code solves the following problem with Inexact ALM algorithm
% minimize ||A||_* + lambda * ||E1||_1 + lambda2 * ||E2||_F
% subject to: D = A + E1 + E2

% Author: Mustafa Ayazoglu 2012
% change log
% Apr. 10, 2017 Xikang Zhang modified for multi-dimensional input

D = D';
[dim, N] = size(D);

sc = norm(D,'fro');
% sc = 1;
D = D / sc;

n = round(N / 2);
m = N - n + 1;

rho = 1.05;
regul = 1e-2;

weights = 1 ./ (ones(n,1)+regul);
WM = zeros(dim*m, n);
WM(eye(dim*m, n)==1) = weights;

%%% create the structure matrix -------------------------------------------
%%% SH (for hankel structures)

%%% step 1) let structure forcing vector is vec varying size depending on the
%%%structure for hankel and toeplitz it is m+n-1 length vector

vec = reshape((1:dim*N), dim, N);

%%% step 2) let V be the structure matrix created using vec

V = blockHankel(vec, [dim*m, n]);

%%% step 3)let vec2 be the vectorized version of the structure matrix

vec2 = V(:);

%%% step 4) these number will represent the linear indeces for matlab arrays
%%sor them to get the corresponding permuation

[Vinp, Vout] = sort(vec2);

%%% step 5) create the structure forcing matrix S with the correct dimensions
%%%for the hankel structure it is m*n x (m+n-1) sized matrix

Sh = zeros(dim*m*n, dim*N);

%%% step 6) use the permuations to build the structure forcing matrix

Sh(Vout+(Vinp-1)*dim*m*n) = 1;

%%% This is it!!! step 2 and step 3 can be changed if necessary to force
%%% different structures or combinations of them

%%% create the structure matrix -------------------------------------------


%%% these are for speed up
Shs = sparse(Sh);

Hproj = geninv(eye(dim*N)+full(Shs'*Shs));
Hprojs = sparse(Hproj);

Hind = zeros(dim*m, n);
Hind(:) = (1:dim*m*n);

% these are modifications for multi-dimensional data
d = D(:);
mask = mask(:);

for ii = 1:3
    re = n;
    mu = 1e-3;
    loopcount = 0;
    
    hopt = 1.1*d;
    eopt = zeros(size(d));
    e2opt = zeros(size(d));
    jopt = Sh*hopt;
    y1opt = 0*d;
    y2opt = 0*jopt;
    
    while ( norm(d-hopt-eopt-e2opt)/sqrt(length(d))>1e-5 || norm(jopt-Sh*hopt)/sqrt(length(jopt))>1e-5 ) && loopcount<1000
        loopcount = loopcount + 1;
        
        Temph = full(Shs*hopt-y2opt/mu);
                
        [Temp, re] = rewshrinkfast(Temph(Hind), 1/mu, WM, re);
        
        %[loopcount norm(Tempzz-Temp,'fro')]
        %val0=lagrangian(d,jopt,hopt,nopt,eopt,e2opt,y1opt,y2opt,y3opt,mu,Sh,Sq,v0,A,n,lambda,lambda2);
        jopt = Temp(:);
        %val1=lagrangian(d,jopt,hopt,nopt,eopt,e2opt,y1opt,y2opt,y3opt,mu,Sh,Sq,v0,A,n,lambda,lambda2);
        %val0-val1
        v1 = d - eopt - e2opt + y1opt/mu;
        v2 = jopt + y2opt/mu;
        hopt = full(Hprojs*(v1+Shs'*v2));
        %val2=lagrangian(d,jopt,hopt,nopt,eopt,e2opt,y1opt,y2opt,y3opt,mu,Sh,Sq,v0,A,n,lambda,lambda2);
        %val1-val2
        
        eopt = rewsoftthr(d-hopt-e2opt+y1opt/mu, lambda/mu, mask);
        %val3=lagrangian(d,jopt,hopt,nopt,eopt,e2opt,y1opt,y2opt,y3opt,mu,Sh,Sq,v0,A,n,lambda,lambda2);
        %val2-val3
        %end

        v4 = d - hopt - eopt + y1opt/mu;
        e2opt = (mu/(mu+lambda2)) * v4;
        
        y1opt(:) = y1opt(:)+mu*(d-hopt-eopt-e2opt);
        y2opt(:) = y2opt(:)+mu*full(jopt-Shs*hopt);
        
        mu = rho * mu;
        
        %[norm(d-A*hopt-eopt-e2opt)/sqrt(length(d)) norm(jopt-Sh*hopt)/sqrt(length(jopt)) norm(nopt-Sq*hopt-v0)/sqrt(length(nopt))]
        
    end
    loopcount
    weights=1./(svd(jopt(Hind))+regul);
    WM(eye(dim*m, n)==1) = weights;
     
end

jopt = sc * jopt;
hopt = sc * hopt;
d = sc * d;
eopt = sc * eopt;
e2opt = sc * e2opt;

D_est = reshape(hopt, dim, N);

end
