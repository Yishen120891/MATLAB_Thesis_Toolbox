classdef NeuromuscularLouay < IdentificationGreyBoxModel
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        N_state     = 1
        N_input     = 3
        N_output    = 1
        N_param     = 4
        param_name = {'K_r', 'K_t', 'T_N', 'v'}        
    end
    properties (Access = public)
        param_nominal_value = [1 12 0.1 18]
    end
    methods
        function obj = NeuromuscularLouay( Ts, varargin )
            obj = obj@IdentificationGreyBoxModel(Ts, varargin);
        end
        function [ A, B, C, D ] = model( obj, param, Ts )
            A = zeros(obj.N_state, obj.N_state);
            B = zeros(obj.N_state, obj.N_input);
            C = zeros(obj.N_output,obj.N_state);
            D = zeros(obj.N_output,obj.N_input);
            
            param_cell = num2cell(param);
            [K_r, K_t, T_N, v] = param_cell{:};
            
            A(1,1) = -1/T_N;
            B(1,1) = 1/T_N*(K_r*v+K_t);
            B(1,2) = -1/T_N*K_t;
            B(1,3) = -1/T_N;
            C(1,1) = 1;

            % Discretization
            if Ts > 0
                A = eye(size(A)) + A*Ts;
                B = B*Ts;
            end
        end
    end
    
end

