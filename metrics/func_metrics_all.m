function [ metrics_all ] = func_metrics_all( data_access_interface, indice_span )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    if nargin == 2
        data = data_access_interface.select_indices(indice_span);
    else
        data = data_access_interface;
    end

    time        = data.time;
    delta_d_deg = rad2deg(data.steering_wheel_angle_rad);
    psi_L       = rad2deg(data.heading_relative_rad);
    y_a         = data.lateral_error;
    rho         = data.road_curvature;
    TLCP        = data.time_to_lane_crossing_path;
    Gamma_d     = data.driver_torque;
    
    
    metrics_all.steering_wheel_angle            = func_metrics_steering_wheel_angle(time, delta_d_deg);
    metrics_all.steering_wheel_angle_filtered   = func_metrics_steering_wheel_angle_filtered(time, delta_d_deg);
%     metrics_all.SRR01                           = func_metrics_steering_wheel_reversal_rate_Markkula(time, delta_d_deg, 0.1);
%     metrics_all.SRR05                           = func_metrics_steering_wheel_reversal_rate_Markkula(time, delta_d_deg, 0.5);
%     metrics_all.SRR2                            = func_metrics_steering_wheel_reversal_rate_Markkula(time, delta_d_deg, 2);
%     metrics_all.SRR3                            = func_metrics_steering_wheel_reversal_rate_Markkula(time, delta_d_deg, 3);
%     metrics_all.SRR4                            = func_metrics_steering_wheel_reversal_rate_Markkula(time, delta_d_deg, 4);    
%     metrics_all.SRR5                            = func_metrics_steering_wheel_reversal_rate_Markkula(time, delta_d_deg, 5);
%     metrics_all.SRR10                           = func_metrics_steering_wheel_reversal_rate_Markkula(time, delta_d_deg, 10);
    metrics_all.SRR01                           = func_metrics_steering_wheel_reversal_rate(time, delta_d_deg, 0.1);
    metrics_all.SRR05                           = func_metrics_steering_wheel_reversal_rate(time, delta_d_deg, 0.5);
    metrics_all.SRR2                            = func_metrics_steering_wheel_reversal_rate(time, delta_d_deg, 2);
    metrics_all.SRR3                            = func_metrics_steering_wheel_reversal_rate(time, delta_d_deg, 3);
    metrics_all.SRR4                            = func_metrics_steering_wheel_reversal_rate(time, delta_d_deg, 4);    
    metrics_all.SRR5                            = func_metrics_steering_wheel_reversal_rate(time, delta_d_deg, 5);
    metrics_all.SRR10                           = func_metrics_steering_wheel_reversal_rate(time, delta_d_deg, 10);
    metrics_all.lateral_error                   = func_metrics_lateral_error(time, y_a, rho);
    metrics_all.TLCP                            = func_metrics_TLCP(time, TLCP);
    metrics_all.torque                          = func_metrics_driver_torque(time, Gamma_d);
    metrics_all.torque_abs                      = func_metrics_driver_torque_abs(time, Gamma_d);
    metrics_all.psi_L                           = func_metrics_relative_cap_angle(time, psi_L);
    metrics_all.psi_L_abs                       = func_metrics_relative_cap_angle_abs(time, psi_L);
    
end