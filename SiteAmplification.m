function [ampFactor] = SiteAmplification(depth, velocity, ...
		  density, velocityReceiver, densityReceiver, f)
 
% SiteAmplification.m
% -----------------------------------------------------------
% Usage: [ampFactor] = SiteAmplification(depth, velocity, ...
%         density, velocityReceiver, densityReceiver, f) 
% -----------------------------------------------------------
% This function calculates the amplification originated close to the station
% due to the geology in the las meters under the receiver.
% Input:
% 	Velocity model: depth, velocity, density. They are vectors of the same
% 					size.
%   velocityReceiver, densityReceiver. Velocity and density in the surrounding
%   				area of the receiver.
%

n = length(depth);

travelTime = zeros(size(depth));
slope = zeros(size(depth));
thickness = zeros(size(depth));
avgDensity = ones(size(depth));
for i = 2 : n
   if velocity(i) == velocity(i - 1)	% Constant velocity
      slope(i) = 0;
      travelTime(i) = travelTime(i - 1) + (depth(i) - depth(i - 1)) / velocity(i);
   else
      if depth(i) == depth(i - 1)	% Step change
         slope(i) = 1e10;
         travelTime(i) = travelTime(i - 1);
      else
         slope(i) = (velocity(i) - velocity(i-1)) / (depth(i) - depth(i-1));
         travelTime(i) = travelTime(i-1) + (1 / slope(i)) * ...
						 log(velocity(i) / velocity(i-1));
      end
   end
   avgDensity(i) = 1 / travelTime(i) * (travelTime(i-1) * avgDensity(i-1) + ...
				   (travelTime(i) - travelTime(i-1)) * ...
				   (density(i) + density(i-1)) / 2);
   thickness(i) = depth(i) - depth(i-1); 
   velocityLayer(i) = thickness(i) / (travelTime(i) - travelTime(i-1));
   densityLayer(i) = (density(i) + density(i)) / 2;
   avgVelocity(i) = depth(i) / travelTime(i);
   freq(i) = 1 / (4 * travelTime(i));
   amplification(i) = sqrt((densityReceiver * velocityReceiver) / ...
					  (avgDensity(i) * avgVelocity(i)));
end

if depth(1) == 0
   freq = freq(2:end);
   amplification = amplification(2:end);
end
% loglog(freq, amplification)
% 
f = f(find(f(:,1)~=0),:);
ampFactor = 10 .^ interp1(log10(freq(find(freq~=0))), log10(amplification(find(freq~=0))), log10(f), ...
			'linear', 'extrap');
