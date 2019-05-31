function replace(va,wh,pa)
% REPLACE -- Replace defaut parameters with specified parameters.
% 
% Use as follows:
%    function out = foo(varargin)
%    a = 1;
%    b = 20;
%    c = 300;
%    d = 4000;
%    param = {'b','d'};
%    replace(varargin,who,param)
%  OR
%    replace(varagin,who);
%
%  Then call FOO with parameters: 
%       out = foo('a',2) --> replaces default a=1 with new a=2
%       out = foo('b',10,'c',100) --> likewise replaces b=10, c=100
%  can also pass structures or specify functions returning structures.
%  for other features see code
%
% Code written by SEAN CARVER, last modified Dec-5-2007

% va is the variable argument list
% wh is the who variable list (used for error checking)
% when get_value is FALSE (0) get name of parameter and put in variable "name"
% when get_value is TRUE (1) get value of parameter

% if don't pass wh make wh empty
if nargin == 1
  wh = {};
end

get_value = 0;  % get name of parameter not value

p = 0;
for i=1:length(va)                     % step through variable length argument
  if get_value                         % if we must get value
    assignin('caller',name,va{i}); % assign to name va{i} in caller's workspace
    get_value = 0;                     % get name next time
  elseif isa(va{i},'function_handle')  % if name of parameter is a function ...
                                       % ... handle not a string
    newvars = va{i}();                 % then evaluate function
    nvnames = fieldnames(newvars);     % should return structure, names of ...
                                       % ... params are fieldnames of struct
    % The code below steps through field names of structure
    % checks that names are in wh structure and assigns values to the names
    % in the caller's workspace.
    for k = 1:length(nvnames)
      if check_var(nvnames{k},wh)
        assignin('caller',nvnames{k},newvars(1,1).(nvnames{k})); 
      else
        error(['Replace error: Parameter ', nvnames{k},' not found']);
      end
    end
    % Do same thing if name of parameter is a structure
  elseif isstruct(va{i}) 
    newvars = va{i}();
    nvnames = fieldnames(newvars);
    for k = 1:length(nvnames)
      if check_var(nvnames{k},wh)
        assignin('caller',nvnames{k},newvars(1,1).(nvnames{k})); 
      else
        error(['Replace error: Parameter ', nvnames{k},' not found']);
      end
    end
   % If name of parameter is numeric assign to names in pa argument 
  elseif isnumeric(va{i}) | p
    p = p+1; 
    if p > length(pa)
      error('Attempt to assign parameter to name unspecified by 3rd argument');
    elseif check_var(pa{p},wh)
      assignin('caller',pa{p},va{i});
    else
      error(['Replace error: Parameter ', pa{p},' not found']);
    end
  % If name is a string in wh struct interpret as name, set get_value true.
  elseif isstr(va{i})
    if check_var(va{i},wh)
      get_value = 1;
      name = va{i};
    % if not in wh structure, see if its a filename
    elseif exist(va{i},'file')
      newvars = runscript(va{i});
      nvnames = fieldnames(newvars);
      for k = 1:length(nvnames)
        if check_var(nvnames{k},wh)
          assignin('caller',nvnames{k},newvars(1,1).(nvnames{k}));
        else
          error(['Replace error: Parameter ', nvnames{k},' not found']);
        end
      end
    else 
      error(['Replace error: Parameter ', va{i},' not found']);
    end
  else
    error('Replace: Unrecognized type for in argument list');
  end
end 

%%%%%%%%%%%%%%%%

function cv = check_var(var,wh)
% CHECK to see if var is in list wh;

cv = 0;
for i = 1:length(wh)
  if strcmp(var,wh{i})
    cv = 1;
    break;
  end
end

%%%%%%%%%%%%%%%%

function nv = runscript(TEMPSCRIPT)
% Run script and assemble

eval(TEMPSCRIPT);
clear TEMPSCRIPT
nv = assemble(who);

