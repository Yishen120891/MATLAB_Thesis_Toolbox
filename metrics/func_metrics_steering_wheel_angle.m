function [ metrics_steering_wheel_angle ] = func_metrics_steering_wheel_angle( time, delta_d_degree )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    % Mean and std of steering wheel angle
    metrics_steering_wheel_angle.mean = mean(delta_d_degree);
    metrics_steering_wheel_angle.std = std(delta_d_degree);
        
end


