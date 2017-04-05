function [ropt,r,etime] = ssrrr_yin_cvx(X,epsilon,fix,w)



[D,N] = size(X);

% N number of points
% D ambient dimension

if nargin<4
    w = ones(N,1);
end

cvx_begin
cvx_quiet true
    
%     cvx_solver gurobi
    variable ropt(D,1)
    variable r(D,N)
    
    obj = 0;
    for n=1:N
%         obj = obj + w(n)*max(abs(ropt - r(:,n)));
        obj = obj + w(n)*norm(ropt - r(:,n));
        X(:,n)'*r(:,n) <= +epsilon
        X(:,n)'*r(:,n) >= -epsilon
    end
    ropt(fix)==1
    stime = tic;
    minimize obj
cvx_end
etime = toc(stime);
