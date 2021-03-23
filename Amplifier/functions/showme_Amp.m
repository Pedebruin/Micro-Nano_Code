function [plots] = showme_Amp(figureName,links,joints,Amp,S)
%{
    Function that plots the object given to it taking the settings in S into account.  
%}
[A,B,C,D,E,F,G,H,I] = links{:};
[a,b,c,d,e,f,g,h,i] = joints{:};

% Save the last amplification factors for plotting. 
if isnan(Amp)
    Amp = 0;
end
persistent amp_v input_v output_v
if isempty(amp_v)
    amp_v = Amp;
    input_v = a.y;
    output_v = i.y - i.y_init;
else
    amp_v = [amp_v Amp];
    input_v = [input_v a.y];
    output_v = [output_v i.y-i.y_init]; 
end

%% Create figure
if isempty(findobj('Name',figureName))
    % Overall figure
    fig = figure('Name',figureName);
    sgtitle(figureName);
    
        % Visualisation subplot
        ax1 = subplot(2,3,[1 2 4 5]);
        hold on
            ax1.Tag = 'ax1';
            ax1.Title.String = 'Visualisation';
            ax1.XLabel.String = 'X pos [$$\mu$$m]';
            ax1.YLabel.String = 'Y pos [$$\mu$$m]';
            ax1.XLim = [-5, c.x_init*1.15];
            ax1.YLim = [-5, i.y_init*2];
            ax1.XGrid = 'on';
            ax1.YGrid = 'on';
            ax1.DataAspectRatio = [1 1 1];
            ax1.PlotBoxAspectRatio = [1 1 1];
        
        % Data box
        ax2 = subplot(2,3,3);
        hold on
            ax2.Tag = 'ax2';
            ax2.Title.String = 'Data';
            ax2.Color = 'none';
            ax2.XColor = 'none';
            ax2.YColor = 'none';
            
        
        % Amplification factor subplot
        ax3 = subplot(2,3,6);
        hold on
            ax3.Tag = 'ax3';
            ax3.Title.String = 'Amplification factor';
            ax3.XLabel.String = 'Input Displacement';
            ax3.YLabel.String = 'Inst. Amp';
            ax3.XLim = [S.d_in_min, S.d_in_max];
            ax3.XGrid = 'on';
            ax3.YGrid = 'on';
            
            

else
    fig = findobj('Name',figureName);
    ax1 = findobj('Parent',fig,'Tag','ax1');
    ax2 = findobj('Parent',fig,'Tag','ax2');
    ax3 = findobj('Parent',fig,'Tag','ax3');
end

% put plots in nice array, such that they can be exported and deleted in
% looped function later on.  
%plots = [fig, ax1, ax2];
plots = [];

%% Mirror if asked
if S.mirror == true
    % Create mirrored links
    linksm = cell(1,length(links));
    for j = 1:length(links)
        if links{j}.offset == false           % Only do this once! (first time)
            links{j}.start(1) = links{j}.start(1) + S.mirrorOffset;     % Offset original figure
            links{j}.finish(1) = links{j}.finish(1) + S.mirrorOffset;   % Offset original figure
            links{j}.offset = true;
        end
        
        temp = copy(links{j});
        temp.name = links{j}.name + "'";    % rename to 'linkm'
        temp.start(1) = -links{j}.start(1);    % Mirror start around y axis & Offset
        temp.finish(1) = -links{j}.finish(1);  % Mirror finish around y axis & Offset
        
        linksm{j} = copy(temp);
        delete(temp);
    end
    
    % Create mirrored joints
    jointsm = cell(1,length(joints));
    for j = 1:length(joints)
        if joints{j}.offset == false                 % Only do this once! (first time)
            joints{j}.x = joints{j}.x + S.mirrorOffset;     % Offset original figure
            joints{j}.offset = true;
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
    ax1.XLim = [-c.x_init*1.15 c.x_init*1.15];
else
    joints_t = joints;  % add nothing to the joints
    links_t = links;    % add nothing to the links
end

%% Find interesting stuff
% maximum x dimension
xs = zeros(size(joints_t));
ys = zeros(size(joints_t));
for j = 1:length(joints_t)
    xs(j) = joints_t{j}.x;
    ys(j) = joints_t{j}.y;
end
xdim = max(xs)-min(xs);
ydim = max(ys)-min(ys);

%% Start plotting!
% Data
if isempty(findobj('Type','annotation'))
    ax2Pos = get(ax2, 'position');
    
    ax2Pos(2) = ax2Pos(2)-0.05;
    str = {['Amplification: ', num2str(round(Amp))],...
            ['  Max: ', num2str(round(max(amp_v)))],...
            ['Input: ',num2str(round(input_v(end),2))],...
            ['  Max: ',num2str(round(max(input_v),2))],...
            ['Output: ',num2str(round(output_v(end),2))],...
            ['  Max: ',num2str(round(max(output_v),2))],...
            ['X dim: ',num2str(xdim)],...
            ['Y dim; ',num2str(ydim)]};
    Amp_p = annotation('textbox',ax2Pos,'String',str,'FitBoxToText','on');
    plots = [plots, Amp_p];
end

% Amplification factor
if size(amp_v) > 1
    plot(ax3,input_v,amp_v,'k*');
else
    plot(ax3,input_v,amp_v,'k-');
end

% joints
if S.plotJoints == true
    joints_p = gobjects(1,length(joints_t));        % vector with plotted lines
    joints_text = gobjects(1,length(joints_t));     % vector with plotted text
    for j = 1:length(joints_t)
        if joints_t{j}.floating == true
            joints_t{j}.color = [0, 0.4470, 0.7410];
        else
            joints_t{j}.color = 'r';
        end
        
        joints_p(j) = plot(ax1, joints_t{j}.x, joints_t{j}.y,...
                            'o', 'color', joints_t{j}.color);
        
        if S.plotNames == true
            posx  = joints_t{j}.x+0.5;
            posy  = joints_t{j}.y;
            joints_text(j) = text(ax1, posx,...
                                    posy,...
                                    joints_t{j}.name, 'color', joints_t{j}.color);
        end
    end
    plots = [plots, joints_p, joints_text];
end

% links
if S.plotLinks == true
    links_p = gobjects(1,length(links_t));
    links_text = gobjects(1,length(links_t));
    for j = 1:length(links_t)
        if links_t{j}.free == true
            links_t{j}.color = [0, 0.4470, 0.7410];
        else
            links_t{j}.color = 'k';
        end
        
        links_p(j) = plot(ax1, [links_t{j}.start(1), links_t{j}.finish(1)],...
                                [links_t{j}.start(2), links_t{j}.finish(2)],...
                                'color', links_t{j}.color, 'lineWidth', links_t{j}.lineWidth);
        if S.plotNames == true
            posx = mean([links_t{j}.start(1),links_t{j}.finish(1)]+0.1);
            posy = mean([links_t{j}.start(2),links_t{j}.finish(2)]);
            links_text(j) = text(ax1, posx,...
                                    posy,...
                                    links_t{j}.name,'color',links_t{j}.color);
        end
    end
    plots = [plots, links_p, links_text];
end

%% Cleanup
% remove offset since this is changed in the actual handle object. We only
% want this to exist within this function, not anywhere else!
for j = 1:length(links)
    if links{j}.offset == true           % Only do this once! (first time)
        links{j}.start(1) = links{j}.start(1) - S.mirrorOffset;     % Offset original figure
        links{j}.finish(1) = links{j}.finish(1) - S.mirrorOffset;   % Offset original figure
        links{j}.offset = false;
    end
end
for j = 1:length(joints)
        if joints{j}.offset == true                 % Only do this once! (first time)
            joints{j}.x = joints{j}.x - S.mirrorOffset;     % Offset original figure
            joints{j}.offset = false;
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