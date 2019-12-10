function [ u_measured, y_measured, time ] = func_iddata_model_driver_Louay( raw_data_selector, vehicle_model_data_mat_file )
%UNTITLED Summary of this function goes here
    load(vehicle_model_data_mat_file, 'C_f0', 'C_r0', 'D_far', 'mu_friction', 'l_f', 'l_r', 'l_s', 'm', 'J', 'R_s', 'eta_t', 'K_m');
%   Detailed explanation goes here
    % # Inputs
    % 1 theta_far
    theta_far = D_far * raw_data_selector.road_curvature_previewed;
    % 2 theta_near
    theta_near = -raw_data_selector.lateral_error_at_distance / l_s;
    % 3 delta_d
    delta_d = raw_data_selector.steering_wheel_angle_rad;
    % 4 Gamma_s
    T_sbeta = 2*K_m*C_f0*mu_friction*eta_t/R_s;
    beta    = raw_data_selector.drift_angle_rad;
    r       = raw_data_selector.yaw_rate_rad;
    v_x     = raw_data_selector.speed_x;
    delta_f = raw_data_selector.steering_wheel_angle_rad / R_s;
    Gamma_s = -T_sbeta*(beta + l_f*r./v_x - delta_f);
    % Measured Input Vector
    u_measured = [      theta_far,...
                        theta_near,...
                        delta_d,...
                        Gamma_s         ]';
    % # Outputs
    % 1 Gamma_d
    Gamma_d = raw_data_selector.driver_torque;
    % 2 delta_SW
    delta_SW = raw_data_selector.steering_wheel_angle_rad;
    % Measured Output Vector
    y_measured = [      Gamma_d, ...
                        delta_SW      ]';
    % # Others
    % 1 time
    time = raw_data_selector.time;
end

