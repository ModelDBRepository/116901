function in = nonpulse
% NONPULSE: paramters for non-preferred direction of pulse
% CALLING SYNTAX: Call within a call to DIRSEL: out = dirsel(nonpulse);
% Code written by SEAN CARVER; last modified 12-5-2007

in = pulse;
in.sigma = -1;
in.p0 = -15*pi;
in.p1 = -18*pi;
