function [r1train] = sysIdOneJoint(y, order)
% function sysIdOneJoint
% system identification of trajectory of one joint

% y = A{1}(3,:);
[d, n] = size(y);
% order = 4;
y = hstln_mo(y, order);

y = y.';
u = zeros(size(y)); u(1,:) = 1;
dat = iddata([zeros(order,d);y], [zeros(order,d); u], 1);
[sys] = ssest(dat, order, 'Ts', 1, 'InitialState','zero','Focus','simulation');
[num,den] = ss2tf(sys.A,sys.B,sys.C,sys.D,1);
systf = tf(num, den, 1);
% lsim(systf, dat.u, 0:length(dat.u)-1);
% hold on; plot(dat.y,'*-'); hold off;
[~, p1train] = estimateNumCoef(systf.num{1}, systf.den{1});
r1train = -fliplr(poly(p1train))';

end