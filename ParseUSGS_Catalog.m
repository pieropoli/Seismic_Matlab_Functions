function [timeevent,lon,lat,depth,magnitude,magtype] = ParseUSGS_Catalog(catalog)
% need to be finished...
% Function to parse the usgs catalog as downloaded ins CSV format

id = fopen(char(catalog));
[catalog] =textscan(id,'%s %f %f %f %f %s%*[^\n]','Delimiter',',','EmptyValue',0,'HeaderLines',1); 
time=char(catalog{1,1});
if isempty(time)==0
%% get time
year=str2num(time(:,1:4));
month=str2num(time(:,6:7));
day=str2num(time(:,9:10));
hour=str2num(time(:,12:13));
minute=str2num(time(:,15:16));
sec=str2num(time(:,18:19));

%% make datevec file
timeevent = [year month day hour minute sec];


lon=cell2mat(catalog(1,2));
lat=cell2mat(catalog(1,3));
depth=cell2mat(catalog(1,4));
magnitude=cell2mat(catalog(1,5));
magtype=catalog(1,6);

% elsesave
% disp('no events found!')
% timeevent = [];
% 
% 
% lon=[];
% lat=[];
% depth=[];
% magnitude=[];
% magtype=[];  
end    
fclose(id);