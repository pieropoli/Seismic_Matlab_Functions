function [s] = Taup_pierce(phase,evdep,mod,evlat,evlon,stlat,stlon)

if strcmp(phase,'ttp+') ~=1


I = [num2str(now) '-' num2str(rand(1)) '-' num2str(rand(1)) '-' num2str(rand(1)) '-' num2str(rand(1))];
system(['taup_pierce -mod ' char(mod) ' -evt ' num2str(evlat) ' ' num2str(evlon) ' -sta ' num2str(stlat) ' ' num2str(stlon) ' --ph ' char(phase) ' -h ' int2str(evdep) ' -o taup' num2str(I) '.tmp']);
% read the output
if exist(['taup' num2str(I) '.tmp'],'file') == 2 
[s.dist, s.dep, s.time, s.lat, s.lon ]=textread(['taup' num2str(I) '.tmp'],'%f %f %f %f %f %*[^\n]','headerlines',1);

else

s= nan;
end

system(['rm -fr taup' num2str(I) '.tmp']);

else
   disp('ERROR!!! The pahse need to be declared. You cannot use ttp+') 

   s=NaN;
end