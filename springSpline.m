function pp_spring = springSpline(varargin)
    n = nargin;
    if n == 3
        [K1, K2,dStop] = varargin{:};
        plotFlag = 0;
    elseif n == 4
        [K1, K2,dStop,plotFlag] = varargin{:};
    else
        warning("Wrong number of inputs")
        return
    end

    x = linspace(-2*dStop,2*dStop,1000);
    y = zeros(size(x));

    for i = 1:length(x)
        if x(i)>dStop
            y(i) = K2.*x(i)-dStop*(K2-K1);
        elseif x(i)<-dStop
            y(i) = K2.*x(i)+dStop*(K2-K1);
        else
            y(i) = K1*x(i);
        end
    end

    pp_spring = spline(x,y);

    if plotFlag
        clf
        plot(x,y,'.')
        plot(x,ppval(pp_spring,x))
        axis([-1.5*dStop 1.5 * dStop -K1*dStop*2 K1*dStop*2])
        xlabel("Displacement")
        ylabel("Force (N)")
    end

end