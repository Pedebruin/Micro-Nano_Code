clear all
close all
%{
    Created by Pim de Bruin. This analysis purely approximates the design
    kinematically assuming pure rotational joints at the end of each
    flexture. 
%}

%% Settings
layerHeight = 25e-6;
linkWidth = 6e-6;




global A B C D E F G H I a b c d e f g h i



%% Parameters
% Material properties
% Links:
    % A
    A = link;
    A.L = 0;
    A.w = linkWidth;
    A.h = layerHeight;
    
    % B
    B = link;
    B.L = 0;
    B.w = linkWidth;
    B.h = layerHeight;
    
    % C
    C = link;
    C.L = 0;
    C.w = linkWidth;
    C.h = layerHeight;
    
    % D
    D = link;
    D.L = 0;
    D.w = linkWidth;
    D.h = layerHeight;
    
    % E
    E = link;
    E.L = 0;
    E.w = linkWidth;
    E.h = layerHeight;
    
    % F
    F = link;
    F.L = 0;
    F.w = linkWidth;
    F.h = layerHeight;
    
    % G
    G = link;
    G.L = 0; 
    G.w = linkWidth;
    G.h = layerHeight;
    
    % H
    H = link;
    H.L = 0;
    H.w = linkWidth;
    H.h = layerHeight;
    
    % I
    I = link;
    I.L = 0;
    I.w = linkWidth; 
    I.h = layerHeight;
    
    
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
    
    


%% Setup


%% Main analysis
kinModel_Amp(0);        % Evaluate the kinematic model

figureName = 'Figure plotter test';
Plots = showme_Amp(figureName);


