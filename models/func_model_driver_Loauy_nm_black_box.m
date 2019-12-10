function [ A, B, C, D ] = func_model_driver_Loauy_nm_black_box( K_p, K_c, T_I, T_L, tau_p, K_r, K_t, T_N, v, Ts )
%func_model_driver_Louay Driver model in Louay Saleh's thesis (see Equation 4.2 in page 41. Attention ! Errors found in original version) 
% with neuromuscular system modified (no more correlation between delta_SW and delta_d). 
%   The driver model is described in state-space representation with:
%   System inputs:      [Theta_far; Theta_near; delta_d; Gamma_s]
%   System outputs:     [Gamma_d; delta_SW]
%   System parameters:  [K_p K_c T_I T_L tau_p K_r K_t T_N v]
% -------------------------------------------------------------------------------
%   Function Inputs:
%       K_p:        visual anticipation gain
%       K_c:        visual compensation gain
%       T_I:        compensation time constant (band)
%       T_L:        compensation time constant (friction)
%       tau_p:      processing delay   
%       K_r:        steering column stiffness internal gain
%       K_t:        stretch reflex gain
%       T_N:        neuromuscular time constant
%       v:          vehicle velocity
%       Ts:         sample time
%           
%
%   Function Outputs:
%       [ A, B, C, D ]: system state-space representation matrices
%
%   Dicretization method: 
%       Euler
% -------------------------------------------------------------------------------
%   Orignial code from file "func_model_driver_Louay.m", modified by Yishen on 07/08/2019
%   Pay attention to the order of inputs and outputs in identification data


    %% Model

    N_states = 3;
    N_inputs = 4;
    N_outputs = 2;
    
    A = zeros(N_states, N_states);
    B = zeros(N_inputs, N_states);
    C = zeros(N_outputs, N_states);
    D = zeros(N_outputs, N_inputs);

    A(1,1)  = -1/T_I;
    A(2,1)  = -2*(1/tau_p)*(K_c/v)*(T_L/T_I -1);
    A(2,2)  = -2*(1/tau_p);
    % Modified element
    % A(3,1)  = 1/T_N*(K_r*v+K_t)*(K_c/v)*(T_L/T_I-1);
    A(3,1)  = 1/T_N*(K_r*v)*(K_c/v)*(T_L/T_I-1);
    % Modified element
    % A(3,2)  = 1/T_N*2*(K_r*v+K_t);
    A(3,2)  = 1/T_N*2*(K_r*v);
    A(3,3)  = -1/T_N;

    B(1,2)  = 1/T_I;
    B(2,1)  = 2*(1/tau_p)*K_p;
    B(2,2)  = 2*(1/tau_p)*(K_c/v)*(T_L/T_I);
    % Modified element
    % B(3,1)  = -1/T_N*(K_r*v+K_t)*K_p;
    B(3,1)  = -1/T_N*(K_r*v)*K_p;
    % Modified element
    % B(3,2)  = -1/T_N*(K_r*v+K_t)*(K_c/v)*(T_L/T_I);
    B(3,2)  = -1/T_N*(K_r*v)*(K_c/v)*(T_L/T_I);
    B(3,3)  = -1/T_N*K_t;
    B(3,4)  = -1/T_N;

    C(1,3)  = 1;
    C(2,1)  = K_c/v*(T_L/T_I-1);
    C(2,2)  = 2;

    D(2,1)  = -K_p;
    D(2,2)  = -K_c/v*T_L/T_I;

    %% Discretization by Euler approximation
    if Ts > 0
        A       = eye(size(A)) + A*Ts;
        B       = B*Ts;
    end

    % P = inv(2/Ts*eye(3)-A);
    % A = (2/Ts*eye(3)+A)*P;
    % B = 2/Ts*P*B;

end

