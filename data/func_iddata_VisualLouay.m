function [ iden_data, time ] = func_iddata_model_two_points_visual_Louay( data_adapter, vehicle_model_data_mat_file )
%UNTITLED Summary of this function goes here
    load(vehicle_model_data_mat_file, 'C_f0', 'C_r0', 'D_far', 'mu_friction', 'l_f', 'l_r', 'l_s', 'm', 'J', 'R_s', 'eta_t', 'K_m');
%   Detailed explanation goes here
    % # Inputs
    % 1 theta_far
    N_avance_points = round(D_far / mean(data_adapter.speed_x)*data_adapter.fs);
    N_retard_points = 2*data_adapter.fs - N_avance_points;
    N_total_points  = data_adapter.N_data_points;
    road_curvature_previewed_by_D_far = zeros(N_total_points, 1);
    road_curvature_previewed_by_D_far(1:N_total_points - N_avance_points) = data_adapter.road_curvature(N_avance_points+1:N_total_points);
    road_curvature_previewed_by_D_far(N_total_points - N_avance_points + 1 : end) = data_adapter.road_curvature_previewed(N_total_points - N_avance_points + 1 - N_retard_points : end - N_retard_points);
    theta_far = D_far * road_curvature_previewed_by_D_far;
    % 2 theta_near
    theta_near = -data_adapter.lateral_error_at_distance / l_s;
    % Measured Input Vector, iddata needs row vector
    u_measured = [      theta_far,...
                        theta_near,     ];
    % # Outputs
    % 1 delta_SW
    delta_SW = data_adapter.steering_wheel_angle_rad;
    % Measured Output Vector, iddata needs row vector
    y_measured = [      delta_SW      ];
    % # Others
    % 1 time
    time = data_adapter.time;
    Ts = time(2) - time(1);
    
    iden_data = iddata(y_measured, u_measured, Ts, 'Tstart', time(1));
end

