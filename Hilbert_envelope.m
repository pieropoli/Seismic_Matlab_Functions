function z=Hilbert_envelope(signal)

if size(signal,1)==1
signal_h = hilbert(signal);
z = sqrt(signal_h.*conj(signal_h));
else
    
    for h = 1 : size(signal,1)
        signal_h (h,:) = hilbert(signal(h,:));
        z (h,:) = sqrt(signal_h(h,:).*conj(signal_h(h,:)));
        
    end


end

