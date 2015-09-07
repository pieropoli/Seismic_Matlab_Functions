function  [cmt]=readPSMECA(name)
% function to read the PSMECA files from the cmt catalog 

[cmt.lon, cmt.lat,cmt.depth,cmt.mrr,cmt.mtt,cmt.mpp,cmt.mrt,cmt.mrp,cmt.mtp,cmt.iexp,cmt.X,cmt.Y,cmt.name]=textread(char(name),'%f%f%f%f%f%f%f%f%f%f%s%s%s %*[^\n]');
