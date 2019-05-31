function I = Igrey(varargin) 
% IGREY Returns a constant intensity as a function of time and space 
%
% I = IGREY(x,t,greyvalue) returns intensity I(x,t) = greyvalue
%     More precisely, returns I = greyvalue*ones(length(x),length(t)) 
%     By convention, greyvalue = 0 is 50% grey.
%
% PERIOD = IGREY() returns 0, the period of the stimulus (i.e. constant)
%          The PERIOD function was used in our implementation of 
%          the original Chance model to save memory (so that the intensity 
%          of only one cycle of the need be handled). 
%          It is not used for the present model.
%
% STRING = IGREY() returns string '{''greyvalue''}';
%
% Code written by SEAN CARVER, last modified 12-5-2007

if nargin==0
  I = '{greyvalue}';
elseif nargin < 2 
  I = 0; 
else
  x = varargin{1};
  t = varargin{2};
  greyvalue = varargin{3};
  I = greyvalue*ones(length(x),length(t)); 
end

