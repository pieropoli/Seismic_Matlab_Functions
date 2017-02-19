function [tt] =GetTraveltimeFast(edist,edep,depths,ddists,ttimes)

if edep <= max(depths) && edist <= max(ddists)

F=find(abs((edep)-depths)==min(abs((edep)-depths)));
d=ddists(F);
t=ttimes(F);
[d,ix] = unique(d);
t = (t(ix));

tt = interp1(d, t, edist );

else

tt  = nan;
disp('distance or depth not in the table')
end