function [ options_PEM ] = func_options_PEM( param_names, param_values, param_free, start_time, end_time )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    
    options_PEM.Parameters.Names    = param_names;
    options_PEM.Parameters.Values   = param_values;
    options_PEM.Parameters.Free     = param_free;
    options_PEM.StartTime           = start_time;
    options_PEM.EndTime             = end_time;

end

