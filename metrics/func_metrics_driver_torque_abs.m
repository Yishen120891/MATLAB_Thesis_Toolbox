function [ metrics_humain_driver_torque_abs ] = func_metrics_driver_torque_abs( time, torque )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    % Mean and std of steering wheel angle
    metrics_humain_driver_torque_abs.mean = mean(abs(torque));
    metrics_humain_driver_torque_abs.std = std(abs(torque));
    
end


