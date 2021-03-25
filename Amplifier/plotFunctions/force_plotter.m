function plots = force_plotter(figureName, axTag, P, S)
if S.mirror == true
    F = 2*P(2);
else
    F = P(2);
end
d_in = P(3);

persistent F_v d_in_v
if isempty(F_v) || isempty(d_in_v)
    F_v = F;
    d_in_v = d_in;
else
    F_v = [F_v F];
    d_in_v = [d_in_v d_in];
end

if isempty(findobj('tag',[axTag, figureName]))
    % Overall figure
    fig = figure('Name',figureName);
        % Visualisation
        ax = gca;
        hold on
            ax.Tag = [axTag, figureName];
            ax.Title.String = 'Crude force estimation';
            ax.XLabel.String = 'Input Displacement';
            ax.YLabel.String = 'Force [N]';
            ax.XLim = [S.d_in_min, S.d_in_max];
            ax.XGrid = 'on';
            ax.YGrid = 'on';
else
    ax = findobj('Type','Axes','Tag',[axTag, figureName]);
end

% Actual plot
F_p = plot(ax,d_in_v(end),F_v(end),'ko');
plot(ax,d_in_v,F_v,'k--');
plots =  F_p;
end