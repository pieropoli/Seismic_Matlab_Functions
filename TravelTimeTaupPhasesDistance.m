function [tt,s] = TravelTimeTaupPhasesDistance(d,phase,evdep)

system(['taup_time -mod prem -deg ' num2str(d) ' --ph ' char(phase) ' -h ' int2str(evdep) ' -o taup.tmp']);

% read the output

[s.dist, s.dep, s.ph, s.time, s.p, s.takeoff, s.inciangle, s.puristd, s.puristname]=textread('taup.tmp','%f %f %s %f %f %f %f %f %s %*[^\n]','headerlines',5);

tt = s.time;