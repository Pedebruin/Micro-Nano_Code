close all; clear;
set(0,'defaultTextInterpreter','latex');

%{
    File to calculate stifnesses of folded flextures.
%}

%% Parameters
    E = 160*10^9;        % E modulus [Pa]
    t = 25e-6;          % height of the layer [m]
    w = 6.5e-6;           % width of the bending beams [m]
    L = 800e-6;         % length of the bending beams [m]
    d = 40e-6;          % Spacing of the beams [m]
    s_req = 22e-6;      % Required stroke (from center) [m]
    
    n = 4;              % number of folded flextures in parallel (now one per side)
    
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

 
%% Stage kinematics
Alpha = 30;                   % degrees
s = 7.8868e-4;                % meters
beamLength = 0.815e-3;


% kinM = [-1 0 s; 
%         -1/sind(45) 1/cosd(45) s;
%         1/sin(45) 1/cos(45) s];
%        
% posCombs = [0 0 0]';    
% posxyt = kinM\posCombs;
% 


x = -22.26e-6;
y = 23.45e-6;
theta = 9.657e-2;

R = [cosd(theta), -sind(theta);
    sind(theta), cosd(theta)];

A = [0, s]';
C = [-cosd(30), -sind(30)]'*s;
E = [cosd(30), -sind(30)]'*s;
stagePos0 = [A, C, E];

% ankers
a = A + beamLength*[1, 0]';
c = C + beamLength*[-cosd(60), sind(60)]';
e = E + beamLength*[-sind(30), -cosd(30)]';

% actuator lengths
aL0 = A-a;
cL0 = C-c;
eL0 = E-e;

% deform
stagePos = R*stagePos0+[x, y]'; 
A1 = stagePos(:,1);
C1 = stagePos(:,2);
E1 = stagePos(:,3);

% new lengths
aL1 = A1-a;
cL1 = C1-c;
eL1 = E1-e;

% FUCKING ELONGATIONS
Aactuation = norm(aL1)-norm(aL0);
Cactuation = norm(cL1)-norm(cL0);
Eactuation = norm(eL1)-norm(eL0);


figure('Name','STAGESSSSS')
hold on
ax = gca;
% Fixed points
plot(ax,a(1),a(2),'ok'); 
plot(ax,c(1),c(2),'ok');
plot(ax,e(1),e(2),'ok');
% Original
patch(ax, stagePos0(1,:),stagePos0(2,:),'r');       % Original
plot(ax, [A(1), a(1)], [A(2), a(2)],'r');
plot(ax, [C(1), c(1)], [C(2), c(2)],'r');
plot(ax, [E(1), e(1)], [E(2), e(2)],'r');

% % Displaced
% patch(ax, stagePos(1,:),stagePos(2,:),'c');         % Displaced
% plot(ax, [A1(1), a(1)], [A1(2), a(2)],'c');
% plot(ax, [C1(1), c(1)], [C1(2), c(2)],'c');
% plot(ax, [E1(1), e(1)], [E1(2), e(2)],'c');


axis equal
alpha(0.3)

  
%% Results
% Stifnessessss
fprintf(['------------- Results -------------\n',...
         'k_total = %4.2f [N/m] \n',...
         'max stroke = %4.2f [um] \n',...
         'F required = %4.2f [N] \n'], k_total, maxStroke*10^6, F_req)

% Displacements    
fprintf(['-> A stroke %4.9f [m] \n',...
            '-> C stroke %4.9f [m] \n',...
            '-> E stroke %4.9f [m] \n'],Aactuation, Cactuation, Eactuation);
    
    
