clear all
close all
clc

dx = 61 *10^-6; %required displacement
overshoot = 0.1; %10 percent overshoot
Amplification = 1; %Amplification facto

delta = dx*(1+overshoot)*Amplification; %displacement of system




%Requirements/limits
Current = 0.2;  %[A]
V = 80;         %[V]
t = 25*10^(-6);   %[m]
epsilon =  8.85*10^(-12); % [F/m];
g = 2.0*10^(-6);   %[m]
E = 190*10^(9);   %[Pa]
w = 3.0*10^(-6);   %[m]
gt = 1/3*delta; %gap to avoid stiction
Lmax = 60*10^(-6);
n = 130*4; %was 108
l_overlap=Lmax-gt;
Fz=(epsilon*l_overlap)*V^2/g;
Kz=(3*E *(t *w^3/12))/Lmax^3;
p = t;

% Force
Fx = n*epsilon*p/g*V^2;
Kx_max = Fx/dx;


%guidance
t_flexure = t;
w_flexure = 6E-6;
L_common = 1000E-6;
Kx_single = 2*E*t*(w_flexure /L_common)^3;
Kx = 2/(3/Kx_single);

I_flexure=(25E-6)*(6E-6)^3/12;
k_flexure=3*E*I_flexure/(450E-6)^3;
k_oneside=(3/k_flexure)^-1;
k_total=2*k_oneside;

K_B = 4*E*t*(w_flexure^3/(4*(L_common^3)));

calculated_disp=Fx/K_B;


disp('Max deliverable force: ' +string(Fx)+' [N]')
disp('Max displacementent of actuator: ' +string(dx*10^6) + ' micrometers')
