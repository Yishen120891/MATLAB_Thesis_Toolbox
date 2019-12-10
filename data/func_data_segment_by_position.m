function [ cSegIndices ] = func_data_segment_by_position( VehicleX, VehicleY, seperatingPoints )
%func_data_segment_by_position Seperating the record data from SCANeR into several
%segments according to road position data and provided seperating points
%coordinates.

    % Number of total indices
    NTotalIndices = length(VehicleX);
    
    % Number of seperating points
    NSeperatingPoints = size(seperatingPoints,2);
    
    seperatingIndices = [];
    for i = 1 : NSeperatingPoints
        % Calculating the distance between each road center point and
        % seperating point
        deltaXY = [VehicleX' - seperatingPoints(1,i); VehicleY' - seperatingPoints(2,i)];
        dist = zeros(1,length(deltaXY));
        for j = 1 : length(deltaXY)
            dist(j) = norm(deltaXY(:, j));
        end
        % Find indices of local minima
        [~, pointIndices] = findpeaks(-dist, 'MinPeakHeight', -3.5);
        % Put indices together in order
        seperatingIndices = union(seperatingIndices, pointIndices);
    end
    
    % Number of all seperating indices
    NSeperatingIndices = length(seperatingIndices);
    % Cell array storing vectors of indice vector for each segment
    cSegIndices = cell(1, length(seperatingIndices) + 1);
    for i = 1 : NSeperatingIndices
        if i == 1
            % The indice of first segment starts from 1
            cSegIndices(i) = {1:seperatingIndices(i)-1};
        else
            % The indice of each segement starts from i-1 seperatingIndices
            % and ends at i seperatingIndice - 1.
            cSegIndices(i) = {seperatingIndices(i-1):seperatingIndices(i)-1};
        end
    end
    % The indice of last segment ends at number of total indices
    cSegIndices(i+1) = {seperatingIndices(i):NTotalIndices};

end

