%% Working with a "Big" Dataset
% In this example, I will load an historical data set, earthquake
% hypocenters from the <http://www.isc.ac.uk/iscgem/overview.php ISC-GEM
% Catalogue> and see how we can work when the amount of data may be too
% large to fit into memory all at once.
%
%
%   Copyright 2015 The MathWorks, Inc.
%

%% Preview the data.
% Having looked in advance, I know that this spreadsheet has a lot of lines
% of explanation and header information up front, followed by tabular data.
% Let's take a look at it.

ds = datastore('isc-gem-cat.csv','NumHeaderLines',56);
preview(ds)

%% Select a subset of information.
% I now select the subset of columns that I want to explore from this
% historical dataset.  You can see I am choosing earthquake location,
% magnitude, moment, and quality information about the data.  In addition,
% I specify the format I want to see it in after importing the information
% to MATLAB.

ds.SelectedVariableNames = {'x_Date','lat','lon',...
    'depth','q_1','mw','q_2','mo','mo_auth'};
ds.SelectedFormats{1} = '%{yyyy-MM-dd HH:mm:ss.SS}D';
ds.SelectedFormats{5}= '%C';
ds.SelectedFormats{7} = '%C';
ds.SelectedFormats{9} = '%s';

%%
preview(ds)

%% 

ds.RowsPerRead = 1000; % normally 20000
dataChunk = read(ds); % show in variable editor

%% Read in the selected information.
% Read it into a <http://www.mathworks.com/help/matlab/ref/table.html
% |table|>, in chunks, selecting only data with high quality depths.

reset(ds)
numreads = 0;

eqQuality = table;

while hasdata(ds)
    eqChunk = read(ds);
    idx = eqChunk.q_1 == 'A';
    eqQuality = [eqQuality; eqChunk(idx,:)]; %#ok<AGROW>
    numreads = numreads + 1
end
    
%%
% If I didn't want to show reading in the chunks, I could have read in the
% data this way instead, assuming it could all be read at once.
%
%      eqQuality = readall(ds);

%% Let's see what we've got.
plot(eqQuality.lon,eqQuality.lat,'.')

%% Let's make a histogram of the number of earthquakes vs. time.
% First let's see what the timespan is.

maxDt = max(eqQuality.x_Date)
minDt = min(eqQuality.x_Date)

%%
% Now our histogram.

histogram(year(eqQuality.x_Date),'BinMethod','integers');
xlabel('year')
ylabel('# Quakes')
title('Histogram of Quakes by Year (High Quality Depth Determination)')

%% Median Time Between Quakes of Quality
% More math on dates.  Let's find some statistics about the time spacing
% between earthquakes.  Now I am creating a duration array and calculating
% some statistics from that array.

durs = diff(eqQuality.x_Date); 
disp('          Median           Max           Min (HH:MM:SS)') 
durStats = [median(durs) max(durs) min(durs)]  ;
disp(durStats)
disp('          Median           Max           Min (days)') 
disp(days(durStats))

%% Plot time vs. magnitude
% We can zoom in to see more detail.
plot(eqQuality.x_Date, eqQuality.mw,'.')

%% Looking for seasonality?
% We can aggregate the earthquake instances by month instead of year to
% look for seasonality.

histogram(month(eqQuality.x_Date),'BinMethod','integers');
xlabel('month')
ylabel('# Quakes')
title('Histogram of Quakes by Year (High Quality Depth Determination)')

%% Looking at Earthquakes in Japan
% We are interested in looking at a particular area of Japan.
%
% * http://www.earthobservatory.sg/news/great-east-japan-tohoku-2011-earthquake-important-lessons-old-dirt#.VMkrtmjF9Sv
% * https://geos309.community.uaf.edu/

lat = [35 40];
lon = [135 145];

%%  Extract Earthquakes in that Area
% Using logical indexing, we can extract the earthquakes in the areas we
% are interested in studying further.

idxlat = eqQuality.lat > lat(1) & eqQuality.lat < lat(2);
idxlon = eqQuality.lon > lon(1) & eqQuality.lon < lon(2);
eqJ = eqQuality(idxlat & idxlon, :);

eqJ.depth = eqJ.depth *(-1000);  % converting depth to negative values

%% Find the Largest Earthquake

[x,idx] = max(eqJ.mw);

eqJ(idx,:)

%% Plot on a Map of Japan
% We first plot the earthquakes on a map of Japan to see if
% they are located in a reasonable position. 

load japantopo  % load topo information (from NASA WorldWind WMS server)

f = figure;

% Plot topography
worldmap(lat,lon)
colormap(f,demcmap(double(Z1))); % change to more appropriate colormap
geoshow(Z1,R1,'DisplayType', 'texturemap'); 
hold on

% Plot earthquakes
ptSz = 2 + 60*(eqJ.mw-5.0)/5.0;  % use ptSz for magnitude
scatterm(eqJ.lat,eqJ.lon,ptSz,...
    'MarkerFaceColor','y','MarkerEdgeColor',[0 .3 .3])

hold off
colorbar   % add a colorbar
title('Japan earthquakes')

%% Convert lat, lon, depth to x, y, z values and plot
%  We are interested in location as a function of depth so to plot the
%  quakes, we first convert our locations to a local Cartesian coordinates.
%  We assume geodetic coordinates relative to a reference ellipsoid
% ('World Geodetic System 1984') to get our x,y,z (enu) values. 

rsph = referenceEllipsoid('earth');
[xEast,yNorth,zDepth] = geodetic2enu(eqJ.lat,eqJ.lon,eqJ.depth,38,145,0,rsph);

figure

scatter3(xEast./1000,yNorth./1000,zDepth./1000,ptSz,eqJ.mw,...
    'filled','MarkerEdgeColor','b')

xlabel('East (km)')
ylabel('North (km)')
zlabel('Depth (km)')
title('Japan earthquakes - overhead view')

axis equal
zlim([-400 0])
colorbar
view(0,90)

%% 
% Display image from published results to compare.
view(-20,3)
%% Compare to model
% imshow('Tohoku2-bloc_diagramme_japan_earthquakes.jpg',...
%    'InitialMagnification','fit');
%
% or
%
web http://www.earthobservatory.sg/files/project/images/Tohoku2-bloc_diagramme_japan_earthquakes.jpg -browser
