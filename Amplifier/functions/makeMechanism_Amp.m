function [links, joints] = makeMechanism_Amp(S)
% This file creates all handle objects necessary for the mechanism. 
%% Mechanism definition! :O
% Material & General properties
    Em = 90E6;
    factor = 50;            % To scale it up quickly. 
    if S.Meters == true
        scale = factor*10^-6;
    else
        scale = factor*1;
    end
    
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
    
    d.x = 10*scale;                                             %-> Tunable
    d.y = 0*scale;                                              %-> Tunable
    
    % f
    f.name = 'f';
    f.floating = false;
    f.children = {F};
    
    f.x = 1.5*d.x;                                                %-> Tunable
    f.y = 5*scale;                                              %-> Tunable
    
    % g
    g.name = 'g';
    g.floating = false;
    g.children = {H};
    
    g.x = 8/10*f.x;                                             %-> Tunable
    g.y = 1.5*f.y;                                                %-> Tunable
    

% Links:
    % B
    B.name = 'B';
    B.parents = {d,b};   
    B.L = 4*scale;                                              %-> Tunable
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
    D.L = 1.5*d.x;                                                %-> Tunable
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
    addprop(a,'mirrorOffsetVal');
    a.mirrorOffsetVal = 1/2*scale;
   
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
end