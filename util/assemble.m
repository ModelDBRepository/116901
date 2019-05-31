function out = assemble(list, blacklist)
% ASSEMBLE collects variables from caller's workspace into a structure
% OUT = ASSEMBLE(LIST,BLACKLIST)  
%       where LIST is a structure of strings containing names to save
%             BLACKLIST is a structure of strings containing names not to save
%             OUT is a structure with fields on LIST but not BLACKLIST
%
% Code written by SEAN CARVER, last modified 12-5-2007

if nargin == 1
  blacklist = {};
end
for i = 1:prod(size(list))
  blacklisted = 0;
  for j = 1:prod(size(blacklist))
    if strcmp(list{i}, blacklist{j})
      blacklisted = 1;
      break
    end
  end
  if ~blacklisted
    out(1,1).(list{i}) = evalin('caller',list{i});
  end
end
