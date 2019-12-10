function [ x0, P0, Q, R ] = func_algorithm_tuning_UKF( model_obj, iden_data, coef )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    [A, B, C, D] = model_obj.nominal_model;
    fs = model_obj.fs;
    sys = ss(A, B, C, D, 1/fs);
    N_state = model_obj.N_state;
    N_free_param = model_obj.N_free_param;
    param_free_init_value = model_obj.param_init_value(model_obj.param_free_indice);
    x0 = zeros(model_obj.N_augmented_state, 1);
    x0(N_state +1 : end) = param_free_init_value;
    
    P0 = 1e-8*blkdiag(eye(N_state), 100*eye(N_free_param));
    
%     output_scale = max(iden_data.OutputData);
%     R = 1e-2*diag(diag((output_scale*output_scale')));
%     R = eye(model_obj.N_output);
    R = 25e-4;
    
    To = 100;
    gramian_option = gramOptions('TimeIntervals', [0 To*fs]);
    dWo = gram(sys, 'o', gramian_option);

    Qx = 1e-7*inv(dWo);
%     Qx = 1/To*inv(dWo);
%     Qp = 1e-3*(1/To)*diag(param_free_init_value.^2);
    Qp = coef*diag(param_free_init_value.^2);
    Q = blkdiag(Qx, Qp);
    
end