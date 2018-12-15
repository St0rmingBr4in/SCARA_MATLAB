%global SCARAVR
%PI, PF position cartésienne initiale et finale

clc
close all
clf
clear

% données d'entrées 1
prompt1 = {'Position X initiale', 'Position Y initiale'};
dlg_title1 = 'Fenêtre position initiale';
num_lines = 1;
default = {'-0.5736', '0.8192'}; %valeur par défaut

Rep = inputdlg(prompt1, dlg_title1, num_lines, default);
PI = [str2double(Rep(1, 1)) str2double(Rep(2, 1))]';


% données d'entrées 2
prompt2 = {'Position X Finale', 'Position Y Finale'};
dlg_title2 = 'Fenêtre position Finale';
num_lines = 1;
default = {'0', '1'};     %valeur par défaut

Rep = inputdlg(prompt2, dlg_title2, num_lines, default);
PF = [str2double(Rep(1, 1)) str2double(Rep(2, 1))]';


to = 0;      %instant initial
tf = 1;      %instant final

a1 = 1;      % longueur bras 1
a2 = 1;      % longueur bras 2
d1 = 1;      % hauteur base souhaitée (pour faire du 3D)

Xi = PI(1, 1);
Yi = PI(2, 1);
Zi = d1;

flag = 0;
Xf = PF(1, 1);
Yf = PF(2, 1);
Zf = d1;

Vo = 0;
Vf = 0;
ao = 0;
af = 0;

%test espace de travail
if Xi > a1
	fprintf('Position initiale hors espace de travail')
	flag = 1;
end

if  Xf > a1
	fprintf('Position finale hors espace de travail')
	flag = 1;
end

[q1i] = Scara_GEOINV(Xi, Yi);
[q2i] = Scara_GEOINV(Xi, Yi);

[q1f] = Scara_GEOINV(Xf, Yf);
[q2f] = Scara_GEOINV(Xf, Yf);

% spline d'ordre 5 pour trajectoire initiale et finale
% à modifier lorqu'on travaille pour le scara pour chaque articulation
A = [1, to, ((to)^2), ((to)^3), ((to)^4), ((to)^5);     % pos init
0, 1, 2 * to, 3 * ((to)^2), 4 * ((to)^3), 5 * ((to)^4); % vit init
0, 0, 2, 6 * to, 12 * ((to)^2), 20 * ((to)^3);          % acc init

1, tf, ((tf)^2), ((tf)^3), ((tf)^4), ((tf)^5);          % pos final
0, 1, 2 * tf, 3 * ((tf)^2), 4 * ((tf)^3), 5 * ((tf)^4); % vit final
0, 0, 2, 6 * tf, 12 * ((tf)^2), 20 * ((tf)^3)];         % acc final

B1 = [q1i; Vo; ao; q1f; Vf; af];
B2 = [q2i; Vo; ao; q2f; Vf; af];

C1 = inv(A) * B1;
C2 = inv(A) * B2;

T = [];      % tableau temps
Q1 = [];     % tableau vecteur arti q1
Q2 = [];     % tableau vecteur arti q1
X = [];      % tableau x
Y = [];      % tableau y
V1 = [];     % tableau des vitesses arti 1
AC1 = [];    % tableau des vitesses arti 2

for t = to:.01:tf-.01
	q1 = C1(1, 1) + C1(2, 1) * t + C1(3, 1) * t^2 + C1(4, 1) * t^3 + C1(5, 1) * t^4 + C1(6, 1) * t^5;  
	v1 = C1(2, 1) + (2 * C1(3, 1) * t) + (3 * C1(4, 1) * t^2) + (4 * C1(5, 1) * t^3) + (5 * C1(6, 1) * t^4); 
	ac1 = (2 * C1(3, 1)) + (6 * C1(4, 1) * t) + (12 * C1(5, 1) * t^2) + (20 * C1(6, 1) * t^3);

	q2 = C2(1, 1) + C2(2, 1) * t + C2(3, 1) * t^2 + C2(4, 1) * t^3 + C2(5, 1) * t^4 + C2(6, 1) * t^5;  
	v2 = C2(2, 1) + (2 * C2(3, 1) * t) + (3 * C2(4, 1) * t^2) + (4 * C2(5, 1) * t^3) + (5 * C2(6, 1) * t^4); 
	ac2 = (2 * C2(3, 1)) + (6 * C2(4, 1) * t) + (12 * C2(5, 1) * t^2) + (20 * C2(6, 1) * t^3);

	x = a1 * cosd(q1);
	y = a1 * sind(q1);
	X = [X x];
	Y = [Y y];
	Q1 = [Q1, q1];
	Q2 = [Q2, q2];
	V1 = [V1 v1];
	AC1 = [AC1 ac1];
	T = [T t];
end

%plot(T, Q1)

title('position articulaire')
figure(1)

%ouverture fenetre VR
%SCARAVR = vrworld('oneddl.wrl');
%open(SCARAVR);
%view(SCARAVR);

%Tracé de la traj désirée

Z = Zi * ones(1, length(X));
plot3(X, Y, Z, 'red', 'linewidth', 2)



%Boucle d'animation


for i = 1:1:length(Q1)
	plot3([0 0], [0  0], [0 Zi], 'green', 'linewidth', 2)
	xlabel('x')
	ylabel('y')
	zlabel('z')
	grid
	hold on
	plot3([Xf Xf], [Yf  Yf], [Zi Zf], 'green', 'linewidth', 3)
	hold on
	plot3(X, Y, Z, 'green', 'linewidth', 3)
	hold on
	Dessiner_SCARA(Q1(i), Q2(i), a1, d1, a2)

	pause(.01)
	hold off
end

hold off
