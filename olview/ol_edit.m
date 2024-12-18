function ol_edit(act1,act2,act3)
%S_EDIT
%           This function controls the user interface
%           editables in OLVIEW. 
%
% ELSA OLVIEW. F. J. Molina 2004
%


global S_Figure;
global S_HTextStep S_HEditStep S_HTextTime S_HEditTime;
global S_HTextEStep S_HEditEStep S_HTextETime S_HEditETime;
global S_HTextSpan S_HEditSpan;
global S_Step S_Time S_Span S_NGAcc;
global S_Status S_Message;
global S_TInit S_Delt S_EndStep;


switch act1
case 'initialize';
  %Relative heigth of every rectangle:
  drmes=1;drsta=2;spa=3;mes=4;sta=5;copa=6;este=7;ste=8;tit=9;
  h(ste)=20;h(este)=20;h(copa)=60;h(sta)=20;h(mes)=20;h(spa)=20;
  h(drsta)=20;h(drmes)=20;h(tit)=20;
  s(ste)=5;s(este)=10;s(copa)=10;s(sta)=5;s(mes)=10;s(spa)=10;
  s(drsta)=5;s(drmes)=10;s(tit)=10;
  y=cumsum(h+s)-h;  fac=1/(max(y)+30); y=y*fac; h=h*fac;
  xleft1=.05;w1=1-2*xleft1;
    
  S_HTextStep=uicontrol(S_Figure,'style','text',...
        'units','normalized','string','Current step:',...
        'position',[.10 y(ste) .20 h(ste)]);
  S_HEditStep=uicontrol(S_Figure,'style','edit',...
        'units','normalized', ...
        'position',[.30 y(ste) .10 h(ste)], ...
        'enable','off','string',num2str(NaN), ...
        'callback','ol_edit(''edit'',''Step'')');
  S_HTextTime=uicontrol(S_Figure,'style','text',...
        'units','normalized','string','Current time(s):',...
        'position',[.40 y(ste) .20 h(ste)]);
  S_HEditTime=uicontrol(S_Figure,'style','edit',...
        'units','normalized', ...
        'position',[.60 y(ste) .10 h(ste)], ...
        'enable','off','string',num2str(NaN), ...
        'callback','ol_edit(''edit'',''Time'')');
  S_HTextEStep=uicontrol(S_Figure,'style','text',...
        'units','normalized','string','End step:',...
        'position',[.15 y(este) .20 h(este)]);
  S_HEditEStep=uicontrol(S_Figure,'style','edit',...
        'units','normalized', ...
        'position',[.35 y(este) .10 h(este)], ...
        'enable','off','string',num2str(NaN), ...
        'callback','ol_edit(''edit'',''End step'')');
  S_HTextETime=uicontrol(S_Figure,'style','text',...
        'units','normalized','string','End time(s):',...
        'position',[.45 y(este) .20 h(este)]);
  S_HEditETime=uicontrol(S_Figure,'style','edit',...
        'units','normalized', ...
        'position',[.65 y(este) .10 h(este)], ...
        'enable','off','string',num2str(NaN), ...
        'callback','ol_edit(''edit'',''End time'')');
  S_HTextSpan=uicontrol(S_Figure,'style','text',...
        'units','normalized','string','Load span(%):',...
        'position',[.15 y(spa) .20 h(spa)]);
  S_HEditSpan=uicontrol(S_Figure,'style','edit',...
        'units','normalized', ...
        'position',[.35 y(spa) .30 h(spa)], ...
        'enable','off','string',num2str(NaN), ...
        'callback','ol_edit(''edit'',''Span'')');
case 'edit';
  switch act2;
  case 'Step';
    S_Step=max(0,round(str2num(get(S_HEditStep,'string'))))
    S_Time=S_TInit+(S_Step-1)*S_Delt;
    S_Message='Current step and time were modified';
    ol_tools('tool','execute');
  case 'Time';
    S_Time=str2num(get(S_HEditTime,'string'));
    S_Step=max(0,round((S_Time-S_TInit)/S_Delt)+1);
    S_Time=S_TInit+(S_Step-1)*S_Delt;    
    S_Message='Current time and step were modified';
    ol_tools('tool','execute');
  case 'End step';
    S_EndStep=max(0,round(str2num(get(S_HEditEStep,'string'))))
    S_Message='End step and time were modified';
  case 'End time';
    EndTime=str2num(get(S_HEditETime,'string'));
    S_EndStep=max(0,round((EndTime-S_TInit)/S_Delt)+1);
    S_Message='End time and step were modified';
  case 'Span';
    S_Span=str2num(get(S_HEditSpan,'string'));
    if length(S_Span)==1; S_Span=S_Span(ones(1,S_NGAcc)); end;
    S_Message='Current load span was modified';
  end;
  olview('update');
case 'update';
  set(S_HEditStep,'enable','off','string',num2str(S_Step));
  set(S_HEditTime,'enable','off','string',num2str(S_Time));
  set(S_HEditEStep,'enable','off','string',num2str(S_EndStep));
  set(S_HEditETime,'enable','off','string',num2str(S_TInit+(S_EndStep-1)*S_Delt));
  set(S_HEditSpan,'enable','off','string',num2str(S_Span));
  switch S_Status;
  case 'closed test';
  case 'paused';
    set(S_HEditStep,'enable','on');
    set(S_HEditTime,'enable','on');
    set(S_HEditEStep,'enable','on');
    set(S_HEditETime,'enable','on');
    set(S_HEditSpan,'enable','on');
  case 'running';
 %   set(S_HEditSpan,'enable','on');      %Necessary 'off' for allowing interruptions
  case 'busy, don''t disturb!';
  end;
end;
