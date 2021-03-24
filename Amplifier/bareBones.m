clear all
close all

% Plot options                  These are general settings for all plots made. 
S.plotLinks = true;             % Show the links?
S.plotJoints = true;            % Show the joints?
S.plotNames = true;             % Show all the names?
S.mirror = true;               % Mirror the mechanism? (more for show)
S.Offset = [0 0];              % Move figure?
S.Rotation = deg2rad(0);        % Rotate figure?
S.Meters = true;                % DONT FORGET TO ADJUST THE MIRROR OFFSET 


[links, joints] = makeMechanism_Amp(S);
d_in = 1e-6; % Give input
[~] = kinModel_Amp(links, joints, d_in);
plots = Amp_plotter('test','testax',links,joints,S);