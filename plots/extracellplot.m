function P = extracellplot(time,APs,ev0,ev1)
% Plot extracellular recording of Action Potentials
% TIME is a vector of discrete times,
% APs are the indicies of the the action potential
% EV0 is the baseline of the extracellular recording
% EV1 is the half-height of the action-potentials
%
% For example if time = [0.2 0.4 0.6 0.8 1.0 1.2] sec
%         and if APs = [2 5] 
%         then action potentials will be plotted at 0.4 and 1.0 seconds
%         with the commands: P = extracellplot(time,APs);
%                            plot(P{:});
%
% Code written by SEAN CARVER; Last modified 12-5-2007

if nargin == 2
  ev0 = 0;
  ev1 = 1;
end

P{1} = ones(4,1)*time(APs);
P{1} = [time(1) P{1}(:)' time(end)];
P{2} = [ev0; ev0+ev1; ev0-ev1; ev0]*ones(1,length(APs));
P{2} = [ev0 P{2}(:)' ev0];

