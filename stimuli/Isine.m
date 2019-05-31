function I = Isine(varargin) 
% ISINEGRATING Returns sine-grating-intensity as a function of time and space 
%
% I = ISINE(x,t,f,lambda,phi,sigma), with 5 args, returns intensity I(x,t) 
%     for position range x, time range t, temporal frequency f
%     spatial wavelegth lamba, sigma (1 = right to left, -1 reverse)
%
% PERIOD = ISINE(f,lambda,phi,sigma), with 3 args, returns period = 1/f 
%          The PERIOD function was used in our implementation of
%          the original Chance model to save memory (so that the intensity
%          of only one cycle of the need be handled).
%          It is not used for the present model.
%
% STRING = ISINE(), with 0 args, returns string of params 
%                  '{f,lambda,phi,sigma}' 
%
% Code written by SEAN CARVER, last modified 12-5-2007

if nargin==0
  I = '{f,lambda,phi,sigma}';
elseif nargin < 6 
  f = varargin{1};
  I = 1/f; 
else
  x = varargin{1};
  t = varargin{2};
  f = varargin{3};
  lambda = varargin{4};	
  phi = varargin{5};
  sigma = varargin{6};

  I = sin(2*pi*x.'*ones(1,length(t))/lambda ...
         -sigma*2*pi*ones(length(x),1)*f*t ...
         +phi*pi/180);
end

