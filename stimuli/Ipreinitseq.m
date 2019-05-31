function I = Ipreinitseq(varargin) 
% IPREINITSEQ Make Spatio-Temporal Intensity Table (preinitialized sequence)
%
% I = ISEQUENCE(x,t,f,lambda,phi,sigma,f_gamma,A_gamma,p0,p1) with 9 args
%     returns intensity I(x,t) for a moving pulse preceded by 
%     gamma oscillations and followed by 50% grey 
%
% PERIOD = ISEQUENCE(f,lambda,phi,sigma,f_gamma,A_gamma,p0,p1), with 7 args,
%          returns period of stimulus (Inf) (i.e. nonperiodic)
%          The PERIOD function was used in our implementation of
%          the original Chance model to save memory (so that the intensity
%          of only one cycle of the need be handled).
%          It is not used for the present model.
%
% STRING = ISEQUENCE(), with 0 args, returns string of stimulus parameters.
%
% Code written by SEAN CARVER, last modified 12-5-27

if nargin == 0
  I = '{f,lambda,phi,sigma,f_gamma,A_gamma,p0,p1,ts,greyvalue}'; % stimulus
                                                                 % parameters 
elseif nargin < 12                     % i.e. x,t not passed in
  I = Inf;                             % Infinite period for non-periodic
else
  x = varargin{1};
  t = varargin{2};
  f = varargin{3};
  lambda = varargin{4};	
  phi = varargin{5};
  sigma = varargin{6};
  f_gamma = varargin{7};
  A_gamma = varargin{8};
  p0 = varargin{9};
  p1 = varargin{10};
  ts = varargin{11};
  greyvalue = varargin{12};

  p = (2*pi*x.'*ones(1,length(t))/lambda ...
       - sigma*2*pi*ones(length(x),1)*f*t ...
       + phi*pi/180);
  Ig = A_gamma*sin(2*pi*ones(length(x),1)*f_gamma*t); % Ig  (gamma oscill)
  I = sin(p);                        % I   (moving sine grating)

  region1 = find(sigma*p>p0);        % determines region 1 (gamma region)
  region3 = find(sigma*p<p1);        % determines region 3 (50% grey region)
  preinit = find(t<ts);              % determines region 0
                                     % region 2 is everywhere else
  I(region1) = Ig(region1);          % overwrites I in region 1
  I(region3) = 0;                    % overwrites I in region 3
  I(:,preinit) = greyvalue;          % overwrites I in region 0
end

