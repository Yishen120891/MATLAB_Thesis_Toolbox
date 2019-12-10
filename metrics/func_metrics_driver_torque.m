function [ metrics_humain_driver_torque ] = func_metrics_driver_torque( time, torque )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    % Mean and std of steering wheel angle
    metrics_humain_driver_torque.mean = mean(torque);
    metrics_humain_driver_torque.std = std(torque);
    metrics_humain_driver_torque.energy = norm(torque);
    
end


