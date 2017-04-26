%% Get JBLD hist
% Jbld_total: 1x20 struct; Jbld_total_flip:1x20 struct
Nvid = 20;
num = length(Jbld{1,1});%number of Jbld
Jbld_head_total = zeros(num,Nvid);
Jbld_sh_total = zeros(num,Nvid*2); % left & right
Jbld_el_total = zeros(num,Nvid*2); % left & right
Jbld_wr_total = zeros(num,Nvid*2); % wrist left & right
Jbld_nec_total = zeros(num,Nvid); % neck

for Nvideo = 1 : Nvid
    Jbld_head_total(:,Nvideo) = Jbld_total(Nvideo).videos{1,1};
    Jbld_nec_total(:, Nvideo) = Jbld_total(Nvideo).videos{1,2};
    
    
    Jbld_sh_total(:, Nvideo) = Jbld_total(Nvideo).videos{1,3};
    Jbld_sh_total(:, Nvideo+Nvid) = Jbld_total(Nvideo).videos{1,6};
    
    Jbld_el_total(:,Nvideo) = Jbld_total(Nvideo).videos{1,4};
    Jbld_el_total(:,Nvideo+Nvid) = Jbld_total(Nvideo).videos{1,7};
    
     
    Jbld_wr_total(:,Nvideo) = Jbld_total(Nvideo).videos{1,5};
    Jbld_wr_total(:,Nvideo+Nvid) = Jbld_total(Nvideo).videos{1,8};

    
end
%%
figure(1)
subplot(5,1,1);
[h1,ind] = hist(Jbld_head_total(:));
title('Histgram of head joint');
xlim([0 1]);

subplot(5,1,2);
h2= hist(Jbld_sh_total(:));
xlim([0 1]);
title('Histgram of shoulder joint');


subplot(5,1,3)
h3 = hist(Jbld_el_total(:));
title('Histgram of elbow joint');
xlim([0 1]);

subplot(5,1,4)
h4 = hist(Jbld_wr_total(:));
title('Histgram of wrist joint');
xlim([0 1]);

subplot(5,1,5)
h5 = hist(Jbld_nec_total(:));
title('Histgram of neck joint');
xlim([0 1]);
%%
































