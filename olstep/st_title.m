function st_title(act1,act2,act3)
%S_TITLE
%           This function controls the user interface
%           titles in STEPTEST. 
%
% ELSA STEPTEST. F. J. Molina 2004
%


global S_Figure;
global S_HTextTitle;
global S_HTextStatus S_HTextMess;
global S_HTextDStatus S_HTextDMess;
global S_Status S_Message;
global S_TestName S_TestTitle;
global D_Status D_Message;
global S_AlarmState S_AlarmMess;


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
  
  S_HTextTitle=uicontrol(S_Figure,'style','text',...
    'units','normalized','string','Test Title',...
    'position',[xleft1 y(tit) w1 h(tit)]);
  S_HTextStatus=uicontrol(S_Figure,'style','text',...
    'units','normalized','string','Status:',...
    'position',[xleft1 y(sta) w1 h(sta)]);
  S_HTextMess=uicontrol(S_Figure,'style','text',...
    'fontangle','italic', ...
    'units','normalized','string','Message:',...
    'position',[xleft1 y(mes) w1 h(mes)]);
  S_HTextDStatus=uicontrol(S_Figure,'style','text',...
    'units','normalized','string','TR status:',...
    'position',[xleft1 y(drsta) w1 h(drsta)]);
  S_HTextDMess=uicontrol(S_Figure,'style','text',...
    'fontangle','italic', ...
    'units','normalized','string','TR message:',...
    'position',[xleft1 y(drmes) w1 h(drmes)]);
case 'update';
  set(S_HTextTitle,'string',sprintf('%s: %s',S_TestName,S_TestTitle));
  set(S_HTextStatus,'string',sprintf('Status: %s',S_Status));
  if S_AlarmState;
    set(S_HTextMess,'string',sprintf('%s',S_AlarmMess), ...
      'fontweight','bold','foregroundcolor','r');
  else;
    set(S_HTextMess,'string',sprintf('%s',S_Message), ...
      'fontweight','normal','foregroundcolor','k');
  end;
  set(S_HTextDStatus,'string',sprintf('TR status: %s',D_Status));
  set(S_HTextDMess,'string',sprintf('%s',D_Message));
end;
