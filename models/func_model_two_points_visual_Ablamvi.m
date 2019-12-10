function [ A, B, C, D ] = func_model_two_points_visual_Ablamvi( K_p, K_c, T_I, tau_p, v, Ts )
%func_model_driver_Ablamvi Driver model in Ablamvi Ameoye's thesis (see Equation 2.16 in page 33). 
%   The driver model is described in state-space representation with:
%   System inputs:      [Theta_far; Theta_near; delta_d; Gamma_s]
%   System outputs:     [Gamma_d; delta_SW]
%   System parameters:  [K_p K_c T_I tau_p K_r K_t T_N v]
% -------------------------------------------------------------------------------
%   Function Inputs:
%       K_p:        visual anticipation gain
%       K_c:        visual compensation gain
%       T_I:        compensation time constant (band)
%       tau_p:      processing delay   
%       K_r:        steering column stiffness internal gain
%       K_t:        stretch reflex gain
%       T_N:        neuromuscular time constant
%       v:          vehicle velocity
%       Ts:         sample time, set to 0 if model is continuous-time
%           
%   Function Outputs:
%       [ A, B, C, D ]: system matrices
%
%   Dicretization method: 
%       Euler
% -------------------------------------------------------------------------------
%   Orignial code of Ablamvi, modified by Yishen on 26/09/2018
%   Orignial function: [ A, B, C, D, K, x0 ] = Driver_Model_Sans_TL( param, T, delta_t )
%   K and x0 are not necessary in this case.
%   Pay attention to the order of inputs and outputs in identification data
%
%   Additional Remark from Ablamvi: retard:padé d'ordre 1

    %% Model
    
    N_states = 2;
    N_inputs = 2;
    N_outputs = 1;
    
    A = zeros(N_states, N_states);
    B = zeros(N_states, N_inputs);
    C = zeros(N_outputs, N_states);
    D = zeros(N_outputs, N_inputs);
    
    A(1, 1) = -1/T_I;
    A(2, 1) = 1/tau_p;
    A(2, 2) = -1/tau_p;

    B(1, 2) = K_c/v*(1/T_I);
    B(2, 1) = 1/tau_p*K_p;
    
    C(1, 2) = 1;

    %% Discretization by Euler approximation
    if Ts > 0
        A = eye(size(A)) + A*Ts;
        B = B*Ts;
    end
end

