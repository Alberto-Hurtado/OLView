function ssout=sst(ssin,field,val,index)
%ssout=sst(ssin,field,val,index)
%  Sets the value of a specified field in a cell or array of structures.
%
% SEE ALSO:   gst
%
% EXAMPLES:
%
%s1.name='';
%ssa=sst({s1 s1},'name','k012001'),               gst(ssa,'name')
%ssb=sst(ssa,'name',{'k012001' 'k012002'}),       gst(ssb,'name')
%ssb=sst(ssb,'Positions',{{'Level 1' 'North'}}),  gst(ssb,'Positions')
%ssc=sst(ssb,'data',[10;20;30]),                  cell2mat(gst(ssc,'data'))
%ssd=sst(ssc,'data',[21 22; 31 32],2:3),          cell2mat(gst(ssd,'data'))
%
%JM01


if nargin<1; ssin=[]; end;
if nargin<2; field=[]; end;
if nargin<3; val=[]; end;
if nargin<4; index=[]; end;

if ~iscell(ssin)  %2019-09-25
    ssin={ssin};
end

ssout=ssin;

expr=['ssout{i}.' field];
if ~isempty(index)
  expr=[expr '(index)'];
end; 
if iscell(val)
  if prod(size(val))==1
    expr=[expr '=val{1};'];
  else
    expr=[expr '=val{i};'];
  end
else
  if size(val,2)==1
    expr=[expr '=val(:,1);'];
  else
    if ischar(val)
      if size(val,1)==1
        expr=[expr '=val(1,:);'];
      else
        if size(val,1)>1
          expr=[expr '=val(i,:);'];
        else
          expr=[expr '=val;'];
        end
      end
    else
      expr=[expr '=val(:,i);'];
    end
  end
end

for i=1:prod(size(ssin));
  eval(expr);
end;
  
ssout=reshape(ssout,size(ssin));


