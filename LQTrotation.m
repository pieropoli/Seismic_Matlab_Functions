function [L,Q,T]=LQTrotation(z,r,t,inc)

% rotate 3 components (z,r,t) seismograms in LQT compoentne using
% incidence angle (i)


L = z.*cosd(inc) + r.*sind(inc) ;

Q = -z.*sind(inc) + r.*cosd(inc) ;

T = t;

