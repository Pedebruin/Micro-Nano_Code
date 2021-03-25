function [plots] = showme_Amp(figureName,links,joints,P,S)
%{
    Function that plots the object given to it taking the settings in S into account. 
 
    Dont forget to clear this function's persistent variables after the
    last use! otherwise it might interfere with the next required plot. 
%}
% Unpack
[A,B,C,D,E,F,G,H,I] = links{:};
[a,b,c,d,e,f,g,h,i] = joints{:};

%% Create figure
if isempty(findobj('Name',figureName))
    % Overall figure
    fig = figure('Name',figureName);
    sgtitle(figureName);
        % Visualisation subplot
        ax1 = subplot(2,3,[1 2]);
        hold on
            ax1.Tag = ['ax1',figureName];
            ax1.Title.String = 'Visualisation';
            ax1.XLabel.String = 'X pos [$$\mu$$m]';
            ax1.YLabel.String = 'Y pos [$$\mu$$m]';
            ax1.XLim = [-c.x_init*0.1, c.x_init*1.15];
            if S.mirror == true
                ax1.XLim = [-c.x_init*1.15, c.x_init*1.15];
            end
            ax1.YLim = [-i.y_init*0.5, i.y_init*2];
            ax1.XGrid = 'on';
            ax1.YGrid = 'on';
            ax1.DataAspectRatio = [1 1 1];
            ax1.PlotBoxAspectRatio = [1 1 1];
        
        % Data box
        ax2 = subplot(2,3,3);
        hold on
            ax2.Tag = ['ax2',figureName];
            ax2.Title.String = 'Data';
            ax2.Color = 'none';
            ax2.XColor = 'none';
            ax2.YColor = 'none';
            
        % Amplification factor subplot
        ax3 = subplot(2,3,4);
        hold on
            ax3.Tag = ['ax3',figureName];
            ax3.Title.String = 'Amplification factor';
            ax3.XLabel.String = 'Input Displacement';
            ax3.YLabel.String = 'Inst. Amp';
            ax3.XLim = [S.d_in_min, S.d_in_max];
            ax3.XGrid = 'on';
            ax3.YGrid = 'on';
            
        % Force guess plot
        ax4 = subplot(2,3,5);
        hold on
            ax4.Tag = ['ax4',figureName];
            ax4.Title.String = 'Crude force estimation';
            ax4.XLabel.String = 'Input Displacement';
            ax4.YLabel.String = 'Force [N]';
            ax4.XLim = [S.d_in_min, S.d_in_max];
            ax4.XGrid = 'on';
            ax4.YGrid = 'on';

else
    fig = findobj('Name',figureName);
    ax1 = findobj('Parent',fig,'Tag','ax1');
    ax2 = findobj('Parent',fig,'Tag','ax2');
    ax3 = findobj('Parent',fig,'Tag','ax3');
    ax4 = findobj('Parent',fig,'Tag','ax4');
end

plots = [];
%% Start plotting!
% ax1: Visualisation
mechanism_p = Amp_plotter(figureName,'ax1', links, joints, S);
plots = [plots mechanism_p];

% ax2: Data
data = data_plotter(figureName, 'ax2', joints, P, S);
plots = [plots data];

% ax3: Amplification factor
ampf = ampf_plotter(figureName, 'ax3',P,S);
plots = [plots ampf];

% ax4: Force estimation
force_p = force_plotter(figureName, 'ax4',P,S);
plots = [plots force_p];

drawnow;        
end