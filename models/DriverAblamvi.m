classdef DriverAblamvi < IdentificationGreyBoxModel
    properties (Constant)
        N_state     = 3
        N_input     = 4
        N_output    = 2
        N_param     = 8
        param_name  = {'K_p', 'K_c', 'T_I', 'tau_p', 'K_r', 'K_t', 'T_I', 'v'}
    end
    
    properties (Access = public)
        param_nominal_value = [3.4 15 1 0.04 1 12 0.1 18]
    end
    
    methods
        function obj = DriverAblamvi( Ts, varargin )
            obj = obj@IdentificationGreyBoxModel(Ts, varargin);
        end
        function [A, B, C, D] = model( obj, param, Ts )
            A = zeros(obj.N_state, obj.N_state);
            B = zeros(obj.N_state, obj.N_input);
            C = zeros(obj.N_output,obj.N_state);
            D = zeros(obj.N_output,obj.N_input);
            
            param_cell = num2cell(param);
            [K_p, K_c, T_I, tau_p, K_r, K_t, T_N, v] = param_cell{:};

            A(1, 1) = -1/T_I;
            A(2, 1) = 1/tau_p;
            A(2, 2) = -1/tau_p;
            A(3, 2) = 1/T_N*(K_r*v+K_t);
            A(3, 3) = -1/T_N;

            B(1, 2) = K_c/v*(1/T_I);
            B(2, 1) = 1/tau_p*K_p;
            B(3, 3) = -1/T_N*K_t;
            B(3, 4) = -1/T_N;

            C(1, 3) = 1;
            C(2, 2) = 1;           

            % Discretization by Euler approximation
            if Ts > 0
                A       = eye(size(A)) + A*Ts;
                B       = B*Ts;
            end
        end
    end
end

