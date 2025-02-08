function [data_mean1,data_mean2]=plot_trace(data1,data2,para,T1,T2)

data1 = data1(:,T1:T2);
data2 = data2(:,T1:T2);
para.sbin = para.sbin(T1:T2);
%options.handle     = figure(1);
options.color_area = [1 0 0];%[0.4940 0.1840 0.5560];    % Blue theme
options.color_area2 = [0 0 1];%[0.4660 0.6740 0.1880];
options.color_line = [1 0 0];%[0.4940 0.1840 0.5560];
%options.color_area = [243 169 114]./255;    % Orange theme
options.color_line2 = [0 0 1];%[0.4660 0.6740 0.1880];
options.alpha      = 0.35;
options.line_width = 2;
options.error      = 'sem';

if(isfield(options,'x_axis')==0), options.x_axis =para.sbin; end
options.x_axis = options.x_axis(:);

% Computing the mean and standard deviation of the data matrix
data_mean1 = nanmean(data1,1);
data_std1  = nanstd(data1,0,1);

data_mean2 = nanmean(data2,1);
data_std2  = nanstd(data2,0,1);

% Type of error plot
switch(options.error)
   % case 'std', error = data_std;
    case 'sem', error1 = (data_std1./sqrt(size(data1,1)));
   % case 'var', error = (data_std.^2);
  %  case 'c95', error = (data_std./sqrt(size(data,1))).*1.96;
end
error2 = (data_std2./sqrt(size(data2,1)));

sem_theta = []; %% standard error mean of direction.
mean_theta=[]; %% mean direction



%set(gcf,'defaultAxesColorOrder',[[0,0,0]; [0,0,0]]);
set(gcf,'defaultAxesColorOrder',[0,0,0]);


xlimt=[para.sbin(1),para.sbin(end)];
% figure1=figure;
% figsizex = 800;
% figsizey = 500;
% set(figure1,'position',[100 100 figsizex figsizey]);
% yyaxis left   % ??
set(gca,'FontSize',20);
x_vector = [options.x_axis', fliplr(options.x_axis')];
%x_vector = [options.x_axis', options.x_axis'];
%ax(1) = gca;
patch_sem1 = fill(x_vector, [data_mean1+error1,fliplr(data_mean1-error1)], options.color_area);hold on
patch_sem2 = fill(x_vector, [data_mean2+error2,fliplr(data_mean2-error2)], options.color_area2);hold on
%patch_sem1 = fill(x_vector, [data_mean1+error1,data_mean1-error1], options.color_area);hold on
%patch_sem2 = fill(x_vector, [data_mean2+error2,data_mean2-error2], options.color_area2);hold on
sac_vector = [150,200,200,150];
%patch_mean = fill(sac_vector, [[1,1],fliplr([0,0])], [0,0,0]);hold on
set(patch_sem1, 'edgecolor', 'none');
set(patch_sem1, 'FaceAlpha', options.alpha);
set(patch_sem2, 'edgecolor', 'none');
set(patch_sem2, 'FaceAlpha', options.alpha);
% set(patch_mean,'edgecolor', 'none');
% set(patch_mean, 'FaceAlpha', options.alpha);
hold on
plot(options.x_axis, data_mean1, 'color', [1,0,0,0.3], ...
    'LineWidth', options.line_width,'linestyle','-'); % options.color_line
hold on
l1 = plot(options.x_axis, data_mean1, 'color', [1,0,0], ...
    'LineWidth',3,'linestyle','-'); % options.color_line
hold on
plot(options.x_axis, data_mean2, 'color',[0,0,1,0.3], ...
    'LineWidth', options.line_width,'linestyle','-');
hold on
l2 = plot(options.x_axis, data_mean2, 'color',[0,0,1], ...
    'LineWidth', 3,'linestyle','-');
legend([l1,l2],'Early','Late','location','SouthEast');

hold on;
plot([xlimt(1)-50,xlimt(2)+20],[1,1],'color',[0,0,0],'LineWidth',3,'LineStyle','-'); hold on

 set(gca,'YColor',[0,0,0],'YTick',[0  0.2  0.4  0.6 0.8 1],'YTickLabel',...
     {'0','0.2','0.4','0.6','0.8','1'});
ylabel(gca,'Norm. shift magnitude');
xlabel(gca,'Time from saccade onset (ms)');
%set(gca,'ylim',[0,1.1]);
set(gca,'ylim',[0,1.2],'YColor',[0,0,0]);
set(gca,'xlim',[0,para.sbin(end)],'YColor',[0,0,0]);
set(gca,'FontSize',25); 
set(gca,'Linewidth',2)

end