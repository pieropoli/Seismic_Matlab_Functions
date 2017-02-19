function out=delayTrace(input,dt)
warning off
% dt is in sample
    out = zeros(size(input));
    % align the data
    if dt > 0
    out = zeros(size(input));
    out(dt+1:end)=input(1:end-dt);    
    elseif dt < 0
    dt = abs(dt);    
    out = zeros(size(input));
    out(1:end-dt)=input(dt+1:end);
    
    elseif dt==0 
    out = input;
    end