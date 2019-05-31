function in = afferents(num_dep,num_nondep)
% AFFERENTS: Parameter file for specifing numbers of afferents
% CALLING SYNTAX: Call within a call to DIRSEL, 
%   e.g. out = dirsel(pulse,afferents(20,40));
% Code written by SEAN CARVER, last modified 12-5-2007

% synaptic weights
w_d = 20/100;
w_n = 1/100;

% synaptic factors
in.gamma_d = w_d*num_dep;
in.gamma_n = w_n*num_nondep;
