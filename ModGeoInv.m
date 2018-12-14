function [out] = ModGeoInv(X, Y, a1, a2)
	t2 = acos((X^2 + Y^2 - a1^2 - a2^2) / (2 * a1 * a2));
	t1 = atan2(Y, X) - atan2(a2 * sin(t2), a1 + a2 * cos(t2));
out = [t1 t2];
