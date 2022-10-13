function timearray = TOA (waypoints,max_time)

% origin = waypoints(1,:);
% wp_num = size(waypoints,1);
% ending = waypoints(wp_num,:);
% timearray = zeros(wp_num,1);
% timearray(1,1) = 0;
% %totald = sqrt((waypoints(wp_num,1)-waypoints(1,1))^2 + (waypoints(wp_num,2)-waypoints(1,2))^2);
% totald = sqrt((300000-waypoints(1,1))^2 + (400000-waypoints(1,2))^2);
% for i = 2:wp_num    
%     
%     currentd = sqrt((waypoints(i,1)-waypoints(1,1))^2 + (waypoints(i,2)-waypoints(1,2))^2);
%     ratio = currentd/totald;
%     time2wp = ratio*10;
%     %currenttime = timearray(i-1,1)+time2wp
%     timearray(i,1) = [time2wp];
% end

waypoints = waypoints - waypoints(1,:);
vecnormal = vecnorm(waypoints,2,2);
%vecnormal = vecnormal - vecnormal(1);
vecnormal = vecnormal./vecnormal(end);

timearray = max_time * vecnormal;

disp(timearray)
end