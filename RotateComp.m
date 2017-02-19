function [R,T] = RotateComp(n,e,phi)

% fucntion to rotate seismograms(out R, T comp) given the azimuth (azimuth between event and station)

R = cosd(phi) * n + sind(phi) * e;
T = -sind(phi) * n + cosd(phi) * e;