function [V1]=RotateVector(V,theta,dip)

% theta = 0 : 360 is positive from X [is the azimuth]
% dip = 0 : 180 positive from Z
% V = [X Y Z] or [N E Z]

X = V(1);
Y=V(2);
Z = V(3);

X1 = cosd(theta)*cosd(dip)*X - sind(theta)*Y + cosd(theta)*sind(dip)*Z;
Y1 = sind(theta)*cosd(dip)*X + cosd(theta)*Y + sind(theta)*sind(dip)*Z;
Z1 = -sind(dip)*X + cosd(dip)*Z;

V1 = [X1 Y1 Z1];