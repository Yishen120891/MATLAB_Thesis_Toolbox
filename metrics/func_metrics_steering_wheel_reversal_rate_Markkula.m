function [ metrics_SRR ] = func_metrics_steering_wheel_reversal_rate_Markkula( time, delta_d_degree, threshold_deg )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    % #1 low pass filtering
    % #2 finding stationary points
    delta_d_point = zeros(size(delta_d_degree));
    delta_d_point(1) = 0;
    delta_d_point(2:end) = diff(delta_d_degree);
    e = union((find(delta_d_point(2:end) == 0))+1, find(abs(diff(sign(delta_d_point))) == 2));
    % #3 finding reversals
    N_upwards   = finding_reversals( delta_d_degree, e, threshold_deg);
    N_downwards = finding_reversals(-delta_d_degree, e, threshold_deg);
    % #4 calculating the reversal rate
    metrics_SRR = (N_upwards + N_downwards) / (time(end) - time(1)) * 60;
end

function N_reversals = finding_reversals(delta_d_degree, stationary_points, threshold_degree)
    e = stationary_points;
    k = 1;
    N_reversals = 0;
    for i = 2 : length(e)
        if delta_d_degree(e(i)) - delta_d_degree(e(k)) >= threshold_degree
            N_reversals = N_reversals + 1;
            k = i;
        else
            if delta_d_degree(e(i)) < delta_d_degree(e(k))
                k = i;
            end
        end
    end
end

