function z = SMcold_bedheight(x, type)
    %DEPTH OF BED BELOW SEA LEVEL, i.e. gives b(x) in Schoof 2007.
    %NOTE the sign convention, SMcold_bedheight is positive if the bed is below
    %sea level, negative if above sea level.
    if (nargin < 2)
        type = 1;
    end

    if (type == 2)
        z = -(729 - 2184.8*(x/7.5e5).^2 + 1031.72*(x/7.5e5).^4 - 151.72*(x/7.5e5).^6);
    else
        z =  -720 +778.5*(x/7.5e5);
    end
end