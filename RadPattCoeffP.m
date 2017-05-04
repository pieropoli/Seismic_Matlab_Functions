function [ffP] = RadPattCoeffP(rake, dip, strike, az, iy)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% RadPattCoeffP.m
%
% Perez-Campos, Xyoli - 04/17/98
%
% Variables:
%	azimuth = Source receiver azimuth
%	dip = Dip
%	ffP = Radiation patter coefficient for P wave
%	fp* = intermediate coefficients to make easier the calculations
%	iy = Take-off angle
%	rake = Rake
%	strike = Strike
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Radiation patterns %%%
%% Far-field P-wave %%
fp1a = cos(rake) .* sin(dip) .* (sin(iy)).^2 .* sin(2.*(az - strike));
fp1b = cos(rake) .* cos(dip) .* sin(2*iy) .* cos(az - strike);
fp1 = fp1a - fp1b;
fp2 = sin(rake).*sin(2*dip).*((cos(iy)).^2 - (sin(iy)).^2.*(sin(az-strike)).^2);
fp3 = sin(rake) .* cos(2*dip) .* sin(2*iy) .* sin(az - strike);
ffP = fp1 + fp2 + fp3;

