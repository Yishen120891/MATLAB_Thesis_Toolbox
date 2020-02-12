classdef (Abstract) IdentificationGreyBoxModel < handle
   
    properties (Abstract, Constant)
        N_state
        N_input
        N_output
        N_param
        param_name
    end
    
    properties (Dependent)
        N_free_param
        N_augmented_state
    end
    
    methods
        function value = get.N_free_param( obj )
            value = sum(obj.param_free_state);
        end
        function value = get.N_augmented_state( obj )
            value = obj.N_state + obj.N_free_param;
        end
    end
    
    properties (Abstract)
        param_nominal_value
    end
    
    properties
        param_init_value
        param_minimum
        param_maximum
        Ts
    end
    
    properties (SetObservable)
        param_free_state    
    end
    
    properties
        param_free_indice
    end
    
    methods (Access = protected)
        function change_param_free_indice ( obj, ~, ~ )
            obj.param_free_indice = find(obj.param_free_state == 1);
        end
    end
    
    methods (Abstract)
        [A, B, C, D] = model( obj, param, Ts )
    end
    
    methods (Sealed)
        function [A, B, C, D] = init_model( obj )
            [A, B, C, D] = model(obj, obj.param_init_value, obj.Ts);
        end
        function [A, B, C, D] = nominal_model( obj )
            [A, B, C, D] = model(obj, obj.param_nominal_value, obj.Ts);
        end
        function [A, B, C, D] = augmented_model( obj, x_a )
            param = obj.param_init_value;
            param(obj.param_free_indice) = x_a(obj.N_state+1:end);
            [A, B, C, D] = model( obj, param, obj.Ts );
        end
        function x_a_dot = augmented_model_state_transition( obj, x_a, u )
            [A, B, ~, ~] = obj.augmented_model( x_a );
            x_a_dot = x_a;
            x_a_dot(1:obj.N_state) = A*x_a(1:obj.N_state) + B*u(1:obj.N_state);
        end
        function y = augmented_model_measurement( obj, x_a, u )
            [~, ~, C, D] = obj.augmented_model( x_a );
            y = C*x_a(1:obj.N_state) + D*u;
        end
    end
    methods
        function obj = IdentificationGreyBoxModel( Ts, varargin )
            addlistener(obj, 'param_free_state', 'PostSet', @obj.change_param_free_indice);
            inParser = inputParser;
            inParser.addRequired('Ts', @isnumeric);
            inParser.addParameter('InitValue', obj.param_nominal_value);
            inParser.addParameter('FreeState', true(1, obj.N_param));
            inParser.addParameter('Min', -Inf(1, obj.N_param));
            inParser.addParameter('Max', Inf(1, obj.N_param));
            inParser.parse(Ts, varargin{:}{:});
            obj.Ts = inParser.Results.Ts;
            obj.param_init_value = inParser.Results.InitValue;
            obj.param_free_state = inParser.Results.FreeState;
            obj.param_minimum    = inParser.Results.Min;
            obj.param_maximum    = inParser.Results.Max;
        end
    end
end
