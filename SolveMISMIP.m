function [surf, bed] = SolveMISMIP(A, N, L, type)
    %% Set default values
    if (nargin < 1)
        A = 4.6416e-24;
    end
    if (nargin < 2)
        N = 901;
    end
    if (nargin < 3)
        L = 1.8e6;
    end
    if (nargin < 4)
        type = 1;
    end
    
    %% Set Mesh parameters
    %-----------------------------------------------------------------------
    %Specify your computational grid
    %-----------------------------------------------------------------------
    meshdx = L/(N-1);
    user_grid = linspace(0,L,N);

    %% Set physical parameters
    %-----------------------------------------------------------------------
    %Parameters as defined in Schoof 2007, see also the MISMIP specifications
    %-----------------------------------------------------------------------
    % A has to be two times given A in MISMIP test
%   A = 2*A;
    
    n = 3;                  %Glen's law exponent
    m =  1/3;               %sliding exponent
    r = 0.9;                %ratio of ice to water density
    rho_g = 900*9.8;           %900 kg m^{-3} * 9.8 m s^{-2}
    C = 7.624e6;            %m = 1/3 value
    %for both, tau_b = 80kPa gives u ~ 35 m a^(-1)
    a = 0.3/(365.25*24*3600);  % Accumulation Rate
    theta = 0;              %cold (theta = 1) or warm (theta = 0) boundary layer specifications,
    %models A and B respectively in Schoof 2007

    % Assemble parameters
    params.m = m;
    params.n = n;
    params.A = A;
    params.C = C;
    params.rho_g = rho_g;
    params.r = r;
    params.a = a;
    params.theta = theta;
    params.type = type;

    %% Calculate GL position
    %-----------------------------------------------------------------------
    %Newton iteration parameters
    %-----------------------------------------------------------------------

    %initial guess of grounding line position (metres)
    % x = 1.270e6;     % EXP 3 -step 4-10
    x = 0.70e6;        % EXP 1 -step 1-4


    delta_x = meshdx*0.001;       %finite difference step size (metres) for gradient calculation

    tolf = 1e-6;        %tolerance for finding zeros
    normf = tolf + eps;

    toldelta = 1e1;     %Newton step size tolerance
    dx = toldelta + 1;

    %-----------------------------------------------------------------------
    %Newton iteration
    %-----------------------------------------------------------------------
    while (normf > tolf) || (abs(dx) > toldelta)
        f = SMcold_function(x, params);
        normf = abs(f);
        grad = (SMcold_function(x+delta_x,params)-f)/delta_x;
        dx = -f/grad;
        x = x + dx;
    end
    %computes steady state grounding line position x based
    %on intial guess, using equations (20) and
    %(24) in Schoof 2007

    %% Calculate thickness of the ice sheet
    %-----------------------------------------------------------------------
    %Calculate ice surface elevation S_Soln for grounded sheet
    %-----------------------------------------------------------------------
    grounded = user_grid(user_grid < x).';
    x_grid = [x; grounded(length(grounded):-1:1)];
    %specifies the grid points on which  ice surface elevations are to be calculated
    %these are in reverse order, i.e. counting
    %backwards from the grounding line at x to the ice
    %divide at zero. FIRST POINT MUST BE GROUNDING LINE
    %POSITION x COMPUTED ABOVE, EVEN IF THIS IS NOT
    %INCLUDED IN YOUR COMPUTATIONAL GRID

    h_f = SMcold_bedheight(x, type)/r;
    %computes ice thickness at the grounding line as
    %initial condition

    options = odeset('AbsTol',1e-6,'RelTol',1e-6);%odeset('AbsTol',f/1e-3);

    func = @(x,y)SMsurface(x,y,params);

    f = @(x)parameterfun(x,a,b,c);

    [X_soln,H_soln] = ode45(func,x_grid,h_f,options);
    %computes ice THICKNESS H_soln at points with
    %position X_soln

    S_soln = H_soln - SMcold_bedheight(X_soln, type);
    %computes ice surface elevation by adding bed
    %elevation

%     figure

    plot(X_soln,-SMcold_bedheight(X_soln, type),'k')
    hold on
    plot(X_soln,S_soln,'b')

    %H_soln is now rearranged and the point
    %corresponding to the grounding line location is expunged to input these data into your
    %computational grid:
    bed=[X_soln,-SMcold_bedheight(X_soln, type)];
    surf=[X_soln,S_soln];

    S_soln = S_soln(length(S_soln):-1:2);

    H_soln = H_soln(length(H_soln):-1:2);


    %% Calculate thickness of shelf
    %-----------------------------------------------------------------------
    %Calculate ice thickness for shelf from van der Veen (1986)
    %-----------------------------------------------------------------------

    floating = user_grid(user_grid > x).';

    q_0 = a*x;

    H_soln2 = h_f*(q_0 + a*(floating-x))./(q_0^(n+1) + h_f^(n+1)*((1-r)*rho_g/4)^n*A*((q_0 + a*(floating-x)).^(n+1) - q_0^(n+1))/a).^(1/(n+1));

    plot([x; floating],(1-r)*[h_f; H_soln2],'b');

    plot([x; floating],-r*[h_f; H_soln2],'b');

    surf=[surf(end:-1:2,:);[floating,(1-r)*H_soln2]];

    bed=[bed(end:-1:2,:);[floating,-r*H_soln2]];

%     user_thickness = [H_soln;H_soln2];
% 
%     %% SAVE data
% 
%     save('bed.dat','bed','-ascii');
%     save('surf.dat','surf','-ascii');
end