function [ A, B, C, D ] = func_model_two_points_visual_Louay_simplified_delay( K_p, K_c, T_I, T_L, tau_p, v, Ts )

    %% Model
    N_states = 2;
    N_inputs = 2;
    N_outputs = 1;

    A = zeros(N_states, N_states);
    B = zeros(N_states, N_inputs);
    C = zeros(N_outputs, N_states);
    D = zeros(N_outputs, N_inputs);
    
    A(1,1) = -1/T_I;
    A(1,2) = 1/tau_p*K_c/v*(T_L/T_I-1);
    
    B(1,2) = 1/T_I;
    
    C(1,1) = K_c/v*(T_L/T_I-1);
    
    D(1,1) = K_p;
    D(1,2) = K_c/v*T_L/T_I;
    
    %% Discretization
    if Ts > 0
        A = eye(size(A)) + A*Ts;
        B = B*Ts;
    end
end

