function z = SMsurface(x,h, params)

m = params.m;
C = params.C;
rho_g = params.rho_g;
a = params.a;
type = params.type;


b_x = SMcold_bedslope(x, type);
s = a*x;

z = b_x - (C/rho_g)*s.^m./h.^(m+1);
