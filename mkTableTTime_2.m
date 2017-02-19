% this fucntion makes the table for travel time given a phase
clear
clc


phase='Schile';

dx=0.1;
dz=1;
dmin = 0 ;
dmax = 20;
hmin = 0;
hmax = 50;

D = dmin : dx : dmax ;
h = hmin : dz : hmax;

for i1 = 1 : length(D)
    for i2 = 1 : length(h)
        
        
        [tp,qp] = TravelTimeTaupPhasesDistance(D(i1),'PKIKPPKIKP',h(i2),'/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/EGF/src/chile');
        
        
        
        
        
    end
end