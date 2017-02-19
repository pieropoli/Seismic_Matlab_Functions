function [ disp ] = wv_integrate( vel,dt )

    clear vel2
    vel2 = vel;
    tt = (0:length(vel)-1)*dt;
    vel2 = vel2 - mean(vel2);
    vel2 = detrend(vel2);
    disp = cumtrapz(tt,vel2);

    return

