function [p,weight] = bal_from_data( y, order )
% function [sysb,M] = bal_from_data( y )
% creates a balanced realization from scalar data y
% input:  y, vector 1 x T containing the data
% output:   p  poles of the system (assumed complex conjugate)
%           weights:  weight for each pair of poles
%
%           
%                                   M.S,  May 2017
%
%
% form the Hankel matrix and get its svd
n=max(size(y));
n=floor(n/2);
Hy=hankel(y(1:n),y(n:end));
s=svd(Hy);
%
% estimate the rank
%
s=s/sum(s);
r=max(find(cumsum(s)<0.99));
r=r+1;
r = order;
%
% now reshape the Hankel matrix
%
Hy=hankel(y(1:2*r),y(2*r:end));
[U,S,V]=svd(Hy);
%
% partition U according to the rank
%
U11=U(1:r,1:r);
U12=U(1:r,r+1:end);
%
% find a basis for the row space of U12'*Hy
%
[UU,SS,VV]=svd(U12'*U11*S(1:r,1:r));
Uq=UU(:,1:r);
%
% now find a state trajectory 
%
X=Uq'*U12'*Hy(1:r,:);
% 
% get the state space matrices:
A=X(:,2:end)/X(:,1:end-1);
 [mx,nx]=size(X);
 C=y(1:nx)/X;
 B=X(:,1);
 D=0;
 sys=ss(A,B,C,D,1);  % this is the identified system
 %
 % as a sanity check compute its impulse response
 %
 yi=impulse(sys,(1:1:length(y)));
 if norm(y-yi')> 1e-3
     fprintf('warning something is wrong')
 end
 %
 % now get a balanced realization
 %
 % note, if A is unstable, we need to scale
 %
 rho=max(abs(eig(A)));
 if rho > 1
     A=A/(rho*1.001);
     sys.A=A;
 end
 [sysb,M]=balreal(sys); 
 Ab=sysb.A;

 p=[];weight=[];
 for i = 1:2:r;
     Am=Ab(i:i+1,i:i+1);
     p=[p,eig(Am)]; weight=[weight,M(i)];
 end
weight=weight/max(weight);     



end

