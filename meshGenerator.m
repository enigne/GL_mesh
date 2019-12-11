function meshGenerator(Nx, A, EXP)
if nargin < 3
    EXP = 3;
    if nargin < 2
        A = 1.5e-25;
        if nargin < 1
            Nx = 200;
        end
    end
end

%% Other Basic settings
Ny = 11;        % 15+1
L = 1.6e6;      % Length of the ice sheet
scale = 1;
partition = 0;

TempMeshName = 'tempSquare';
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
MeshName = ['square', 'N', num2str(Nx)];

%% Generate unit square and read in the nodes info
templateMesh = [path, TempMeshName, '.grd'];
baseMesh = [path, MeshName, '.grd'];
meshNodeFileName = [path, MeshName, '/mesh.nodes'];
system(['sed ''s/#NX#/', num2str(Nx), '/'' ', templateMesh,'>',baseMesh]);
system(['ElmerGrid 1 2 ', baseMesh]);
system(['rm ', baseMesh]);

meshfile = fopen(meshNodeFileName, 'r');
data = fscanf(meshfile, '%f', [5, (Nx+1)*Ny])';
fclose(meshfile);

%% Solve MISMIP for the ice profile
if A == 0
    [surf, bed] = initializeIce((Nx+1), L, hmin, type);
else
    [surf, bed] = SolveMISMIP(A*2, (Nx+1), L, type);
end
%% Remeshing
meshfile = fopen(meshNodeFileName, 'w');
x0 = min(surf(:,1));
x1 = max(surf(:,1));

for i = 1: (Nx+1)*Ny
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
% system(['ElmerGrid 2 5 ',[path, MeshName]]);
system(['rm -rf ', [path, OutputName]]);
system(['mv ',[path, MeshName],' ', [path, OutputName]]);

%% Categry mesh files
system(['mkdir -p N', num2str(Nx)]);
objFolder = ['N', num2str(Nx), '/N', num2str(Nx),'_A', num2str(A*1e27)];
system(['rm -rf ', objFolder]);
system(['mv ', OutputName, ' ', objFolder]);
