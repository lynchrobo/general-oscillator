function pp_spring = springSpline(varargin)
    n = nargin;
    if n == 3
        [Ksmall, Klarge,dStop] = varargin{:};
        plotFlag = 0;
    elseif n == 4
        [Ksmall, Klarge,dStop,plotFlag] = varargin{:};
    else
        warning("Wrong number of inputs")
        return
    end

    x = linspace(-2*dStop,2*dStop,1000);
    y = zeros(size(x));

    for i = 1:length(x)
        if x(i)>dStop
            y(i) = Klarge.*x(i)-dStop*(Klarge-Ksmall);
        elseif x(i)<-dStop
            y(i) = Klarge.*x(i)+dStop*(Klarge-Ksmall);
        else
            y(i) = Ksmall*x(i);
        end
    end

    pp_spring = spline(x,y);

    if plotFlag
        clf
        plot(x,y,'.')
        plot(x,ppval(pp_spring,x))
    end

end