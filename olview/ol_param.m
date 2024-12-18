function ol_param(act1,act2)
%OL_PARAM
%           This function controls the user interface
%           functions within the main menu section
%           called 'Param' in OLVIEW. 
%
%

global S_HMenuParam S_HMenuParamList S_ParamFig S_HParamEdit;
global S_ControlParam;
global S_Figure;
global S_Status;


switch act1;
case 'initialize';
  S_HMenuParam=uimenu(S_Figure,'label','Param');
  S_HMenuParamList=[];
  for i=1:2;
    S_HMenuParamList(i)=uimenu(S_HMenuParam,'label','', ...
      'enable','off', ...
      'callback',['ol_param(''menu'',' num2str(i) ')']);
  end;
  for f1=get(0,'children')';
    if strcmp(get(f1,'name'),'OLVIEW PARAM EDIT');
      delete(f1);
    end;
  end;
   S_ControlParam.StepTime=NaN;
   S_ControlParam.LatencyTime=NaN;
case 'menu';
  paramval=[S_ControlParam.StepTime S_ControlParam.LatencyTime];
  for f1=get(0,'children')';
    if strcmp(get(f1,'name'),'OLVIEW PARAM EDIT');
      delete(f1);
    end;
  end;
  S_ParamFig=figure;
  set(S_ParamFig,'position',[150   300   300 50],'numbertitle','off', ...
      'name','OLVIEW PARAM EDIT','menubar','none');
  uicontrol(S_ParamFig,'style','text',...
        'units','normalized','position',[.1 .5 .8 .4], ...
        'string',get(S_HMenuParamList(act2),'label'));
  S_HParamEdit=uicontrol(S_ParamFig,'style','edit',...
        'units','normalized','position',[.1 .1 .8 .4], ...
        'enable','on','string',num2str(paramval(act2)), ...
        'callback',['ol_param(''edit'',' num2str(act2) ')']);
case 'edit';
  switch act2;
  case 1;
    S_ControlParam.StepTime=round(str2num(get(S_HParamEdit,'string'))/2)*2
    S_Message='Ramp time was modified'
  case 2
    S_ControlParam.LatencyTime=round(str2num(get(S_HParamEdit,'string'))/2)*2
    S_Message='Latency time was modified'
  end;
  delete(S_ParamFig);
  ol_param('update');
case 'update';
  set(S_HMenuParamList(1),'label', ...
          sprintf('Ramp Time:    %6d ms',S_ControlParam.StepTime));
  set(S_HMenuParamList(2),'label', ...
          sprintf('Latency Time: %6d ms',S_ControlParam.LatencyTime));
  switch S_Status;
  case {'paused'};
    set(S_HMenuParamList,'enable','on');
  case {'closed test' 'running' 'busy, don''t disturb!'};
    set(S_HMenuParamList,'enable','off');
  end;
end;

