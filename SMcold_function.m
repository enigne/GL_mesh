function z = SMcold_function(x,params)
%Evaluates function whose zeros define x_g in `cold' steady marine sheet
%problem

m = params.m;
n = params.n;
A = params.A;
C = params.C;
rho_g = params.rho_g;
r = params.r;
a = params.a;
theta = params.theta;
type = params.type;


h_f = r^(-1)*SMcold_bedheight(x,type);
b_x = SMcold_bedslope(x,type);
s = a*x;

z = theta*a + C*s.^(m+1)./(rho_g*h_f.^(m+2)) - theta*s.*b_x./h_f - A*(rho_g*(1-r)/4)^n*h_f.^(n+1);
