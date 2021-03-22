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
    A.name = 'A';
    A.L = 5;

    % B
    B = link;
    B.name = 'B';
    B.L = 4;
    
    % C
    C = link;
    C.name = 'C';
    C.L = 0;
    
    % D
    D = link;
    D.name = 'D';
    D.L = 0;
    
    % E
    E = link;
    E.name = 'E';
    E.L = 0;
  
    % F
    F = link;
    F.name = 'F';
    F.L = 0;
 
    % G
    G = link;
    G.name = 'G';
    G.L = 0; 
    
    % H
    H = link;
    H.name = 'H';
    H.L = 0;
    
    % I
    I = link;
    I.name = 'I';
    I.L = 0;
    
    
% Joints:
    % a
    a = joint;
    a.name = 'a';
    a.K = 0;
   
    
    % b
    b = joint;
    b.name = 'b';
    b.K = 0;
    
    % c
    c = joint;
    c.name = 'c';
    c.K = 0;
    
    % d
    d = joint;
    d.name = 'd';
    d.K = 0;
    
    d.x = sqrt(A.L^2-B.L^2);
    
    % e
    e = joint;
    e.name = 'e';
    e.K = 0;
    
    % f
    f = joint;
    f.name = 'f';
    f.K = 0;
    
    % g
    g = joint;
    g.name = 'g';
    g.K = 0;
    
    % h
    h = joint;
    h.name = 'h';
    h.K = 0;
    
    % i
    i = joint;
    i.name = 'i';
    i.K = 0;
    
    
    links = {A,B,C,D,E,F,G,H,I};
    joints = {a,b,c,d,e,f,g,h,i};


%% Setup


%% Main analysis
d_in = 1;
kinModel_Amp(d_in,links,joints);        % Evaluate the kinematic model

figureName = 'Kinematic model';
Plots = showme_Amp(figureName,links,joints);


