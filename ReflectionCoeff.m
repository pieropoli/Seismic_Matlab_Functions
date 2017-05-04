function [PP, SP] = ReflectionCoeff(iypP, iysP, alfax, betax)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ReflectionCoeff.m
% 
% Perez-Campos, Xyoli - 04/17/98
%
% This program calculates the free-surface reflection coefficients (PP and SP)
% given the take-off-angle, the P-wave and the S-wave velocities at the
% receiver (Aki and Richards, 1980, p. 140).
%
% Variables:
%	alfax = P-wave velocity at the receiver
%	betax = S-wave velocity at the receiver
%	ci = coeffients to calculate PP and SP (i is a counter)
%	ix = take-off-angle at the receiver
%	na = vertical slowness for alfa
%	nb = vertical slowness for beta
%	p = slowness parameter
%	PP = Reflection coefficient for reflected P
%	SP = Reflection coefficient for reflected S, including spherical 
%	     correction
%       spherCorr = Spherical correction = etha_alfa / etha_beta
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%
% For an incident P wave %
%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Horizontal slowness %%%
i =  deg2rad(180) - iypP;	% for pP wave
ppP = sin(i)/alfax;

j = asin(betax*ppP);	% for SV wave

%% Coefficients to make easier the calculations %%
c1pP = 4*ppP.^2.*(cos(i)/alfax).*(cos(j)/betax);
c2pP = ((1/betax).^2 - 2*ppP.^2).^2;

%%% Reflected P %%%
PP = (c1pP - c2pP) ./ (c1pP + c2pP);

%%%%%%%%%%%%%%%%%%%%%%%%%%
% For an incident S wave %
%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Horizontal slowness %%%
j = deg2rad(180) - iysP;	 % for sP wave
psP = sin(j)/betax;

i = asin(alfax*psP);	% for P wave

%% Coefficients to make easy the calculations %%
c1sP = 4*psP.^2.*(cos(i)/alfax).*(cos(j)/betax);
c2sP = ((1/betax).^2 - 2*psP.^2).^2;
c3sP = 4 * (betax/alfax) * psP .* (cos(j)/betax) .* sqrt(c2sP);

%% Spehricity coerrection %%
spherCorr =  betax*cos(i)./(alfax*cos(j));

%%% Reflected S %%%
SP = c3sP ./ (c1sP + c2sP);
SP = spherCorr .* SP;

