%Square mesh
%[X Y] = meshgrid(0:8);
%figure, voronoi(X(:),Y(:)),axis square
clc;
clear all;
%Hex mesh
scale = 34.641016151377531741097853660240657828156662760086052142215113918;
tic
rad3over2 = (sqrt(3)/2);
[X, Y] = meshgrid(0:1:5);
tempY = Y;
n = size(X,1);
X = rad3over2 * X;
Y = Y + repmat([0 0.5], [n,n/2]);

%scale to make edge length = 40
X = scale*X;
Y=scale*Y;
    

%returns vertices of edges, each column is an edge
[XV, YV] = voronoi(X(:),Y(:));
plot(XV,YV,'r-')
axis equal
axis([0 160 0 180])
zoom on

%determines edge length
pt1 = [XV(1,1), YV(1,1)];
pt = [XV(2,1), YV(2,1)];
edge_length = norm(pt1-pt);

%label hexes and find closest hex to test_position
test_position = [50,50];
total_hex = n*n;
dist2centres = zeros(1,total_hex);

hex_label = 0;
for i  = 1:n
    for j =1:n
        hex_label = hex_label +1;
        %inserts text on graph
        text(X(i,j),Y(i,j),int2str(hex_label),'HorizontalAlignment','center');
        
        %finds closest hex centre
        dist2centres(hex_label) = norm(test_position - [X(i,j),Y(i,j)]);
        
    end
end


[M, I] = min(dist2centres);
disp(I)


toc
%test = 0:1:41

%how to tell what hexagon im in?

