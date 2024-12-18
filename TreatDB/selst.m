function ssout=selst(ssin,field,value)
%ssout=selst(ssin,field,value)
%    Selects structures with a specified value at the specified field
%    from a cell or array of structures.
%
% SEE ALSO: gst sst
%
% EXAMPLES:
%s1.name='';
%ssa=sst({s1 s1 s1 s1},'name',{'aaa' 'bbb' 'bbb' 'ccc'});           gst(ssa,'name')
%ssa=sst(ssa,'num',{'1' '2' '3' '4'});                              gst(ssa,'num')
%ssout=selst(ssa,'name','bbb');                                     gst(ssout,'num')
%
%s=struct('Project','Dual Frame','Structure','Dual Frame CFRP', ...
% 'Experiment','d08','PostProcessing','62');
%s.Signal={};
% SF=selst(selst(getsig(s),'Description','Shear'),'Magnitude','Force')
% SF1=selst(SF,'Positions{1}','Level 1')
%
%JM01

ssout={};
if iscell(ssin)
  expr=['ssin{i}'];
else
  expr=['ssin(i)'];
end

for i=1:prod(size(ssin));
  eval(['valuei=' expr '.' field ';']);
  if all(strcmp(value,cellstr(valuei)))
    eval(['ssout={ssout{:} ' expr '};']);
  end
end;


