v = [-1 -12];
theta = 5;
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
vR = v*R;
quiver(0,0,v(1),v(2))
hold on
quiver(0,0,vR(1),vR(2))
