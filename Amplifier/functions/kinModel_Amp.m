function [Amp] = kinModel_Amp(links, joints, P)
%{
This evaluates the kinematic model and updates the angles and positions of
the joints and link instances and are stored in the instances itself. These can later be plotted. 
%}

% Unpack
[A,B,C,D,E,F,G,H,I] = links{:};
[a,b,c,d,e,f,g,h,i] = joints{:};

%% Links
    %{
    https://math.stackexchange.com/questions/256100/
    how-can-i-find-the-points-at-which-two-circles-intersect
    %}
% a
    % a.x = 0;
    % a.y is defined in the main script, as this is the input. (Yes, you
    % just need to know). 
% b    
    [b.x, b.y] = intersection(a,d,A,B);

% c   
    [c.x, c.y] = intersection(b,d,C,D);

% d
    % d is fixed, thus an easy point. 
    
% e
    [e.x, e.y] = intersection(f,c,F,E);
    
% f 
    % f is fixed, thus an easy point. 
    
% g 
    % g is fixed,  thus an easy point
    
% h  
    [h.x, h.y] = intersection(g,e,H,G);
% i
    % i.x is kept at the value it has when it arrives at the kinModel. 
    i.y = h.y + sqrt(I.L^2-h.x^2);
    
  %% Joints  
  % Just connect the links to each other by means of defining the ending
  % and starting points as the joint locations. 
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
    
    
%% Check link lengths!
    % If the calculated and defined lengths do not correspond, a joint
    % position is not calculated properly. 
    for j = 1:length(links)
        if round(norm(links{j}.start-links{j}.finish),2) ~= round(links{j}.L,2)
            warning(['Link ', links{j}.name, ' Is not the correct length!! GO AND FIX IT']);
            disp(['Defined length: ', num2str(links{j}.L)]);
            disp(['Calculated length: ', num2str(norm(links{j}.start-links{j}.finish))]);
        end
    end
%% Amplification factor

    % Get initial i_y position
    if ~isprop(i,'y_init')
        addprop(i,'y_init');
        i.y_init = i.y;
    end
    Amp = (i.y - i.y_init)/a.y;
    
%% Function defenition   
    function [x,y] = intersection(point1, point2, link1, link2)   
        %{
            This function finds the intersection point between two circles
            with centers at point1 and point2, and radii of link1 and
            link2.
        %}
        
        R = norm([point1.x,point1.y]-[point2.x,point2.y]);  % Distance between center points
        r1 = link1.L;   % Radius of circle 1
        r2 = link2.L;   % Radius of circle 2
        x1 = point1.x;  % position of center 1
        x2 = point2.x;  
        y1 = point1.y;  % position of center 2
        y2 = point2.y;
        
        % very complicated, much mathematical
        temp = 1/2*[x1+x2, y1+y2] ...
            + (r1^2-r2^2)/(2*R^2)*[x2-x1, y2-y1] ...
            - 1/2*sqrt(2*(r1^2+r2^2)/R^2 - (r1^2-r2^2)^2/R^4 - 1)*[y2-y1, x1-x2];
        x = temp(1);
        y = temp(2);    
    end
end