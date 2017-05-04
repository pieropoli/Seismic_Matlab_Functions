function [ffS] = RadPattCoeffS(rake, dip, strike, az, iy)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% RadPattCoeffS.m
%
% Perez-Campos, Xyoli - 04/17/98
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

fs1a = sin(rake) .*cos(2*dip) .* cos(2*iy) .* sin(az - strike);
fs1b = cos(rake) .* cos(dip) .* cos(2*iy) .* cos(az - strike);
fs1 = fs1a - fs1b;
fs2 = 0.5 * cos(rake) .* sin(dip) .* sin(2*iy) .* sin(2*(az - strike));
fs3 = 0.5 * sin(rake) .* sin(2*dip) .* sin(2*iy) ...
      .* (ones(size(az - strike)) + (sin(az - strike)).^2);
ffS = fs1 + fs2 - fs3;
