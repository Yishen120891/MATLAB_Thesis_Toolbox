function [ x_a_estimated, y_estimated, e ] = func_algorithm_Unscented_Kalman_Filter_Ablamvi( model_obj, iden_data, coef )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    %% Initialization

    [initialStateGuess, P, Q, R] = func_algorithm_tuning_UKF(model_obj, iden_data, coef);
    u_measured = iden_data.InputData';
    y_measured = iden_data.OutputData';
    N_data = size(iden_data);
    % Number of steps
    N_steps             = N_data(1);
    % Order of augmented system
    N_augmented_state   = model_obj.N_augmented_state;
    % Number of outputs
    N_output            = model_obj.N_output;

    x_a_hat         = zeros(N_augmented_state, N_steps);
    x_a_hat(:,1)    = initialStateGuess;
    y_hat           = zeros(N_output, N_steps);
    Cxx             = zeros(N_augmented_state, N_augmented_state, N_steps);
    Cxx(:,:,1)      = P;
    Cxy             = zeros(N_augmented_state, N_output, N_steps);
    Cyy             = zeros(N_output, N_output, N_steps);
    e               = zeros(N_output, N_steps);

    %% Iteration on each time step
    text_count = 0;
    
    for k = 1 : N_steps
        
        fprintf(repmat('\b', 1, text_count));
        text_count = fprintf('UKF: Current data point / Total data points : %d / %d', k, N_steps);
        
        %% Correct
        [y_hat(:,k), Cyy(:,:,k), Cxy(:,:,k)] = func_algorithm_Unscented_Transformation(x_a_hat(:,k), ...
                                                                                       Cxx(:,:,k), ...
                                                                                       @model_obj.augmented_model_measurement, ...
                                                                                       u_measured(:,k));
        Cyy(:,:,k) = Cyy(:,:,k) + R;

        e(:,k) = y_measured(:,k) - y_hat(:,k);

        %% Enforce system stability
        gain = Cxy(:,:,k)/Cyy(:,:,k); 
        x_a_temp = x_a_hat(:,k);
        factor = 1;
        while true
            x_a_hat(:,k) = x_a_temp + factor*gain*e(:,k);
            A = model_obj.augmented_model(x_a_hat(:,k));
            [~, eigValue] = eig(A);
            if max(abs(diag(eigValue))) <= 1
                break;
            end
            factor = factor /2;
            if factor < 1e-10
                factor = 0;
            end
        end

        Cxx(:,:,k) = Cxx(:,:,k) - factor*factor*gain*Cyy(:,:,k)*gain.';

        %% Predict when not the last time step
        if k ~= N_steps
            [x_a_hat(:,k+1), Cxx(:,:,k+1)] = func_algorithm_Unscented_Transformation(x_a_hat(:,k), ...
                                                                                     Cxx(:,:,k), ...
                                                                                     @model_obj.augmented_model_state_transition, ...
                                                                                     u_measured(:,k));    
            Cxx(:,:,k+1) = Cxx(:,:,k+1) + Q;
        end
       
    end
    
    fprintf('\n');
    %% Outputs estimated states and outputs
    x_a_estimated = x_a_hat;
    y_estimated = y_hat;
    

end

