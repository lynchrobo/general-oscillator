function dsdt = springWingSim(t,s,sim_opts)

% reset
dsdt    = zeros(2,1);
theta   = s(1);
dtheta  = s(2);


% inertia
switch sim_opts.inertiaMode
    case 'constant'
        I = sim_opts.params.inertia;
    otherwise
        warning('Unexpected mode, please try again')
        return
end

% drag
switch sim_opts.dragMode
    case 'aero'
        beta = sim_opts.params.drag;
        F_d  = beta*dtheta^2*sign(dtheta);
    case 'linear'
        beta = sim_opts.params.drag;
        F_d  = beta*dtheta;
    otherwise
        warning('Unexpected mode, please try again')
        return
end

% elastic
switch sim_opts.springMode
    case 'linear'
        K   = sim_opts.params.spring;
        F_e = K*theta;
    case 'mech_stop'
        if length(sim_opts.params.spring)<2
            warning("Mechanical stop requires two parameters")
            return
        else
            Klinear = sim_opts.params.spring(1);
            dStop   = sim_opts.params.spring(2);
            F_e     = Klinear*atanh(theta./dStop);
        end
    otherwise
        warning('Unexpected mode, please try again')
        return
end

% transmission
switch sim_opts.transmissionMode
    case 'linear'
        T = sim_opts.params.transmission;
    otherwise
        warning('Unexpected mode, please try again')
        return
end

% force
switch sim_opts.forceMode
    case 'sinusoid'


end