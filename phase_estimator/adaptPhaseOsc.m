function dsdt = adaptPhaseOsc(t,s,lambda,K,F_vec,t_vec)

dsdt = zeros(2,1);

% input function
F = interp1(t_vec,F_vec,t);

% phase oscillator
dsdt(1) = lambda*s(2) - K*sin(s(1))*F;
dsdt(2) = - K*sin(s(1))*F;

end