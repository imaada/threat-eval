
%waypoint generation
function return_paths = wp_gen(wp_num)
%300 km by 400km
origins = [[0,20,0];[1000,1000,0];[3000,10000,0];[10000,3500,0];[4800,5000,0];[2000,3000,0];[4100,800,0];[7800,2300,0]];
endings = [[180000,220000,0];[295000,398000,0];[245000,310000,0]];





origin = origins(randi(8),:);
ending = endings(randi(3),:);

current_path = [origin];

wp_ptr = origin;

for i = 1:wp_num
    min_x = origin(:,1);
    max_x = ending(:,1);
    min_y = origin(:,2);
    max_y = ending(:,2);
    x = min_x + randi(max_x - min_x);
    y = min_y + randi(max_y - min_y);
    DistanceFromEnding2xy = sqrt((ending(:,1)-x)^2 + (ending(:,2)-y)^2);
    DistanceFromEnding2WpPtr = sqrt((ending(:,1)-wp_ptr(:,1))^2 + (ending(:,2)-wp_ptr(:,2))^2);
    while DistanceFromEnding2xy >= DistanceFromEnding2WpPtr
        x = min_x + randi(max_x - min_x);
        y = min_y + randi(max_y - min_y);
        DistanceFromEnding2xy = sqrt((ending(:,1)-x)^2 + (ending(:,2)-y)^2)
        DistanceFromEnding2WpPtr = sqrt((ending(:,1)-wp_ptr(:,1))^2 + (ending(:,2)-wp_ptr(:,2))^2)
        
        disp([x,y])
    end

    wp_ptr = [x,y,0];
    current_path = [current_path;wp_ptr];        

end
current_path = [current_path;ending];
return_paths = current_path

%size_all = size(all_path);
% for i = 1:(size(current_path))
%     X = current_path(:,1);
%     Y = current_path(:,2);
%     plot(X,Y)
%     hold on
% end
%disp(all_path)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

