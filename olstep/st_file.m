function st_file(act1,act2,act3)
%ST_FILE
%           This function controls the user interface
%           functions within the main menu section
%           called 'File' in STEPTEST. 
%
% ELSA STEPTEST. F. J. Molina 2004
%


global S_Figure;
global S_HMenuFile S_HOpenTest S_HSaveSI S_HRecover S_HExit ...
    S_HSendMasterInput  S_HSendAcqInput;
global S_Status S_Message;
global S_TestName S_TestTitle;
global S_Path S_TestProc S_ToolProc S_ControlParam;
global S_Mast P_Mast S_AcqNod
global S_Step S_EndStep 
global S_MenuMode


switch act1;
case 'initialize';
  S_HMenuFile=uimenu(S_Figure,'label','File');
  S_HOpenTest=uimenu(S_HMenuFile,'label','Open a test', ...
    'enable','off', ...
    'callback',['st_file(''menu'',''Open a test'')']);
%   S_HSaveSI=uimenu(S_HMenuFile,'label','Save SI files', ...
%     'enable','off', ...
%     'callback',['st_file(''menu'',''Save SI files'')']);
%   S_HRecover=uimenu(S_HMenuFile,'label','Recover state', ...
%     'callback',['st_file(''menu'',''Recover state'')']);
  S_HSendMasterInput=uimenu(S_HMenuFile,'label','Send to Master an input xls file', ...
    'enable','off', ...
    'callback',['st_file(''menu'',''Send to Master'')']);
  S_HSendAcqInput=uimenu(S_HMenuFile,'label','Send to Acq an input xls file', ...
    'enable','off', ...
    'callback',['st_file(''menu'',''Send to Acq'')']);
  S_HExit=uimenu(S_HMenuFile,'label','Exit', ...
    'enable','off', ...
    'callback',['st_file(''menu'',''Exit'')']);
case 'menu';
  switch act2;
  case 'Open a test';
    sta1=S_Status;
    S_Status='busy, don''t disturb!';
    S_Message='Opening a test'; olstep('update');
    [file1,PathRead]=uigetfile([pwd '\*_olstep.m'],'Open a test');
    if file1==0;
      S_Status=sta1;
      S_Message='No test was opened';
    else;
      S_TestName=file1;
      S_TestName(findstr(S_TestName,'_olstep.m'):length(S_TestName))=[];
      S_Path=PathRead;
%       S_Path=['d:\users\olsteps\st_' S_TestName];
%       pwd1=pwd;
%       cd('c:\');
%       S_Path=['c:\olsteps\st_' S_TestName];    
%       s=['!mkdir ' S_Path]; disp(s); eval(s);
%       s=['!copy ' PathRead '*.* ' S_Path]; disp(s); eval(s);
%       cd(pwd1);
      cd(S_Path);
      [S_TestTitle,S_TestProc,S_ToolProc,S_ControlParam, ...
          S_EndStep,S_Mast,S_AcqNod]= ...
          feval([S_TestName '_olstep']);
      feval(S_TestProc,'open the test');
      st_tools('tool','open menu');
      st_alarm('menu','Reset alarm configuration');
      feval(S_TestProc,'save MAT data');
      S_Message='The test was opened. Press CONTINUE to start';
      S_Status='paused';
    end;
    olstep('update');
  case 'Save SI files';
    sta1=S_Status;
    S_Status='busy, don''t disturb!';
    S_Message='Saving SI files'; olstep('update');
    feval(S_TestProc,'save SI files');
    S_Message='The SI files were saved';
    S_Status=sta1;
    olstep('update');
  case 'Recover state';
    disp('Recover state');
    if ~strcmp(S_Status,'closed test');
      S_Status='paused';
    end;
    olstep('update');   
  case 'Send to Master';
    sta1=S_Status;
    S_Status='busy, don''t disturb!';
    S_Message='Sending input'; olstep('update');
    [file1,PathRead]=uigetfile([pwd '\*_Master_in.*'],'Select an input file');
    if file1==0;
      S_Status=sta1;
      S_Message='No input file was opened';
    else;
      cd(PathRead);
      file2ctrl(file1,'Master');
      if ~strcmp(S_MenuMode,'Remote monitoring');
          transmit('read');;
          st_tools('tool','execute');
      else         %Remote monitoring  (test must be executed elsewhere)
          feval(S_TestProc,'read MAT data');
          st_tools('tool','execute');
      end
      S_Message='The input file was sent. Press CONTINUE to continue';
      S_Status='paused';
    end;
    olstep('update');
  case 'Send to Acq';
    sta1=S_Status;
    S_Status='busy, don''t disturb!';
    S_Message='Sending input'; olstep('update');
    [file1,PathRead]=uigetfile([pwd '\*_Acq_in.*'],'Select an input file');
    if file1==0;
      S_Status=sta1;
      S_Message='No input file was opened';
    else;
      cd(PathRead);
      file2ctrl(file1,'Acq');
      S_Message='The input file was sent. Press CONTINUE to continue';
      S_Status='paused';
    end;
    olstep('update');
  case 'Exit';
    disp('Exit');
    st_tools('tool','clear');
    delete(S_Figure);
  end;
case 'update';
  switch S_Status;
  case 'closed test';
    set(S_HOpenTest,'enable','on');
%     set(S_HSaveSI,'enable','off');
    set(S_HSendMasterInput,'enable','off');
    set(S_HSendAcqInput,'enable','off');
    set(S_HExit,'enable','on');
  case 'paused';
    set(S_HOpenTest,'enable','on');
%     set(S_HSaveSI,'enable','on');
    if isempty(S_Step)
      set(S_HSendMasterInput,'enable','off');
      set(S_HSendAcqInput,'enable','off');
    else
      set(S_HSendMasterInput,'enable','on');
      set(S_HSendAcqInput,'enable','on');
    end
    set(S_HExit,'enable','on');
  case 'running';
    set(S_HOpenTest,'enable','off');
%     set(S_HSaveSI,'enable','off');
    set(S_HSendMasterInput,'enable','off');
    set(S_HSendAcqInput,'enable','off');
    set(S_HExit,'enable','off');
  case 'busy, don''t disturb!';
    set(S_HOpenTest,'enable','off');
%     set(S_HSaveSI,'enable','off');
    set(S_HSendMasterInput,'enable','off');
    set(S_HSendAcqInput,'enable','off');
    set(S_HExit,'enable','off');
  end;
end;

