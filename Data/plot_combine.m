% Plot fig6c
clear;
close all
brain = 'LIP';
ind = '1';

datafile1=['overlap/',brain,ind,'.mat'];


load(datafile1)
%load LIP7.mat;
time1 = 1;
time2 = 351;
%lip_tot_p=[];
time = 0:1:parameter.sbin(end);
lip1 = early_shift_mag;
lip2 = late_shift_mag;
%[lipmean1,lipmean2] = plot_trace(early_shift_mag ,late_shift_mag,parameter,end_time1,end_time2);hold on
title(brain);
%lip1_full = early_shift_mag;
%lip2_full = late_shift_mag;
brain = 'FEF'
datafile2=['overlap/',brain,ind,'.mat'];
load(datafile2)
fef1 = early_shift_mag;
fef2 = late_shift_mag;
tot1 = [lip1;fef1];
tot2 = [lip2;fef2];
[mean1,mean2] = plot_trace(tot1 ,tot2,parameter,time1,time2);hold on


title('Combined')
figname = ['combine.png'];
saveas(gcf,figname);
