function plots = ampf_plotter(figureName, axTag, P, S)
Amp = P(1);
d_in = P(3);

% Save stuff for plotting. 
persistent amp_v d_in_v
if isempty(amp_v)
    amp_v = Amp;                        % Amplification factor
    d_in_v = d_in;
else
    amp_v = [amp_v Amp];
    d_in_v = [d_in_v d_in];
end

if isempty(findobj('tag',[axTag, figureName]))
    % Overall figure
    fig = figure('Name',figureName);
        % Visualisation
        ax = gca;
        hold on
            ax.Tag = [axTag, figureName];
            ax.Title.String = 'Amplification factor';
            ax.XLabel.String = 'Input Displacement';
            ax.YLabel.String = 'Inst. Amp';
            ax.XLim = [S.d_in_min, S.d_in_max];
            ax.XGrid = 'on';
            ax.YGrid = 'on';
else
    ax = findobj('Tag',[axTag, figureName]);
end
plots = plot(ax,d_in_v(end),amp_v(end),'ko');
plot(ax,d_in_v,amp_v,'k--');
end