function varargout = vline(x,varargin)
% VLINE Function to draw a vertical line on a plot
%   VLINE(X) draws line at x = X
%   VLINE(X, PARAMS ...) passes PARAMS ... into plot (e.g. 'r' for red line)
%
% Code written by SEAN CARVER, last modified Dec-05-2007

v = axis;
ish = ishold;
hold on
P = plot([x, x], [min(-1e10,v(3)), max(1e10, v(4))], varargin{:});
if ~ish
  hold off
end
axis(v)
if nargout > 0
 varargout{1} = P;
end
