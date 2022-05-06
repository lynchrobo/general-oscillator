function fcnHandle = springWingFunSetup(sim_opts)

% Synch Modes:  s = [theta,dtheta/dt];
% Asynch Modes: s = [theta,dtheta/dt,dSA,d(dSA)/dt]

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
    case 'piecewise'
        if length(sim_opts.params.spring)<3 || length(sim_opts.params.spring)>4
            warning("Piecewise spring requires 3 or 4 parameters")
            return
        elseif length(sim_opts.params.spring)==3
            [K1,K2,dStop] = matsplit(sim_opts.params.spring);
        else    
            [K1,K2,dStop,plotFlag] = matsplit(sim_opts.params.spring);
        end
        
        spring_spline = springSpline(K1,K2,dStop,plotFlag);
        
        F_e     = @(s) ppval(spring_spline,s(1));
        
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
    case 'par_sine'
        amp         = sim_opts.params.force(1);
        freq        = sim_opts.params.force(2);
        u           = @(t) amp*sin(2*pi*freq*t);
        % The function output
        fcnHandle   = @(t,s) [s(2), (1/I)*(u(t)/T - F_d(s) - F_e(s)/T^2)]';
    
    case 'ser_sine'
        amp         = sim_opts.params.force(1);
        freq        = sim_opts.params.force(2);
        u           = @(t,s) amp*sin(2*pi*freq*t) - s(1);
        % The function output
        fcnHandle   = @(t,s) [s(2), (1/I)*(u(t)/T - F_d(s) - F_e(s)/T^2)]';
        
    case 'dSA3'  % 3-parameter dSA
        r3      = sim_opts.params.force(1);
        kappa   = sim_opts.params.force(2);
        mu      = sim_opts.params.force(3);
        
        % make dSA coefficients
        a1      = r3*(1-kappa);
        a2      = r3*(1+kappa);
        a3      = kappa*r3^2;        
        u       = @(s) mu*s(3);
        % The function output
        fcnHandle = @(t,s) [s(2);... 
                            (1/I)*(u(s)/T - F_d(s) - F_e(s)/T^2);...
                            s(4);...
                            -a1*T*s(2)-a2*s(4)-a3*s(3)];
    otherwise
        warning('Unexpected force mode, please try again')
        return
end




end