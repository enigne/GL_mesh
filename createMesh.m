clear 
close all
       
%% Basic settings 
EXP = 1;    % Experiment 1 or 3 in MISMIP
A = 4.6416e-25; % MISMIP EXP1 step 1
Nx = 901;       % 200+1
Ny = 16;        % 15+1
L = 1.8e6;      % Length of the ice sheet
hmin = 10;

%% Choose bedrock type
% EXP 1
if EXP == 1
    type = 1;
% EXP 3
elseif EXP == 3
    type = 2;
else
    error('Unknown experiment type')
end

%% Generate unit square and read in the nodes info
unitx = linspace(0,1,Nx);
unity = linspace(0,1,Ny);
[x,y] = meshgrid(unitx,unity);

%% Solve MISMIP for the ice profile
[surf, bed] = SolveMISMIP(A, Nx, L, type);

%% Remeshing 
x0 = min(surf(:,1));
x1 = max(surf(:,1));

% Compute x coordinate
xnew = x0 + x .* (x1 - x0);
    
zs = interp1(surf(:,1), surf(:,2), xnew,'linear');
zb = interp1(bed(:,1), bed(:,2), xnew, 'linear');

% Compute y coordinate
ynew = zb + y .* (zs - zb);    

%% plot
xvec = reshape(xnew, Nx*Ny, 1);
yvec = reshape(ynew, Nx*Ny, 1);
scatter(xvec, yvec)

