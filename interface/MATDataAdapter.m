classdef MATDataAdapter
    %RawDataAdapter An adapter for getting access to signals from Matlab ".mat" file.
    %This adapter has 2 features:
    %   1. Providing an uniform signal name to experimental data not
    %   mattter where the data come from. The data should be stored in ".mat" file. 
    %   The origin of data could be Matlab, Simulink, SCANeR, csv file etc. depending on its origin. 
    %   For each new origin or new type of file, acess methods need to be
    %   added.
    %   2. Selecting a certain range of data by providing a criteria or an
    %   indice range. The selected data adapter will be returned by using
    %   function "select_indices".
    
    %% Private properties of data information
    properties (Access = public)
        mat_data
        %{ 
          Author list
          This is the list of author represented by a number.
          -2 : Louay Saleh
          -1 : Ablamvi Ameoye
           0 : Yishen Zhao
           1 : Béatrice Pano, SCANeR data
        %}
        author
        indice_span
    end
   
    %% Read-only properties as data access interface
    properties (Dependent)
        % Record info
        time
        N_data_points
        fs
        % Road
        road_center_x
        road_center_y
        road_angle_rad
        road_width
        road_curvature
        lane_width
        % Vehicle
        speed_x
        speed_y
        heading_rad
        heading_relative_rad
        drift_angle_rad
        yaw_rate_rad
        lateral_error
        lateral_error_at_distance
        steering_wheel_angle_rad
        vehicle_cdg_x
        vehicle_cdg_y
        vehicle_rear_axle_center_x
        vehicle_rear_axle_center_y
        time_to_lane_crossing_path
        % Driver
        road_curvature_previewed
        driver_intention_angle_rad
        driver_torque
        % Assistance
        assistance_torque
    end
    
    %% Methods    
    methods
        % constructor
        function obj = MATDataAdapter( mat_data_name, author )
            obj.mat_data = load(mat_data_name);
            obj.author = author;
            obj.indice_span = 1:length(obj.mat_data.time);
        end
        function obj = select_indices( obj, criteria )
            assert(length(criteria)<=length(obj.indice_span));
            obj.indice_span = obj.indice_span(criteria);
        end
        % read-only property get functions
        function value = get.time( obj )
            value = obj.mat_data.time(obj.indice_span);
        end
        function value = get.N_data_points( obj )
            value = length(obj.indice_span);
        end
        function value = get.fs( obj )
            value = 1 / (obj.mat_data.time(2) - obj.mat_data.time(1));
        end
        function value = get.road_center_x ( obj )
            switch ( obj.author )
                case {-2,1}
                    value = obj.mat_data.txt_data.RoadX(obj.indice_span);
                otherwise
                    value = NaN;
            end
        end
        function value = get.road_center_y ( obj )
            switch ( obj.author )
                case {-2,1}
                    value = obj.mat_data.txt_data.RoadY(obj.indice_span);
                otherwise
                    value = NaN;
            end
        end
        function value = get.road_angle_rad ( obj )
            switch ( obj.author )
                case {-2,1}
                    value = obj.mat_data.txt_data.RoadAngle(obj.indice_span);
                otherwise
                    value = NaN;
            end
        end
        function value = get.road_width ( obj )
            switch ( obj.author )
                case 0
                    value = obj.mat_data.SCRIPT.RoadWidth;
                case {-2,1}
                    value = 19;
                otherwise
                    value = NaN;
            end
        end
        function value = get.road_curvature ( obj )
            switch ( obj.author )
                case -2
                    value = obj.mat_data.txt_data.rho_ref0(obj.indice_span);
                case 1
                    value = obj.mat_data.txt_data.rho_ref(obj.indice_span);
                otherwise
                    value = NaN;
            end
        end
        function value = get.lane_width ( obj )
            switch ( obj.author )
                case 0
                    value = obj.mat_data.SCRIPT.LaneWidth;
                case {-2, 1}
                    value = 3.5;
                otherwise
                    value = NaN;
            end
        end
        function value = get.speed_x ( obj )
            switch ( obj.author )
                case -2
                    value = obj.mat_data.txt_data.v(obj.indice_span);
                case 1
                    value = obj.mat_data.txt_data.vx(obj.indice_span);
                otherwise
                    value = NaN;
            end
        end
        function value = get.speed_y ( obj )
            switch ( obj.author )
                case 1
                    value = obj.mat_data.txt_data.vy(obj.indice_span);
                otherwise
                    value = NaN;
            end
        end
        function value = get.heading_rad ( obj )
            switch ( obj.author )
                otherwise
                    value = NaN;
            end
        end
        function value = get.heading_relative_rad ( obj )
            switch ( obj.author )
                case -2
                    value = obj.mat_data.txt_data.Psi_L(obj.indice_span);
                case 1
                    value = obj.mat_data.txt_data.Psi_L_calcul(obj.indice_span);
                otherwise
                    value = NaN;
            end
        end
        function value = get.drift_angle_rad ( obj )
            switch ( obj.author )
                case {-2,1}
                    value = obj.mat_data.txt_data.Beta(obj.indice_span);
                otherwise
                    value = NaN;
            end
        end
        function value = get.yaw_rate_rad ( obj )
            switch ( obj.author )
                case {-2, 1}
                    value = obj.mat_data.txt_data.r(obj.indice_span);
                otherwise
                    value = NaN;
            end
        end
        function value = get.lateral_error ( obj )
            switch ( obj.author )
                case -2
                    value = obj.mat_data.txt_data.y_act(obj.indice_span);
                case 1
                    value = -obj.mat_data.txt_data.Y_Road(obj.indice_span);
                otherwise
                    value = NaN;
            end
        end
        function value = get.lateral_error_at_distance ( obj )
            switch ( obj.author )
                case -2
                    value = obj.mat_data.txt_data.yL_nf(obj.indice_span);
                case 1
                    value = obj.mat_data.txt_data.Y_L_calcul(obj.indice_span);
                otherwise
                    value = NaN;
            end
        end
        function value = get.steering_wheel_angle_rad ( obj )
            switch ( obj.author )
                case -2
                    value = obj.mat_data.txt_data.deltad(obj.indice_span);
                case 1
                    value = obj.mat_data.txt_data.delta_d(obj.indice_span);
                otherwise
                    value = NaN;
            end
        end
        function value = get.vehicle_cdg_x ( obj )
            switch ( obj.author )
                otherwise
                    value = NaN;
            end
        end
        function value = get.vehicle_cdg_y ( obj )
            switch ( obj.author )
                otherwise
                    value = NaN;
            end
        end
        function value = get.vehicle_rear_axle_center_x ( obj )
            switch ( obj.author )
                case -2
                    value = obj.mat_data.txt_data.vhcl_x(obj.indice_span);
                case 1
                    value = obj.mat_data.txt_data.Vehicle_X(obj.indice_span);
                otherwise
                    value = NaN;
            end
        end
        function value = get.vehicle_rear_axle_center_y ( obj )
            switch ( obj.author )
                case -2
                    value = obj.mat_data.txt_data.vhcl_y(obj.indice_span);                
                case 1
                    value = obj.mat_data.txt_data.Vehicle_Y(obj.indice_span);
                otherwise
                    value = NaN;
            end
        end
        function value = get.time_to_lane_crossing_path ( obj )
            switch ( obj.author )
                case 1
                    value = obj.mat_data.txt_data.TLCP(obj.indice_span);
                otherwise
                    value = NaN;
            end
        end
        function value = get.road_curvature_previewed ( obj )
            switch ( obj.author )
                case 1
                    value = obj.mat_data.txt_data.rho_previewed(obj.indice_span);
                otherwise
                    value = NaN;
            end
        end
        function value = get.driver_torque ( obj )
            switch ( obj.author )
                case -2
                    value = obj.mat_data.txt_data.SteeringT(obj.indice_span);
                case 1
                    value = obj.mat_data.txt_data.T_Pilot_inversed(obj.indice_span);
                otherwise
                    value = NaN;
            end
        end
        function value = get.driver_intention_angle_rad ( obj )
            switch ( obj.author )
                otherwise
                    value = NaN;
            end
        end
        function value = get.assistance_torque ( obj )
            switch ( obj.author )
                case -2
                    value = obj.mat_data.txt_data.H2_couple(obj.indice_span);
                case 1
                    value = obj.mat_data.txt_data.Tc(obj.indice_span);
                otherwise
                    value = NaN;
            end
        end
    end
end

