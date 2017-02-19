%% Map Recent Earthquakes
% We'd like to read in locations of recent earthquakes from USGS website
% and plot them on an interactive map.

%%
%   Copyright 2015 The MathWorks, Inc.

%% Read locations from USGS
% Load data from real-time datafeed.
% Read all the earthquakes in the last month magnitude 4.5 and greater.
% Find information about the data here:
% http://earthquake.usgs.gov/earthquakes/feed/v1.0/glossary.php
%
% Find the last 30 days, 4.5 or greater.
% http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_month.geojson
%
% Could look for last week if we preferred.
% http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_week.geojson

options = weboptions('Timeout',10);
quakeDataJSON = webread('http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_month.geojson', options);


%% Extract information per quake
quakeDataInfo = [quakeDataJSON.features.properties];
quakeDataLocation = [quakeDataJSON.features.geometry];

%% Convert struct to table
% open |quakeTable| to see what it looks like
quakeTable = struct2table(quakeDataInfo);
quakeTable(1:5,:)

%% What's in the table?
quakeTable.Properties.VariableNames

%% Add location info to the table
% First let's get the earthquake coordinates.  And then append them to the
% table of information we collected.
eqcoordinates = [quakeDataLocation.coordinates]';
quakeTable.Lon = eqcoordinates(:,1);
quakeTable.Lat = eqcoordinates(:,2);
quakeTable.depth = eqcoordinates(:,3);
quakeTable.Properties.VariableNames

%% Sort table by earthquake magnitude
% First look at part of the unsorted table
quakeTable.mag(1:5)

%%
% It's much harder to keep like-data together with structs than with
% tables.
quakeTable = sortrows(quakeTable,'mag','ascend');
quakeTable.mag(end-4:end)

%% Find the biggest quake
quakeTable(end,{'place','Lat', 'Lon','depth'})

%% First find range of earthquake magnitudes
% We could have chosen to pin maxmag to the largest we expect and minmag to 4.5
% so we can compare monthly maps with colors that coordinated.
minmag = min(quakeTable.mag);
maxmag = max(quakeTable.mag);

%% Plot earthquake locations on webmap
% Scale icon color by magnitude
cm = parula(10);
iconColor = cm(ceil(1+9*(quakeTable.mag-minmag)/(maxmag-minmag)),:);

%%
% Put name of location as hoverover label
names = quakeTable.title;

%%
% Convert quakeTable to geopint vector to add as info for each quake
quakePoints = geopoint(table2struct(quakeTable));

%% Map with Ocean Basemap to see alignment with some fracture zones
webmap('Ocean Basemap')
wmmarker(quakePoints,'OverlayName','Quake Points',...
    'FeatureName',names,'Color',iconColor,'AutoFit',false);
wmzoom(1)
snapnow

%% Load in plate boundaries
% I can illustrate file import here.  The data reference for plate
% boundaries is
% http://geoscience.wisc.edu/~chuck/MORVEL/PltBoundaries.html
% Citation: Argus, D. F., Gordon, R. G., and DeMets, C., 2011.
% Geologically current motion of 56 plates relative to the 
% no-net-rotation reference frame, 
% Geochemistry, Geophysics, Geosystems, accepted for publication, 
% September, 2011.
[lat, lon] = importPlates('All_boundaries.txt');
coast = load('coast');
figure
worldmap world
setm(gca,'mlabelparallel',-90,'mlabellocation',90)
plotm(coast.lat,coast.long,'Color','k')
plotm(lat,lon,'LineWidth',2)

%% Find the first plate
% Look for the first NaN and stop there.
ind = find(isnan(lat),1,'first')
plotm(lat(1:ind),lon(1:ind),'Color','red','Linewidth',3)

%% Make array of geopoints from the plate boundaries
bounds = geopoint(lat,lon);

%% Draw plate boundaries on map 
% Center the map on the longitude of largest quake first.
wmcenter(0,quakeTable.Lon(end))
wmline(bounds,'FeatureName','Plate Boundaries','Color','m','AutoFit',false)
wmzoom(1)
snapnow
