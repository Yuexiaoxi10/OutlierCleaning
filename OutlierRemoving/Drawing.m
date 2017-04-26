% load('./Results/Jbld_total.mat');
close all
Nvideo = 12;
Jt = 5;
dt = 2; 
windSize = 10;
Jbld = Jbld_total(Nvideo).Jbld{1,Jt};
Jnew_ihstln = JbldValue_New(NewTrajectory_ihstln(Nvideo).Trajec{1, Jt},dt,windSize);
Jnew_alm = JbldValue_New(NewTrajectory(Nvideo).Trajec{1, Jt},dt,windSize);
% Jnew_sr = JbldValue_New(NewTrajectory_sr(Nvideo).Trajec{1, Jt},dt,windSize);
ithJbld = (1 : length(Jbld))';

figure(1)
xAxis = ithJbld(:,1)*dt+windSize;
plot(xAxis,Jbld,'r-*','LineWidth',2,'MarkerSize',10),hold on
% plot(xAxis,Jnew_ihstln,'c-x','LineWidth',2,'MarkerSize',10);
% plot(xAxis,Jnew_alm,'m-o','LineWidth',2,'MarkerSize',10);
% plot(xAxis,Jnew_sr,'g-+','LineWidth',2,'MarkerSize',10);

t = title('JBLD Value:Left Wrist','Color','k');
legend('JBLD-Detection','JBLD-IHSTLN','JBLD-ALM');
set(t,'FontSize',25);
set(gca,'fontsize',15);
xlabel('Time');
ylabel('JBLD Values');
% ylim([0,1.2]);
  ax = gca;
  ax.Color = 'none';

%%


figure(2)
plot(xAxis, Jnew_ihstln);
% ylim([0 2]);
