% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% This example shows how to use the running intersection property and the 
% reweighted heuristic to get a rank-1 moment matrix.
%
% objective:    min f0 = x1*x2 + x1*x3
% subject to
%              K =  { x1^2+x2^2<=1, x1^2+x3^2<=2 }
%
clear; clc;
%%
%%
flag = 1;
count = 1;
%first run, no reweighted heuristic
W1 = zeros(3);
W2 = zeros(3);
I = eye(3);

%%
% generally, we want to do all this setup outside the loop because this only
% needs to be done once. it makes no difference for this small problem but
% for larger problems doing this outside the loop can save a lot of time.
mons12 = [0 0 0;1 0 0; 0 1 0];
mons13 = [0 0 0;1 0 0; 0 0 1];
[M12,~] = get_mmatrix(1,3,mons12);
[M13,~] = get_mmatrix(1,3,mons13);
[monomials,n_monomials] = get_monomials({M12,M13}); %get all mons
indices.x1x2 = get_index(monomials,[1 1 0]);
indices.x1x3 = get_index(monomials,[1 0 1]);
indices.x1_2 = get_index(monomials,[2 0 0]);
indices.x2_2 = get_index(monomials,[0 2 0]);
indices.x3_2 = get_index(monomials,[0 0 2]);
indices.x = get_index(monomials,eye(3));
maps.M12 = get_map(M12,monomials);
maps.M13 = get_map(M13,monomials);
%%
while(flag)
    fprintf('Iteration %d:...\n',count);
    cvx_clear
    cvx_begin sdp
    cvx_solver sedumi
        
    variable y(n_monomials); 
    
    M12 = assignm(y,maps.M12);
    M13 = assignm(y,maps.M13);
    x = y(indices.x);
    x1x2 = y(indices.x1x2);
    x1x3 = y(indices.x1x3);
    x1_2 = y(indices.x1_2);
    x2_2 = y(indices.x2_2 );
    x3_2 = y(indices.x3_2 );
    
    f0 = x1x2 + x1x3;
      
    minimize(f0+trace(W1*M12+W2*M13))
    subject to
    y(1)==1
    M12>=0
    M13>=0
    x1_2+x2_2<=1
    x1_2+x3_2<=2
    cvx_end
    
    S1 = svd(M12);
    S2 = svd(M13);
    W1 = inv(M12+I*S1(2));
    W2 = inv(M13+I*S2(2));
    flag = or(rank(M12,1e-4)~=1,rank(M13,1e-4)~=1);
    count = count + 1;
end
fprintf('reached rank-1 moment matrices!\n');
fprintf('one solution is: \n');
%show results
f0
x
%%
% after a couple of these reweightings:
% f0 = -1.4142
% x1* = 0.81649, x2* = -0.57727, x3* = -1.1546
%
% global solutions:
% x* = [pm 0.8165; mp 0.57734; mp 1.1547]
% f0* = -1.4142
%%
return
%%
mset clear
mpol x 3
f0 = mom(x(1)*x(2)) + mom(x(1)*x(3));
K = [x(1)^2+x(2)^2<=1;x(1)^2+x(3)^2<=2]
mu = meas;
P = msdp(min(f0),K)
[status,obj,M] = msol(P)
%%

I = eye(4);
reweight = 1;
fprintf('\n\n');
while(status<1)
    fprintf('reweight = %d \n',reweight);
    M1 = mmat(M);
    W = inv(double(M1)+I*0.01);
    f1 = trace(W*M1);
        
    %%
    P2 = msdp(min(f0+f1),K);
    [status,obj,M] = msol(P2);
    
    %%
    temp = mmat(M(1));
    svd( double(temp) )
    reweight = reweight + 1;
end
double(f0)
z = double(x)
fz = z(1)*z(2)+z(1)*z(3)

%%