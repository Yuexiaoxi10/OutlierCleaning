function [r1train] = sysIdOneJoint(y, orderUpperBound)
% function sysIdOneJoint
% system identification of trajectory of one joint

[d, n] = size(y);
if nargin < 2
    orderUpperBound = 5;
end

y = bsxfun(@minus, y, mean(y, 2));
% y = y + 10;
H = blockHankel(y);
order = rankEst(H, 0.8);
order = min(order, orderUpperBound);

% order = 4;
y = hstln_mo(y, order);

y = y.';
u = zeros(size(y)); u(1,:) = 1;
dat = iddata([zeros(order,d);y], [zeros(order,d); u], 1);
% [sys] = ssest(dat, order, 'Ts', 1, 'InitialState','zero','Focus','stability');
[sys] = ssest(dat, order, 'Ts', 1, 'InitialState','zero','Focus','simulation');
% sys = n4sid(dat, order, 'Ts', 1, 'InitialState','zero','Form','Canonical','DisturbanceModel','none','Focus','stability');
[num,den] = ss2tf(sys.A,sys.B,sys.C,sys.D,1);
systf = tf(num, den, 1);
lsim(systf, dat.u, 0:length(dat.u)-1);
hold on; plot(dat.y,'*-'); hold off;
% [~, p1train] = estimateNumCoef(systf.num{1}, systf.den{1});
% r1train = -fliplr(poly(p1train))';
r1train = -fliplr(systf.den{1})';

sys1 = ssest(dat, order, 'Ts', 1, 'InitialState','zero','Focus','simulation');
y1 = lsim(sys1, dat.u, 0:length(dat.u)-1);
sys2 = ssest(dat, order, 'Ts', 1, 'InitialState','zero','Focus','prediction');
y2 = lsim(sys2, dat.u, 0:length(dat.u)-1);
figure(1);
plot(dat.y,'*-');
hold on;
plot(y1, 'o-');
plot(y2, '>-');
hold off

end