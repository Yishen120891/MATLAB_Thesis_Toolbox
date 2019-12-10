function [ metrics_relative_cap_angle ] = func_metrics_relative_cap_angle( time, psi_L_degree )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    % Mean and std of steering wheel angle
    metrics_relative_cap_angle.mean = mean(psi_L_degree);
    metrics_relative_cap_angle.std = std(psi_L_degree);
        
end


