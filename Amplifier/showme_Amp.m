function [Plots] = plotter_Amp(figureName,links,joints)
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
hold on



% joints
    % a
    a_p = plot(ax, a.x, a.y,'o', 'color', a.color); 
    
    % b
    b_p = plot(ax, b.x, b.y, 'o', 'color', b.color);
    
    

% links
    % A
    A_p = plot(ax, [a.x b.x], [a.y b.y], 'color', A.color, 'lineWidth', A.lineWidth);
    
    % B
    B_p = plot(ax, [b.x d.x], [b.y d.y], 'color', B.color, 'lineWidth', B.lineWidth);





drawnow;
Plots = [   fig, ax,...
            A_p, B_p...
            a_p, b_p];

end