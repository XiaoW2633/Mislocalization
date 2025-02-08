function output = vec2angle(vecs,para)
%% vec2angle:  calculate the angles of the vectors w.r.t the nomalized direction (rightward saccade);
%% input: vecs, crf to fixation,frf,prf/drf and target vectors.
%%        para, parameters.
%% output:  angles and magnitudes of input vectors.
%% atan2:Four quadrant inverse tangent. -pi <= atan2(Y,X) <= pi.(radians) 
output.crf2fpAngle = atan2(vecs(:,para.CRF2FP+1),vecs(:,para.CRF2FP)); %% crf to fixation angle 
output.crf2frfAngle = atan2(vecs(:,para.CRF2FRF+1),vecs(:,para.CRF2FRF)); %% crf to frf angle
output.crf2prfAngle = atan2(vecs(:,para.CRF2PRF+1),vecs(:,para.CRF2PRF)); %% crf to prf/drf angle
output.crf2tgAngle  = atan2(vecs(:,para.CRF2TG+1),vecs(:,para.CRF2TG));   %%  crf to target angle

%% magnitude of these vectors;
output.crf2fpMag    = sqrt(vecs(:,para.CRF2FP+1).^2 + vecs(:,para.CRF2FP).^2 );
output.crf2frfMag    = sqrt(vecs(:,para.CRF2FRF+1).^2 + vecs(:,para.CRF2FRF).^2 );
output.crf2prfMag    = sqrt(vecs(:,para.CRF2PRF+1).^2 + vecs(:,para.CRF2PRF).^2 );
output.crf2tgMag    = sqrt(vecs(:,para.CRF2TG+1).^2 + vecs(:,para.CRF2TG).^2 );


end