function [ road ] = func_road_coordinates( road_center_x, road_center_y, road_angle_rad, road_width, lane_width )
%func_road_coordinates Generates lane edge coordinates for figure.

    road_left_edge_x    = road_center_x - road_width./2.*sin(road_angle_rad);
    road_left_edge_y    = road_center_y + road_width./2.*cos(road_angle_rad);
    road_right_edge_x   = road_center_x + road_width./2.*sin(road_angle_rad);
    road_right_edge_y   = road_center_y - road_width./2.*cos(road_angle_rad);
    
    left_lane_center_x  = road_center_x - lane_width./2.*sin(road_angle_rad);
    left_lane_center_y  = road_center_y + lane_width./2.*cos(road_angle_rad);
    left_lane_edge_x    = road_center_x - lane_width.*sin(road_angle_rad);
    left_lane_edge_y    = road_center_y + lane_width.*cos(road_angle_rad);
    
    right_lane_center_x = road_center_x + lane_width./2.*sin(road_angle_rad);
    right_lane_center_y = road_center_y - lane_width./2.*cos(road_angle_rad);
    right_lane_edge_x   = road_center_x + lane_width.*sin(road_angle_rad);
    right_lane_edge_y   = road_center_y - lane_width.*cos(road_angle_rad);
    
    road.center.x       = road_center_x;
    road.center.y       = road_center_y;   
    road.left_edge.x    = road_left_edge_x;
    road.left_edge.y    = road_left_edge_y;
    road.right_edge.x   = road_right_edge_x;
    road.right_edge.y   = road_right_edge_y;
    
    road.left_lane.center.x     = left_lane_center_x;
    road.left_lane.center.y     = left_lane_center_y;
    road.left_lane.left_edge.x  = left_lane_edge_x;
    road.left_lane.left_edge.y  = left_lane_edge_y;
    road.left_lane.right_edge.x = road_center_x;
    road.left_lane.right_edge.y = road_center_y;
    
    road.right_lane.center.x        = right_lane_center_x;
    road.right_lane.center.y        = right_lane_center_y;
    road.right_lane.left_edge.x     = road_center_x;
    road.right_lane.left_edge.y     = road_center_y;
    road.right_lane.right_edge.x    = right_lane_edge_x;
    road.right_lane.right_edge.y    = right_lane_edge_y;

end

