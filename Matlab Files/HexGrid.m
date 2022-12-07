function [index,x_centre,y_centre ]= HexGrid(X,Y,test_position)


%determines edge length
% pt1 = [XV(1,1), YV(1,1)];
% pt = [XV(2,1), YV(2,1)];
% edge_length = norm(pt1-pt);

%label hexes and find closest hex to test_position
%test_position = [50,50];
n = size(X,1);

total_hex = n*n;
dist2centres = zeros(1,total_hex);
cell_centres = zeros(total_hex,2);
hex_label = 0;
for i  = 1:n
    for j =1:n
        hex_label = hex_label +1;
        %inserts text on graph
        %text(X(i,j),Y(i,j),int2str(hex_label),'HorizontalAlignment','center');
        
        %finds closest hex centre
        dist2centres(hex_label) = norm(test_position - [X(i,j),Y(i,j)]);
        cell_centres(hex_label,:) = [X(i,j),Y(i,j)];
    end
end


[M, index] = min(dist2centres);
x_centre = cell_centres(index,1);
y_centre = cell_centres(index,2);
%disp(I)
%index = I;


%toc
%test = 0:1:41

%how to tell what hexagon im in?

end