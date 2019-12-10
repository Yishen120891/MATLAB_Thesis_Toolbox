function [ metrics_SRR ] = func_metrics_steering_wheel_reversal_rate( time, delta_d_degree, threshold_deg )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    metrics_SRR = 0;
    
    [local_maxima, indice_local_maxima] = findpeaks(delta_d_degree);
    [local_minima, indice_local_minima] = findpeaks(-delta_d_degree);
    min_local_maxima = min(local_maxima);
    max_local_minima = max(-local_minima);
    if (delta_d_degree(1) >= min_local_maxima)
        indice_local_maxima = union(indice_local_maxima, 1);
    end
    if (delta_d_degree(1) <= max_local_minima)
        indice_local_minima = union(indice_local_minima, 1);
    end
    if (delta_d_degree(end) >= min_local_maxima)
        indice_local_maxima = union(indice_local_maxima, length(delta_d_degree));
    end
    if (delta_d_degree(end) <= max_local_minima)
        indice_local_minima = union(indice_local_minima, length(delta_d_degree));
    end 
    
    for i = 1 : length(indice_local_minima)
        
        indice_adjacent_local_maxima = [find( indice_local_maxima < indice_local_minima(i), 1, 'last'),...
                                        find( indice_local_maxima > indice_local_minima(i), 1)];
        indice_adjacent_local_maxima = indice_local_maxima(indice_adjacent_local_maxima);                            
        for j = 1 : length(indice_adjacent_local_maxima)
            if (delta_d_degree(indice_adjacent_local_maxima(j)) - delta_d_degree(indice_local_minima(i))) >= threshold_deg
                metrics_SRR = metrics_SRR + 1;
            end
        end
    end
    
    metrics_SRR = metrics_SRR / (time(end) - time(1)) * 60;
end

