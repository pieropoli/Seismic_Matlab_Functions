function [geomSpread] = GeomSpreadNum(rx, ry, velocy, t, p, h, ix, iy, delta)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% GeomSpreadNum.m
%
% Perez-Campos, Xyoli - 02/24/00
%
% This program calulate the geometric spreading, assuming a spherically
% symmetric Earth.
% The variables are:
%	cix = cosine of the take off angle at the receiver
%	ciy = cosine of the take off angle at the source
%	dpddNum = Numeric dp/d(distance)
%	delta = Distance from the source to the receiver
%	geomSpread = Geometrical spreading (output)
%	ix = take off angle at the receiver
%	iy = take off angle at the source
%	p = Slowness parameter
%	rx = Radius to the receiver
%	ry = Radius to the hypocenter
%	t = arrival time vector for P waves
%	velocy = Wave velocity at the source
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%rx, ry, velocy, t, p, h, rad2deg(ix), rad2deg(iy), rad2deg(delta)

cix = cos(ix);
ciy = cos(iy);

%% Numeric derivative of slowness factor with respect to distance (delta) %%%
dpddNum = (t(3) - 2*t(2) + t(1)) / (h^2);

%%% Geometric spreading factor %%%
geomSpread = (rx .* ry ./ velocy) .* ((ciy .* cix .* sin(delta) / p) * ...
				 abs(1 / dpddNum)) .^ 0.5;

