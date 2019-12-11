function [surf, bed] = initializeIce(N, L, Hinit, type, sea_level)
    %% Set default values
    if (nargin < 1)
        N = 901;
    end
    if (nargin < 2)
        L = 1.8e6;
    end
    if (nargin < 4)
        Hinit = 10;
    end
    if (nargin < 3)
        type = 1;
    end
    if (nargin < 5)
        sea_level = 0;
    end
    %%
    rhoi = 0.9;
    rhow = 1.0;
    x_grid = linspace(0, L, N)';
    % Use positive b as above sea level
    b = -SMcold_bedheight(x_grid, type);
    H = Hinit + zeros(N,1);

    %% floating condition for ice sheet geometry determination
    haf = b-sea_level+H*rhoi/rhow; % height above floating
    b(haf<0) = sea_level-rhoi*H(haf<0)/rhow;
	s = b + H;
    
    surf = [x_grid, s];
    bed = [x_grid, b];
end