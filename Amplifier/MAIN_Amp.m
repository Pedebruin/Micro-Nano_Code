clear all; close all;
set(0,'defaultTextInterpreter','latex');
addpath('./functions');

%{
Created by:

Pim de Bruin
Barbara de Vries
Jelle Smit
Pepijn van Esch
Steijn Nieuwenhuis

This analysis purely approximates the design
kinematically assuming pure rotational joints at the end of each
flexture. Its purpose is to find the amplification factor and be able
to iteratively design the amplifier to required specifications. 

This file is supported by:
    joint.m
        The source file for the handle class: 'joint'
    link.m
        The source file for the handle class: 'link'
    kinModel_Amp.m
        The function file where the kinematic model function is
        defined. 
    showme_Amp.m
        The function file where the plot function is defined. 
%}

%% Settings (Put everything in S struct)
% Plot options                  These are general settings for all plots made. 
S.plotLinks = true;             % Show the links?
S.plotJoints = true;            % Show the joints?
S.plotNames = false;             % Show all the names?
S.mirror = true;                % Mirror the mechanism? (more for show)
    S.mirrorOffset = 2;         % Offset the mirrored mechanisms for neatness?

% single position plot          A single plot of the mechanism in desired configuration
S.singlePosPlot = true;         % Make a plot with a single position?
    S.d_in_single = 0;          % Input for single position plot

% animation                     Or would you like to see it move?
S.animation = true;             % Simulate the mechanism?
    S.doubleStroke = true;      % Go forwards and backwards, or only forwards?
    S.pausing = false;          % Pause the animation before it starts for screen recording?
    S.d_in_min = 0;             % Min input displacement [mu m] 
    S.d_in_max = 1;             % Max input displacement [mu m]

    S.T = 0.1;                  % Simulation time [tried S, but sim too slow i think]
    S.n = 100;                  % Amount of animation steps []


%% Mechanism definition! :O
% Material & General properties
    Em = 90E6;

% Objects 
    a = joint;
    b = joint;
    c = joint;
    d = joint;
    e = joint;
    f = joint;
    g = joint;
    h = joint;
    i = joint;
    
    A = link;
    B = link;
    C = link;
    D = link;
    E = link;
    F = link;
    G = link;
    H = link;
    I = link; 
    
    % For easy transportation
    links = {A,B,C,D,E,F,G,H,I};    
    joints = {a,b,c,d,e,f,g,h,i};
    objects = [links, joints];
    
% Fixed joints:
    % d
    d.name = 'd';
    d.floating = false;
    d.children = {B,D};
    
    d.x = 10;                                                   %-> Tunable
    d.y = 0;                                                    %-> Tunable
    
    % f
    f.name = 'f';
    f.floating = false;
    f.children = {F};
    
    f.x = 3*d.x;                                                %-> Tunable
    f.y = 4;                                                    %-> Tunable
    
    % g
    g.name = 'g';
    g.floating = false;
    g.children = {H};
    
    g.x = 9/10*f.x;                                             %-> Tunable
    g.y = 2*f.y;                                                %-> Tunable
    

% Links:
    % B
    B.name = 'B';
    B.parents = {d,b};   
    B.L = 4;                                                    %-> Tunable
    B.k = (3*Em*B.t*B.w^3)/(12*B.L^3)*10^-6;   % Normal load case [N/m]
    
    % A         (At a weird place because its length is defined by d and B)
    A.name = 'A';
    A.free = false;
    A.parents = {a,b};    
    A.L = sqrt(d.x^2+B.L^2);
    A.k = (3*Em*A.t*A.w^3)/(12*A.L^3)*10^-6;   % Normal load case [N/m]

    % D
    D.name = 'D';
    D.parents = {d,c};    
    D.L = 4*d.x;                                                %-> Tunable
    D.k = (3*Em*D.t*D.w^3)/(12*D.L^3)*10^-6;   % Normal load case [N/m]
    
    % C         (At a weird place because its length is defined by D and B)
    C.name = 'C';
    C.free = false;
    C.parents = {b,c};    
    C.L = sqrt(B.L^2+D.L^2);
    C.k = (3*Em*C.t*C.w^3)/(12*C.L^3)*10^-6;   % Not normal load case, but guess. [N/m]
  
    % F
    F.name = 'F';
    F.parents = {f,e};    
    F.L = 2*B.L;                                                %-> Tunable
    F.k = (3*Em*F.t*F.w^3)/(12*F.L^3)*10^-6;   % Normal load case [N/m]
    
    % E         (At a weird place because its length is defined by F and D)
    E.name = 'E';
    E.free = false;
    E.parents = {e,c};    
    E.L = sqrt((F.L+f.y)^2+(D.L+d.x-f.x)^2);
    E.k = (3*Em*E.t*E.w^3)/(12*E.L^3)*10^-6;   % Not normal load case, but crude guess. [N/m]
    
    % G
    G.name = 'G';
    G.free = false;
    G.parents = {h,e};    
    G.L = sqrt((B.L+F.L-g.y)^2+f.x^2); 
    G.k = (3*Em*G.t*G.w^3)/(12*G.L^3)*10^-6;   % Not normal load case, but crude guess. [N/m]
    
    % H
    H.name = 'H';
    H.parents =  {h,g}; 
    H.L = g.x;                                                  %-> Tunable
    H.k = (3*Em*H.t*H.w^3)/(12*H.L^3)*10^-6;   % Normal load case [N/m]
    
    % I
    I.name = 'I';
    I.parents = {h,i};    
    I.L = (f.y+F.L-g.y)*1.3;
    I.k = (3*Em*I.t*I.w^3)/(12*I.L^3)*10^-6;  % Not normal load case, but crude guess. [N/m]


% Joints:
    % a
    a.name = 'a';
    a.children = {A};
    a.x = 0; % Kept at x = 0, unless offset is applied. 
   
    % b
    b.name = 'b';
    b.children = {A,B,C};
    
    % c
    c.name = 'c';
    c.children = {D,C,E};
    
    % d is fixed, so defined above. 
    
    % e
    e.name = 'e';
    e.children = {G,F,E};
    
    % f is fixed, so defined above. 
    
    % h
    h.name = 'h';
    h.children = {I,G,H};
    
    % i
    i.name = 'i';
    i.children = {I};
    i.x = 0; % Kept at x = 0, unless offset is applied. 
            
%% Analysis part
% Single plot
if S.singlePosPlot == true
    figureName = ['Kinematic model, $$d_{in}$$ = ',num2str(S.d_in_single)];
    a.y = S.d_in_single;
    
    P = kinModel_Amp(links,joints,S);
    [~] = showme_Amp(figureName,links,joints,P,S);   
    clear showme_Amp;
    a.y = 0;        % Put configuration back to original. 
    
%     P = kinModel_Amp(links,joints,S);
%     [~] = showme_Amp(figureName,links,joints,P,S);
%     clear showme_Amp;
end


% Animation plot
if S.animation == true
    figureName = 'Kinematic model ANIMATION';
    
    if S.doubleStroke == true
        d_in_v = linspace(S.d_in_min,S.d_in_max,S.n/2);
        d_in_v = [d_in_v linspace(S.d_in_max,S.d_in_min,S.n/2)];
    else
        d_in_v = linspace(S.d_in_min,S.d_in_max,S.n);
    end
    
    counter = 0;
    tic;
    for d_in = d_in_v
        if counter ~= 0
            delete(Plots);
        end
        
        tstart = tic;
        a.y = d_in;                                           % Update input 
        P = kinModel_Amp(links,joints,S);                   % Evaluate the kinematic model
        Plots = showme_Amp(figureName,links,joints,P,S);    % Plot the model
        
        if counter == 0 && S.pausing == true
            disp('Press key to continue when ready');
            pause;
        end
        
        counter = counter + 1;
        telapsed = toc;
        pause(S.T/S.n-telapsed);
    end
    clear showme_Amp
end

%% Clean up handle objects
for j = 1:length(objects)
    delete(objects{j});
end

