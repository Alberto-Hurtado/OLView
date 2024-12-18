function val=gst(ss,field,index)
%val=gst(ss,field,index)
%  Gets the value of a specified field from a cell or array of structures.
%
% SEE ALSO:   sst cell2mat selst
%
% EXAMPLES:
%
%s1.name='k012001';
%s1.data=rand(3,1);
%s2.name='k012002';
%s2.data=rand(3,1);
%nam=gst({s1 s2},'name')
%val=gst({s1 s2 s1},'data',2:3)
%nam=gst([s1 s2],'name')
%val=gst([[s1 s2] s1],'data',{2:3 1})
%nam=char(nam)
%val=cell2mat(val)
%
%JM01


if nargin<1; ss=[]; end;
if nargin<2; field=[]; end;
if nargin<3; index=[]; end;

if iscell(ss)
  expr=['val{i,j}=ss{i,j}.' field];
else
  expr=['val{i,j}=ss(i,j).' field];
end
if isempty(index)
  expr=[expr ';'];
else
  if iscell(index)
    expr=[expr '(index{:});'];
  else
    expr=[expr '(index);'];
  end
end; 

for i=1:size(ss,1);
  for j=1:size(ss,2);
    eval(expr);
  end;
end;

%if strcmp(field,'Data');
%    val=double(val);
%end



