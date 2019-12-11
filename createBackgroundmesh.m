clear
clc
close all
%% Basic settings 
EXP = 1;    % Experiment 1 or 3 in MISMIP
A = 4.6416e-24; % MISMIP EXP1 step 1
Nx = 901;       % 200+1
L = 1.6e6;      % Length of the ice sheet
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

%% Solve MISMIP for the ice profile
[surf, bed] = SolveMISMIP(A, Nx, L, type);


%% Load .m file generated by gmsh
myMesh;

%% The mesh was on [0,10]x[0,1], rescale it to [0,1.6e6]x[-1000,5000]
nodes = msh.POS(:, 1:2);
elements = msh.TRIANGLES(:, 1:3);

% [0,10] -> [0,1.6e6]
nodes(:,1) = nodes(:,1) * 1.6e5;
% [0,1] -> [-1000,5000]
nodes(:,2) = nodes(:,2) * 6000 - 1000;

%% visualize in matlab 
figure(1)
triplot(elements,nodes(:,1),nodes(:,2))
hold on
plot(surf(:,1), surf(:,2),'r', 'LineWidth',2)
plot(bed(:,1), bed(:,2),'r', 'LineWidth',2)
