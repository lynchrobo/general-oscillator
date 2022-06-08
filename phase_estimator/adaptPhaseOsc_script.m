%% adaptPhaseOsc_script.m
% Righetti et al. 2021 (SIAM) describes a phase oscillator that adapts its
% frequency to that of a coupled signal (or another oscillator). This has
% the potential to be a nice way of estimating the phase and frequency of
% an asynchronous spring-wing system with little to no time delay after
% convergence. 
%
% The oscillator is defined as a second-order system with parameters lambda
% (convergence rate) and K (coupling strength). p is the phase of the 
% oscillator and lambda*w is the frequency (rad/s). The input is F(t), some
% periodic function (zero mean):
%
%       dp/dt = lambda*w - K*sin(p)*F(t)
%       dw/dt = -K*sin(p)*F(t)
%
% This script is meant for testing parameters and investigating when we get
% convergence, and how good the estimate of phase actually is.
%%

K   = 5;
lam = 1.1;

w_sig   = 10;
amp     = 1;

tspan   = [0,10];
s0      = [0,1.1*w_sig/lam];
t_vec   = linspace(tspan(1),tspan(2),w_sig*1000)';
F_ref   = amp*cos(w_sig*t_vec);

odefun  = @(t,s) adaptPhaseOsc(t,s,lam,K,F_ref,t_vec);

odeSol   = ode45(odefun,tspan,s0);

y   = deval(odeSol,t_vec);
t   = t_vec';

%
clf
subplot(2,2,1)
hold on
plot(t,lam*y(2,:))
yline(w_sig)
xlabel('time (s)')
ylabel('frequency (rad/s)')
title("frequency adaptation, w_{sig} = 10 rad/s")
% axis([0,inf,0,w_sig*2])
hold off
subplot(2,2,3)
hold on
plot(t,w_sig*t);
plot(t,y(1,:))
% plot(y)
hold off
xlabel('time (s)')
ylabel('phase (rad)')
title("phase adaptation")
subplot(1,2,2)
plot(t_vec,abs(y(1,:)-w_sig*t_vec'),'.')


rms(y(1,end/2:end)-w_sig*t_vec(end/2:end)')*180/2/pi