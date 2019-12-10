function [ metrics_steering_wheel_angle_filtered ] = func_metrics_steering_wheel_angle_filtered( time, delta_d_degree )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    %% Steering wheel metrics
    fs = 1/(time(2) - time(1));
    % Steering wheel angle
    N_delta_d_degree = length(delta_d_degree);
    % Frequency analysis
    stop_band_freq1 = 0.3;
    stop_band_freq2 = 0.6;

    filter_BP = designfilt('bandpassiir', 'FilterOrder', 20, ...
                           'StopbandFrequency1', stop_band_freq1 , 'StopbandFrequency2', stop_band_freq2, ...
                           'StopbandAttenuation', 60, 'SampleRate', fs);
    % fvtool(filter_BP);
    delta_d_degree_filtered = filter(filter_BP, delta_d_degree);
    fft_delta_d_deg      = abs(fft(delta_d_degree_filtered)/N_delta_d_degree);
    freq_amp_delta_d_deg = fft_delta_d_deg(1:floor(N_delta_d_degree/2)+1);
    freq_delta_d_deg     = fs*(0:(N_delta_d_degree/2))/N_delta_d_degree;
    % figure, plot(Freq_delta_d_deg, Freq_amp_delta_d_deg); axis([0.2 2 0 inf]); xlabel('Frequency (Hz)'); grid on;
    % Mean and std of filtered steering wheel angle
    metrics_steering_wheel_angle_filtered.mean = mean(delta_d_degree_filtered);
    metrics_steering_wheel_angle_filtered.std = std(delta_d_degree_filtered);
    
    power_delta_d = norm(delta_d_degree);
    power_delta_d_filtered = norm(delta_d_degree_filtered);
    high_frequence_component = power_delta_d_filtered / power_delta_d;
    metrics_steering_wheel_angle_filtered.HFC = high_frequence_component;

end