function [plots] = showme_Amp(figureName,links,joints,Amp,S)
%{
    Function that plots the object given to it. 
%}
[A,B,C,D,E,F,G,H,I] = links{:};
[a,b,c,d,e,f,g,h,i] = joints{:};

if isempty(findobj('Name',figureName))
    fig = figure('Name',figureName);
    ax = axes(fig,'Title',[figureName]);

    title(figureName);
    xlabel(ax,'X pos [$$\mu$$m]');
    ylabel(ax,'Y pos [$$\mu$$m]');
    xlim(ax,[-5,15]);
    ylim(ax,[-5,15]);
    hold on
else
    fig = findobj('Name',figureName);
    ax = findobj('Type','Axes','parent',fig);
end

% put plots in nice array, such that they can be exported and deleted in
% looped function later on.  
plots = [fig, ax];

% Amplification factor
if isempty(findobj('Type','annotation'))
    dim = [0.6 0.8 0.1 0.1];
    str = {['Amplification factor: ', num2str(round(Amp))],...
            ['Input: ',num2str(round(a.y,2))]};
    Amp_p = annotation('textbox',dim,'String',str,'FitBoxToText','on');
    plots = [plots, Amp_p];
end

% joints
if S.plotJoints == true
    joints_p = gobjects(1,length(joints));
    joints_text = gobjects(1,length(joints));
    for j = 1:length(joints)
        if joints{j}.floating == true
            joints{j}.color = [0, 0.4470, 0.7410];
        else
            joints{j}.color = 'r';
        end
        
        joints_p(j) = plot(ax, joints{j}.x, joints{j}.y,...
                            'o', 'color', joints{j}.color);
        
        if S.plotNames == true
            posx  = joints{j}.x+0.5;
            posy  = joints{j}.y;
            joints_text(j) = text(ax, posx,...
                                    posy,...
                                    joints{j}.name, 'color', joints{j}.color);
        end
    end
    plots = [plots, joints_p, joints_text];
end

% links
if S.plotLinks == true
    links_p = gobjects(1,length(links));
    links_text = gobjects(1,length(links));
    for j = 1:length(links)
        if links{j}.free == true
            links{j}.color = [0, 0.4470, 0.7410];
        else
            links{j}.color = 'k';
        end
        
        links_p(j) = plot(ax, [links{j}.start(1), links{j}.finish(1)],...
                                [links{j}.start(2), links{j}.finish(2)],...
                                'color', links{j}.color, 'lineWidth', links{j}.lineWidth);
        if S.plotNames == true
            posx = mean([links{j}.start(1),links{j}.finish(1)]+0.1);
            posy = mean([links{j}.start(2),links{j}.finish(2)]);
            links_text(j) = text(ax, posx,...
                                    posy,...
                                    links{j}.name,'color',links{j}.color);
        end
    end
    
    plots = [plots, links_p, links_text];
end



              
drawnow;        
end