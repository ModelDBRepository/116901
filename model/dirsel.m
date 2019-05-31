function out = dirsel(varargin)
% DIRSEL: Main engine for Carver, Roth, Cowan, Fortune Model
% CALLING SYNTAX: out = dirsel(PARAMS)
% Code written by Sean Carver, last modified 12-5-07

% Afferent parameters
Rb = 5/1000;  % Baseline firing rate of afferents (1/msec)
Rc = 0.172*log(67*.2); % Contrast dependent constant (Af*log(Cf*C)) (1/msec)
xn = -45;     % position of non-depressing receptive field (degrees)
xd = 45;      % position of depressing receptive field (degrees)

% Synapse parameters & initial conditions
tau_D = 150;  % time constant for faster depression process (msec)
tau_S = 3000; % time constant for slower depression process (msec)
d = 0.4;      % fast depression strength 
s = 0.99;     % slow depression strength
D0 = 1;       % initial condition for fast variable
S0 = 1;       % initial condition for slow variable

% Conductance parameters
gamma_d = 4.5;   % depressing synaptic factor
gamma_n = 0.045; % non-depressing synaptic factor

% Membrane parameters
V0 = -70;   % resting potential (mV)
VE = 0;     % synaptic reversal potential (E = Excitatory) (mV)
Vt = -64;   % threshold for action potentials (mV)
Vr = -65;   % reset potential for action potentials (mV)
tau_m = 30;    % membrane time constant, used to compute firing rate (msec)
tau_R = 10;   % refractory period of membrane (msec)

% Stimulus parameters
t0 = -500;            % start time for stimulus (msec)
ts = 0;               % switching time from preinitization to pulse/sine 
tfinal = 5500;            % final time of stimulus
lambda = 360;         % spatial wavelength (degrees)
f = 2/1000;           % temporal frequency of sine-grating oscillation (1/msec)
phi = 225;            % initial phase of sine-grating at (x,t) = 0 (degrees)
f_gamma = 20/1000;    % temporal frequency of gamma band oscillation (1/msec)
A_gamma = .7;         % Amplitude of gamma band oscillations
sigma = 1;            % preferred direction = 1, nonpreferred = -1
p0 = Inf;             % (leading?) boundary of pulse
p1 = -Inf;            % (leading?) boundary of pulse
greyvalue = 0;        % Intensity of 50% grey (parameter of function Igrey)

% Changing the following varaibles allows alternative specifications of stimuli 
num_stim_seg = 1;    % number of stimulus regimes
Ifun1 = @Ipreinitseq; % stimulus (function returning intensity)
stim = [];           % Can pass own stimulus structure instead of assembling

% Parameters for alternative stimuli
Ifun2 = @Isine;     % second stimulus (function returning intensity)
Ifun3 = @Igrey;      % third stimulus (function returning intensity)
Ifun4 = @Igrey;      % fourth stimulus (function returning intensity)
t0_2 = 0;            % start time for stimulus (msec)
t0_3 = 0;            % start time for stimulus (msec)
t0_4 = 0;            % start time for stimulus (msec)
tfinal_2 = 5500;         % final time of sitmulus
tfinal_3 = 1000;         % final time of sitmulus
tfinal_4 = 1000;         % final time of sitmulus

% Simulation parameters
seed = 0;            % seed for Poisson process
dt = 2;              % time step for Euler simulation (msec)

% Output (stimulus plotting) parameters
imageflag = 0;        % set to 1 to output image of stimulus, otherwise 0
xplot = -155:370;   % stimulus image plot range

% The next line replaces the default parameters specified above with 
% values specified in the arguments used to call this function, varargin{:}. 
% WHO passes the list of variables in the workspace for error checking.

replace(varargin,who);  

% Initialize random number generator for Poisson process
rand('state',seed);  

% Assemble stimulus structure (up to 4 segments, add to this function for more)
% if num_stim_seg < 4 some parameters defined above are not used
% stim is a structure containing the stimulus parameters
if isempty(stim);              % not passing own stimulus structure?
  stim(1).Ifun = Ifun1;
  stim(1).t_segment = tfinal-t0;    % stimulus duration (msec)
  stim(1).t_initial = t0;
   stim(2).Ifun = Ifun2;
   stim(2).t_segment = tfinal_2;    % stimulus duration (msec)
   stim(2).t_initial = t0_2;
  stim(3).Ifun = Ifun3;
  stim(3).t_segment = tfinal_3;
  stim(3).t_initial = t0_3;
   stim(4).Ifun = Ifun4;
   stim(4).t_segment = tfinal_4;    % stimulus duration (msec)
   stim(4).t_initial = t0_4;
end

% Derived variables: tmax, time, kmax
% where time = vector of sample times for simulation, 
%       tmax = time(end), and
%       kmax = length(time)
% kstim is used to index the stimulus segments
if isfield(stim,'t_segment');    % t_segment differs for each stimulus segment
  tmax = 0;                      % initialize tmax
  for k_stim = 1:num_stim_seg    % loop over stimulus segments
    tmax = tmax + stim(k_stim).t_segment;  % add up the t_segment's
  end
else   % t_segment defined in parameter list, i.e. the same for all segments
  tmax = t_segment*num_stim_seg; % multiply t_segment times number of segments
end
time = (dt:dt:tmax) + t0;               % construct vector of sample times
kmax = length(time);             % read off number of samples

% Get cell array of intensity function parameters and period of stimuli
% k_stim is used to index the stimulus segments
% IparamsString is a string of the stimulus parameters 
%   e.g. IparamsSring = '{Ag,fg}';
% Iparams{k_stim} is a cell array of the values of the stimulus parameters 
%   for the k_stim^th segment 
%   ...  obtained by evaluating IparamsString in DIRSEL function's workspace
for k_stim = 1:num_stim_seg     % loop over stimulus segments
  extract(stim(k_stim));        % extract fields Ifun, t_initial, and t_segment
  IparamsString = Ifun();       % call with no args to return string of params
       % then turn string into cell array using the variables in the workspace
  Iparams{k_stim} = eval(IparamsString); 
end

% Skip this section if imageflag == 0
% Create stimulus image if indicated by imageflag == 1
% Ifun evaluated not at ([xd xn],time) but at (xplot(1:end),time(1:end))
% BitMap can be plotted with image(BitMap); this function sets the colormap
% if imageflag > 1 returns I(x,t) = I(xplot(1:end),time(1:end))
%   More precisely returns structure with strings I, x, t, ExplainingString
if imageflag
  BitMap = [];
  I_out = [];
  for k_stim = 1:num_stim_seg       % loop over stimulus segments
    extract(stim(k_stim));          % extract fields Ifun, t0, and t_segment
    time_stim = t0+(dt:dt:t_segment); % create descretized stimulus time vector
    Isegment = Ifun(xplot,time_stim,Iparams{k_stim}{:});
    BitMap = [BitMap, 127*(Isegment+1)+1];
    I_out = [I_out, Isegment];
  end
  Cmap = [0:255;0:255;0:255]'/255;
  colormap(Cmap);
  switch imageflag
  case 1
    out = BitMap;
  otherwise
    out.I = I_out;
    out.x = xplot;
    out.time = time;
    out.ExplainingString = 'Intensity = I(x,time)';
  end
  return       % program exits here
end

% Compute stimulus at each receptive field
% Id (stimulus intensity at depressing receptive field)
% In (stimulus intensity at non-depressing receptive field)
% Insegment, Idsegment (In and Id for just one segment)
% k_stim (index of stimulus segment)
% time_stim (vector of sample times for stimulus segment t0...(t0 + t_segment)
In = [];                    % initialize In
Id = [];                    % initialize Id
for k_stim = 1:num_stim_seg  % loop over stimulus segments
  extract(stim(k_stim));     % extract fields Ifun, t0, and t_segment
  time_stim = t0+(dt:dt:t_segment); % create stimulus time vector
  Insegment = Ifun(xn,time_stim,Iparams{k_stim}{:});
  Idsegment = Ifun(xd,time_stim,Iparams{k_stim}{:});
  In = [In, Insegment];             % build In
  Id = [Id, Idsegment];             % build Id
end

% Initialize constants associated with firing rate of post-synaptic cell
Rs = (VE - Vt)/(tau_m*(Vt - Vr));
Gf = (Vt - V0)/(VE - Vt);

% Initialize input to synapses; model of afferents
Rd = max(0,Rb+Rc*Id);
Rn = max(0,Rb+Rc*In);

% Initialize state variables
D = zeros(1,kmax);
D(1,1) = D0;
S = zeros(1,kmax);
S(1,1) = S0;

% Initialize outputs 
GE = zeros(1,kmax);  % Synaptic conductance sampled at discrete times
F = zeros(1,kmax);   % Firing rate of model neuron, sampled (1/msec)
AP = zeros(1,kmax);  % Boolean indicating Action Potentials in sample intervals
V = zeros(1,kmax);   % Membrane potential of model neuron, sampled (mV)
GE(1) = gamma_d*D0*S0*Rd(1) + gamma_n*Rn(1);
F(1) = max(0,Rs*(GE(1)-Gf));
AP(1) = (rand < dt*F(1));
V(1) = 1/(1+GE(1))*(V0 + GE(1)*VE);

% Clock time at start of main loop (returned in structure "out")
clock0 = clock;  

% Main loop
for k = 2:kmax
  D(k) = D(k-1) + dt/tau_D*(1-D(k-1) + tau_D*D(k-1)*(d-1)*Rd(k-1));
  S(k) = S(k-1) + dt/tau_S*(1-S(k-1) + tau_S*S(k-1)*(s-1)*Rd(k-1));
  GE(k) = gamma_d*D(k)*S(k)*Rd(k) + gamma_n*Rn(k);
  F0 = max(0,Rs*(GE(k)-Gf));
  F(k) = F0/(1+tau_R*F0);
  AP(k) = (rand < dt*F(k));
  V(k) = 1/(1+GE(k))*(V0 + GE(k)*VE);
end

% Elapsed time for computation within main loop (returned in structure "out")
comptime = etime(clock,clock0);  

% Caculate expected numbers of action potentials within each burst
endburst = [0, find(F(1:end-1) > 0 & F(2:end) == 0)];
if F(end) > 0
  endburst = [endburst length(time)]; 
end
for k = 1:length(endburst)-1
  bursts(k) = dt*sum(F(endburst(k)+1:endburst(k+1)));
end
% F = F*1000;  % Uncomment to convert F to Hz, if desired

% Assemble output
out = assemble(who);
