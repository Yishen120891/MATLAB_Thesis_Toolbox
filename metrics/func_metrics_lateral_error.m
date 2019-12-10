function [ metrics_y_a ] = func_metrics_lateral_error( time, y_a, rho )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    
    %% Lane keeping metrics
    % Lateral error
    metrics_y_a.std     = std(y_a);
    % For mean, the sign of y_a needs to be inversed
    % Remind: y_a < 0 when on right side of lane center;
    %         y_a > 0 when on left side of lane center;
    %         rho < 0 when right turn;
    %         rho > 0 when left turn;
    % Humain cut curve, thus y_a < 0 when rho < 0;
    %                        y_a > 0 when rho > 0;
    % Here we inverse right turns so that y_a > 0 when rho < 0;
    y_a_adjusted = y_a;
    y_a_adjusted(rho < 0) = -y_a_adjusted(rho < 0);
    metrics_y_a.mean    = mean(y_a_adjusted);
    metrics_y_a.SALP    = sum(abs(y_a(rho ~= 0)));

end