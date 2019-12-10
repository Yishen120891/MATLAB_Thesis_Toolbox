function [ x_a_estimated, y_estimated, e ] = func_algorithm_Unscented_Kalman_Filter_MATLAB( model_obj, time, u_measured, y_measured, options  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    %% Initialization
    [initialStateGuess, P, Q, R] = func_algorithm_tuning_UKF(func_model, options);
    % Number of steps
    N_steps             = length(time);
    % Order of augmented system
    N_augmented_state   = model_obj.augmented_state;
    % Number of outputs
    N_output            = model_obj.N_output;

    x_a_hat         = zeros(N_augmented_state, N_steps);
    x_a_hat(:,1)    = initialStateGuess;
    y_hat           = zeros(N_output, N_steps);
    Cxx             = zeros(N_augmented_state, N_augmented_state, N_steps);
    Cxx(:,:,1)      = P;
    e               = zeros(N_output, N_steps);

    objUKF = unscentedKalmanFilter(@model_obj.augmented_state_transition,...
                                   @model_obj.augmented_measurement,...
                                   initialStateGuess,...
                                   'HasAdditiveProcessNoise',true,...
                                   'HasAdditiveMeasurementNoise',true);
    objUKF.StateCovariance = P;
    objUKF.ProcessNoise = Q;
    objUKF.MeasurementNoise = R;
    objUKF.Alpha = 1;
    objUKF.Beta = 0;
    
    %% Iteration on each time step
    text_count = 0;
    
    for k = 1 : N_steps
        
        fprintf(repmat('\b', 1, text_count));
        text_count = fprintf('Current data point / Total data points : %d / %d', k, N_steps);     
        % Correct
        y_hat(:,k) = model_obj.augmented_measurement(objUKF.State, u_measured(:,k));
        e(:,k) = y_measured(:,k) - y_hat(:,k);
        [x_a_hat(:,k),Cxx(:,:,k)] = correct(objUKF, y_measured(:,k), u_measured(:,k));
        % Predict
        predict(objUKF, u_measured(:,k));  
    end
    
    fprintf('\n');
    % Outputs estimated states and outputs
    x_a_estimated = x_a_hat;
    y_estimated = y_hat;

end

