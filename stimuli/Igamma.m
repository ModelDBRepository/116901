function I = Igamma(varargin) 
% IGAMMA Returns intensity of gamma oscillations as a function of time & space
%
% I = IGAMMA(x,t,f_gamma,A_gamma) with 4 args returns, intensity for x & t 
%     I(x,t) = A_gamma*sin(2*pi*f_gamma*t) constant for x
%     More precisely, I = A_gamma*sin(2*pi*ones(length(x),1)*f_gamma*t)
%
% PERIOD = IGAMMA(f_gamma,A_gamma) with 2 args, returns period = 1/f_gamma 
%          The PERIOD function was used in our implementation of
%          the original Chance model to save memory (so that the intensity
%          of only one cycle of the need be handled).
%          It is not used for the present model.
%
% STRING = IGAMMA() with 0 args, returns string '{f_gamma,A_gamma}';
% 
% Code written by SEAN CARVER, last modified 12-5-2007

if nargin==0
  I = '{f_gamma,A_gamma}';
elseif nargin < 4 
  f_gamma = varargin{1};
  I = 1/f_gamma; 
else
  x = varargin{1};
  t = varargin{2};
  f_gamma = varargin{3};
  A_gamma = varargin{4};
  I = A_gamma*sin(2*pi*ones(length(x),1)*f_gamma*t);
end

