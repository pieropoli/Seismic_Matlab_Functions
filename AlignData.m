function DataAlign = AlignData(s,delay)

for id = 1 : length(delay)
    
   DT = delay(id) ;
    
    % align the data
    if DT > 0
    datatmp = zeros(size(s(id,:)));
    datatmp(DT+1:end)=s(id,1:end-DT);
    
    elseif DT < 0
    dt = abs(DT);    
    datatmp = zeros(size(s(id,:)));
    datatmp(1:end-dt)=s(id,dt+1:end);
    
    elseif DT==0 
    datatmp = s(id,:);
    end
    
   DataAlign(id,:) = datatmp; clear datatmp
    
    
end