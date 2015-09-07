function [t,p] =getTravelTime(dist,depth,phase)

 load(['travelTime_direct' char(phase) '.mat'])
 depth=round(depth);
 F=find(abs(depth-table.depth)==min(abs(depth-table.depth)));
 d=table.distance(F);
 t=table.traveltim(F);
 p=table.rayp(F);
 t = interp1(d, t, dist );
 p = interp1(d,  p, dist );
