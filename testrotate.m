clear
clc
close all
 theta = 180;
 dip = 10;
 
 
 Z = 0;
 X= 1;
 Y = 0;
 V = [X Y Z];
 [V1]=RotateVector(V,theta,dip);
 X1 = V1(1);
 Y1 = V1(2);
 Z1 = V1(3);
 
%  X1 = cosd(theta)*cosd(dip)*X - sind(theta)*Y + cosd(theta)*sind(dip)*Z
%  Y1 = sind(theta)*cosd(dip)*X + cosd(theta)*Y + sind(theta)*sind(dip)*Z
%  Z1 = -sind(dip)*X + cosd(dip)*Z
%  
%  
 sqrt(X1^2 + Y1^2 + Z1^2)
 
 plot3([0 X],[0 Y],[0 Z],'-o')
 hold all
  plot3([0 X1],[0 Y1],[0 Z1],'-o')
  grid on
  xlim([-1 1])
  ylim([-1 1])
  zlim([-1 1])
  
  
  figure
  
  subplot(221)
  plot([0 X],[0 Y],'-o')
  hold all
  plot([0 X1],[0 Y1],'-o')
    xlim([-1 1])
  ylim([-1 1])
  
  
  subplot(222)
  plot([0 X],[0 Z],'-o')
  hold all
  plot([0 X1],[0 Z1],'-o')
    xlim([-1 1])
  ylim([-1 1])
  
  subplot(223)
  plot([0 Y],[0 Z],'-o')
  hold all
  plot([0 Y1],[0 Z1],'-o')
  xlim([-1 1])
  ylim([-1 1])