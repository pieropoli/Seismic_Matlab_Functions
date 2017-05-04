function [vertPhorzS] = FreeSurfaceCoeff(ix, alfax, betax)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% FreeSurfaceCoeff.m
% 
% Perez-Campos, Xyoli - 04/17/98
%
% This program calculates the free-surface reflection coefficient
% given the slowness parameter, the P-wave and the S-wave velocities at the
% surface (Aki and Richards, 1980, p. 140).
%
% Variables:
%	alfax = P-wave velocity at the receiver
%	betax = S-wave velocity at the receiver
%	p = slowness parameter

%	vertPhorzS = Amplificatipn factor to be applied to the vertical
%		     component of P motion or the horizontal component of SV 
%		     motion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pP = sin(ix)/alfax;

%% Coefficients to make easy the calculations %%

G = 1/betax^2 - 2*pP^2;

j = asin(betax * pP);

Q = (4 * pP^2 * cos(ix) * cos(j)) / (alfax * betax);

D = G^2 + Q;	% D is the Rayleigh denominator

%%% Amplification factors for the vertical component of P wave %%%
vertPhorzS = ((2 / betax^2) * G * cos(ix)) / D;