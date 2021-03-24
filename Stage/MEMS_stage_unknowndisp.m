clc
clear all
close all

syms dispA dispC dispE
syms rot x y 
%% initial conditions
%desired position
x=-15E-6;
y=15E-6;
rot=-2;
%origin location, can be changed
origin=[0,0];
%max chip size
chipx=[2.5 -2.5 -2.5 2.5 2.5]*1E-3;
chipy=[5 5 -5 -5 5]*1E-3;

%define silicon square
siliconx=[0.5 -0.5 -0.5 0.5 0.5]*1E-3;
silicony=[0.5 0.5 -0.5 -0.5 0.5]*1E-3;

%define contact points
side=(0.5/tand(60)+0.5)*1E-3;

%define hexagon [Xcoord Ycoord] letter order can be seen in the figure on
%the drive
A=[0 side];
B=[-cosd(30)*side sind(30)*side];
C=[-cosd(30)*side -sind(30)*side];
D=[0 -side];
E=[cosd(30)*side -sind(30)*side];
F=[cosd(30)*side sind(30)*side];
%easier plotting of hexagon
hexagonx=[A(1),B(1),C(1),D(1),E(1),F(1),A(1)];
hexagony=[A(2),B(2),C(2),D(2),E(2),F(2),A(2)];
%plotting attachment points
attachx=[A(1),C(1),E(1)];
attachy=[A(2),C(2),E(2)];
%required RoM, rotation=2degrees
requiredx=[origin(1)+15E-6 origin(1)-15E-6 origin(1)-15E-6 origin(1)+15E-6 origin(1)+15E-6];
requiredy=[origin(2)+15E-6 origin(2)+15E-6 origin(2)-15E-6 origin(2)-15E-6 origin(2)+15E-6];

%rotation can be animated
k=1;

x_origin=linspace(0,x,k);
y_origin=linspace(0,y,k);
rot_origin=linspace(0,rot,k);
xy_origin=[x_origin;y_origin];


%% solving equations
for i=1:k
disp(['Calculation iteration: ',num2str(i)]);                                       %
eqn1= sind(60)*dispE-sind(60)*dispC==y_origin(i);
eqn2= cosd(60)*dispE+cosd(60)*dispC-dispA==x_origin(i);
eqn3=2*asind(0.5*dispA/side)+2*asind(0.5*dispC/side)+2*asind(0.5*dispE/side)==rot_origin(i);
eqns=[eqn1 eqn2 eqn3];
Set = solve(eqns,[dispA dispC dispE],'Real',true);
Set.dispA;
Set.dispC;
Set.dispE;

% Verification

verify_A(i)=double(Set.dispA);
verify_C(i)=double(Set.dispC);
verify_E(i)=double(Set.dispE);
end

verify_x=cosd(60)*verify_E+cosd(60)*verify_C-verify_A;
verify_y=sind(60)*verify_E-sind(60)*verify_C;
verify_rot=2*asind(0.5*verify_A/side)+2*asind(0.5*verify_C/side)+2*asind(0.5*verify_E/side);

%% Make amplifier                                                                   %
% Let's attatch our new amplifier to corner E for fun. 
% Plot options                  These are general settings the amplifier            %       
Set.plotLinks = true;             % Show the links?                                 %
Set.plotJoints = false;            % Show the joints                                 %
Set.plotNames = false;             % Show all the names?                             %
Set.mirror = true;                % Mirror the mechanism? (more for show)           %
Set.Meters = true;

[links, joints] = makeMechanism_Amp(Set);                                           %  
[~] = kinModel_Amp(links, joints, 0);


% Where to put the origin? initially:
extraLength = norm(A);                                                              %
amp_length = joints{end}.y + extraLength;     % find the length first.              %
amp_angle = [0, 120, 240]; 

amp_pos_init(1,:) = A + [cosd(amp_angle(1)) sind(amp_angle(1))]*amp_length; 
amp_pos_init(2,:) = C + [cosd(amp_angle(2)) sind(amp_angle(2))]*amp_length;
amp_pos_init(3,:) = E + [cosd(amp_angle(3)) sind(amp_angle(3))]*amp_length;

%% Coordinates
for i=1:k
new_A(:,i)=A+[-verify_A(i) 0];
new_C(:,i)=C+[cosd(60)*verify_C(i) -sind(60)*verify_C(i)];
new_E(:,i)=E+[cosd(60)*verify_E(i) sind(60)*verify_E(i)];

%new_B(:,i)=xy_origin(:,i)+side*[-cosd(30-verify_rot(i)) sind(30-verify_rot(i))].';
new_B(:,i)=xy_origin(:,i)+2*((0.5*abs(new_A(:,i)-new_C(:,i))+new_C(:,i))-xy_origin(:,i));
new_D(:,i)=xy_origin(:,i)+side*[sind(verify_rot(i)) -cosd(verify_rot(i))].';
new_F(:,i)=xy_origin(:,i)+side*[cosd(30-verify_rot(i)) sind(30-verify_rot(i))].';

% easier plotting
new_hexagonx(i,:)=[new_A(1,i) new_B(1,i) new_C(1,i) new_D(1,i) new_E(1,i) new_F(1,i) new_A(1,i)];
new_hexagony(i,:)=[new_A(2,i) new_B(2,i) new_C(2,i) new_D(2,i) new_E(2,i) new_F(2,i) new_A(2,i)];
end

%verify
verify_angle = -(asind(E(2)/norm(origin-E))- asind(new_E(2,end)/norm(xy_origin(:,end)-new_E(:,end))));
%points B,D and F deform a bit because small deformation is required to
%allow movement, this means that the verification angle is slightly off.
verify_origin=new_C+new_A+new_E;




%% plotting
figure('Name','Matlab Design');
grid on
axis equal
ax = gca;                                                                       %
ax.Tag = 'ax1';                                                                 %
patch(siliconx,silicony,'w')
hold on
plot(origin(1),origin(2),'r*') 
plot(chipx,chipy,'c')
plot(hexagonx,hexagony,'b')
plot(requiredx,requiredy,'r')
plot(attachx,attachy,'bo')
for i=1:k
    plot(new_hexagonx(i,:),new_hexagony(1,:),'b')

    plot(x_origin(i),y_origin(i),'r*')
    plot(new_A(1,:),new_A(2,:),'r-')
    plot(new_A(1,end),new_A(2,end),'rd')
    plot(new_C(1,:),new_C(2,:),'r-')
    plot(new_C(1,end),new_C(2,end),'rd')
    plot(new_E(1,:),new_E(2,:),'r-')
    plot(new_E(1,end),new_E(2,end),'rd')
    
    [~] = kinModel_Amp(links, joints, 0);
    for j = 1:3
        Set.Offset = amp_pos_init(j,:);                                                  %
        Set.Rotation = deg2rad(amp_angle(j)+90);

        Amp_plotter('Matlab Design','ax1',links,joints,Set);
    end
end
display("Displacement of A: "+verify_A(end))
display("Displacement of C: "+verify_C(end))
display("Displacement of E: "+verify_E(end))
display("Maximum displacement required: " + 2*max([abs(verify_A) abs(verify_C) abs(verify_E)]));