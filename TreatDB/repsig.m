 function report=repsig(ss,fnam,perm,propline,format)
%report=repsig(ss,fnam,perm,propline,format)           
%     Reports a list of ELSA Data Base signals.
%          FNAM               output file name
%          PERM='w'     write (create if necessary) (default)
%          PERM='a'     append (create if necessary)
%     Several lines of properties to be reported and corresponding
%     formats may be specified.
%
% SEE ALSO: getsig selst
%
% EXAMPLES:
%
% s=struct('Project','Dual Frame','Structure','Dual Frame CFRP', ...
% 'Experiment','d08','PostProcessing','62');
% s.Signal={};
% SF=selst(selst(getsig(s),'Description','Shear'),'Magnitude','Force');
% repsig(SF);
% repsig(SF,[],[],{{'Name' 'Description' 'Magnitude' 'Positions{1}'} {'Length'}}, ...
%                {{'  %s#' ' %s' ' %s' '%s'} {'    Length=%s'}});
%
% repsig(SF,'SFlist.txt');
%
%JM01



iarg=1;
if nargin<iarg; ss=[]; end; iarg=iarg+1;
if nargin<iarg; fnam=[]; end; iarg=iarg+1;
if nargin<iarg; perm=[]; end; iarg=iarg+1;
if nargin<iarg; propline=[]; end; iarg=iarg+1;
if nargin<iarg; format=[]; end; iarg=iarg+1;

if isempty(perm); perm='w'; end;
if isempty(format);
  propline={{'Project' 'Proj_Descr'} ...
      {'Structure' 'Struc_Descr'} ...
      {'Experiment' 'Exp_Descr'} ...
      {'PostProcessing' 'PostP_Descr'} ...
      {'Name' 'Description' 'Magnitude' 'Unit' 'Positions'} ...
      {'Length' 'Min' 'Max'}};
  %  propline{5}={'Mean' 'Max_Min'};
  format={{'Project          %s:' ' %s'} ...
      {'Structure        %s:' ' %s'} ...
      {'Experiment       %s:' ' %s'} ...
      {'PostProcessing   %s:' ' %s'} ...
      {'  %s#' ' %s' ' %s' ' (%s)' ' %s'} ...
      {'    Length=%s' '  Min=%s' '  Max=%s'}};
  %  format{5}={'      Mean=%s' '  Max-Min=%s'};
end;

report={};linprev={};
for isig=1:length(ss)
  if isfield(ss{isig},'Data')
    dat=double(ss{isig}.Data);
    ss{isig}.Mean=sprintf('%12g',mean(dat));
  else
    dat=[];
    ss{isig}.Mean=[];
  end
  ss{isig}.Length=sprintf('%8g',length(dat)); 
  ss{isig}.Max=sprintf('%12g',max(dat));
  ss{isig}.Min=sprintf('%12g',min(dat));
  ss{isig}.Max_Min=sprintf('%12g',max(dat)-min(dat));
  for ilin=1:length(propline)
    lin{ilin}='';
    for iprop=1:length(propline{ilin})
      if isfield(ss{isig},propline{ilin}{iprop})
        eval(['pro=cellstr(ss{isig}.' propline{ilin}{iprop} ');']);
      else
        pro=[];
      end
      lin{ilin}=[lin{ilin} sprintfcell(format{ilin}{iprop},pro)];
    end
  end
  lincomplem=complem(lin,linprev);
  report={report{:} compact(lincomplem)};
  linprev=lin;
end
report=char(report);
if isempty(fnam);
  disp(report);
else
  repc=cellstr(report);
  fid=fopen(fnam,perm);
  fprintf(fid,'%s\n',repc{:});
  fclose(fid);
end;

return





function textf=sprintfcell(format,text)
if iscell(text);
  textf=sprintf(format,text{:});
  if isempty(sprintf('%s',text{:})); textf=''; end;
else
  textf=sprintf(format,text);
  if isempty(text); textf=''; end;
end
return



function str=compact(str)
str=cellstr(str);
str=char({str{:} '-'});
for i=size(str,1):-1:1;
  if isempty(deblank(str(i,:))); str(i,:)=[]; end;
end
str=str(1:(size(str,1)-1),:);
return







