function RF = testRF(RF,X,Y)
%RF= early_Rf_sbin;

% if there are nans in RF
if sum(isnan(RF(:)))
    % good indeces
    [rowG,colG,~] = find(~isnan(RF));
    % bad indeces
    [rowB,colB,~] = find(isnan(RF));
    
    indG = sub2ind(size(RF),rowG, colG);
    indB = sub2ind(size(RF),rowB, colB);
    % good coordinates
    XXG = X(indG);
    YYG = Y(indG);
    % bad coordinates
    XXB = X(indB);
    YYB = Y(indB);
    % good values
    rfG = RF(indG);
    
    % interpolate
   % F = scatteredInterpolant(colG, rowG, rfG, 'linear');
    F = scatteredInterpolant(XXG, YYG, rfG, 'natural');
    %Vq = F(colB,rowB);
    Vq = F(XXB,YYB);
    % griddata does not work for nans at corners (considered as
    % extrapolation)
    %Vq = griddata(colG, rowG, rfG, colB, rowB, 'cubic');
    
    % fill in the interpolated values
    for i = 1:length(Vq)
        RF(rowB(i), colB(i)) = Vq(i);
    end
    
    % compare
%     early_Rf_sbin;
%     RF;
end
