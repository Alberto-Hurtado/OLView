function olstep(act1)
% %STEPTEST:    Step-by-setp test
% %             in communication through RemoteControl.
% %
% % ELSA STEPTEST. F. J. Molina 2004
% %

global S_Figure;
global S_Status S_Message;
global S_Step S_Time  S_Delt S_Times S_EndStep S_TEnd
global D_Status D_Message;
global S_AlarmState S_AlarmMess;
global S_TestName S_TestTitle;


if nargin<1; act1=[]; end;
if isempty(act1); act1='initialize'; end;

switch act1;
case 'initialize';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  initializes step test window
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  f=0;
  for f1=get(0,'children')';
    if strcmp(get(f1,'name'),'STEPTEST');
      f=f1;
      break;
    end;
  end;
  if f>0;
    po=get(f,'position');
    delete(f);
    f=figure;
    set(f,'position',po)
  else;
    f=figure;
    set(f,'position',[50   300   480  330]);
  end;
  clf reset;
  S_Figure=f;
  set(S_Figure,'numbertitle','off','name','STEPTEST');
  set(S_Figure,'menubar','none');
  %   File submenu:
  st_file('initialize');
  %   Tool submenu:
  st_tools('initialize');
  %   Mode submenu:
  st_mode('initialize');
  %   Alarm submenu:
  st_alarm('initialize');
  %   Titles:
  st_title('initialize');
  %   Editables:
  st_edit('initialize');
  %   Buttons:
  st_butt('initialize');
  %   Adjustable parameters:
  st_param('initialize');
  %
  % Updates controls:
  %
  S_TestName='test';
  S_TestTitle='No test opened';
  S_Status='closed test';
  S_Message='Please open a test';
  S_Step=[]; S_Time=[]; S_EndStep=[]; S_Span=[];
  %  D_Status='Not initialized';
%  D_Message='Start minipdtm, but don''t do ''go''';
  S_AlarmState=0;
  S_AlarmMess='';
%   S_MenuMode='Local simulation';
  S_MenuMode='Real data transmission';
  st_mode('menu',S_MenuMode);
  olstep('update');
case 'update';
  st_file('update');
  st_tools('update');
  st_mode('update');
  st_alarm('update');
  st_edit('update');
  st_butt('update');
  st_param('update');
  st_title('update');
end;

