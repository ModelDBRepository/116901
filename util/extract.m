function extract(s,errlist,warnlist)
% EXTRACT Function to extract fields from structure to caller's workspace
%
%   EXTRACT(S) assigns the value in each field of S to a variable with the 
%   same name in the workspace of the function that called EXTRACT.
%   EXTRACT(S,ERR) where ERR is a cell array of strings causes an error if
%   any of the strings is a field of S
%   EXTRACT(S,WHO) prevents overwriting any current variables
%   EXTRACT(S,{},WARN) warns instead of causing error.
%
%   Code written by SEAN CARVER, last modified 12-5-2007

if nargin > 1
  for i = 1:prod(size(errlist))
    if isfield(s,errlist{i})
      error(['EXTRACT: ', errlist{i}, ' cannot be a field'])
    end
  end
end
if nargin > 2
  for i = 1:prod(size(warnlist))
    if isfield(s,warnlist{i})
      warning(['EXTRACT: ', warnlist{i}, ' is a field flagged for warning'])
    end
  end
end

names = fieldnames(s);
for i = 1:length(names)
  assignin('caller', names{i}, s(1,1).(names{i}));
end
