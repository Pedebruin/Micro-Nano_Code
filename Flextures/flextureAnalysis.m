close all; clear;
set(0,'defaultTextInterpreter','latex');

%{
    File to calculate stifnesses of folded flextures.
%}

%% Parameters
    E = 190*10^9;        % E modulus [Pa]
    t = 25e-6;          % height of the layer [m]
    w = 6e-6;           % width of the bending beams [m]
    L = 450e-6';         % length of the bending beams [m]
    d = 25e-6;          % Spacing of the beams [m]
    s_req = 22e-6;      % Required stroke (from center) [m]
    
    
    n = 2;              % number of folded flextures in parallel (now one per side)
    
%% Calculation
% Stifness
    % Surface moment of intertia
    I = 1/12*t*w^3;

    % Beam stiffness
    k_beam = 12*E*I/L^3;

    % Total stiffness
    k_total = n*2/3*k_beam;

% Deformation
    %{
    (Assuming the figure in whatsapp, left is the space on the
     left betweent eh right is the spacing on the right between the beams and
     the stage connection. 
    %}
    maxLeft = 2*d;          % Max deformation assuming left will touch
    maxRight = 4/3*d;       % Max deformation assuming right will touch
    
    maxStroke = min(maxLeft, maxRight);

% Required force for stroke:
    F_req = k_total*s_req;

%% Results
fprintf(['------------- Results -------------\n',...
         'k_total = %f4 [N/m] \n',...
         'max stroke = %f4 [um] \n',...
         'F required = %f4 [N] \n'], k_total, maxStroke*10^6, F_req)
