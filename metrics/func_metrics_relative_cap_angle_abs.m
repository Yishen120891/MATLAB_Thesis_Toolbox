function [ metrics_relative_cap_angle_abs ] = func_metrics_relative_cap_angle_abs( time, psi_L_degree )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    % Mean and std of steering wheel angle
    metrics_relative_cap_angle_abs.mean = mean(abs(psi_L_degree));
    metrics_relative_cap_angle_abs.std = std(abs(psi_L_degree));
        
end


