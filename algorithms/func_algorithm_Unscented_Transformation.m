function [ mean_z, Czz, Cxz ] = func_algorithm_Unscented_Transformation( mean_x, Cxx, f, additional_input )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
%

    % Dimension of vector
    N = length(mean_x);
    % Sigma points
    X = zeros(N, 2*N+1);
    X(:, 1) = mean_x;
    [sqrt_Cxx, positivity] = chol(Cxx, 'lower');
    if positivity > 0
        dips('Covariance matrix is not positive definitive, no squre root.');
        sqrt_Cxx = zeros(size(Cxx));
    end
    X(:, 2:N+1)     = mean_x + sqrt(N)*sqrt_Cxx;
    X(:, N+2:end)   = mean_x - sqrt(N)*sqrt_Cxx;
    % Propagated sigma points
    for i_X = 1 : 2*N+1
        Z(:, i_X) = f(X(:, i_X), additional_input);
    end
    % Weighting vector
    W = zeros(2*N+1, 1);
    W(1)        = 0;
    W(2:end)    = 1/(2*N);
    % Mean and covariance of propagated sigma points
    mean_z = Z*W;
    Z_centered = Z - mean_z;
    X_centered = X - mean_x;
    Czz = Z_centered.*W'*Z_centered';
    %Cross-covariance
    Cxz = X_centered.*W'*Z_centered';
    
end

