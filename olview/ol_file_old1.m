function ol_file(act1,act2,act3)
%OL_FILE
%           This function controls the user interface
%           functions within the main menu section
%           called 'File' in OLVIEW. 
%


global S_Figure;
global S_HMenuFile S_HOpenTest S_HSaveSI S_HRecover S_HExit;
global S_Status S_Message;
global S_TestName S_TestTitle;
global S_Path S_TestProc S_ToolProc S_GeomProc S_ControlParam;
global S_EndStep
global S_Mast S_AcqNod;   
global S_Time S_Time0 S_FirstReadTime;

switch act1;
case 'initialize';
  S_HMenuFile=uimenu(S_Figure,'label','File');
  S_HOpenTest=uimenu(S_HMenuFile,'label','Open a test', ...
    'enable','off', ...
    'callback',['ol_file(''menu'',''Open a test'')']);
  S_HRecover=uimenu(S_HMenuFile,'label','Recover state', ...
    'callback',['ol_file(''menu'',''Recover state'')']);
  S_HExit=uimenu(S_HMenuFile,'label','Exit', ...
    'enable','off', ...
    'callback',['ol_file(''menu'',''Exit'')']);
  S_Time0=0;
  S_FirstReadTime=[];
case 'menu';
  switch act2;
  case 'Open a test';
    sta1=S_Status;
    S_Status='busy, don''t disturb!';
    S_Message='Opening a test'; olview('update');
    [file1,PathRead]=uigetfile([pwd '\*_test.m'],'Open a test');
    if file1==0;
      S_Status=sta1;
      S_Message='No test was opened';
    else;
      S_TestName=file1;
      S_TestName(findstr(S_TestName,'_test.m'):length(S_TestName))=[];
      S_Path=PathRead;
      cd(S_Path);
      [S_TestTitle,S_TestProc,S_ToolProc,S_ControlParam, ...
          S_EndStep,S_Mast,S_AcqNod]=feval([S_TestName '_test']);
      ol_tools('tool','open menu');
      S_Message='The test was opened. Press CONTINUE to start';
      S_Status='paused';
    end;
    olview('update');
  case 'Recover state';
    disp('Recover state');
    if ~strcmp(S_Status,'closed test');
      S_Status='paused';
    end;
    olview('update');   
    S_Status='busy, don''t disturb!';
    S_Message='Recovering state';
    olview('update');
    feval(S_TestProc,'read MAT data');
    S_Time0=S_Time;
    S_FirstReadTime=clock;
    S_Status='paused';
    S_Message='Press CONTINUE to continue'
    olview('update');
  case 'Exit';
    disp('Exit');
    ol_tools('tool','clear');
    delete(S_Figure);
  end;
case 'update';
  switch S_Status;
  case 'closed test';
    set(S_HOpenTest,'enable','on');
    set(S_HRecover,'enable','off');
    set(S_HExit,'enable','on');
  case 'paused';
    set(S_HOpenTest,'enable','off');
    set(S_HRecover,'enable','on');
    set(S_HExit,'enable','on');
  case 'running';
    set(S_HOpenTest,'enable','off');
    set(S_HRecover,'enable','off');
    set(S_HExit,'enable','off');
  case 'busy, don''t disturb!';
    set(S_HOpenTest,'enable','off');
    set(S_HRecover,'enable','off');
    set(S_HExit,'enable','off');
  end;
end;

