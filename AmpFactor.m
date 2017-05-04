function amp = AmpFactor(freq,k)


f=[0.01 0.1 .2 .3 .5 .9 1.25 1.8 3 5.3 8];
amp=[1 1.02 1.03 1.05 1.07 1.09 1.11 1.12 1.13 1.14 1.15];

amp=interp1(f,amp,freq);
amp=amp.*exp(-pi.*freq.*k);