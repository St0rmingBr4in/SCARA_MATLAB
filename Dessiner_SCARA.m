function DessinerSCARA = Dessiner_SCARA(T1, T2, a1, a2, d1)

%%%%%%%% Tracé du bras 1
X_1 = a1 * cosd(T1);
Y_1 = a1 * sind(T1);
plot3([0 X_1], [0 Y_1], [d1 d1], 'blue', 'linewidth', 7)

%%%%%%%% Tracé du bras 2
X_2 = a2 * cosd(T2 + T1);
Y_2 = a2 * sind(T2 + T1);
plot3([X_1 (X_2 + X_1)], [Y_1  (Y_1 + Y_2)], [d1 d1], 'green', 'linewidth', 7)

axis([-(2 * a1) (2 * a1) -(2 * a1) (2 * a1) 0 d1])
hold off
