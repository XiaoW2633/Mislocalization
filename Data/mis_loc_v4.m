% Single cell analysis for the prediction of the misloc. paper.
% Using Jin Min's v-1 data
% Xiao Wang, 2024.10.02
clear; close all;
% Change running_root to your own folder where the code is located. The data will be from, and the anaylysis results
% will be saved to, subfolders named 'data' and 'results', respectively.
running_root = '/Users/wangxiao/Desktop/matlab_code/mis_loc/';
addpath(genpath(pwd));
cd('/Users/wangxiao/Desktop/matlab_code/mis_loc');
% add paths for lib files
addpath([running_root, 'lib/CircStat2012a/']); % for Mac
%% Set parametermeters
parameter = setParaBin_misloc(running_root);


%% Get the filenames of the neurons in each folder.
All_fef=dir([[parameter.datatime_root,parameter.time_names{1}],'*.','mat']);
All_lip=dir([[parameter.datatime_root,parameter.time_names{2}],'*.','mat']);
All_cell = {All_fef,All_lip}; % array of 2 matlab cells for the two areas

%% if parameter.subset is empty, run all the cells;
if parameter.subset
    loop_cells = parameter.subset;
else
    loop_cells = length(All_cell{parameter.brainIndex});
end

early_shift_mag   = []; % store the remapping amplitude with time #(ncell*T)
late_shift_mag   = []; % store the remapping amplitude with time #(ncell*T)
early_shift_direc = [];
late_shift_direc = [];
time_shift_direc = []; % time course of shift direction: Numofcell X timebins
fef_out_cell=[];
fef_name={};
tot_time=[]; % store all time of probe onset to saccade onset
%error_space = [];
tot_early_proj = [];
tot_prf = [];
early_late_shift = [];
for ncell= 1:loop_cells(end)% 
    ncell
    try
        All_cell_tmp = All_cell{parameter.brainIndex};
        name = All_cell_tmp(ncell).name;
        % load the data
        load([parameter.datatime_root, parameter.time_names{parameter.brainIndex}, name]);
        % Pre-calculated results, centers of crf/fef.
        cordn = cfg.cordn; % RFs' centers
        direc = cfg.direc;
        siz=size(data_fr_time.diff_ProbeOn_SacOn); % size of recording grid
        time_list_ = []; % collect all the times from probe onset to saccade onset of each cell
       
        Xrange=unique(para.X(:));
        Yrange=flipud(unique(para.Y(:)));
        %x_space = abs(Xrange(2)-Xrange(1));
        %y_space = abs(Yrange(2)-Yrange(1));
        %error_space = [error_space,abs(x_space-y_space)];
        [X,Y] = meshgrid(Xrange,Yrange);
        Xrange_interp=Xrange(1):0.1:Xrange(end);
        Yrange_interp=Yrange(1):-0.1:Yrange(end);
        [XI,YI] = meshgrid(Xrange_interp,Yrange_interp);
        for k= 1:siz(2)
         
            for l = 1:siz(1)
                % data_fr_time.diff_ProbeOn_SacOn{l,k} is an array for all trials
                time_list_=[time_list_;data_fr_time.diff_ProbeOn_SacOn{l,k}];

            end
        end
        tot_time=[tot_time;time_list_(:)];
        % Compute the time course for each time bin.
        tmp_contour=data_fr_time.fr;
        probe2sac_time = data_fr_time.diff_ProbeOn_SacOn;
        %% select cell
        tot_resp_bin = cell(siz);
        tot_resp_rf = zeros(siz);
        for k = 1:siz(2)
            for l = 1:siz(1)
              trials = tmp_contour{l,k};% spike times  
              if ~isempty(trials)
                  for i=1:length(trials) %% loop all trials  Is the loop necessary ??
                      tot_resp_bin{l,k}(i,4) = (1000/100)*sum((trials{i}>=0) & (trials{i}<100));%
                  end
                  tot_resp_rf(l,k) = mean(tot_resp_bin{l,k}(:,4));
              else
                  tot_resp_rf(l,k) = 0;
              end
                
            end
        end
        tot_RFbin=CenterOfMass(tot_resp_rf,X,Y,XI,YI,...
                Xrange_interp,Yrange_interp,parameter);
        [tmp_rfvec,towards_flag,hoz_flag] = ConvertAngle(P,...
            cordn.crfCenter,cordn.frfCenter,cordn.prfCenter,cordn.sacamp,-direc);

        tot_prf = [tot_prf;[tot_RFbin.center,cordn.prfCenter]];

        %% Time course analysis
        
        if(1)
            
        for sbin = 1:length(parameter.sbin)% all the time points
%             if sbin ==1
%             parameter.binsz
%             end

            pre  = parameter.sbin(sbin)-parameter.binsz/2; %% parameter.binsz/2 start time of each time bin
            post = parameter.sbin(sbin)+parameter.binsz/2;
            early_Rf_sbin = zeros(siz); % RF heat map
            late_Rf_sbin = zeros(siz);  % RF heat map
            early_resp_sbin = cell(siz); % spike counts for each time bin each grid
            late_resp_sbin = cell(siz);
            for k = 1:siz(2)% size of the grid
                for l = 1:siz(1)
                    trials = tmp_contour{l,k};% spike times
                    t_probe2sac_time = probe2sac_time{l,k}; % probe onset to saccade onset
                    %trial_Mtime = median( t_probe2sac_time , 'omitnan') ;
                    
                    % split the trials into early and late
                    early_ind = find(t_probe2sac_time<parameter.early_time);
                    early_trials = trials([early_ind(:)]);
                    late_ind = find(t_probe2sac_time>=parameter.late_time);
                    late_trials = trials([late_ind(:)]);
                    if ~isempty(early_trials)
                        for i=1:length(early_trials) %% loop all trials  Is the loop necessary ??
                            early_resp_sbin{l,k}(i,4) = parameter.nSpk2fr*sum((early_trials{i}>=pre) & (early_trials{i}<post));% 
                          
                            
                        end
                    else
                        early_resp_sbin{l,k}(1,4) = NaN;%?assign one trial as NAN
                    end
                    if ~isempty(late_trials)
                        for i=1:length(late_trials) %% 
                            late_resp_sbin{l,k}(i,4) = parameter.nSpk2fr*sum((late_trials{i}>=pre) & (late_trials{i}<post));% ?? try cellfun
                            %   loc_resp1_sbin{l,k}(i,3) = parameter.nSpk2fr_bsl*sum((baseline_trials{i}>=parameter.bsl_start) & (baseline_trials{i}<parameter.bsl_end));
                            
                        end
                    else
                        late_resp_sbin{l,k}(1,4) = NaN;%assign one trial as NAN
                    end
                    early_Rf_sbin(l,k) = mean(early_resp_sbin{l,k}(:,4));
                    late_Rf_sbin(l,k) = mean(late_resp_sbin{l,k}(:,4));
                end
            end
            %early_Rf_sbin1 = inpaint_nans(early_Rf_sbin);
            %Interpolate
            early_Rf_sbin = testRF(early_Rf_sbin,X,Y);
            %test_inpaint = early_Rf_sbin1-early_Rf_sbin;
            %early_Rf_sbin = shmat(early_Rf_sbin);
            late_Rf_sbin =  testRF(late_Rf_sbin,X,Y);
            
            early_RFbin=CenterOfMass(early_Rf_sbin,X,Y,XI,YI,...
                Xrange_interp,Yrange_interp,parameter);
            late_RFbin=CenterOfMass(late_Rf_sbin,X,Y,XI,YI,...
                Xrange_interp,Yrange_interp,parameter);
            early_CenterBin = early_RFbin.center;
            late_CenterBin = late_RFbin.center;
            % cRF and fRF centers are pre-calculted by cell reports' matlab code
            [early_rfvec_bin ,~,~]=  ConvertAngle(P,cordn.crfCenter,cordn.frfCenter,early_CenterBin,cordn.sacamp,-direc);% 
            % early_rfvec_bin(:,para.CRF2PRF)
            [late_rfvec_bin ,~,~]=  ConvertAngle(P,cordn.crfCenter,cordn.frfCenter,late_CenterBin,cordn.sacamp,-direc);% 
            % late_rfvec_bin(:,para.CRF2PRF)
            early_thetaNmag = vec2angle(early_rfvec_bin,parameter);
            late_thetaNmag = vec2angle(late_rfvec_bin,parameter);
             tmp_direc(sbin) = early_thetaNmag.crf2prfAngle; %% in radians
           tmp_magnitude_early(sbin) = early_thetaNmag.crf2prfMag./cordn.sacamp;
           tmp_magnitude_late(sbin) = late_thetaNmag.crf2prfMag./cordn.sacamp;
           
            % vecs(:,para.CRF2FRF:para.CRF2FRF+1);
            % vecs(:,para.CRF2PRF:para.CRF2PRF+1);
%              early_proj =...
%             dot(early_rfvec_bin(:,parameter.CRF2FRF:parameter.CRF2FRF+1),...
%                  early_rfvec_bin(:,parameter.CRF2PRF:parameter.CRF2PRF+1));
%              early_proj = early_proj./norm(early_rfvec_bin(:,parameter.CRF2FRF:parameter.CRF2FRF+1));
%              late_proj =...
%             dot(late_rfvec_bin(:,parameter.CRF2FRF:parameter.CRF2FRF+1),...
%                  late_rfvec_bin(:,parameter.CRF2PRF:parameter.CRF2PRF+1));
%             late_proj = late_proj./norm(late_rfvec_bin(:,parameter.CRF2FRF:parameter.CRF2FRF+1));

        end
        early_shift_mag     =  [early_shift_mag;tmp_magnitude_early];
        late_shift_mag      =  [late_shift_mag;tmp_magnitude_late];
         time_shift_direc  = [time_shift_direc;tmp_direc];
         early_late_shift = [early_late_shift;[tmp_magnitude_early,tmp_magnitude_late]];
    end
%         
    catch
        fef_out_cell=[fef_out_cell,ncell];
        fef_name = [fef_name,name];
    end
    
end
filename = parameter.time_names{parameter.brainIndex};
filename = filename(1:3);

if parameter.alignFlag ==3
save(['overlap/',filename,parameter.saveId,'.mat'],'early_shift_mag','late_shift_mag','parameter','tot_time');
%save(['timecourse/',filename,'0.mat'],'early_shift_mag','late_shift_mag','parameter','tot_time','time_shift_direc');
end
if parameter.alignFlag ==4

 save(['nonoverlap/',filename,parameter.saveId,'.mat'],'early_shift_mag','late_shift_mag','early_late_shift');
end
% vecs(:,para.CRF2FRF:para.CRF2FRF+1);
            % vecs(:,para.CRF2PRF:para.CRF2PRF+1);
%              early_proj =...
%             dot(early_rfvec_bin(:,parameter.CRF2FRF:parameter.CRF2FRF+1),...
%                  early_rfvec_bin(:,parameter.CRF2PRF:parameter.CRF2PRF+1));
%              early_proj = early_proj./norm(early_rfvec_bin(:,parameter.CRF2FRF:parameter.CRF2FRF+1));
%              late_proj =...
%             dot(late_rfvec_bin(:,parameter.CRF2FRF:parameter.CRF2FRF+1),...
%                  late_rfvec_bin(:,parameter.CRF2PRF:parameter.CRF2PRF+1));
%             late_proj = late_proj./norm(late_rfvec_bin(:,parameter.CRF2FRF:parameter.CRF2FRF+1));
% early_shift = mean(early_shift_mag(:,end-100:end),2);
% late_shift = mean(late_shift_mag(:,end-100:end),2);
% early_mean = nanmean(early_shift);
% late_mean = nanmean(late_shift);
% early_sem = nanstd(early_shift)/sqrt(length(early_shift));
% late_sem = nanstd(late_shift)/sqrt(length(late_shift));
% 
% l1 = bar([1],early_mean,'edgecolor','r','facecolor','none','linewidth',2,'DisplayName','Early');
% hold on
% l2 = bar([2],late_mean,'edgecolor','b','facecolor','none','linewidth',2,'DisplayName','Late');
% hold on
% legend('Early','Late');
% ylabel('Norm. shift magnitude');
% ylim([0,1.2]);
% hold on
% errorbar([1,2],[early_mean,late_mean],[early_sem,late_sem],'k.','linewidth',2);
% hold on
% [h,pv] = ttest(early_shift,late_shift);

% % OrigData=magic(3);
% X=randperm(numel(OrigData));
% ShuffledData=reshape(OrigData(X),size(OrigData))
% prctile

% hold on
% legend('Early','Late');
% ylabel('Norm. shift magnitude');
% ylim([0,1.2]);
% hold on
% errorbar([1,2],[early_mean,late_mean],[early_sem,late_sem],'k.','linewidth',2);
% hold on
% [h,pv] = ttest(early_shift,late_shift);
                                                                                 
% % OrigData=magic(3);
% X=randperm(numel(OrigData));
% ShuffledData=reshape(OrigData(X),size(OrigData))
% prctile
% hold on
% legend('Early','Late');
% ylabel('Norm. shift magnitude');
% ylim([0,1.2]);
% hold on
% errorbar([1,2],[early_mean,late_mean],[early_sem,late_sem],'k.','linewidth',2);
% hold on
% [h,pv] = ttest(early_shift,late_shift);