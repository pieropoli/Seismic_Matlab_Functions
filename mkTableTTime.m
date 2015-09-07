% this fucntion makes the table for travel time given a phase
clear
clc


phase='directP';

dx=0.1;
dz=1;

d=dx:dx:180;
z=dz:dz:800;


count=1;
for id = 1 : length(d)
   for iz = 1 : length(z)
    
       
    a=tauptime('dep',z(iz),'ph','ttp+','deg',d(id));
    if isempty(a)==0
    A=a(1,1).time(1);    
    P=a(1,1).rayparameter;
    if count==1
    model=a(1,1).modelname;
        
    end
    
    t(count)=A(1);
    dist(count)=d(id);
    depth(count)=z(iz);    
    rayp(count)=P;  

    count=count+1; 

    end    
    
    
   end

end

table.model=model;
table.traveltim=t;
table.depth=depth;
table.rayp=rayp;
table.distance=dist;


eval(['save travelTime_' char(phase) ' table'])
