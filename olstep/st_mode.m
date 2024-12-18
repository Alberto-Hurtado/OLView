function st_mode(act1,act2,act3)
%S_MenuMode
%           This function controls the user interface
%           functions within the main menu section
%           called 'Mode' in STEPTEST. 
%
% ELSA STEPTEST. F. J. Molina 2004
%


global S_Figure;
global S_HMenuMode S_HMenuModeReal S_HMenuModeSim S_HMenuModeMon;
global S_MenuMode;
global S_Status D_Message;
global D_Status;

switch act1;
case 'initialize';
  S_HMenuMode=uimenu(S_Figure,'label','Mode');
  S_HMenuModeReal=uimenu(S_HMenuMode,'label','Real data transmission', ...
    'enable','off', ...
    'callback',['st_mode(''menu'',''Real data transmission'')']);
  S_HMenuModeSim=uimenu(S_HMenuMode,'label','Local simulation', ...
    'enable','off', ...
    'callback',['st_mode(''menu'',''Local simulation'')']);
  S_HMenuModeMon=uimenu(S_HMenuMode,'label','Remote monitoring', ...
    'enable','off', ...
    'callback',['st_mode(''menu'',''Remote monitoring'')']);
case 'menu';
  switch act2;
  case 'Real data transmission';
    disp('Real data transmission');
    S_MenuMode='Real data transmission';
    set(S_HMenuModeSim,'checked','off');
    set(S_HMenuModeMon,'checked','off');
    set(S_HMenuModeReal,'checked','on');
    if strcmp(D_Status,'ready to read') ...
        | strcmp(D_Status,'ready to write');
      k=menu(['There must have been a MATLAB execution error and ' ... 
          'global variables for communication addresses may be wrong or don''t exist'...
          'Should transmission state be reset?'] ...
        ,'Yes (Current value of temposonics will be taken as zero!)' ...
        ,'No (Global variables are ok)');
      if k==1;
        D_Status='Not initialized';
        D_Message='Start RemoteControl and masters and do F12 and F11';
      else;
        D_Message='Masters are assumed to be still running';
      end;
    else;
      D_Status='Not initialized';
      D_Message='Start RemoteControl and masters and do F12 and F11';
    end;
    col=[1 0.8 0.8]; set(0,'defaultfigurecolor',col); set(S_Figure,'color',col);
    st_alarm('menu','Insert every alarm');
  case 'Local simulation';
    disp('Local simulation');
    S_MenuMode='Local simulation';
    set(S_HMenuModeReal,'checked','off');
    set(S_HMenuModeMon,'checked','off');
    set(S_HMenuModeSim,'checked','on');
    D_Status='';
    D_Message='Local simulation';
    col=[0.85 0.85 1]; set(0,'defaultfigurecolor',col); set(S_Figure,'color',col);
  case 'Remote monitoring';
    disp('Remote monitoring');
    S_MenuMode='Remote monitoring';
    set(S_HMenuModeReal,'checked','off');
    set(S_HMenuModeSim,'checked','off');
    set(S_HMenuModeMon,'checked','on');
    D_Status='';
    D_Message='Remote monitoring (test must be started elsewhere)';
    col=[0.75 1 0.75]; set(0,'defaultfigurecolor',col); set(S_Figure,'color',col);
  end;
  olstep('update');
case 'update';
  switch S_Status;
  case 'closed test';
    set(S_HMenuModeReal,'enable','on');
    set(S_HMenuModeSim,'enable','on');
    set(S_HMenuModeMon,'enable','on');
  case {'paused','running','busy, don''t disturb!'};
    set(S_HMenuModeReal,'enable','off');
    set(S_HMenuModeSim,'enable','off');
    set(S_HMenuModeMon,'enable','off');
  end;
end;
