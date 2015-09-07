function [catalog] = ParseUSGS_Catalog(catalog)
% need to be finished...
% Function to parse the usgs catalog as downloaded ins CSV format

id = fopen(char(catalog));
[catalog] =textscan(id,'%s %f %f %f %f %s%*[^\n]','Delimiter',',','EmptyValue',0,'HeaderLines',1); 
fclose(id);