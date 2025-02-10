function para = setParaBin_misloc(running_root)
% Set all the parameters for the analysis
para.early_time = -100; %
para.late_time =-100; % 
para.saveId = '1';
% Y = prctile(tot_time,200/3)

para.version='01'; %
para.brainFlag = 1; % brain area: 1 FEF, 2 LIP
para.timeFlag  = 2; % time period: 1 delay, 2 perisaccade
para.alignFlag =3; % alignment: 1 probe onset, 2 saccade offset,3 saccade onset 4: 25ms bin
para.vecFlag   = 1; % mean vector plot Flag,1:r-theta mean. 0: x-y mean.

if para.timeFlag ~= 2 && para.alignFlag ~= 1 && para.alignFlag ~= 3
    error('Non perisaccadic responses should only be aligned on probe onset');
end

para.svfigFlag = 0; % Flag for save the figures
para.svecFlag  = 0;
para.drawHeatmap = 0; % Flag for drawing the heatmap of receptive field.

% if para.subset is empty, run all the cells, otherwise only run those with 
% indeces manually in para.subset.
para.subset = []; 

%% define data and result paths.
%para.data_root = '/Users/wangxiao/Desktop/model/FEFLIP/';
%para.data_root='/Users/wangxiao/Desktop/torch/RFdataset/';% cell report dataset path
para.datatime_root = '/Users/wangxiao/Desktop/matlab/LIP-FEF-data-analysis/misloc/runData/';% path to the dataset folder

para.time_names={'FEF_MisLoc/','LIP_MisLoc/'}; % misloc. dataset path

para.nboot = 1000; % number of samples for bootstrap
para.intpItv = 0.1;

%structure index indicates data on different time period,get data from yangling's data 
para.CURRENT = 1; %% crf
para.DELAY = 2;   %% drf
para.PERI_PROBE = 3; %% prf aligned on probe onset
para.FUTURE = 4;     %% frf
para.PERI_SAC =8;    %% prf aligned on saccade offset
%Column number indicates rf data centers on different time periods, save the data.
% 1,3,5,7 are x axis, 2,4,6,8 are y axis.
para.CRF2FP = 1; %% crf to fixation vector
para.CRF2FRF= 3; %% crf to frf vector
para.CRF2PRF= 5; %% crf to prf/drf vector
para.CRF2TG = 7; %% crf to target vector

% Column number for saccade amplitude
para.SACAMP = 9;



%% cell screening criteria
para.rf=0.85; %% 85% of max firing rate countour.
para.edge =0.20; %% completeness (1-0.8), 0.25
%para.area=0.5;
para.sigLevel=0.05; %% visual response test level
para.shift_level = 0.90; %% significant shift test level
para.trialNum = 5; % 4
%%calculate mean response time window, time parameters (ms)
para.bsl_start = -50; %% baseline time window start time ,0 means probe onset
para.bsl_end   = 0;   %% baseline time window end time,
para.pre_probe =  50; %% visual respone time window start time, 0 means probe onset
para.post_probe=  150; %% visual response time window end time
para.pre_sac = -50;   %% visual response time window start time, 0 means saccade off set.
para.post_sac=  50;    %% visual response time window end time.

para.pre_sacon = 0;   %% visual response time window start time, 0 means saccade off set.
para.post_sacon=  100;
%brain flag indicates which brain area to analyze.
%para.median_time = -100; %(ms), time point to split the trials into early and late.
% 1 is FEF and 2 is LIP
if para.brainFlag ==1 
    para.brainIndex = 1;
    para.brain = 'FEF'; 
    %para.median_time = -100;
elseif para.brainFlag ==2
    para.brainIndex = 2;
    para.brain = 'LIP';
    %para.median_time=-100;
else
    error('Invalid brain flag');
end

% time period flag indicates which time period to analyze.
% 1 is delay period and 2 is peri-saccade period.
para.binsz = 50; % 50 25
para.sbinsz = 1;
if para.timeFlag == 1
    para.tP = 2; % struct array index for the data from Yang Lin
    para.RFtime = 'dRF'; 
    para.align = 'probeon';
    %para.bin = 0:25:200; 
    para.bin = 75:para.binsz:300; % ?? 50
    para.sbin = 75 : para.sbinsz : 300; % 275
    
    para.timecourse_xlabel = 'Time from probe onset(ms)';
elseif para.timeFlag == 2
    para.RFtime = 'pRF';
    % alignment flag, 1 is probe onset and 2 is saccade offset.
    if para.alignFlag == 1 
        para.tP = 3;
        para.align = 'probeon';
        para.timecourse_xlabel = 'Time from probe onset(ms)';
        para.bin = 75:para.binsz:300; % ?? 50
        para.sbin = 75 : para.sbinsz : 300; % 275
    elseif para.alignFlag == 2
        para.tP = 8;
        para.align = 'sacoff';
        para.timecourse_xlabel = 'Time from saccade offset(ms)';
        para.bin = -125:para.binsz:200;
        para.sbin = -125 : para.sbinsz : 200;
    elseif para.alignFlag == 3
        para.tP = 5;
        para.align = 'sacon';
        para.timecourse_xlabel = 'Time from saccade onset(ms)';
        para.bin = 0:para.binsz:260; %-100 
        para.sbin = 0:para.sbinsz:400; %225
    elseif para.alignFlag == 4
        %para.alignFlag == 4;
        para.tP = 5;
        para.align = 'sacon';
        para.timecourse_xlabel = 'Time from saccade onset(ms)';
        %para.binsz = 50;
        para.bin = 0:para.binsz:400; %-100 
         para.sbin = 0:para.binsz:400; %225
        
    else
        error('Invalid alignment flag')
    end
else
    error('Invalid timeFlag');
end

%para.bin = para.bin-12.5;
para.results_root = [running_root, 'results',para.version,'/'];
%para.heatmap_root = [para.results_root,'heatmap/',para.align,'/', para.brain,'/',para.RFtime,'/'];

para.heatmap_root = [para.results_root,para.brain,'/',para.align,'/','heatmap/'];

%% Spike counts to firing rates conversion factors
para.nSpk2fr = 1000/(para.bin(2)-para.bin(1)); 
para.nSpk2fr_probe = 1000/(para.post_probe-para.pre_probe);
para.nSpk2fr_sac = 1000/(para.post_sac-para.pre_sac);
para.nSpk2fr_sacon = 1000/(para.post_sacon-para.pre_sacon);
para.nSpk2fr_bsl = 1000/(para.bsl_end -para.bsl_start);

%% number of time bins in time course figure.
para.max_T = length(para.bin);
para.expanAngle = [-10,10]; % 0,0
para.splitRatio = 0.5;
para.bin2rf = para.nSpk2fr;
end