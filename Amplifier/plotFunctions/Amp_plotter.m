function plots = Amp_plotter(figureName,axTag, links, joints,S)
[A,B,C,D,E,F,G,H,I] = links{:};
[a,b,c,d,e,f,g,h,i] = joints{:};

%% Find/make figure
if isempty(findobj('tag',axTag))
    % Overall figure
    fig = figure('Name',figureName);
        % Visualisation
        ax = gca;
        hold on
            ax.Tag = axTag;
            ax.Title.String = axTag;
            ax.XLabel.String = 'X pos [$$\mu$$m]';
            ax.YLabel.String = 'Y pos [$$\mu$$m]';
            ax.XLim = [-c.x_init*0.1, c.x_init*1.15];
            if S.mirror == true
                ax.XLim = [-c.x_init*1.15, c.x_init*1.15];
            end
            ax.YLim = [-i.y_init*0.5, i.y_init*2];
            ax.XGrid = 'on';
            ax.YGrid = 'on';
            ax.DataAspectRatio = [1 1 1];
            ax.PlotBoxAspectRatio = [1 1 1];
else
    ax = findobj('Type','Axes','Tag',axTag);
end

%% Mirror
if S.mirror == true
    % Create mirrored links
    linksm = cell(1,length(links));
    for j = 1:length(links) 
        if links{j}.mirrorOffset == false           % Only do this once! (first time)
            links{j}.translate([a.mirrorOffsetVal 0]);
            links{j}.mirrorOffset = true;
        end
        
        
        temp = copy(links{j});
        temp.name = links{j}.name + "'";    % rename to 'linkm'
        temp.start(1) = -links{j}.start(1);    % Mirror start around y axis & Offset
        temp.finish(1) = -links{j}.finish(1);  % Mirror finish around y axis & Offset
        temp.slope = -links{j}.slope;
        
        linksm{j} = copy(temp);
        delete(temp);
    end
    
    % Create mirrored joints
    jointsm = cell(1,length(joints));
    for j = 1:length(joints)  
        if joints{j}.mirrorOffset == false                 % Only do this once! (first time)
            joints{j}.translate([a.mirrorOffsetVal 0]);
            joints{j}.mirrorOffset = true;
        end
        
        temp = copy(joints{j});
        temp.name = joints{j}.name + "'";
        temp.x = -joints{j}.x;
        
        jointsm{j} = copy(temp);
        delete(temp);
    end
    
    % Add these to be looped later while plotting
    joints_t = [joints, jointsm];       % total joints
    links_t = [links, linksm];          % total links
    
    % Adjust the axes
    % ax.XLim = [-c.x_init*1.15 c.x_init*1.15];
else
    joints_t = joints;  % add nothing to the joints
    links_t = links;    % add nothing to the links
end
plots = [];

%% Offset & Rotate entire figure!
%links
for j = 1:length(links_t)
    if links_t{j}.offset == false                           % Only do this once! (first time)
        links_t{j}.rotate(S.Rotation);
        links_t{j}.translate(S.Offset);
        links_t{j}.offset = true;
    end
end

%joints
for j = 1:length(joints_t)
    if joints_t{j}.offset == false                 % Only do this once! (first time)
        joints_t{j}.rotate(S.Rotation);
        joints_t{j}.translate(S.Offset);
        joints_t{j}.offset = true;
    end
end

%% Plot!
% ax: joints
if S.plotJoints == true
    joints_p = gobjects(1,length(joints_t));        % vector with plotted lines
    joints_text = gobjects(1,length(joints_t));     % vector with plotted text
    for j = 1:length(joints_t)
        if joints_t{j}.floating == true
            joints_t{j}.color = [0, 0.4470, 0.7410];
        else
            joints_t{j}.color = 'r';
        end
        
        joints_p(j) = plot(ax, joints_t{j}.x, joints_t{j}.y,...
                            'o', 'color', joints_t{j}.color);
        
        if S.plotNames == true
            posx  = joints_t{j}.x+0.1;
            posy  = joints_t{j}.y;
            joints_text(j) = text(ax, posx,...
                                    posy,...
                                    joints_t{j}.name, 'color', joints_t{j}.color);
        end
    end
    plots = [plots, joints_p, joints_text];
end

% ax: links
if S.plotLinks == true
    links_p = gobjects(1,length(links_t));
    links_text = gobjects(1,length(links_t));
    for j = 1:length(links_t)
        if links_t{j}.free == true
            links_t{j}.color = [0, 0.4470, 0.7410];
        else
            links_t{j}.color = 'k';
        end
        
        links_p(j) = plot(ax, [links_t{j}.start(1), links_t{j}.finish(1)],...
                                [links_t{j}.start(2), links_t{j}.finish(2)],...
                                'color', links_t{j}.color, 'lineWidth', links_t{j}.lineWidth);
        if S.plotNames == true
            POS = 0.1*links_t{j}.L;        % Distance from line. 
            posx = mean([links_t{j}.start(1),links_t{j}.finish(1)]+POS*cos(links_t{j}.slope+pi/2));
            posy = mean([links_t{j}.start(2),links_t{j}.finish(2)]+POS*sin(links_t{j}.slope+pi/2));
            links_text(j) = text(ax, posx,...
                                    posy,...
                                    links_t{j}.name,'color',links_t{j}.color);
        end
    end
    plots = [plots, links_p, links_text];
end


%% Cleanup created and modified objects!
%links
for j = 1:length(links)
    if links{j}.offset == true                           % Only do this once! (first time)
        links{j}.translate(-S.Offset);
        links{j}.rotate(-S.Rotation);
     
        links{j}.offset = false;
    end
    
    if links{j}.mirrorOffset == true
        links{j}.translate([-a.mirrorOffsetVal 0]);
        links{j}.mirrorOffset = false;
    end
end

%joints
for j = 1:length(joints)
    if joints{j}.offset == true                 % Only do this once! (first time)        
        joints{j}.translate(-S.Offset);
        joints{j}.rotate(-S.Rotation);
        
        joints{j}.offset = false;
    end
    
    if joints{j}.mirrorOffset == true
        joints{j}.translate([-a.mirrorOffsetVal 0]);
        joints{j}.mirrorOffset = false;
    end
    
end


% Delete mirrored linkes since they are handle objects. Their scope is
% larger then this function. 
if S.mirror == true
    for j = 1:length(linksm)
        delete(linksm{j});
    end
    for j = 1:length(jointsm)
        delete(jointsm{j});   
    end
end

drawnow;   
end