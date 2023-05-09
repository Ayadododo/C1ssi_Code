%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%11111
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function v=getoptions(options,name,v,mendatory)

% getoptions - retrieve options parameter
%
%   v = getoptions(options, 'entry', v0);
% is equivalent to the code:
%   if isfield(options, 'entry')
%       v = options.entry;
%   else
%       v = v0;
%   end
%如果输入参数的数量不足，设置参数的默认值
if nargin<4       %nargin为函数输入参数的数量
    mendatory=0;
end

if isfield(options,name)
    v=eval(['options.' name ';']);       %eval函数用来将字符串转化为matlab语句
elseif mendatory
    error(['You have to provide options.' name '.']);
end 