function sine_grating(title_string,seed0,varargin)
% SINE_GRATING Plots response to a sine_grating stimulus 
%
% CALLING SYNTAX sine_grating(title_string,seed,EXTRA_PARAMS_FOR_DIRSEL...)
% where title_string = string title for plot
%       seed for Possion process for timing of action potentials of model cell 
%       EXTRA_PARAMS_FOR_DIRSEL pass parameters to be fed to DIRSEL 
%
% Code written by SEAN CARVER, last modified 12-5-2007

% The following constants can be changed
% PARAMS can be overwritten input in VARARGIN (extra parameters for DIRSEL)
% MAXTIME is used for plotting, changes require editing this file
maxtime = 3000;
params = {'gamma_d',15,'gamma_n',.7,'Vt',-49,'Vr',-50,'tfinal',maxtime};

% Run model in preferred and non-preferred directions
out_pref = dirsel(params{:},'seed',seed0+1000,varargin{:});
out_nonpref = dirsel(nonpref,params{:},'seed',seed0+2000,varargin{:});

% Pick out burst values 
P_bursts = out_pref.bursts;
N_bursts = out_nonpref.bursts;

% Define plotting constants
XTextPos = 0:500:maxtime;
YTextPos = -25;
TextString = '%2.2g';
%time = out_pref.time - 500;
time = out_pref.time;
Vt = out_nonpref.Vt;

AP_pref = extracellplot(time,find(out_pref.AP == 1),-20,10);
AP_nonpref = extracellplot(time,find(out_nonpref.AP == 1),-20,10);
axis0 = [-500,maxtime,-75,-10];

subplot(2,1,1)
hold off
P = plot(AP_pref{1},AP_pref{2},'c');
set(P,'LineWidth',1)
hold on
[AX,H1,H2] = plotyy(time,out_pref.V,time,1000*out_pref.F);
set(H1,'LineWidth',2)
set(gca,'LineWidth',2);
set(AX,'FontSize',13);
set(AX,'FontWeight','Bold');
axis(AX(1),axis0);
set(AX(1),'YTick',[-70,-40]);
set(AX(2),'YTick',[0,100,200]);
axis(AX(2),[-500,maxtime,0,200*65/35]);
set(H2,'LineWidth',2)
axes(AX(1));
hline(Vt,'b--');
axes(AX(2));
T = title(title_string);
set(T,'FontSize',14);
set(T,'FontWeight','Bold');
axes(AX(1));
text(-400,YTextPos,['E[# APs] = ',num2str(P_bursts(1),TextString)]);
for i = 2:length(P_bursts)
  text(XTextPos(i),YTextPos,num2str(P_bursts(i),TextString));
end
axes(AX(2));
set(AX(2),'YColor','c')
set(H2,'Color','c')
ylabel(AX(1),'Membrane Potential, (mV)');
ylabel(AX(2),'Firing Rate, (Hz)');

subplot(2,1,2)
hold off
P = plot(AP_nonpref{1},AP_nonpref{2},'m');
set(P,'LineWidth',1)
hold on
[AX,H1,H2] = plotyy(time,out_nonpref.V,time,1000*out_nonpref.F);
set(H1,'LineWidth',2)
set(gca,'LineWidth',2);
set(AX,'FontSize',13);
set(AX,'FontWeight','Bold');
axis(AX(1),axis0);
set(AX(1),'YTick',[-70,-40]);
axis(AX(2),[-500,maxtime,0,200*65/35]);
set(H2,'LineWidth',2)
axes(AX(1));
hline(Vt,'r--');
text(-400,YTextPos,['E[# APs] = ',num2str(N_bursts(1),TextString)]);
for i = 2:length(N_bursts)
  text(XTextPos(i),YTextPos,num2str(N_bursts(i),TextString));
end
axes(AX(2));
set(AX(1),'YColor','r')
set(AX(2),'YColor','m')
set(AX(2),'YTick',[0,100,200]);
set(H1,'Color','r');
set(H2,'Color','m')
ylabel(AX(1),'Membrane Potential, (mV)');
ylabel(AX(2),'Firing Rate, (Hz)');
