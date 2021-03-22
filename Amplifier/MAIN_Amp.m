clear all; close all
set(0,'defaultTextInterpreter','latex');

%{
    Created by Pim de Bruin. This analysis purely approximates the design
    kinematically assuming pure rotational joints at the end of each
    flexture. 
%}

%% Settings
% Options
S.plotLinks = true;
S.plotJoints = true;



%% Parameters
% Material & General properties

% Links:
    % A
    A = link;
    A.L = 5;

    % B
    B = link;
    B.L = 4;
    
    % C
    C = link;
    C.L = 0;
    
    % D
    D = link;
    D.L = 0;
    
    % E
    E = link;
    E.L = 0;
  
    % F
    F = link;
    F.L = 0;
 
    % G
    G = link;
    G.L = 0; 
    
    % H
    H = link;
    H.L = 0;
    
    % I
    I = link;
    I.L = 0;
    
    
% Joints:
    % a
    a = joint;
    a.K = 0;
   
    
    % b
    b = joint;
    b.K = 0;
    
    % c
    c = joint;
    c.K = 0;
    
    % d
    d = joint;
    d.K = 0;
    
    d.x = sqrt(A.L^2-B.L^2);
    
    % e
    e = joint;
    e.K = 0;
    
    % f
    f = joint;
    f.K = 0;
    
    % g
    g = joint;
    g.K = 0;
    
    % h
    h = joint;
    h.K = 0;
    
    % i
    i = joint;
    i.K = 0;
    
    
    links = {A,B,C,D,E,F,G,H,I};
    joints = {a,b,c,d,e,f,g,h,i};


%% Setup


%% Main analysis
d_in = 0;
kinModel_Amp(d_in,links,joints);        % Evaluate the kinematic model

figureName = 'Kinematic model';
Plots = showme_Amp(figureName,links,joints);


