function [ time, u_measured, y_measured, fs ] = func_data_identification_two_points_visual_Louay( data_structure )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    time = data_structure.time;
    
    % # Inputs

    % 1 theta_far
    theta_far = 15*data_structure.SCRIPT.PreviewedRoadCurvature;

    % 2 theta_near
    theta_near = data_structure.Assistance.y_L_calculated / 5;

    % 3 Measured Input Vector
    u_measured = [      theta_far,...
                        -theta_near      ]';
%     u_names = {'\theta_{far}', '\theta_{near}'};

    % # Outputs

    % 1 delta_d
    delta_d = data_structure.SHM.VehicleOutput.SteeringWheelAngle;

    % 2 Measured Output Vector
    y_measured = [      delta_d       ]';
%     y_names = {'\Gamma_d', '\delta_{SW}'};

    % # Others

    % 1 Sample frequency
    fs = 1/(time(2)-time(1));

end

