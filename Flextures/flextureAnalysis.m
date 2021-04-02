
close all; clear;
set(0,'defaultTextInterpreter','latex');

%{
    File to calculate stifnesses of folded flextures.
%}

%% Parameters
    E = 190*10^9;       % E modulus [Pa]
    t = 25e-6;          % height of the layer [m]
    w = 6.5e-6;         % width of the bending beams [m]
    L = 1150e-6;        % length of the bending beams [m]
    d = 40e-6;          % Spacing of the beams [m]
    s_req = 50e-6;      % Required stroke (from center) [m]
    
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

%% Stage kinematics
Alpha = 30;                   % degrees
s = 0.782669e-3;                % meters
beamLength = 0.815e-3;

x = 50e-6;  %6.059738292e-06;
y = 75e-6; %-7.088136361e-09;
theta = 15;

R = [cosd(theta), -sind(theta);
    sind(theta), cosd(theta)];

A = [0, 1]'*s;
B = [-cosd(30), sind(30)]'*s;
C = [-cosd(30), -sind(30)]'*s;
D = [0, -1]'*s;
E = [cosd(30), -sind(30)]'*s;
F = [cosd(30), sind(30)]'*s;
stagePos0 = [A, B, C, D, E, F];

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
C1 = stagePos(:,3);
E1 = stagePos(:,5);

% new lengths
aL1 = A1-a;
cL1 = C1-c;
eL1 = E1-e;

% FUCKING ELONGATIONS
Aactuation = norm(aL1)-norm(aL0);
Cactuation = norm(cL1)-norm(cL0);
Eactuation = norm(eL1)-norm(eL0);

% Forces
AF = 2*(k_total * Aactuation + 3.6279e-05*theta);
CF = 2*(k_total * Cactuation + 3.6279e-05*theta);
EF = 2*(k_total * Eactuation + 3.6279e-05*theta);

p = cell(11,1);
%% Plot!
figure('Name','STAGESSSSS')
hold on
title('Kinematic stage analysis')
xlabel('X position [m]')
ylabel('Y position [m]')
ax = gca;

% Fixed points
p{1} = plot(ax,a(1),a(2),'ok'); 
p{2} = plot(ax,c(1),c(2),'ok');
p{3} = plot(ax,e(1),e(2),'ok');

% Original
p{4} = patch(ax, stagePos0(1,:),stagePos0(2,:),'k');       % Original
p{5} = plot(ax, [A(1), a(1)], [A(2), a(2)],'k');
p{6} = plot(ax, [C(1), c(1)], [C(2), c(2)],'k');
p{7} = plot(ax, [E(1), e(1)], [E(2), e(2)],'k');

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

legend(pv([4,8]),'Original location','Displaced location');
axis equal
grid on

% Original
alpha(pv(4:7),0.65)          % Patch surface
set(pv(4),'EdgeAlpha',0.4); % Patch lines
p{5}.Color(4) = 0.75;      % plotted lines
p{6}.Color(4) = 0.75;
p{7}.Color(4) = 0.75;

% Displaced
alpha(pv(8:11),0.35)
set(pv(8),'EdgeAlpha',0.1);
p{9}.Color(4) = 0.35;
p{10}.Color(4) = 0.35;
p{11}.Color(4) = 0.35;
  
%% Results
% Stifnessessss
fprintf(['------------- Results -------------\n',...
         'k_total = %4.9f [N/m] \n',...
         'max stroke = %4.9f [um] \n',...
         'F required = %4.9f [N] \n'], k_total, maxStroke*10^6, F_req)
% Displacements    
fprintf([   '-> A stroke: %4.9f  [m] \n',...
            '      Force:  %4.9f [N] \n',...
            '-> C stroke: %4.9f  [m] \n',...
            '      Force:  %4.9f [N] \n',...
            '-> E stroke: %4.9f  [m] \n'...
            '      Force:  %4.9f [N] \n'],Aactuation, AF, Cactuation, CF, Eactuation, EF);
fprintf([ '->POS: \n',...
          '    x = %4.9f [m] \n',...
          '    y = %4.9f [m] \n',...
          'theta = %4.9f [deg] \n'],x,y,theta);
    
    
    
