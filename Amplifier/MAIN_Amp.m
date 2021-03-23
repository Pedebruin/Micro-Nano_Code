clear all; close all; clc;
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
S.mirror = true;                % Mirror the mechanism? (more for show)
    S.mirrorOffset = 1;         % Offset the mirrored mechanisms for neatness?

% single position plot          A single plot of the mechanism in desired configuration
S.singlePosPlot = true;         % Make a plot with a single position?
    S.d_in_single = 0.1;        % Input for single position plot

% animation                     Or would you like to see it move?
S.animation = true;             % Simulate the mechanism?
    S.doubleStroke = true;      % Go forwards and backwards, or only forwards?
    S.pausing = false;          % Pause the animation before it starts for screen recording?
    S.d_in_min = 0;             % Min input displacement [mu m] 
    S.d_in_max = 1;             % Max input displacement [mu m]

    S.T = 0.1;                  % Simulation time [tried S, but sim too slow i think]
    S.n = 100;                  % Amount of animation steps []


%% Parameters
% Material & General properties
    % None yet

% Objects 
% Fixed joints:
    % d
    d = joint;
    d.name = 'd';
    d.floating = false;
    
    d.x = 3;
    d.y = 0;
    
    % f
    f = joint;
    f.name = 'f';
    f.floating = false;
    
    f.x = 2*d.x;
    f.y = 4;
    
    % g
    g = joint;
    g.name = 'g';
    g.floating = false;
    
    g.x = 9/10*f.x;
    g.y = 1.5*f.y; 
    

% Links:
    % B
    B = link;
    B.name = 'B';
    B.free = true;
    B.L = 4;
    
    % A         (At a weird place because its length is defined by d and B)
    Amp = link;
    Amp.name = 'A';
    Amp.free = false;
    Amp.L = sqrt(d.x^2+B.L^2);

    % D
    D = link;
    D.name = 'D';
    D.free = true;
    D.L = 3*d.x;
    
    % C         (At a weird place because its length is defined by D and B)
    C = link;
    C.name = 'C';
    C.free = false;
    C.L = sqrt(B.L^2+D.L^2);
  
    % F
    F = link;
    F.name = 'F';
    F.L = 2*B.L;
    
    % E         (At a weird place because its length is defined by F and D)
    E = link;
    E.name = 'E';
    E.free = false;
    E.L = sqrt((F.L+f.y)^2+(D.L+d.x-f.x)^2);
 
    % G
    G = link;
    G.name = 'G';
    G.free = false;
    G.L = sqrt((B.L+F.L-g.y)^2+f.x^2); 
    
    % H
    H = link;
    H.name = 'H';
    H.L = g.x;
    
    % I
    I = link;
    I.name = 'I';
    I.L = f.y+F.L-g.y;
    
    
% Joints:
    % a
    a = joint;
    a.name = 'a';
    a.floating = true;
    a.x = 0; % Starting at x=0 initially. Changed when needed. 
   
    % b
    b = joint;
    b.name = 'b';
    b.floating = true;
    
    % c
    c = joint;
    c.name = 'c';
    c.floating = true;
    
    % d is fixed, so defined above. 
    
    % e
    e = joint;
    e.name = 'e';
    e.floating = true;
    
    % f is fixed, so defined above. 
    
    % h
    h = joint;
    h.name = 'h';
    h.floating = true;
    
    % i
    i = joint;
    i.name = 'i';
    i.floating = true;
    i.x = 0; % Assumed to be 0, changed when needed. 
        
    links = {Amp,B,C,D,E,F,G,H,I};    % For easy transportation
    joints = {a,b,c,d,e,f,g,h,i};

    
%% Analysis loop
% Single plot
if S.singlePosPlot == true
    figureName = 'Kinematic model';
    a.y = S.d_in_single;
    
    Amp = kinModel_Amp(links,joints,S);
    [~] = showme_Amp(figureName,links,joints,Amp,S);   
    clear showme_Amp;
    a.y = 0;        % Put configuration back to original. 
end


% Animation plot
if S.animation == true
    figureName = 'Kinematic model ANIMATION';
    
    if S.doubleStroke == true
        d = linspace(S.d_in_min,S.d_in_max,S.n/2);
        d = [d linspace(S.d_in_max,S.d_in_min,S.n/2)];
    else
        d = linspace(S.d_in_min,S.d_in_max,S.n);
    end
    
    counter = 0;
    tic;
    for d_in = d
        if counter ~= 0
            delete(Plots);
        end
        
        tstart = tic;
        a.y = d_in;                                             % Update input 
        Amp = kinModel_Amp(links,joints,S);                   % Evaluate the kinematic model
        Plots = showme_Amp(figureName,links,joints,Amp,S);    % Plot the model
        
        if counter == 0 && S.pausing == true
            disp('Press key to continue when ready');
            pause;
        end
        
        counter = counter + 1;
        telapsed = toc;
        pause(S.T/S.n-telapsed);
    end
    
end

