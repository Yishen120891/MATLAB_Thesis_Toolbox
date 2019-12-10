classdef TwoPointsVisualModelLouay < IdentificationGreyBoxModel
    
    properties (Constant)
        N_state     = 2
        N_input     = 2
        N_output    = 1
        N_param     = 6
        param_name = {'K_p', 'K_c', 'T_I', 'T_L', 'tau_p', 'v'}        
    end

    properties (Access = public)
        param_nominal_value = [3.4 15 1 3 0.04 18]
    end
    
    methods
        function obj = TwoPointsVisualModelLouay( param_init_value, param_free_state, fs)
            obj = obj@IdentificationGreyBoxModel(param_init_value, param_free_state, fs);
        end
        function [ A, B, C, D ] = model( obj, param, Ts )
            A = zeros(obj.N_state, obj.N_state);
            B = zeros(obj.N_state, obj.N_input);
            C = zeros(obj.N_output,obj.N_state);
            D = zeros(obj.N_output,obj.N_input);

            param_cell = num2cell(param);
            [K_p, K_c, T_I, T_L, tau_p, v] = param_cell{:};
            
            A(1,1) = -1/T_I;
            A(2,1) = -2/tau_p*(K_c/v)*(T_L/T_I-1);
            A(2,2) = -2/tau_p;
            B(1,2) = 1/T_I;
            B(2,1) = 2/tau_p*K_p;
            B(2,2) = 2/tau_p*(K_c/v)*(T_L/T_I);
            C(1,1) = K_c/v*(T_L/T_I-1);
            C(1,2) = 2;
            D(1,1) = -K_p;
            D(1,2) = -K_c/v*T_L/T_I;

            % Discretization
            if Ts > 0
                A = eye(size(A)) + A*Ts;
                B = B*Ts;
            end
        end
    end
    
end

