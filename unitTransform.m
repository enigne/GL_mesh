clear
%%
rho_i = 900;    %   kg*m^-3 
rho_w = 1000;   %   kg*m^-3
g = 9.81;       %   m*s^-2
A = 4.6416e-25;        %   MPa^-3 a^-1
a = 0.3;        %   m/a
C = 7.624e6;    %   Pa*m^(-1/3)*s^(-1/3)
year2sec = 365*24*3600; 
km2m = 1000;
MPa2Pa = 1e6;
%% To MPa-m-a
rho_i_uni = rho_i/(MPa2Pa*year2sec^2);
rho_w_uni = rho_w/(MPa2Pa*year2sec^2);
g_uni = g*year2sec^2;
A_uni = A*year2sec*MPa2Pa^3;
C_uni = C /(MPa2Pa*year2sec^(1/3));

disp('==========================');
disp('Using MPa-m-a unit system');
disp('==========================');
disp(['rho_i=', num2str(rho_i_uni)]);
disp(['rho_w=', num2str(rho_w_uni)]);
disp(['g=', num2str(g_uni)]);
disp(['A=', num2str(A_uni)]);
disp(['C=', num2str(C_uni)]);
disp('==========================');

%% To MPa-km-a
rho_i_uni = rho_i/(MPa2Pa*year2sec^2)*km2m^2;
rho_w_uni = rho_w/(MPa2Pa*year2sec^2)*km2m^2;
g_uni = g*year2sec^2/km2m;
A_uni = A*year2sec*MPa2Pa^3;
a_uni = a/km2m;
C_uni = C /(MPa2Pa*year2sec^(1/3)/km2m^(1/3));

disp('==========================');
disp('Using MPa-km-a unit system');
disp('==========================');
disp(['rho_i=', num2str(rho_i_uni)]);
disp(['rho_w=', num2str(rho_w_uni)]);
disp(['g=', num2str(g_uni)]);
disp(['A=', num2str(A_uni)]);
disp(['a=', num2str(a_uni)]);
disp(['C=', num2str(C_uni)]);
disp('==========================');
