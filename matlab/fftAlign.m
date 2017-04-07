function [yOut, w0] = fftAlign(y, w0)

if nargin < 2
    w0 = [];
end

yOut = cell(size(y));
for i = 1:length(y)
%     if i==16, keyboard; end
%     N = length(y{i});
N = 1000;
    f = fft(y{i}, N);
    f_abs = abs(f);
    if mod(N, 2) == 0
        [~, index] = max(f_abs(1:(N/2+1)));
    else
        [~, index] = max(f_abs(1:(N+1)/2));
    end
    if i == 1 && isempty(w0)
        index0 = index;
        w0 = (2*pi/N) * (index0-1);
        continue;
    end
    w = (2*pi/N) * (index-1);
    scale = w / (w0 + eps);
    fNew = mapFreq(f, scale);
    yOut{i} = ifft(fNew, 'symmetric');
    
end

end

function fNew = mapFreq(f, scale)

N = length(f);
fNew = zeros(size(f));
if mod(N, 2) == 0
    wr = (2*pi/N) * (0:(N/2));
else
    wr = (2*pi/N) * (0:(N-1)/2);
end
wrNew = wr / scale;

% find index map
ind1 = cell(1, length(wr));
for i = 1:length(wrNew)
    [~, z] = min(abs(wrNew(i)-wr));
    ind1{i} = [ind1{i}, z];
end

% get fNew
for i = 1:length(ind1)
    if isempty(ind1{i})
        continue;
    end
    fNew(i) = mean(f(ind1{i}));
end

if mod(N, 2) == 0
    fNew(N/2+2:end) = fliplr(fNew(2:N/2));
else
    fNew((N+1)/2+1:end) = fliplr(fNew(2:(N+1)/2));
end

end