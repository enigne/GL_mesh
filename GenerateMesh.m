clear 
close all
       
%% Basic settings 
EXP = 1;    % Experiment 1 or 3 in MISMIP
A = 4.6416e-24; % MISMIP EXP1 step 1
% A = 6e-25; % MISMIP EXP1 initialize
Nx = 1601;       % 900+1
Ny = 11;        % 15+1
L = 1.6e6;      % Length of the ice sheet
scale = 1;
partition = 0;

MeshName = 'square';
path = './';
hmin = 100*scale; % Minimal thickness

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

outputSuffix = ['EXP',num2str(EXP)];
OutputName = ['MISMIP_',outputSuffix];

%% Generate unit square and read in the nodes info
baseMesh = [path, MeshName, '.grd'];
meshNodeFileName = [path, MeshName, '/mesh.nodes'];

system(['ElmerGrid 1 2 ', baseMesh]);
meshfile = fopen(meshNodeFileName, 'r');
data = fscanf(meshfile, '%f', [5, Nx*Ny])';
fclose(meshfile);

%% Solve MISMIP for the ice profile
if A == 0 
    [surf, bed] = initializeIce(Nx, L, hmin, type);
else 
    [surf, bed] = SolveMISMIP(A, Nx, L, type);
end
%% Remeshing 
meshfile = fopen(meshNodeFileName, 'w');
x0 = min(surf(:,1));
x1 = max(surf(:,1));

for i = 1: Nx*Ny
    id = data(i, 1);
    flag = data(i, 2);
    x = data(i, 3);
    y = data(i, 4);
    
    z = data(i, 5);
    
    xnew = x0 + x .* (x1 - x0);
    
    zs = interp1(surf(:,1), surf(:,2), xnew);
    zb = interp1(bed(:,1), bed(:,2), xnew);

    ynew = zb + y .* max((zs - zb), hmin);
    
    fprintf(meshfile, '%d %d %g %g %g\n', id, flag, xnew*scale, ynew*scale, z);
end

fclose(meshfile);

%% Partition
if partition > 1
    system(['ElmerGrid 2 2 ',[path, MeshName], ' -partition ', num2str(partition), ' 1 0 2']);
end

%% Generate output
system(['ElmerGrid 2 5 ',[path, MeshName]]);
system(['rm -rf ', [path, OutputName]]);
system(['mv ',[path, MeshName],' ', [path, OutputName]]);