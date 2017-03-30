%% Generating poles
function poles = GeneratePoles(N)
% # of output poles: 2N
% N = 100;
% n = 0.5*N;
r1 = 0.98 + (1.02-0.98)*rand(1,N);
r2 = -1.02 + (-0.98+1.02)*rand(1,N);
r3 = [r1 r2];
ir = randperm(2*N);
r = r3(ir); % 0.9<|r|<1.1
%%
% r = -1 + 2*rand(1,N); %||r||<=1;
theta = rand(1,N)*pi; % 0 < theta < 180;
a = r(1:N).* cos(theta);%real part
b = r(1:N).* sin(theta);%complex part
p1 = [complex(a,b);complex(a,-b)]';

% real poles
% p2 = [rand(1,N);rand(1,N)]';
p2 = reshape(r(N+1:end),[N/2,2]);
p = [p2;p1];

% rearrange poles
 ix = randperm(length(p));
 poles = p(ix,:);
 end