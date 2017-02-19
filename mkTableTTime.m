% this fucntion makes the table for travel time given a phase
clear
clc

phase='directPprem_0_700kmdepth_0_90distance';


dx=.1;
dz=.1;

d=0:dx:90;
z=0:dz:700;

count=1;
for id = 1 : length(d)
   for iz = 1 : length(z)
    
    tic   
    a=tauptime('dep',z(iz),'ph','ttp+','deg',d(id),'mod','prem');
    if isempty(a)==0
    A=a(1,1).time(1);    
    P=a(1,1).rayparameter;
    if count==1
    mmodel=a(1,1).modelname;
        
    end
    
    ttime(count)=A(1);
    ddist(count)=d(id);
    depth(count)=z(iz);    
    rayp(count)=P;  

    count=count+1; 

    end    
    
    
   end

end

eval(['save travelTime_' char(phase) ' mmodel ttime ddist rayp depth'])
