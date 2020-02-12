function [ param, sys ] = func_algorithm_PEM( model_obj, iden_data )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
   
    iden_model = idgrey(@model_obj.model, model_obj.param_init_value, 'cd', {}, model_obj.Ts);
    iden_model.Structure.Parameters(:).Free         = model_obj.param_free_state;
    iden_model.Structure.Parameters(:).Minimum      = model_obj.param_minimum;
    iden_model.Structure.Parameters(:).Maximum      = model_obj.param_maximum;
    
    iden_option = greyestOptions;
        % Show estimation process
        iden_option.Display = 'on';
        % Disturbace model is not identified (no matrix K)
        iden_option.DisturbanceModel = 'none';        
        % Focus on prediction error (default value, for models that have no disturbance
        % model, there is no difference between 'Simulation' and 'Prediction'.)
        iden_option.Focus   = 'prediction';
        % The initial state is treated as an independent estimation parameter.
        iden_option.InitialState = 'estimate';
        % Minimize det(E'*E/N). The difference between the two criteria is meaningful in multiple-output cases only. 
        % In single-output models, the two criteria are equivalent. 
        % Both the Det and Trace criteria are derived from a general requirement of minimizing a weighted sum of squares of prediction errors. 
        % The Det criterion can be interpreted as estimating the covariance matrix of the noise source and using the inverse of that matrix as the weighting. 
        % When using the Trace criterion, you must specify the weighting using the Weighting property. 
        % If you want to achieve better accuracy for a particular channel in multiple-input multiple-output models, 
        % you should use Trace with weighting that favors that channel. Otherwise it is natural to use the Det criterion. 
        % When using Det, you can check cond(model.NoiseVariance) after estimation. If the matrix is ill-conditioned, 
        % it may be more robust to use the Trace criterion.
        iden_option.OutputWeight = 'noise';
        % A combination of the line search algorithms, 'gn', 'lm', 'gna', and 'grad' methods is tried in sequence at each iteration. 
        % The first descent direction leading to a reduction in estimation cost is used.
        iden_option.SearchMethod = 'auto';
        % Maximum number of iterations during loss-function minimization
        iden_option.SearchOption.MaxIter = 200;
        % Minimum percentage difference between the current value of the loss function and its expected improvement after the next iteration
        iden_option.SearchOption.Tolerance = 1e-10;
    
    sys = greyest(iden_data, iden_model, iden_option);
    param = getpvec(sys);
end

