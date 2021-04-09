close all; clear;
set(0,'defaultTextInterpreter','latex');

%{
    This file was made to support the design project of group 9 in the
    course ME46020 2020/2021 at the Delft University of Technology and was 
    written by:

    Steijn Nieuwenhuis
    Pepijn van Esch
    Jelle Smit
    Barbara de Vries
    Pim de Bruin

    This file estimates the required dimensions of the design to achieve a 
    set of performance requirements defined in the assignment.
%}

%% General Parameters
    % Material parameters
    Em = 190*10^9;       % E modulus [Pa]
    epsilon =  8.85*10^(-12); % [F/m];
    t = 25e-6;          % Height of the layer [m]
    
    % Requirements! 
    x = 17e-6;          % Required X position
    y = 17e-6;          % Required Y position
    theta = 2.6;          % Required rotation

    
%% Stage kinematics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
-> Calculate the required displacements of the actuators based on the 
kinematics of the design.
%}
    Alpha = 30;                     % degrees
    s = 0.782669e-3;                % [m]
    beamLength = 0.815e-3;          % [m]
  
% Define the hexagonal stage
    A0 = [0, 1]'*s;
    B0 = [-cosd(30), sind(30)]'*s;
    C0 = [-cosd(30), -sind(30)]'*s;
    D0 = [0, -1]'*s;
    E0 = [cosd(30), -sind(30)]'*s;
    F0 = [cosd(30), sind(30)]'*s;
    stagePos0 = [A0, B0, C0, D0, E0, F0];

% ankers
    a = A0 + beamLength*[1, 0]';
    c = C0 + beamLength*[-cosd(60), sind(60)]';
    e = E0 + beamLength*[-sind(30), -cosd(30)]';

% actuator lengths
    aL0 = A0-a;
    cL0 = C0-c;
    eL0 = E0-e;

% deform
    R = [cosd(theta), -sind(theta);
        sind(theta), cosd(theta)];
    
    stagePos = R*stagePos0+[x, y]'; % First rotate, then translate!
    A1 = stagePos(:,1);
    B1 = stagePos(:,2);
    C1 = stagePos(:,3);
    D1 = stagePos(:,4);
    E1 = stagePos(:,5);
    F1 = stagePos(:,6);

% new lengths
    aL1 = A1-a;
    cL1 = C1-c;
    eL1 = E1-e;

% Elongations
    Aactuation = norm(aL1)-norm(aL0);
    Cactuation = norm(cL1)-norm(cL0);
    Eactuation = norm(eL1)-norm(eL0);
  
% Angular deformations of joints connecting stage
    Aang(1) = angDiff(aL1, aL0);
    Aang(2) = angDiff(aL1, A1 - F1) - angDiff(aL0, A0 - F0);    
    
    Cang(1) = angDiff(cL1, cL0);
    Cang(2) = angDiff(cL1, C1 - B1) - angDiff(cL0, C0 - B0);
    
    Eang(1) = angDiff(eL1, eL0);
    Eang(2) = angDiff(eL1, E1 - D1) - angDiff(eL0, E0 - D0);


% Get Max displacement for design purposes
    overshoot = 0.1;    % Overshoot over max displacement (safeguard)
    delta = max([Aactuation, Cactuation, Eactuation, 61e-6])*(1+overshoot);    % Required displacement
    
    
%% Flextures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
-> Calculate the approximate stiffness one actuator experiences based on quick
MEMS. This does not take the stiffness of the beams connecting the stage
into account, which can cause significant error.

-> Also find the minimal beam spacing in the flextures based on the max
displacement. 

-> Using the required max displacement, the required force can then be
found. 
%}
    w = 6.5e-6;         % Width of the bending beams [m]
    L = 1150e-6;        % Length of the bending beams [m]
    n = 2;              % Number of folded flextures in parallel (now two per side)
    
% Stiffness folded flexures
    % Surface moment of intertia
    I_beam = 1/12*t*w^3;

    % Beam stiffness
    k_beam = 12*Em*I_beam/L^3;

    % Total stiffness
    k_foldedF = n*2/3*k_beam;

% Stiffness support flexure hinges
    w_hinge = 4e-6;
    L_hinge = 40e-6;
    t_hinge = t;
    
    I_hinge = 1/12*t_hinge*w_hinge^3;
    k_hinge = Em*I_hinge/L_hinge;   % Based on rotation! (M = k*theta)
   
% Forces of actuators (assuming superposition!)
    % Internal potential energy per actuator
    AV = 1/2 * (k_foldedF * Aactuation^2 + k_hinge * norm(deg2rad(Aang))^2);
    CV = 1/2 * (k_foldedF * Cactuation^2 + k_hinge * norm(deg2rad(Cang))^2);
    EV = 1/2 * (k_foldedF * Eactuation^2 + k_hinge * norm(deg2rad(Eang))^2);

    % Vinternal = 1/2*Force*displacement;
    AF = 2*AV/Aactuation;
    CF = 2*CV/Cactuation;
    EF = 2*EV/Eactuation;

% Get max force for design purposes
    F_max = max([AF, CF, EF]);      % Maxium required force
    
% Calculate minimal gap spacing of beams in flexure
    d_min = 3/4*delta; 

%% Electrostatic actuation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
    Find the required electrostatic actuator dimensions. 
%}
% Dimensions
    w_actuator = 3.0*10^(-6);   % Finger width [m]
    g = 2.0*10^(-6);            % Gap width [m]
    Lmax = 60*10^(-6);          % Some length [m]
    V = 80;                     % Potential difference [V]
    
    gt = 1/3*delta;             % Gap to avoid stiction [m]
    l_overlap = Lmax-gt;        % Length of total overlap [m]
    p = t;
    
% Minimum amount of fingers? (Rough approximation)
    n_fingers = F_max*g/(epsilon*p*V^2);
    F_max_actuator = n_fingers*epsilon*p/g*V^2;
    
    
%% Plot! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure('Name','Stage kinematics')
    hold on
    title('Kinematic stage analysis')
    xlabel('X position [m]')
    ylabel('Y position [m]')
    ax = gca;
    
    p = cell(11,1); 
    
% Fixed points
    p{1} = plot(ax,a(1),a(2),'ok'); 
    p{2} = plot(ax,c(1),c(2),'ok');
    p{3} = plot(ax,e(1),e(2),'ok');

% Original
    p{4} = patch(ax, stagePos0(1,:),stagePos0(2,:),'k');       % Original
    p{5} = plot(ax, [A0(1), a(1)], [A0(2), a(2)],'k');
    p{6} = plot(ax, [C0(1), c(1)], [C0(2), c(2)],'k');
    p{7} = plot(ax, [E0(1), e(1)], [E0(2), e(2)],'k');

% Displaced
    p{8} = patch(ax, stagePos(1,:),stagePos(2,:),'k');         % Displaced
    p{9} = plot(ax, [A1(1), a(1)], [A1(2), a(2)],'k');
    p{10} = plot(ax, [C1(1), c(1)], [C1(2), c(2)],'k');
    p{11} = plot(ax, [E1(1), e(1)], [E1(2), e(2)],'k');

    pv = zeros(length(p),1);
    for i = 1:length(p)
        pv(i) = p{i};
    end

% Important points
    p{12} = text(ax,a(1)+2e-5,a(2),'$$a$$','FontSize',18);
    p{13} = text(ax,c(1)+2e-5,c(2),'$$c$$','FontSize',18);
    p{14} = text(ax,e(1)+2e-5,e(2),'$$e$$','FontSize',20);

    legend(pv([4,8]),'Original location','Displaced location','location','NW');
    axis equal
    grid on

% Original colors
    alpha(pv(4:7),0.65)          % Patch surface
    set(pv(4),'EdgeAlpha',0.4); % Patch lines
    p{5}.Color(4) = 0.75;      % plotted lines
    p{6}.Color(4) = 0.75;
    p{7}.Color(4) = 0.75;

% Displaced colors
    alpha(pv(8:11),0.35)
    set(pv(8),'EdgeAlpha',0.1);
    p{9}.Color(4) = 0.35;
    p{10}.Color(4) = 0.35;
    p{11}.Color(4) = 0.35;
  
%% Print %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For these displacements:
fprintf(['------------------ RESULTS ------------------\n',...
         'Required: \n',...
         '              x = %4.3f [um] \n',...
         '              y = %4.3f [um] \n',...
         '          theta = %4.3f [deg] \n',...
         '\n'],x*10^6,y*10^6,theta);
     
% Stifnessess
fprintf(['Flexures:\n',...
         '        k_total = %4.3f [N/m] \n',...
         '          d_min = %4.3f [um] \n',...
         '\n'], k_foldedF, d_min*10^6)  
     
% Strokes    
fprintf(['Kinematics & Actuator forces: \n',...
         '   A)    stroke =  %4.3f [um] \n',...
         '     Req. Force =  %4.3f [mN] \n',...
         '   C)    stroke =  %4.3f [um] \n',...
         '     Req. Force =  %4.3f [mN] \n',...
         '   E)    stroke =  %4.3f [um] \n'...
         '     Req. Force =  %4.3f [mN] \n',...
         '\n'],Aactuation*10^6, AF*10^3, Cactuation*10^6, CF*10^3, Eactuation*10^6, EF*10^3);
      
% Electrostatic actuator
fprintf(['Minimal actuator dimensions:\n',...
         '      n_fingers = %4.3f [-]\n',...
         '          F_max = %4.3f [mN]\n',...
         '\n'],n_fingers,F_max_actuator*10^3); 
     
%% Function defenitions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
 function ang = angDiff(u,v)
    if size(u,1) == 2 && size(v,1)== 2
        u = [u; 0];
        v = [v; 0];
    end
    ang = rad2deg(atan2(norm(cross(u,v)),dot(u,v)));
 end