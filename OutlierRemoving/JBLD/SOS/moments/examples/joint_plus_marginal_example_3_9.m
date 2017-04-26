% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% This example implements a joint+marginal example from Lasserre
%
% REFERENCE: JOINT+MARGINAL PARAMETRIC 2010, Ex. 3.9
% K = { 1 - x^2 -y^2 >=0}
% f(x,y) = -y*x^2
%
clear;clc;
close all;
set(0, 'DefaultFigurePosition', [111,243,809,679]);
set(0, 'DefaultAxesFontSize', 14);
set(0, 'DefaultLineLineWidth', 2); 

%%
% I made this example before I knew Sedumi solves both the primal & dual.
% DUAL
moments = uniform_moments(0,1,0:7);

cvx_clear
cvx_begin sdp
cvx_solver sedumi

[M,~] = get_mmatrix(4,2);
[monomials,n_monomials] = get_monomials(M);
B = get_index_matrices(monomials,get_map(M,monomials));

[M,~] = get_mmatrix(3,2);
C = get_index_matrices(monomials,get_map(M,monomials));

L = localize(M,[1 0]);
C10 = get_index_matrices(monomials,get_map(L,monomials));

L = localize(M,[0 1]);
C01 = get_index_matrices(monomials,get_map(L,monomials));

L = localize(M,[2 0]);
C20 = get_index_matrices(monomials,get_map(L,monomials));

L = localize(M,[0 2]);
C02 = get_index_matrices(monomials,get_map(L,monomials));

%[(1:n_monomials)',monomials]
n_moments = length(moments);
variable p(n_moments,1);
variable X(15,15) symmetric;
variable Z1(10,10) symmetric; %h1 = 1-x^2-y^2
variable Z2(10,10) symmetric; %h2 = 1-x
variable Z3(10,10) symmetric; %h3 = x
variable Z4(10,10) symmetric; %h4 = 1-y
variable Z5(10,10) symmetric; %h5 = y

f = zeros(n_monomials,1);
f(get_index(monomials,[2 1])) = -1;
idx = get_index(monomials,[zeros(8,1),(0:7)']);
maximize( moments'*p )
subject to

for k = 1:n_monomials
    [~,idx_p] = ismember(k,idx);
    if(idx_p)
        f(k) - p(idx_p) == trace(X*B{k})+...
            trace(Z1*(C{k}-C20{k}-C02{k}))+...
            trace(Z4*(C{k}-C01{k}))+...
            trace(Z5*C01{k});
        %             trace(Z2*(C{k}-C10{k}))+...
        %             trace(Z3*C10{k})+...
    else
        f(k) == trace(X*B{k})+...
            trace(Z1*(C{k}-C20{k}-C02{k}))+...
            trace(Z4*(C{k}-C01{k}))+...
            trace(Z5*C01{k});
        %             trace(Z2*(C{k}-C10{k}))+...
        %             trace(Z3*C10{k})+...
    end
end
X>=0;
Z1>=0;
Z2>=0;
Z3>=0;
Z4>=0;
Z5>=0;
cvx_end
cvx_optval
%%
y = linspace(0,1,100);
Jy = y.*(1-y.^2);
p = -p;
% p = [0.00116694589068829;
% 0.97675523582367;
% 0.182416317893377;
% -1.7165913157714;
% 1.54416265272775;
% -1.85319093145952;
% 1.1612101865023;
% -0.29591779025793]
f = zeros(size(y));
for k = 0:7
    f = f + p(k+1)*(y.^k);
end
close all; 
subplot(2,1,1);
plot(y,Jy,'-b.');
grid on;
hold on;
plot(y,f,':ro');
legend('Jy','-p');
xlabel('y');
title('Optimal Solution J(Y) AND ITS SOS APPROXIMATION');
subplot(2,1,2);
plot(Jy-f,'-b.');
grid on;
ylim([-1,1]*1e-3);
xlabel('Data Point');
ylabel('Jy-(-p)');
%%
return
%%
% PRIMAL, -0.250067 VS -0.25001786 IN LASSERRE
moments = uniform_moments(0,1,0:7);
[M,basis_data] = get_mmatrix(4,2);
[monomials,n_monomials] = get_monomials(M);


cvx_clear
cvx_begin sdp
cvx_solver sedumi 

variable z(n_monomials,1);
dual variable p{8}; %p is the same as p from the dual program above
M4 = assignm(z,get_map(M,monomials));

[M,~] = get_mmatrix(3,2);
M3 = assignm(z,get_map(M,monomials));
L = localize(M,[1 0]);
L10 = assignm(z,get_map(L,monomials));
L = localize(M,[0 1]);
L01 = assignm(z,get_map(L,monomials));
L = localize(M,[2 0]);
L20 = assignm(z,get_map(L,monomials));
L = localize(M,[0 2]);
L02 = assignm(z,get_map(L,monomials));

%f(x,y) = -y*x^2

z21 = z(get_index(monomials,[2 1])); % (x^2) y
z00 = z(get_index(monomials,[0 0]));  
z01 = z(get_index(monomials,[0 1])); % y
z02 = z(get_index(monomials,[0 2]));  
z03 = z(get_index(monomials,[0 3])); 
z04 = z(get_index(monomials,[0 4])); 
z05 = z(get_index(monomials,[0 5]));  
z06 = z(get_index(monomials,[0 6])); 
z07 = z(get_index(monomials,[0 7])); 
z08 = z(get_index(monomials,[0 8])); 
z10 = z(get_index(monomials,[1 0])); % x

minimize( -z21 )
subject to
M4>=0
% L10>=0
% M3-L10>=0
L01>=0
M3-L01>=0
M3 - L20 - L02 >=0

z00 == moments(1) : p{1} %this is how to get the dual variables
z01 == moments(2) : p{2}
z02 == moments(3) : p{3}
z03 == moments(4) : p{4}
z04 == moments(5) : p{5}
z05 == moments(6) : p{6}
z06 == moments(7) : p{7}
z07 == moments(8) : p{8}
%z08 == moments(9)
cvx_end
%p = [-0.00117102748164474;
% -0.976678510580376;
% -0.183038189313921;
% 1.71914823541913;
% -1.54993335291317;
% 1.86041775847208;
% -1.16591353221268;
% 0.297156879989116]


