clear all; close all;
set(0,'defaultTextInterpreter','latex');
addpath('./functions');
addpath('./plotFunctions');

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
    makeMechanism_Amp.m
        The function file where all mechanism handle objects are created. 
%}

%% Settings (Put everything in S struct)
% Plot options                  These are general settings for all plots made. 
S.plotLinks = true;             % Show the links?
S.plotJoints = true;            % Show the joints?
S.plotNames = true;             % Show all the names?
S.mirror = true;               % Mirror the mechanism? (more for show)
    S.mirrorOffset = 10;         % Offset the mirrored mechanisms for neatness?
S.Offset = [0 0];              % Move figure?
S.Rotation = deg2rad(0);        % Rotate figure?
S.Meters = false;

% single position plot          A single plot of the mechanism in desired configuration
S.singlePosPlot = true;         % Make a plot with a single position?
    S.d_in_single = 0;          % Input for single position plot

% animation                     Or would you like to see it move?
S.animation = true;             % Simulate the mechanism?
    S.doubleStroke = false;      % Go forwards and backwards, or only forwards?
    S.pausing = false;          % Pause the animation before it starts for screen recording?
    S.d_in_min = -5;             % Min input displacement [mu m] 
    S.d_in_max = 5;             % Max input displacement [mu m]

    S.T = 0.1;                  % Simulation time [tried S, but sim too slow i think]
    S.n = 50;                  % Amount of animation steps []


%% Make the mechanism!
% Everything you are looking fore is in this function! (alld efinitions,
% and lengths and stuff. 
[links, joints] = makeMechanism_Amp(S);

% Unpack
[A, B, C, D, E, F, G, H, I] = links{:};
[a, b, c, d, e, f, g, h, i] = joints{:};
objects = [links, joints];

%% Analysis part
% Single plot
if S.singlePosPlot == true
    figureName = ['Kinematic model, $$d_{in}$$ = ',num2str(S.d_in_single)];
    d_in = S.d_in_single;
    
    P = kinModel_Amp(links,joints,d_in);
    [~] = showme_Amp(figureName,links,joints,P,S);   
    clear showme_Amp;
    a.y = 0;        % Put configuration back to original. 
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
        tstart = tic;
        P = kinModel_Amp(links,joints,d_in);                   % Evaluate the kinematic model
        if counter ~= 0
            delete(Plots);
        end          
        Plots = showme_Amp(figureName,links,joints,P,S);    % Plot the model
        
      
        if counter == 0 && S.pausing == true
            disp('Press key to continue when ready');
            pause;
        end
        
        counter = counter + 1;
        telapsed = toc;
        pause(0);
    end
    clear showme_Amp
end

%% Clean up handle objects
for j = 1:length(objects)
    delete(objects{j});
end

