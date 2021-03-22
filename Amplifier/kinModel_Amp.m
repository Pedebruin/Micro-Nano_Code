function [] = kinModel_Amp(d_in, links, joints)
%{
This evaluates the kinematic model and updates the angles and positions of
the joints and link instances and are stored in the instances itself. These can later be plotted. 
%}

% Unpack
[A,B,C,D,E,F,G,H,I] = links{:};
[a,b,c,d,e,f,g,h,i] = joints{:};

%% Links
% a
    a.x = 0;
    a.y = d_in;
% b
    %{
    https://math.stackexchange.com/questions/256100/
    how-can-i-find-the-points-at-which-two-circles-intersect
    %}
    R = norm([a.x,a.y]-[d.x,d.y]);
    temp = 1/2*[a.x+d.x, a.y+d.y] + (A.L^2-B.L^2)/(2*R^2)*[d.x-a.x, d.y-a.y] ...
        - 1/2*sqrt(2*(A.L^2+B.L^2)/R^2 - (A.L^2-B.L^2)^2/R^4 - 1)*[d.y-a.y, a.x-d.x];
    b.x = temp(1);
    b.y = temp(2);



    
    
  %% Joints  
    % A
    A.start = [a.x, a.y];
    A.finish = [b.x, b.y];
    
    % B
    B.start = [b.x, b.y];
    B.finish = [d.x, d.y];
    
    % C
    C.start = [b.x, b.y];
    C.finish = [c.x, c.y];
    
    % D
    D.start = [d.x, d.y];
    D.finish = [c.x, c.y];
    
    % E
    E.start = [c.x, c.y];
    E.finish = [e.x, e.y];
    
    % F
    F.start = [f.x, f.y];
    F.finish = [e.x, e.y];
    
    % G
    G.start = [e.x, e.y];
    G.finish = [h.x, h.y];
    
    % H
    H.start = [h.x, h.y];
    H.finish = [g.x, g.y];
    
    % I
    I.start = [h.x, h.y];
    I.finish = [i.x, i.y];
end