function [D_est, hopt, eopt, e2opt] = SRPCA_e1_e2_clean_md(D, lambda, lambda2, mask)
% Structure Robust Principle Component Analysis (SRPCA) for multi-dimension
% sequence noise cleaning
%
% This code solves the following problem with Inexact ALM algorithm
% minimize ||A||_* + lambda * ||E1||_1 + lambda2 / 2 * ||E2||_F^2
% subject to: hankel(D) = A + E1 + E2
% It uses the hankel structure to convert to the equivalent problem 
% minimize ||H||_* + lambda * ||e1||_1 + lambda2 / 2 * ||e2||_2^2
% subject to: vec(D) = h + e1 + e2
% where H is the hankel matrix constructed from h, and vec(D) is the
% vectorized D
%
% Inputs:
% D: data to be cleaned. It is a n-by-d matrix, where n is data length, 
% and d is the dimension of data
% lambda: penalty for outlier noise. It should be a positive real number
% lambda2: penalty for gaussian noise. It should be a positive real number
% mask: weights for each term in the sequence. It is of the same size of D.
% Usually it can be set to all ones.
% Outputs:
% D_est: cleaned sequence
% hopt: vectorized version of D_est
% eopt: recovered outlier noise
% e2opt: recovered Gaussian noise
%
% Example on outlier cleaning
% y = impulse(tf([1 0],[1 -1.414 1],-1), 100);
% y(randi(100, [1 5])) = 3;
% y_hat = SRPCA_e1_e2_clean_md(y,10,1e10,ones(size(y)));
% plot(y,'*-');hold on;plot(y_hat,'o-'); hold off; legend('y','y\_hat');
%
% Example on Gaussian noise cleaning
% y = impulse(tf([1 0],[1 -1.414 1],-1), 100);
% y = y + 0.1 * randn(size(y));
% y_hat = SRPCA_e1_e2_clean_md(y,1e10,100,ones(size(y)));
% plot(y,'*-');hold on;plot(y_hat,'o-'); hold off; legend('y','y\_hat');
%
% Author: Mustafa Ayazoglu 2012
% change log
% Apr. 10, 2017 Xikang Zhang modified for multi-dimensional input
% Apr. 19, 2017 Xikang Zhang added inputs check and more comments

%%% to be consistent with the dimension-one version
D = D'; 
mask = mask';

[dim, N] = size(D);
%%% Inputs check
if dim > N
    warning('Sequence length should be larger than dimension.\n');
end

[dim_m, N_m] = size(mask);
if dim_m ~= dim || N_m ~= N
    error('The size of mask should be the same as that of D.\n');
end

%%% scale the data to make it numerically more stable
sc = norm(D,'fro');
% sc = 1;       % uncomment this line if you don't want scaling
D = D / sc;

n = round(N / 2);
m = N - n + 1;

rho = 1.05;
regul = 1e-2;

%%% This is for reweighted heuristic
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
        
        jopt = Temp(:);

        v1 = d - eopt - e2opt + y1opt/mu;
        v2 = jopt + y2opt/mu;
        hopt = full(Hprojs*(v1+Shs'*v2));
        
        eopt = rewsoftthr(d-hopt-e2opt+y1opt/mu, lambda/mu, mask);

        v4 = d - hopt - eopt + y1opt/mu;
        e2opt = (mu/(mu+lambda2)) * v4;
        
        y1opt(:) = y1opt(:)+mu*(d-hopt-eopt-e2opt);
        y2opt(:) = y2opt(:)+mu*full(jopt-Shs*hopt);
        
        mu = rho * mu;
        
    end
    
    %%% This is reweighted heuristic
    weights=1./(svd(jopt(Hind))+regul);
    WM(eye(dim*m, n)==1) = weights;
     
end

%%% scale the data back
% d = sc * d;       % reserved for debugging
% jopt = sc * jopt; % reserved for debugging
hopt = sc * hopt;
eopt = sc * eopt;
e2opt = sc * e2opt;

D_est = reshape(hopt, dim, N);
D_est = D_est';

end
