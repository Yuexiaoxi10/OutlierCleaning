function [ropt,r,model,etime] = ssrrr_yin_lp(X,epsilon,fix,w,model)


[D,N] = size(X);

% N number of points
% D ambient dimension

if nargin<4
    w = ones(N,1);
end

if nargin<4 || (nargin==5 && isempty(model))
    
    % minimize c'*v
    c = [zeros(D+D*N,1); w];
    
    % constraints from lp conversion
    % A*v <= b
    A = zeros(2*N*D,D+N*D+N);
    b = zeros(2*N*D,1);
    oneri = [diag(ones(D,1)) zeros(D,D*(N-1))];
    oneti = [ones(D,1) zeros(D,N-1)];
    eyed = diag(ones(D,1));
    for n=1:N
        acons = [[+eyed -oneri -oneti]; ...
                [-eyed +oneri -oneti]];
        A(2*(n-1)*D+1:2*D*n,:) = acons;
%         b = [b; zeros(2*D,1)];
        
        % shift constraint ones
        oneri = circshift(oneri,[0,D]);
        oneti = circshift(oneti,[0,1]);
        
        35;
        
    end
    
    % constraints from original formulation
    % |yi - xi'*ri| < epsilon
    % E*v <= f
    E = zeros(2*N,D+N*D+N);
    f = zeros(2*N,1);
    onexi = [ones(1,D) zeros(1,D*(N-1))];
    onexind = onexi;
    for n=1:N
        onexi(onexind~=0) = X(:,n);
        
        econs = [[zeros(1,D)  +onexi zeros(1,N)]; ...
                 [zeros(1,D)  -onexi zeros(1,N)]];
        

        E(2*(n-1)+1:2*n,:) = econs;
        f(2*(n-1)+1:2*n) = [+epsilon;+epsilon];

        
        % shift constraint ones
        onexi = circshift(onexi,[0,D]);
        onexind = circshift(onexind,[0,D]);
        
        35;
    end
    
%     econs = zeros(1,D+N*D+N);
%     econs(fix) = 1;
%     E = [E;econs;-econs];
%     f = [f;1;1];
    
    
    % combine constraints
    AE = [A;E];
    bf = [b;f];
    lb = [-inf(D,1);-inf(D*N,1);zeros(N,1)];    % set lower and upper bounds for variables
    ub = [+inf(D,1);+inf(D*N,1);+inf(N,1)];     % only t is lower bounded by 0.
    
    % add r(fix)==1 by setting the bounds
    lb(fix) = 1;
    ub(fix) = 1;
    
    
    % call the solver
    model.obj = c;
    model.A = sparse(AE);
    model.sense = '<';
    model.rhs = full(bf);
    model.lb = lb;
    model.ub = ub;
    
else
    c = model.obj;
    c(end-N+1:end) = w;
    model.obj = c;
end

params.outputflag = 0;          % Silence gurobi
% params.method = 1;
% params.scaleflag = 2;
stime = tic;
result = gurobi(model,params);
etime = toc(stime);

model.vbasis = result.vbasis;
model.cbasis = result.cbasis;


rall = reshape(result.x(1:D*(N+1)),[D N+1]);
ropt = rall(:,1);
r = rall(:,2:end);

