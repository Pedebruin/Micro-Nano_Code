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
S.plotNames = true;             % Show all the names?
S.mirror = false;                % Mirror the mechanism? (more for show)
    S.mirrorOffset = 1;         % Offset the mirrored mechanisms for neatness?

% single position plot          A single plot of the mechanism in desired configuration
S.singlePosPlot = true;         % Make a plot with a single position?
    S.d_in_single = 0.5;        % Input for single position plot

% animation                     Or would you like to see it move?
S.animation = true;             % Simulate the mechanism?
    S.doubleStroke = true;      % Go forwards and backwards, or only forwards?
    S.pausing = false;          % Pause the animation before it starts for screen recording?
    S.d_in_min = 0;             % Min input displacement [mu m] 
    S.d_in_max = 1;           % Max input displacement [mu m]

    S.T = 0.1;                  % Simulation time [tried S, but sim too slow i think]
    S.n = 100;                  % Amount of animation steps []


%% Mechanism definition! :O
% Material & General properties
    % None yet

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
    
    d.x = 10;
    d.y = 0;
    
    % f
    f.name = 'f';
    f.floating = false;
    f.children = {F};
    
    f.x = 3*d.x;
    f.y = 4;
    
    % g
    g.name = 'g';
    g.floating = false;
    g.children = {H};
    
    g.x = 9/10*f.x;
    g.y = 2*f.y; 
    

% Links:
    % B
    B.name = 'B';
    B.free = true;
    B.parents = {d,b};    
    B.L = 4;
    
    % A         (At a weird place because its length is defined by d and B)
    A.name = 'A';
    A.free = false;
    A.parents = {a,b};    
    A.L = sqrt(d.x^2+B.L^2);

    % D
    D.name = 'D';
    D.free = true;
    D.parents = {d,c};    
    D.L = 4*d.x;
    
    % C         (At a weird place because its length is defined by D and B)
    C.name = 'C';
    C.free = false;
    C.parents = {b,c};    
    C.L = sqrt(B.L^2+D.L^2);
  
    % F
    F.name = 'F';
    F.parents = {f,e};    
    F.L = 2*B.L;
    
    % E         (At a weird place because its length is defined by F and D)
    E.name = 'E';
    E.free = false;
    E.parents = {e,c};    
    E.L = sqrt((F.L+f.y)^2+(D.L+d.x-f.x)^2);
 
    % G
    G.name = 'G';
    G.free = false;
    G.parents = {h,e};    
    G.L = sqrt((B.L+F.L-g.y)^2+f.x^2); 
    
    % H
    H.name = 'H';
    H.parents =  {h,g};    
    H.L = g.x;
    
    % I
    I.name = 'I';
    I.parents = {h,i};    
    I.L = (f.y+F.L-g.y)*1.3;


% Joints:
    % a
    a.name = 'a';
    a.floating = true;
    a.children = {A};
    a.x = 0; % Starting at x=0 initially. Changed when needed. 
   
    % b
    b.name = 'b';
    b.floating = true;
    b.children = {A,B,C};
    
    % c
    c.name = 'c';
    c.floating = true;
    c.children = {D,C,E};
    
    % d is fixed, so defined above. 
    
    % e
    e.name = 'e';
    e.floating = true;
    e.children = {G,F,E};
    
    % f is fixed, so defined above. 
    
    % h
    h.name = 'h';
    h.floating = true;
    h.children = {I,G,H};
    
    % i
    i.name = 'i';
    i.floating = true;
    i.children = {I};
    i.x = 0; % Assumed to be 0, changed when needed. 
            
%% Analysis part
% Single plot
if S.singlePosPlot == true
    figureName = ['Kinematic model, $$d_{in}$$ = ',num2str(S.d_in_single)];
    a.y = S.d_in_single;
    
    S.plotNames = false;
    P = kinModel_Amp(links,joints,S);
    [~] = showme_Amp(figureName,links,joints,P,S);   
    clear showme_Amp;
    a.y = 0;        % Put configuration back to original. 
    
%     S.plotNames = true;
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
% for j = 1:length(objects)
%     delete(objects{j});
% end

