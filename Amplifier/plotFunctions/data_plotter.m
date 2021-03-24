function plots = data_plotter(figureName, axTag, joints, P, S)
[a,b,c,d,e,f,g,h,i] = joints{:};
Amp = P(1);
d_in = P(3);
output = i.y - i.y_init;

persistent Amp_v d_in_v output_v
if isempty(Amp_v) || isempty(d_in_v) || isempty(output_v)
    Amp_v = Amp;
    d_in_v = d_in;
    output_v = output;
else
    Amp_v = [Amp_v Amp];
    d_in_v = [d_in_v d_in];
    output_v = [output_v output];
end

if isempty(findobj('tag',axTag))
    % Overall figure
    fig = figure('Name',figureName);
        ax = gca;
        hold on
            ax.Tag = 'ax2';
            ax.Title.String = 'Data';
            ax.Color = 'none';
            ax.XColor = 'none';
            ax.YColor = 'none';       
else
    ax = findobj('Type','Axes','Tag',axTag);
end

% find stuff out
% maximum x dimension
xs = zeros(size(joints));
ys = zeros(size(joints));
for j = 1:length(joints)
    xs(j) = joints{j}.x;
    ys(j) = joints{j}.y;
end
xdim = max(xs)-min(xs);
ydim = max(ys)-min(ys);


% Plot!
if isempty(findobj('Type','annotation'))
    axPos = get(ax, 'position');
    
    axPos(2) = axPos(2)-0.05;
    str = {['Amplification: ', num2str(round(Amp))],...
            ['  Max: ', num2str(round(max(Amp_v)))],...
            ['Input: ',num2str(round(d_in_v(end),2))],...
            ['  Max: ',num2str(round(max(d_in_v),2))],...
            ['Output: ',num2str(round(output_v(end),2))],...
            ['  Max: ',num2str(round(max(output_v),2))],...
            ['X dim: ',num2str(xdim)],...
            ['Y dim; ',num2str(ydim)]};
    plots = annotation('textbox',axPos,'String',str,'FitBoxToText','on');

end
end