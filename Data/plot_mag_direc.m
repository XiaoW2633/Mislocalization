close all
figure;
x0=10;
y0=10;
width=1000;
height=500;

set(gcf,'position',[x0,y0,width,height]);
brain = 'LIP';
% ind = 2,new data
% ind = 3,new data valid
ind = '0';
%mean_prf = circular_mean(tot_prf_direc)*180/pi;
datafile1=['timecourse/',brain,ind,'.mat'];
if brain == 'LIP'

mean_forward = -1.57;
mean_target = -30;%-33.9
mean_fixation = -105.8291;
N=104;
end
if brain == 'FEF'
mean_forward = -4.3;
mean_target= -27.9328;
mean_fixation = -87.2894;
N=113;
end
%load(datafile1)
%tot_theta_radian = time_shift_direc;
tot_theta_radian = time_shift_direc;

%para = parameter;


options.color_area = [0.4940 0.1840 0.5560];    % Blue theme
options.color_area2 = [0.4660 0.6740 0.1880];
options.color_line = [0.4940 0.1840 0.5560];

%options.color_area = [243 169 114]./255;    % Orange theme
options.color_line2 = [0.4660 0.6740 0.1880];
c_line_text = options.color_line2 ;
options.alpha      = 0.4;
options.line_width = 2;



if(isfield(options,'x_axis')==0), options.x_axis =para.sbin; end
options.x_axis = options.x_axis(:);
%options.x_axis = para.sbin;
x_vector = [options.x_axis', fliplr(options.x_axis')];
% Computing the mean and standard deviation of the data matrix
early_shift_mag = time_shift_mag;
data_mean1 = nanmean(early_shift_mag,1);
data_std1  = nanstd(early_shift_mag,0,1);
error = (data_std1./sqrt(size(early_shift_mag,1)));


sem_theta= [];
mean_theta =[];
for i = 1:size(tot_theta_radian,2) % do you need the loop ??
    tmp_theta = tot_theta_radian(:,i);
     Indval = find(~isnan(tmp_theta));
    [s s0] = circ_std(tmp_theta(Indval));
    sem_theta = [sem_theta,s0*180/pi/sqrt(size(tot_theta_radian,1))]; % standard error named std ??
    %% computer the circular mean without nan values
    
    %mean_theta=[mean_theta,circ_mean(tot_theta_radian(:,i))];
    mean_theta=[mean_theta,circ_mean(tmp_theta(Indval))];
    [pval, z] = circ_rtest(tot_theta_radian(:,i)');
   % ptheta = [ptheta,pval];
end
xlimt=[para.sbin(1),para.sbin(end)];
mean_theta = mean_theta*180/pi;
%ylabel('Normalized shift magnitude')

yyaxis left   % ??
set(gca,'FontSize',20);
x_vector = [options.x_axis', fliplr(options.x_axis')];
%ax(1) = gca;
patch_sem = fill(x_vector, [data_mean1+error,fliplr(data_mean1-error)], options.color_area);
set(patch_sem, 'edgecolor', 'none');
set(patch_sem, 'FaceAlpha', options.alpha);
hold on
plot(options.x_axis, data_mean1, 'color', options.color_line, ...
    'LineWidth', options.line_width,'linestyle','-');
hold on;
%xlimt=[para.sbin(1),para.sbin(end)+30];
plot(xlimt,[1,1],'color',options.color_area,'LineWidth',3,'LineStyle','-'); hold on
set(gca,'ylim',[0,1.1],'YColor',options.color_area);
set(gca,'YTick',[ 0,0.5,1],'YTickLabel',...
   {'0','0.5','1'});
%% Direction
yyaxis right
set(gca,'FontSize',20);
patch_direc = fill(x_vector, [mean_theta+sem_theta,fliplr(mean_theta-sem_theta)], options.color_area2);
set(patch_direc, 'edgecolor', 'none');
set(patch_direc, 'FaceAlpha', options.alpha);
hold on
plot(options.x_axis, mean_theta, 'color', options.color_line2, ...
    'LineWidth', options.line_width,'linestyle','-');
%ylim([-100,20]);
set(gca,'ylim',[-120,20],'YColor',options.color_area2);
hold on;

plot(xlimt,[mean_target,mean_target],'color',options.color_area2,'LineWidth',3,'LineStyle','--');hold on % 6 horizontal saccade;
plot(xlimt,[mean_forward,mean_forward],'color',options.color_area2,'LineWidth',3,'LineStyle',':');hold on
%mean_fixation
plot(xlimt,[mean_fixation,mean_fixation],'color',options.color_area2,'LineWidth',3,'LineStyle','-.');hold on
if brain == 'LIP'
text(-45,mean_target-10,'Mean target direction','FontSize',20,'color',c_line_text,'FontWeight', 'Bold');
text(-45,mean_forward+5,'Mean fRF direction','FontSize',20,'color',c_line_text,'FontWeight', 'Bold');
text(-45,mean_fixation+10,'Mean fixation direction','FontSize',20,'color',c_line_text,'FontWeight', 'Bold');
end
xlabel('Time from saccade onset (ms)','FontSize',30);
show_string1 = sprintf([brain,' N=%g'],N); 
text(120,28,show_string1,'FontSize',30);
text(-90,-115,'Normalized shift magnitude','FontSize',30,'rotation',90,'color',options.color_line );
text(445,-100,'Shift direction (deg)','FontSize',30,'rotation',90,'color',options.color_line2 );
set(gca,'xlim',xlimt);
set(gca,'FontSize',25); 
set(gca,'linewidth',2)
pstat.mean_vec = data_mean1;
