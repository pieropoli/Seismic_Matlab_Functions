function [tt,s] = TravelTimeTaupPhasesDistance(d,phase,evdep,mod)
I = [num2str(now) '-' num2str(rand(1)) '-' num2str(rand(1)) '-' num2str(rand(1)) '-' num2str(rand(1))];
system(['taup_time -mod ' char(mod) ' -deg ' num2str(d) ' --ph ' char(phase) ' -h ' int2str(evdep) ' -o taup' num2str(I) '.tmp']);
% read the output
if exist(['taup' num2str(I) '.tmp'],'file') == 2 
[s.dist, s.dep, s.ph, s.time, s.p, s.takeoff, s.inciangle, s.puristd, s.puristname]=textread(['taup' num2str(I) '.tmp'],'%f %f %s %f %f %f %f %f %s %*[^\n]','headerlines',5);
tt = s.time;
else
tt = nan;
s= nan;
end

system(['rm -fr taup' num2str(I) '.tmp']);