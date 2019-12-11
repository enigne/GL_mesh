function z = SMcold_bedslope(x, type)
    %FIRST DERIVATIVE OF DEPTH OF BED BELOW SEA LEVEL; must agree with
    %SMcold_bedheight.
    if (nargin < 2)
        type = 1;
    end

    if (type == 2)
        z = -(-2184.8*2*x/7.5e5^2 + 1031.72*4*x.^3/7.5e5^4 - 151.72*6*x.^5/7.5e5^6);
    else
        z = 778.5/7.5e5;
    end
end