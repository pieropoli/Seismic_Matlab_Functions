function out = loaddatafromdir(directory)


out = dir(directory);
out(1:2) = [];
