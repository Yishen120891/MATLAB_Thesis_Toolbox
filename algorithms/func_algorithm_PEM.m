function [ param, sys ] = func_algorithm_PEM( model_obj, iden_data )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
   
    iden_model = idgrey(@model_obj.model, model_obj.param_init_value, 'd', {}, iden_data.Ts);

    iden_model.Structure.Parameters(:).Free         = model_obj.param_free_state;
    
    iden_option = greyestOptions;
        % Show estimation process
        iden_option.Display = 'on';
        % Focus on prediction error
        iden_option.Focus   = 'prediction';
        % Disturbace model is not identified (no matrix K)
        iden_option.DisturbanceModel = 'auto';
        % The initial state is treated as an independent estimation parameter.
        iden_option.InitialState = 'estimate';
        % Minimize trace(E'*E/N) instead of det(E'*E/N)
        iden_option.OutputWeight = eye(model_obj.N_output);
        % Maximum number of iterations during loss-function minimization
        iden_option.SearchOption.MaxIter = 200;
        % Minimum percentage difference between the current value of the loss function and its expected improvement after the next iteration
        iden_option.SearchOption.Tolerance = 1e-10;
    
    iden_sys = greyest(iden_data, iden_model, iden_option);
    iden_param = getpvec(iden_sys);
    
    param = iden_param;
    sys = iden_sys;

end

