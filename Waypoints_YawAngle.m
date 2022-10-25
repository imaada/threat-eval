function waypoints = Waypoints_YawAngle(NumberofWaypoints)

origins = [10,20,0; 100,5,0; 75,100,0;100,100,0;120,150,0;150,60,0];
origin = origins(randi(6),:);

YawAngle = [0,90];
section_length = 20;
%NumberofWaypoints = 10;

waypoints = zeros(NumberofWaypoints, 3);
waypoints(1,:) = origin;
%RandomTheta = (YawAngle(2)-YawA ngle(1)).*rand(1000) + YawAngle(1)
RandomTheta = (YawAngle(2)-YawAngle(1))*rand + YawAngle(1);
%disp(RandomTheta)

%Range =   [min(RandomTheta) max(RandomTheta)]
for i = 2:NumberofWaypoints
    waypoints(i,1) = waypoints(i-1,1) + section_length*sind(RandomTheta);
    waypoints(i,2) = waypoints(i-1,2) + section_length*cosd(RandomTheta);
    
    RandomTheta = (YawAngle(2)-YawAngle(1))*rand + YawAngle(1);
%     x += section_length*sind(RandomTheta);
%     y += section_length*cosd(RandomTheta);
%     waypoints(i,:) = [x,y,0];
end
%disp(waypoints)
waypoints(:,1) = smoothdata(waypoints(:,1),'gaussian',4);
waypoints(:,2) = smoothdata(waypoints(:,2),'gaussian',4);
%plot(waypoints(:,1), waypoints(:,2));

end
