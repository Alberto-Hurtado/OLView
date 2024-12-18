function ol_tools(act1,act2,act3)
%OL_TOOLS
%           This function controls the user interface
%           functions within the main menu section
%           called 'Tools' in OLVIEW. 
%
%


global S_Figure;
global S_Status S_Message;
global S_HMenuTools S_HToolsCh;
global S_Path S_ToolProc S_ToolStruct;
global S_Step;

switch act1
case 'initialize';
  S_HMenuTools=uimenu(S_Figure,'label','Tools');
  S_HToolsCh=[];  
case 'menu';
  if strcmp(get(S_HToolsCh(act2),'checked'),'on');
    set(S_HToolsCh(act2),'checked','off');
  else;
    set(S_HToolsCh(act2),'checked','on');
  end;
  sta1=S_Status;
  S_Status='busy, don''t disturb!'; olview('update');
  ol_tools('tool','clear');
  ol_tools('tool','execute');
  S_Status=sta1; olview('update');
case 'update';
  switch S_Status;
  case {'closed test','busy, don''t disturb!'};
    set(S_HToolsCh,'enable','off');
  case {'paused','running'};
    if isempty(S_Step)
      set(S_HToolsCh,'enable','off');
    else
      set(S_HToolsCh,'enable','on');
    end
  end;
case 'tool';
  switch act2;
  case 'open menu';
    delete(S_HToolsCh); S_ToolStruct={};
    for ich=1:length(S_ToolProc);
      S_HToolsCh(ich)=uimenu(S_HMenuTools,'label',S_ToolProc{ich}, ...
        'enable','off','checked','off', ...
        'callback',['ol_tools(''menu'',' num2str(ich) ')']);
      S_ToolStruct{ich}=[];
    end;
    ol_tools('tool','clear');
  case 'clear';
    cd(S_Path);
    for ich=1:length(S_ToolProc);
      if strcmp(get(S_HToolsCh(ich),'checked'),'off');
        for f1=get(0,'children')';
          if strcmp(get(f1,'name'),['ST: ' S_ToolProc{ich}]);
            delete(f1);
          end;
        end;
      end;
    end;
  case 'execute';
    cd(S_Path);
    for ich=1:length(S_ToolProc);
      if strcmp(get(S_HToolsCh(ich),'checked'),'on');
        if ~isempty(S_ToolStruct{ich})
          if ~sum(get(0,'children')==S_ToolStruct{ich}.Figure)
            S_ToolStruct{ich}=[];
          elseif ~strcmp(get(S_ToolStruct{ich}.Figure,'name'),['ST: ' S_ToolProc{ich}]);
            S_ToolStruct{ich}=[];
          end;
        end;
        if isempty(S_ToolStruct{ich});
          S_ToolStruct{ich}.Figure=figure;
          set(S_ToolStruct{ich}.Figure,'numbertitle','off', ...
            'name',['ST: ' S_ToolProc{ich}]);
          S_ToolStruct{ich}.Init=1;
        end
        S_ToolStruct{ich}=feval(S_ToolProc{ich},S_ToolStruct{ich});
      end;
    end;
  end;
end;
