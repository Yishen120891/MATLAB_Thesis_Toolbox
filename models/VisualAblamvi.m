classdef VisualAblamvi < IdentificationGreyBoxModel
    
    properties (Constant)
        N_state     = 2
        N_input     = 2
        N_output    = 1
        N_param     = 5
        param_name = {'K_p', 'K_c', 'T_I', 'tau_p', 'v'}        
    end

    properties (Access = public)
        param_nominal_value = [3.4 15 1 3 0.04 18]
    end
    
    methods
        function obj = VisualAblamvi( Ts, varargin )
            obj = obj@IdentificationGreyBoxModel(Ts, varargin);
        end
        function [ A, B, C, D ] = model( obj, param, Ts )
            A = zeros(obj.N_state, obj.N_state);
            B = zeros(obj.N_state, obj.N_input);
            C = zeros(obj.N_output,obj.N_state);
            D = zeros(obj.N_output,obj.N_input);

            param_cell = num2cell(param);
            [K_p, K_c, T_I, tau_p, v] = param_cell{:};
            
            A(1,1) = -1/T_I;
            A(2,1) = 1/tau_p;
            A(2,2) = -1/tau_p;
            B(1,2) = K_c/v*(1/T_I);
            B(2,1) = 1/tau_p*K_p;
            C(1,2) = 1;

            % Discretization
            if Ts > 0
                A = eye(size(A)) + A*Ts;
                B = B*Ts;
            end
        end
    end
    
end

