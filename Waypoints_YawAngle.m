function waypoints = Waypoints_YawAngle(NumberofWaypoints)

origins = [10000,20000,0; 100000,5000,0; 75000,12000,0];
origin = origins(randi(3),:);

YawAngle = [10,160];
section_length = 20000;
%NumberofWaypoints = 10;

waypoints = zeros(NumberofWaypoints, 3);
waypoints(1,:) = origin;
%RandomTheta = (YawAngle(2)-YawA ngle(1)).*rand(1000) + YawAngle(1)
RandomTheta = YawAngle(2)*rand;

%Range =   [min(RandomTheta) max(RandomTheta)]
for i = 2:NumberofWaypoints
    waypoints(i,1) = waypoints(i-1,1) + section_length*sind(RandomTheta);
    waypoints(i,2) = waypoints(i-1,2) + section_length*cosd(RandomTheta);
    waypoints
    RandomTheta = YawAngle(2)*rand;
%     x += section_length*sind(RandomTheta);
%     y += section_length*cosd(RandomTheta);
%     waypoints(i,:) = [x,y,0];
end
waypoints(:,1) = smoothdata(waypoints(:,1),'gaussian',4);
waypoints(:,2) = smoothdata(waypoints(:,2),'gaussian',4);
plot(waypoints(:,1), waypoints(:,2));

