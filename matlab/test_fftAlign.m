clear; close all;

addpath(genpath('../matlab'));
addpath(genpath('../3rdParty'));

dataPath = '~/research/data/MHAD';
load(fullfile(dataPath, 'MHAD_data_whole.mat'));

A = data(label_act == 1);
n = length(A);
ys = cell(1, n);
for i = 1:n
    ys{i} = A{i}(3,30:end-30); % get the first joint
end
ys = getVelocity(ys);

A2 = data(label_act == 3);
n2 = length(A2);
ys2 = cell(1, n2);
for i = 1:n2
    ys2{i} = A2{i}(3,30:end-30); % get the first joint
end
ys2 = getVelocity(ys2);

[ys_align, w0] = fftAlign(ys);
% [ys2_align, w0] = fftAlign(ys2, w0);

figure(1);
for i = 1:length(ys)
    plot(ys{i});
    hold on;
    plot(ys_align{i});
    title(sprintf('Instance %d', i));
    hold off;
    pause
end

% for i=1:length(ys),
% %     plot(ys{i}); 
%     plot(abs(fft(ys_align{i},1000)))
%     hold on;
% end, hold off;