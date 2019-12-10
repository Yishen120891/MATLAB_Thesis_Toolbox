function [ options_UKF ] = func_options_UKF( param_names, param_values, param_free, start_time, end_time, output_scale )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    
    options_UKF.Parameters.Names    = param_names;
    options_UKF.Parameters.Values   = param_values;
    options_UKF.Parameters.Free     = param_free;
    options_UKF.StartTime           = start_time;
    options_UKF.EndTime             = end_time;
    options_UKF.output_scale        = output_scale;

end

