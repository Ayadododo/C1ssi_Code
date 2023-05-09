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
%�������������������㣬���ò�����Ĭ��ֵ
if nargin<4       %narginΪ�����������������
    mendatory=0;
end

if isfield(options,name)
    v=eval(['options.' name ';']);       %eval�����������ַ���ת��Ϊmatlab���
elseif mendatory
    error(['You have to provide options.' name '.']);
end 