function in = pulse
% PULSE: Parameter file for pulse stimulus in preferred direction
% CALLING SYNTAX: Call within a call to DIRSEL: out = dirsel(pulse);
% Code written by SEAN CARVER, last modified 12-5-2007

in = afferents(40,24);
in.t0 = -1000;
in.ts = 0;
in.tfinal = 5500;
in.phi = -135;
in.p0 = -16*pi;
in.p1 = -19*pi;
