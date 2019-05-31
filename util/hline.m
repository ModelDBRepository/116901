function varargout = hline(y,varargin)
% HLINE Function to draw a horizonal line on a plot
%   HLINE(Y) draws line at y = Y
%   HLINE(Y, PARAMS ...) passes PARAMS ... into plot (e.g. 'r' for red line)
%
% Code written by SEAN CARVER, last modified 12-5-2007

v = axis;
ish = ishold;
hold on
P = plot(v(1:2), [y, y], varargin{:});
if ~ish
  hold off
end
if nargout > 0
  varargout{1} = P;
end
