function [plots] = showme_Amp(figureName,links,joints)
%{
    Function that plots the object given to it. 
%}
% Unpack
[A,B,C,D,E,F,G,H,I] = links{:};
[a,b,c,d,e,f,g,h,i] = joints{:};


fig = figure('Name',figureName);
ax = axes(fig,'Title',[figureName,' ax']);

title(figureName);
xlabel(ax,'X pos [$$\mu$$m]');
ylabel(ax,'Y pos [$$\mu$$m]');
xlim(ax,[0,10]);
ylim(ax,[0,10]);
hold on



% joints
joints_p = gobjects(1,length(joints));
joints_text = gobjects(1,length(joints));
for i = 1:length(joints)
    joints_p(i) = plot(ax, joints{i}.x, joints{i}.y, 'o', 'color', joints{i}.color);
    joints_text = text(ax, joints{i}.x+0.05, joints{i}.y, joints{i}.name);
end
    
% links

links_p = gobjects(1,length(links));
links_text = gobjects(1,length(links));
for i = 1:length(links)
    links_p(i) = plot(ax, [links{i}.start(1), links{i}.finish(1)],...
                          [links{i}.start(2), links{i}.finish(2)],...
                        'color', links{i}.color, 'lineWidth', links{i}.lineWidth);
    links_text(i) = text(ax, mean([links{i}.start(1),links{i}.finish(1)]+0.1),...
                             mean([links{i}.start(2),links{i}.finish(2)]),...
                             links{i}.name);
end

              
drawnow;        
plots = [fig, ax, joints_p, joints_text, joints_p, links_p];
end