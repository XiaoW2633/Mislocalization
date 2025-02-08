function Rf=CenterOfMass(vis,X,Y,XI,YI,Xrange_interp,Yrange_interp,para)
%% CenterOfMass: calculate rf's center of mass.
%% input:
%% vis : raw heatmap before normalization and interpolation.
%% X,Y : raw x-y meshgrid
%% XI,YI: interpolated  x-y meshgrid 
%% Xrange_interp,Yrange_interp : x,y range (interpolated);[XI,YI] = meshgrid(Xrange_interp,Yrange_interp);
%% para: parameters
%% output: Rf.rawRF,interpolated raw heat map
%%         Rf.rf,  interpolated and normalized recptive field above the threshold.
%%         Rf.center, xy center of Rf.rf in screen coordinates.
%%         Rf.center_pos, row and column position of rf center in the interpolated rf.
%% get the rf threshold
th_rf=para.rf;
% th_area = 0.2;
% th_num_area=3;
% th_edge=0.4;
%x_fp_interp = target(1);
%y_fp_interp = target(2);
%x_tg_interp = target(3);
%y_tg_interp = target(4);

%% normalize the firing rate to [0,1];
vis_min=min(vis(:));
vis_max=max(vis(:));

vis_norm=(vis-vis_min)./(vis_max-vis_min);
%% recording grids that beyond the threshold.0/1 matrix, 1 represents receptive field grid.
above_th=vis_norm>=th_rf; 
%min_above_th=min(vis(above_th))-vis_min; % ??


siz=size(vis);
vis_norm_intp=interp2(X,Y,vis_norm,XI,YI);%% interpolate ( linear interpolation) the normalized heat map
Rf.rawRF = interp2(X,Y,vis,XI,YI); %% interpolate the raw heat map (output)
%Rf.normRFtt = 1;
vis_norm_intp(vis_norm_intp<th_rf)=0; %% Get the recptive field
Rf.rf=vis_norm_intp;

%%  compute the center of mass
Mass=sum(Rf.rf(:));
rfcenter_x = sum(sum(XI.*Rf.rf))/Mass;
rfcenter_y = sum(sum(YI.*Rf.rf))/Mass;
[~,xmeanI1]=min(abs(Xrange_interp-rfcenter_x)); %% get the column of the center in the interpolated matrix
[~,ymeanI1]=min(abs(Yrange_interp-rfcenter_y)); %% get the row of the center in the interpolated matrix
Rf.center=[rfcenter_x,rfcenter_y];
Rf.center_pos = [xmeanI1,ymeanI1];


end