%% Generating poles
% complex poles
function poles = GeneratePoles(N)
% # of output poles: 2N
r = -1 + 2*rand(1,N); %||r||<=1;
theta = rand(1,N)*pi; % 0 < theta < 180;
a1 = r.* cos(theta);%real part
b2 = r.* sin(theta);%complex part
p1 = [complex(a1,b2);complex(a1,-b2)]';

% real poles
p2 = [rand(1,N);rand(1,N)]';
p = [p2;p1];

% rearrange poles
ix = randperm(2*N);
poles = p(ix,:);
end
