function [F,F_i,T] = call_ssrrr_lp(X,epsilon,fix,tol,step)

[D,N] = size(X);
w = ones(N,1);
T = 0;
model = [];
f_if_prev = zeros(D,N+1);
% f_if_prev = zeros(2*D,N+1);

for iter = 1:30
    fprintf('%2.0f\t',iter);
%     [f,f_i,model,etime] = ssrrr_yin_lp(X,epsilon,fix,w,model);
    [f,f_i,etime] = ssrrr_yin_cvx(X,epsilon,fix,w);
%     [f,f_i,etime] = ssrrr_yin_cvx2(X,epsilon,fix,w);
    T = T+etime;
    
%     disp(f);
    % check for convergence
    if max(max(abs(f_if_prev-[f_i,f]))) < tol
        break;
    end
    if step==0
        stepsize = 1e-2;
    end
    if step==1
        stepsize = max(min(exp(-iter),1e-2),1e-4);
    end
    w = 1./(max(abs(bsxfun(@minus,f_i,f)),[],1)+stepsize);
    f_if_prev = [f_i,f];
end
fprintf('\n');
F = f;
F_i = f_i;