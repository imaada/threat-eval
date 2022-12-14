% Generated by MATLAB(R) 9.13 (R2022b) and Sensor Fusion and Tracking Toolbox 2.4 (R2022b).
% Generated on: 11-Oct-2022 12:00:26
clear;
tic
%hold on
[X, Y, n] = Mesh();

for i = 1:1
    NumberofWaypoints = 5;
    [waypoints] = ChooseWaypoints(NumberofWaypoints);

    clear scenario;
    clear attribute_vec;
    RunTime = 20;
    scenario = createScenario(RunTime,waypoints,NumberofWaypoints);
    attribute_vec = zeros(RunTime*.5,9);
    attackIntention = zeros(1,3);
    CellData = zeros(RunTime*.5,1);
    WhileIndex = 1;
    lookup_table = [ 30 90 150 -150 -90 -30];
    %[P60 P120 P180 P240 P300 P360] = [30 90 -30 30 -90 -30]

    %[tp, platp, detp, covp] = createPlotters();
    
    % Configure your tracker here:s
    
    % Add a trackPlotter here:
    
    % Main simulation loop
    %while advance(scenario) && ishghandle(tp.Parent)
    while advance(scenario)
      
        % generate sensor data
        [dets, configs, sensorConfigPIDs] = detect(scenario);
        
        [truePosition, meas, measCov, e, velocity] = readData(scenario, dets);
        
       

        index = 0;
        [throwaway,x_centre,y_centre] = HexGrid(X,Y,[truePosition(1,1),truePosition(1,2)]);
        CellData(WhileIndex) = HexGrid(X,Y,[truePosition(1,1),truePosition(1,2)]);

        if WhileIndex ~= 1
            
            attackIntention = CalculateAttackIntention(truePosition,WhileIndex,attribute_vec,velocity);
            
            if CellData(WhileIndex) - CellData(WhileIndex -1) ~= 0
                first_pt = zeros(1,2);%hex centre of origin hex
                second_pt = zeros(1,2);%hex centre of new hex

                pointer = 1;
                for m  = 1:n
                    for j =1:n
                        if pointer == CellData(WhileIndex)
                            second_pt = [X(m,j),Y(m,j)];
                        end
                        pointer= pointer +1;
                       
                    end
                end
                
                pointer = 1;
                for m  = 1:n
                    for j =1:n
                        if pointer == CellData(WhileIndex-1)
                            first_pt = [X(m,j),Y(m,j)];
                        end
                        pointer= pointer +1;        
                    end
                end
                
%                slope =  (second_pt(2)-first_pt(2))/(second_pt(1)-first_pt(1)); 
               index = atan2d((second_pt(2)-first_pt(2)),(second_pt(1)-first_pt(1)));%angle of movement to adjacent hex
               index = round(index);
               index = find(lookup_table==index);
%              
                if isempty(index)
                    index = 0;
                    disp("We went out of range of the hex mesh")
                end
               attribute_vec(WhileIndex-1,1) = index;
            end
        
        end 
        
        x_tilda = x_centre - truePosition(1,1);
        y_tilda = y_centre - truePosition(1,2);
        %attribute_vec(WhileIndex,:) = [0,CellData(WhileIndex),x_tilda,y_tilda,0,e(1,3),attackIntention];
        attribute_vec(WhileIndex,:) = [0,CellData(WhileIndex),x_tilda,y_tilda,norm(velocity),e(1,3),attackIntention];

        WhileIndex = WhileIndex +1;
        % update your tracker here:
        
        % update plots
%         plotPlatform(platp,truePosition);
%         plotDetection(detp,meas,measCov);
%         plotCoverage(covp,coverageConfig(scenario));
        
        % Update the trackPlotter here:
        
%         drawnow
    end
    writematrix(attribute_vec,sprintf('C:/Users/i_maa/Desktop/Thesis/Old Data/Data_g/atrribute_vec%u.csv', i)); 
    writematrix(attribute_vec(:,3:6),sprintf('C:/Users/i_maa/Desktop/Thesis/Old Data/Data_f/atrribute_vec%u.csv', i));
    %writematrix(eulerangles,sprintf('eulerangles_%u.csv', i)); 

end
%hold off
toc

function[waypoints] = ChooseWaypoints(NumberofWaypoints)
    % plot Waypoints_YawAngle line on hex
    %NumberofWaypoints = 5;
    rng('shuffle');
    
    waypoints = Waypoints_YawAngle(NumberofWaypoints);
    %plot(waypoints(:,1), waypoints(:,2));
    
    waypoints1 = [-waypoints(:,1)-min(-waypoints(:,1))+5, waypoints(:,2),waypoints(:,3)];
    %plot(waypoints1(:,1), waypoints1(:,2))
    
    waypoints2 = [waypoints(:,1), -waypoints(:,2)-min(-waypoints(:,2))+5,waypoints(:,3)];
    %plot(waypoints2(:,1), waypoints2(:,2));
    
    waypoints3 = [-waypoints(:,1)-min(-waypoints(:,1))+5, -waypoints(:,2)-min(-waypoints(:,2))+5,waypoints(:,3)];
    %plot(waypoints3(:,1), waypoints3(:,2),'b');
    
    WaypointSet = [waypoints,waypoints1,waypoints2,waypoints3];
    randint = randi(4);
    waypoints = WaypointSet(:,randint*3-2:randint*3);
    plot(waypoints(:,1), waypoints(:,2));
end

function [attackIntention] = CalculateAttackIntention(truePosition,WhileIndex,attribute_vec,velocity)
    attackIntention = zeros(1,3);    
    %angle bw 2 vectors a & b is inverse cos (a dot b / mag(a) * mag(b))
    PlanePosition = truePosition(1,:);
    Tower1Pos = truePosition(2,:);
    Tower2Pos = truePosition(3,:);
    Tower3Pos = truePosition(4,:);

    normTower = norm(truePosition(1,:)-truePosition(2,:));
    a = [Tower1Pos(1,2)-PlanePosition(1,2),Tower1Pos(1,1)-PlanePosition(1,1),0];
    b = [PlanePosition(1,2)-attribute_vec(WhileIndex-1,2),PlanePosition(1,1)-attribute_vec(WhileIndex-1,1),0];
    attackTheta2 = acosd((dot(a,b))/(norm(a)*norm(b)));
    attackIntention(1) = norm(velocity)*cosd(attackTheta2)/normTower;

    normTower = norm(truePosition(1,:)-truePosition(3,:));
    a = [Tower2Pos(1,2)-PlanePosition(1,2),Tower2Pos(1,1)-PlanePosition(1,1),0];
    b = [PlanePosition(1,2)-attribute_vec(WhileIndex-1,2),PlanePosition(1,1)-attribute_vec(WhileIndex-1,1),0];
    attackTheta2 = acosd((dot(a,b))/(norm(a)*norm(b)));
    attackIntention(2) = norm(velocity)*cosd(attackTheta2)/normTower;

    normTower = norm(truePosition(1,:)-truePosition(4,:));
    a = [Tower3Pos(1,2)-PlanePosition(1,2),Tower3Pos(1,1)-PlanePosition(1,1),0];
    b = [PlanePosition(1,2)-attribute_vec(WhileIndex-1,2),PlanePosition(1,1)-attribute_vec(WhileIndex-1,1),0];
    attackTheta2 = acosd((dot(a,b))/(norm(a)*norm(b)));
    attackIntention(3) = norm(velocity)*cosd(attackTheta2)/normTower;
end

function [X, Y, n]  = Mesh()

    %Create hex mesh
    %This scale is to make edge length 40
    scale = 34.641016151377531741097853660240657828156662760086052142215113918/1.5; 
    rad3over2 = (sqrt(3)/2);
    [X, Y] = meshgrid(0:1:7);
    n = size(X,1);
    X = rad3over2 * X;
    Y = Y + repmat([0 0.5], [n,n/2]);
    %scale to make edge length = 40
    X = scale*X;
    Y=scale*Y;
    
    %returns vertices of edges, each column is an edge
   [XV, YV] = voronoi(X(:),Y(:));
    hold on
    plot(XV,YV,'r-')
    axis equal  
    axis([0 140 0 170])
    zoom on
    
    
   % hold off
    
    %Add text to hex mesh
    hex_label = 0;
    for i  = 1:n
        for j =1:n
            hex_label = hex_label +1;
            %inserts text on graph
            text(X(i,j),Y(i,j),int2str(hex_label),'HorizontalAlignment','center')        
        end
    end

end

function [position, meas, measCov, eulerang,velocity] = readData(scenario,dets)
allDets = [dets{:}];

if ~isempty(allDets)
    % extract column vector of measurement positions
    meas = cat(2,allDets.Measurement)';

    % extract measurement noise
    measCov = cat(3,allDets.MeasurementNoise);
else
    meas = zeros(0,3);
    measCov = zeros(3,3,0);
end

truePoses = platformPoses(scenario);
position = vertcat(truePoses(:).Position);
velocity = truePoses(1,:).Velocity;
eulerang = eulerd(truePoses(1).Orientation, 'XYZ', 'frame');

end


function [tp, platp, detp, covp] = createPlotters
% Create plotters
tp = theaterPlot('XLim', [-19.0499952293663 73.1702865541693], 'YLim', [-63.3323407980601 28.8879409854753], 'ZLim', [-86.0323407980601 6.18794098547532]);
set(tp.Parent,'YDir','reverse', 'ZDir','reverse');
view(tp.Parent, -37.5, 30);
platp = platformPlotter(tp,'DisplayName','Platforms','MarkerFaceColor','k');
detp = detectionPlotter(tp,'DisplayName','Detections','MarkerSize',6,'MarkerFaceColor',[0.85 0.325 0.098],'MarkerEdgeColor','k','History',10000);
covp = coveragePlotter(tp,'DisplayName','Sensor Coverage');
end


function scenario = createScenario(RunTime,waypoints,NumberofWaypoints)
% Create Scenario
%NumberofWaypoints = 5;
%rng('shuffle');
%waypoints = Waypoints_YawAngle(NumberofWaypoints);
timearray = TOA(waypoints, RunTime);

scenario = trackingScenario;
scenario.StopTime = Inf;
scenario.UpdateRate = 0;


% Create platforms
Plane = platform(scenario,'ClassID',1);
Plane.Dimensions = struct( ...
    'Length', 1, ...
    'Width', 1, ...
    'Height', 1, ...
    'OriginOffset', [0 0 0]);
Plane.Signatures = {...
    rcsSignature(...
        'FluctuationModel', 'Swerling0', ...
        'Pattern', [20 20;20 20], ...
        'Azimuth', [-180 180], ...
        'Elevation', [-90;90], ...
        'Frequency', [0 1e+20])};
Plane.Trajectory = waypointTrajectory( ...
    waypoints, ...
    timearray, ...
    'ClimbRate', zeros(1,NumberofWaypoints), ...
    'AutoPitch', true, ...
    'AutoBank', true);

Tower = platform(scenario,'ClassID',3);
Tower.Dimensions = struct( ...
    'Length', 10, ...
    'Width', 10, ...
    'Height', 60, ...
    'OriginOffset', [0 0 30]);
Tower.Trajectory.Position = [140, 70,0];

Tower = platform(scenario,'ClassID',4);
Tower.Dimensions = struct( ...
    'Length', 10, ...
    'Width', 10, ...
    'Height', 60, ...
    'OriginOffset', [0 0 30]);
Tower.Trajectory.Position = [110, 120,0];   

Tower = platform(scenario,'ClassID',5);
Tower.Dimensions = struct( ...
    'Length', 10, ...
    'Width', 10, ...
    'Height', 60, ...
    'OriginOffset', [0 0 30]);
Tower.Trajectory.Position = [140, 90,0];

% Create sensors
Rotator = fusionRadarSensor('SensorIndex', 1, ...
    'UpdateRate', 0.5, ...
    'MountingLocation', [0 -0.06 0], ...
    'FieldOfView', [1 10], ...
    'HasINS', true, ...
    'DetectionCoordinates', 'Scenario');


% Assign sensors to platforms
Plane.Sensors = Rotator;
end
