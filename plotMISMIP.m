clear
close all
%%
EXP = 3;    % Experiment 1 or 3 in MISMIP
% A = 4.6416e-24*2; % MISMIP EXP1 step 1
A = 3e-25*2; % MISMIP EXP3 step 1
% A = 0; % MISMIP EXP1 initialize
Nx = 8001;       % 900+1
Ny = 11;        % 15+1
L = 1.6e6;      % Length of the ice sheet
scale = 1;
partition = 0;

MeshName = 'square';
path = './';
hmin = 10*scale; % Minimal thickness
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
[surf, bed] = initializeIce(Nx, L, hmin, type);

%%
subplot(2,1,2)
SolveMISMIP(A, Nx, L, type);
hold on 
plot(bed(:,1),-SMcold_bedheight(bed(:,1), type),'k','linewidth',2)
xlabel('x/m');
ylabel('z/m');
ylim([-1000,5000])
title('Steady State')

subplot(2,1,1)
plot(surf(:,1),surf(:,2),'b','linewidth',2)
hold on
plot(bed(:,1),bed(:,2),'b','linewidth',2)
plot(bed(:,1),-SMcold_bedheight(bed(:,1), type),'k','linewidth',2)
ylim([-1000,5000])
xlabel('x/m');
ylabel('z/m');
title('t=0')

