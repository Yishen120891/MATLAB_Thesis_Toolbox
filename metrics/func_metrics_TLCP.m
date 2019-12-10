function [ metrics_TLCP ] = func_metrics_TLCP( time, TLCP )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    %% Lane keeping metrics
    % Time to Lane Crossing Path (TLCP)
    
    % Handle exception values
    Max_TLCP = max(TLCP);
    TLCP(TLCP == -99000) = Max_TLCP;

    metrics_TLCP.mean       = mean(TLCP);
    metrics_TLCP.std        = std(TLCP);
    metrics_TLCP.median     = median(TLCP);

end

