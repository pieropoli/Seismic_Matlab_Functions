function dateout=obspyTimeToMat(timein)

year =str2num(timein(1:4));
month  = str2num(timein(6:7));
day  = str2num(timein(9:10));
hour  = str2num(timein(12:13));
min  = str2num(timein(15:16));
sec  = str2num(timein(18:19));

dateout = [year month day hour min sec];