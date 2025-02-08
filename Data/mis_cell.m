clear; close all;
% Change running_root to your own folder where the code is located. The data will be from, and the anaylysis results
% will be saved to, subfolders named 'data' and 'results', respectively.
running_root = '/Users/wangxiao/Desktop/matlab_code/mis_loc';
addpath(pwd);
cd('/Users/wangxiao/Desktop/matlab_code/mis_loc');
% add paths for lib files
addpath([running_root, 'CircStat2012a/']); % for Mac
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
tot_prf_direc = [];


