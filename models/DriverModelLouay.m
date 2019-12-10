classdef DriverModelLouay < IdentificationGreyBoxModel
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        N_state     = 3
        N_input     = 4
        N_output    = 2
        N_param     = 9
        param_name  = {'K_p', 'K_c', 'T_I', 'T_L', 'tau_p', 'K_r', 'K_t', 'T_I', 'v'}
    end
    
    properties (Access = public)
        param_nominal_value = [3.4 15 1 3 0.04 1 12 0.1 18]
    end
    
    methods
        function obj = DriverModelLouay( param_init_value, param_free_state, fs)
            obj = obj@IdentificationGreyBoxModel(param_init_value, param_free_state, fs);
        end
        function [A, B, C, D] = model( obj, param, Ts )
            A = zeros(obj.N_state, obj.N_state);
            B = zeros(obj.N_state, obj.N_input);
            C = zeros(obj.N_output,obj.N_state);
            D = zeros(obj.N_output,obj.N_input);
            
            param_cell = num2cell(param);
            [K_p, K_c, T_I, T_L, tau_p, K_r, K_t, T_N, v] = param_cell{:};

            A(1,1)  = -1/T_I;
            A(2,1)  = -2*(1/tau_p)*(K_c/v)*(T_L/T_I -1);
            A(2,2)  = -2*(1/tau_p);
            A(3,1)  = 1/T_N*(K_r*v+K_t)*(K_c/v)*(T_L/T_I-1);
            A(3,2)  = 1/T_N*2*(K_r*v+K_t);
            A(3,3)  = -1/T_N;
            B(1,2)  = 1/T_I;
            B(2,1)  = 2*(1/tau_p)*K_p;
            B(2,2)  = 2*(1/tau_p)*(K_c/v)*(T_L/T_I);
            B(3,1)  = -1/T_N*(K_r*v+K_t)*K_p;
            B(3,2)  = -1/T_N*(K_r*v+K_t)*(K_c/v)*(T_L/T_I);
            B(3,3)  = -1/T_N*K_t;
            B(3,4)  = -1/T_N;
            C(1,3)  = 1;
            C(2,1)  = K_c/v*(T_L/T_I-1);
            C(2,2)  = 2;
            D(2,1)  = -K_p;
            D(2,2)  = -K_c/v*T_L/T_I;
            
            % Original model in thesis of Louay, correct if the input theta_far is not inversed
            % A(1,1)  = -1/T_I;
            % A(2,1)  = 2*(1/tau_p)*(K_c/v)*(T_L/T_I -1);
            % A(2,2)  = -2*(1/tau_p);
            % A(3,1)  = -1/T_N*(K_r*v+K_t)*(K_c/v)*(T_L/T_I-1);
            % A(3,2)  = 1/T_N*2*(K_r*v+K_t);
            % A(3,3)  = -1/T_N;
            % B(1,2)  = 1/T_I;
            % B(2,1)  = 2*(1/tau_p)*K_p;            
            % B(2,2)  = -2*(1/tau_p)*(K_c/v)*(T_L/T_I);
            % B(3,1)  = -1/T_N*(K_r*v+K_t)*K_p;
            % B(3,2)  = 1/T_N*(K_r*v+K_t)*(K_c/v)*(T_L/T_I);
            % B(3,3)  = -1/T_N*K_t;
            % B(3,4)  = -1/T_N;
            % C(1,3)  = 1;
            % C(2,1)  = -K_c/v*(T_L/T_I-1);
            % C(2,2)  = 2;
            % D(2,1)  = -K_p;
            % D(2,2)  = K_c/v*T_L/T_I;
            

            % Discretization by Euler approximation
            if Ts > 0
                A       = eye(size(A)) + A*Ts;
                B       = B*Ts;
            end
        end
    end
end

