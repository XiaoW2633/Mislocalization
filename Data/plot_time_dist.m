brain = 'LIP';
ind = '16';

datafile1=['overlap/',brain,ind,'.mat'];
load(datafile1);
tot_time_LIP = tot_time(tot_time>-500);
brain = 'FEF';
ind = '16';

datafile2=['overlap/',brain,ind,'.mat'];
load(datafile2);
tot_time_FEF = tot_time(tot_time>-500);
figure;

h1 = histogram(tot_time_LIP,40);hold on
%h1.Normalization = 'probability';

h2 = histogram(tot_time_FEF,40);
%h2.Normalization = 'probability';
legend('LIP','FEF','location','NorthWest');
xlim([-350,0]);
xlabel('Flash time from saccade onset (ms)');
ylabel('Trial number');
set(gca,'FontSize',25); 
set(gca,'Linewidth',2)
box off