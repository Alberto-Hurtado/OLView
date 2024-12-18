function olview(act1)
%OLVIEW:    On-line visualization and acquisition
%             in communication through RemoteControl.
%
% ELSA OLVIEW  F. J. Molina 2004
%

global S_Figure;
global S_Status S_Message;
global S_Step S_Time S_EndStep S_Span;
global D_Status D_Message;
global S_MenuMode;
global S_AlarmState S_AlarmMess;
global S_TestName S_TestTitle;


if nargin<1; act1=[]; end;
if isempty(act1); act1='initialize'; end;

switch act1;
case 'initialize';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  initializes olview window
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear global
f=0;po=[];
f1=get(0,'children');
n1=length(f1);
for i=1:n1
    if strcmp(get(f1(i),'name'),'OLVIEW')
        po=get(f1(i),'position');
        delete(f1(i));
        break;
    end;
end;
f=figure;
if isempty(po)
    po=[ -1196         619         480         330];
%     po=[825    32   480   330];
end;
set(f,'position',po);
clf reset;
  S_Figure=f;
  set(S_Figure,'numbertitle','off','name','OLVIEW');
  set(S_Figure,'menubar','none');
  %   File submenu:
  ol_file('initialize');
  %   Tool submenu:
  ol_tools('initialize');
  %   Titles:
  ol_title('initialize');
  %   Editables:
  ol_edit('initialize');
  %   Buttons:
  ol_butt('initialize');
  %   Adjustable parameters:
  ol_param('initialize');
  %
  % Updates controls:
  %
  S_TestName='test';
  S_TestTitle='No test opened';
  S_Status='closed test';
  S_Message='Please open a test';
  S_Step=[]; S_Time=[]; S_EndStep=[]; S_Span=[];
  S_AlarmState=0;
  S_AlarmMess='';
  S_MenuMode='Real data transmission';
  D_Status='Not initialized';
  olview('update');
case 'update';
  ol_file('update');
  ol_tools('update');
  ol_edit('update');
  ol_butt('update');
  ol_param('update');
  ol_title('update');
end;

