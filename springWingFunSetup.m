function fcnHandle = springWingFunSetup(sim_opts)

% s = [theta,dtheta];

% inertia
switch sim_opts.inertiaMode
    case 'constant'
        I = sim_opts.params.inertia;
    otherwise
        warning('Unexpected inertia mode, please try again')
        return
end

% drag
switch sim_opts.dragMode
    case 'aero'
        beta = sim_opts.params.drag;
        F_d  = @(s) beta*s(2)^2*sign(s(2));
    case 'viscous'
        beta = sim_opts.params.drag;
        F_d  = @(s) beta*s(2);
    otherwise
        warning('Unexpected drag mode, please try again')
        return
end

% elastic
switch sim_opts.springMode
    case 'linear'
        K   = sim_opts.params.spring;
        F_e = @(s) K*s(1);
    case 'mech_stop'
        if length(sim_opts.params.spring)<3
            warning("Mechanical stop requires two parameters")
            return
        else
            Ksmall = sim_opts.params.spring(1);
            Klarge = sim_opts.params.spring(2);
            dStop   = sim_opts.params.spring(3);
            
            spring_spline = springSpline(Ksmall,Klarge,dStop); % add a 1 at the end of the inputs to plot the spline
            
            F_e     = @(s) ppval(spring_spline,s(1));

        end
    otherwise
        warning('Unexpected spring mode, please try again')
        return
end

% transmission
switch sim_opts.transmissionMode
    case 'linear'
        T = sim_opts.params.transmission;
    otherwise
        warning('Unexpected transmission mode, please try again')
        return
end

% force
switch sim_opts.forceMode
    case 'sinusoid'
        amp     = sim_opts.params.force(1);
        freq    = sim_opts.params.force(2);
        u       = @(t) amp*sin(2*pi*freq*t);
    otherwise
        warning('Unexpected force mode, please try again')
        return
end

% The function itself
fcnHandle = @(t,s) [s(2), (1/I)*(u(t)/T - F_d(s) - F_e(s)/T^2)]';


end