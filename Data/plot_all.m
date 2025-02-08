% plot time course with overlab



%cd('/Users/wangxiao/Desktop/matlab/LIP-FEF-data-analysis/misloc/runcode');
close all
clear;
surfix= '400ms';
brain = 'LIP';
ind = '1';
datafile1=['overlap/',brain,ind,'.mat'];


load(datafile1)

time1 = 1;
time2 = 350;
lip_tot_p=[];
time = 0:1:parameter.sbin(end);
[lipmean1,lipmean2] = plot_trace(early_shift_mag ,late_shift_mag,parameter,time1,time2);hold on
title(brain);
lip1_full = early_shift_mag;
lip2_full = late_shift_mag;


figname = [brain,ind,'-time1.png'];
%saveas(gcf,figname);
