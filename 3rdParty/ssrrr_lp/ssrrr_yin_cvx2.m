function [ropt,r,etime] = ssrrr_yin_cvx2(X,epsilon,fix,w)



[D,N] = size(X);
assert(mod(D,2)==0); % confirm D is even

% N number of points
% D ambient dimension

if nargin<4
    w = ones(N,1);
end

cvx_begin
cvx_quiet true
    
%     cvx_solver gurobi
    variable ropt(2*D,1)
    variable r(2*D,N)
    
    obj = 0;
    for n=1:N
        obj = obj + w(n)*max(abs(ropt - r(:,n)));
%         X(:,n)'*r(:,n) <= +epsilon
%         X(:,n)'*r(:,n) >= -epsilon
        X(:,n)'*r(1:D,n) <= +epsilon
        X(:,n)'*r(1:D,n) >= -epsilon
        X(:,n)'*r(D+1:end,n) <= +epsilon
        X(:,n)'*r(D+1:end,n) >= -epsilon
    end
    ropt(2*(fix-1)+1)==1
    ropt(2*fix)==0
    ropt(D+2*(fix-1)+1)==0
    ropt(D+2*fix)==1
    stime = tic;
    minimize obj
cvx_end
etime = toc(stime);
