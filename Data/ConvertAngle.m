function [output,towards_flag,hoz_flag]  =  ConvertAngle(P,crfCenter,frfCenter,prfCenter,sacAmp,sacDirec)
%% ConvertAngle : Align saccade direction to rightward.
%% input : 
%%         P     : parameters
%%         crfCenter: crf xy center
%%         frfCenter: frf xy center
%%         prfCenter: prf/drf xy center
%%         sac_amp /sacAmp     : designed saccade amplitude (degree)
%%         sacDirec / %sacDirec   : designed saccade direction ,0: right; 1: left; 2:up; 3:down;
%% output:X
% % output(1) fixation to crf center x
% % output(2) fixation to crf center y
% % output(3) crf to frf center x
% % output(4) crf to frf center y
% % output(5) crf to prf/drf center x
% % output(6) crf to prf/drf center y
% % output(7) crf to target center x
% % output(8) crf to target center y
%   towards_flag: flag for toward or away saccade, 1: toward saccade, 0: away saccade.
fp=P.fixLoc; %% fixation (x,y)
tg=P.tarLoc; %% target   (x,y)
displacement = abs(tg-fp);
if displacement(1) < 1
    hoz_flag = 1;
else
    hoz_flag = 0;
end

%% vectors before rotation  Are these row vectors ??
crf2fp  = fp-crfCenter;%% crf to fixation vector
crf2tg  = tg-crfCenter;%% crf   to target vector
crf2frf = frfCenter-crfCenter;%%  crf to frf vector
crf2prf = prfCenter-crfCenter;%%  crf to  prf/drf vector
centers_vec = [crf2fp;crf2frf;crf2prf;crf2tg]';%% Combine the centers for rotation operation;

%% method:
%% Rotation matrix
%% [cos(t),-sin(t);sin(t),cos(t)]*[x;y]
%% counterclockwise t (radians) of vector (x,y);
%% centers_vec = [crf2fp;crf2frf;crf2prf]';
%% centers_vec = rotationMatrix * centers_vec;
%% after rotation, if the crf below the fp, reverse the y components.
%%  centers_vec(2,:) =-centers_vec(2,:);

% no saccade in an oblique direction ??
%rotationAngle=[0,pi,3*pi/2,pi/2];
%% use the saccade direction as the index of rotation angle.
%theta = rotationAngle(sacDirec+1);
theta = sacDirec;
rotationMatrix = [cos(theta),-sin(theta);sin(theta),cos(theta)];
%% rotate the vectors.
centers_vec = rotationMatrix*centers_vec;
% if the crf below the fixation, flip the y components.
% We always put the center of crf above the fixation
if  centers_vec(2,1) > 0
    centers_vec(2,:) =-centers_vec(2,:);
    
end
if centers_vec(1,1)<0
    towards_flag = 1;
else
    towards_flag = 0;
end
output = reshape(centers_vec,1,numel(centers_vec));
%% align the saccade rigthward and put the crf center on the top of fixation.


% switch sacDirec
%     case 0
%         %% rightward saccade,rotation matrix:[1,0;0,1];
%         rotationMatrix = [1,0;0,1];
%         centers_vec = rotationMatrix*centers_vec;
%        
%         
%     case 1
%          %% left saccade, counterclockwise rotated by pi rotation matrix:[-1,0;0,-1];
%         rotationMatrix = [-1,0;0,-1];
%        
%         centers_vec =   rotationMatrix*centers_vec;
%      
%         
%         
%     case 3
%         %% downward  saccade. counterclockwise rotated by pi/2 rotation matrix:[0,-1;1,0];
%         rotationMatrix = [0,-1;1,0];
%         centers_vec =   rotationMatrix*centers_vec;
%     
%     case 2
%         %% upward saccade. counterclockwise rotation by 3*pi/2 : rotation matrix:[0,1;-1,0];
%         
%         rotationMatrix = [0,1;-1,0];
%         centers_vec =   rotationMatrix*centers_vec;
% 
% end




end

