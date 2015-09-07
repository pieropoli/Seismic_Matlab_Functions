function dsac=readsac(nomfich,inlect)
% dsac=readsac(nomfich,<inlect>)
% Lecture d'un fichier sac
% dsac=readsac(nomfich) avec nomfich : chemin complet du fichier SAC
%			     inlect (optionnel) : type de lecture
%
% sortie :
% dsac est une structure

% par defaut on lit les signaux en mode 'r'

if nargin ==1
	modlect='r';
else
	modlect=inlect;
end

% lecture des signaux
% -------------------

% Suivant le type des signaux la lecture s'effectue de mani�re differente
% pour les stations Minititan :
%	 'l' - IEEE floating point with little-endian byte ordering
% pour les stations Ceispace :
%	'b' - IEEE floating point with big-endian byte ordering 

boolceis=0;	% 0 = Minititan		1 = CEIS

fidev=fopen(nomfich,modlect,'l');


if fidev > 0

h1=fread(fidev,70,'float');		% -----------------
h2=fread(fidev,40,'long');		% lecture du header
h3=fread(fidev,192,'uchar');		% -----------------

% on teste pour savoir dans quel ordre sont ordonn�s les bytes
% (suivant que l'on lit une Ceispace ou une Minititan)

if h2(7)~=6
	boolceis=1;
	fclose(fidev);
	fidev=fopen(nomfich,modlect,'b');
	h1=fread(fidev,70,'float');
	h2=fread(fidev,40,'long');
	h3=fread(fidev,192,'uchar');
end

% lecture de la trace

tamp=fread(fidev,inf,'float');

dsac.h1=h1;
dsac.h2=h2;
dsac.h3=h3;

% lecture des parametres de type float
% ------------------------------------

dsac.tau=h1(1);		% pas d'echantillonage
dsac.pointe=h1(2);
dsac.bt=h1(6);		% begin time (d�calage du 1er �chantillon)
dsac.evt0=h1(8);	% Temps origine de l'�v�nement / r�f�rence
dsac.atime=h1(9);   % Temps pointe par ppk de Sac

dsac.tp1=h1(11);
dsac.tp2=h1(12);
dsac.tp3=h1(13);	% Temps des phases point�es (10 possibles en fait)
dsac.tp4=h1(14);
dsac.tp5=h1(15);


dsac.slat=h1(32);
dsac.slon=h1(33);	% Coordonn�es de la station
dsac.salt=h1(34);

dsac.elat=h1(36);
dsac.elon=h1(37);	% Coordonn�es de l'�v�nement
dsac.edep=h1(39);

dsac.us1=h1(41);
dsac.us2=h1(42);	% Espace libre (10 possibles en fait)
dsac.us3=h1(43);

dsac.distkm=h1(51);	% distance ev-sta en km
dsac.az=h1(52);		% azimut ev-sta
dsac.baz=h1(53);	% backazimut ev-sta
dsac.dist=h1(54);	% distance ev-sta en degr�es
dsac.cmpaz=h1(58);	% azimut composante
dsac.cmpinc=h1(59);	% incidence composante


% lecture des parametres de type long
% -----------------------------------

			% Temps origone du 1er echantillon
dsac.an=h2(1);
dsac.jr=h2(2);
dsac.hr=h2(3);
dsac.mn=h2(4);
dsac.sec=h2(5)+h2(6)/1000;

dsac.npts=h2(10);	% Nombre de points

% lecture des parametres de type uchar
% ------------------------------------

%dsac.staname=char(h3(1:8))';	% Nom de la station
dsac.staname=rm_blanc(h3(1:8))';

dsac.evname=rm_blanc(h3(9:24))';	% Nom de l'�v�nement (region)

dsac.ktp1=rm_blanc(h3(49:56))';
dsac.ktp2=rm_blanc(h3(57:64))';
dsac.ktp3=rm_blanc(h3(65:72))';	% Identification des point�s h1(11:20)
dsac.ktp4=rm_blanc(h3(73:80))';
dsac.ktp5=rm_blanc(h3(81:88))';

dsac.kus1=rm_blanc(h3(137:144))';
dsac.kus2=rm_blanc(h3(145:152))';	% Espace libre
dsac.kus3=rm_blanc(h3(153:160))';

dsac.kcomp=rm_blanc(h3(161:168))';	% Nom de la composante
dsac.kinst=rm_blanc(h3(185:192))';	% Nom de l'instrument


% lecture de la trace
% -------------------

dsac.trace=tamp;

if strcmp(modlect,'r+')
	dsac.fidev=fidev;
else
	fclose(fidev);
end

end
if fidev==-1
	disp('erreur de lecture - fichier inexistant')
	dsac.tau=-1;

end

function ch1=rm_blanc(ch)
 
% recherche les blancs de la chaine ch et les enleve
 if ischar(ch)
         ch1=ch(find(double(ch)~=32));
 else
         ch1=ch(find(ch~=32));
         ch1=char(ch1);
 end 
