function [out] = ModGeoInv(X, Y, a1, a2)
	t2 = acosd((X^2 + Y^2 - a1^2 - a2^2) / (2 * a1 * a2));
	t1 = atan2d(Y, X) - atan2d(a2 * sind(t2), a1 + a2 * cosd(t2));
out = [t1 t2];
