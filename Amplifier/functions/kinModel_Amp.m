function P = kinModel_Amp(links, joints, S)
%{
This evaluates the kinematic model and updates the angles and positions of
the joints and link instances and are stored in the instances itself. These can later be plotted. 
%}

% Unpack
[A,B,C,D,E,F,G,H,I] = links{:};
[a,b,c,d,e,f,g,h,i] = joints{:};

%% Check if model is run before
link_inits = 0;
for j = 1:length(links)
    link_inits = link_inits+ ~isempty(links{j}.start_init); 
end

joint_inits = 0;
for j = 1:length(joints)
    joint_inits = joint_inits + ~isempty(joints{j}.x_init);
end

initialised = joint_inits == length(joints) && link_inits == length(links); % Is the initial position already calculated?
if initialised 
    % Just continue with the current configuration. 
    n = 1;
else 
    % First run the script with zero displacement and save the 
    n = 2;
end

% Actual kinematic model script: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j = 1:n
    %% Make sure the initial position is set correctly at the first evaluation. 
    if n == 2 && j < 2      % First run
        % Set zero displacement
        disp_temp = a.y;
        a.y = 0;
    elseif n==2 && j == 2   % Second run
        % Set initial values to just calculated ones. 
        % For the links
        for k = 1:length(links)
            links{k}.start_init = links{k}.start;
            links{k}.finish_init = links{k}.finish;
            links{k}.slope_init = links{k}.slope;
        end
        % For the joints
        for k = 1:length(joints)
            joints{k}.x_init = joints{k}.x;
            joints{k}.y_init = joints{k}.y; 
        end
        
        % Change a.y back. 
        a.y = disp_temp; 
    else                    % Every other run. 
        % Do exactly nothing :)
    end
    

    
    %% Calculate joint positions
    %{
    https://math.stackexchange.com/questions/256100/
    how-can-i-find-the-points-at-which-two-circles-intersect
    %}
    % a
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

    %% Put these in link positions 
    % Just connect the links to each other by means of defining the ending
    % and starting points as the joint locations. 
    
    for k = 1:length(links)
        links{k}.start = [links{k}.parents{1}.x links{k}.parents{1}.y];
        links{k}.finish = [links{k}.parents{2}.x links{k}.parents{2}.y];
    end
    
    %% Calculate the angle with x axis
    for k = 1:length(links)
        slope = asin((links{k}.finish(2)-links{k}.start(2))/links{k}.L); % dy/dx
        links{k}.slope = rad2deg(real(round(slope,5)));
    end

    %% Check link lengths!
    % If the calculated and defined lengths do not correspond, a joint
    % position is not calculated properly. 
    for k = 1:length(links)
        if round(norm(links{k}.start-links{k}.finish),2) ~= round(links{k}.L,2)
            warning(['Link ', links{k}.name, ' Is not the correct length!! GO AND FIX IT']);
            disp(['Defined length: ', num2str(links{k}.L)]);
            disp(['Calculated length: ', num2str(norm(links{k}.start-links{k}.finish))]);
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Amplification factor
    Amp = (i.y - i.y_init)/a.y;  

    
%% Deformation update
    % A
        A.deform = 0; % Negligable i think
    % B
        B.deform = abs(B.slope - B.slope_init);
    % C
        C.deform = 0; % Negligable i think
    % D
        D.deform = abs(D.slope - D.slope_init);
    % E
        E.deform = 0; % Negligable i think
    % F
        F.deform = abs(F.slope - F.slope_init);
    % G
        G.deform = abs(G.slope - G.slope_init) - abs(E.slope - E.slope_init);
    % H
        H.deform = abs(H.slope - H.slope_init); % CRUDE
    % I
        I.deform = abs(I.slope - I.slope_init); % CRUDE
    
%% Force calculation
F = 0;    


P = [Amp, F];
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