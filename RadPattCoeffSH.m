function [ffS] = RadPattCoeffS(rake,dip,strike,az,iy)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RadPattCoeffS.m
%
% Perez-Campos, Xyoli - 01/12/98
%
% Variables:
%	azimuth = Source receiver azimuth
%	dip = Dip
%	ffS = Radiation patter coefficient for P wave
%	fs* = intermediate coefficients to make easier the calculations
%	iy = Take-off angle
%	rake = Rake
%	strike = Strike
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Far-field S-wave %%%

fs1a = cos(rake) *cos(dip) * cos(iy) * sin(az - strike);
fs1b = cos(rake) * sin(dip) * sin(iy) * cos(2*(az - strike));
fs1 = fs1a + fs1b;
fs2 = sin(rake) * cos(2*dip) * cos(iy) * cos(az - strike);
fs3 = 0.5 * sin(rake) * sin(2*dip) * sin(iy)*sin(2*(az - strike));
ffS = fs1 + fs2 - fs3;
