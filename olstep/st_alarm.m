function S_AlarmState=st_alarm(act1,act2,act3,act4,act5)
% %S_ALARM
% %           This function controls the user interface
% %           functions within the main menu section
% %           called 'Alarm' in STEPTEST. 
% %
% % ELSA STEPTEST. F. J. Molina 2004
% %
% 
% global S_HMenuAlarm S_HMenuAlarmReset S_HMenuAlarmRemove S_HMenuAlarmInsert;
% global S_HMenuAlarmList;
% global S_AlarmState S_AlarmMess;
% global A_HeidMax A_HeidMin A_TempAbsMax A_TempAbsMin A_FPisMax A_FPisMin ...
%   A_ErrConMax A_ErrConMin;
% global S_ConFB;
% global S_Figure;
% global S_Path S_TestName;
% global S_Status;
% global D_TempAbsValue0 S_MenuMode;
% global A_RfoConRec A_DisHeiRec A_DisTemAbsRec A_ErrConRec A_DisConTargRec;



    S_AlarmState=0;



% switch act1;
% case 'initialize';
%   S_HMenuAlarm=uimenu(S_Figure,'label','Alarm');
%   S_HMenuAlarmReset=uimenu(S_HMenuAlarm,'label','Reset alarm configuration', ...
%     'enable','off', ...
%     'callback',['st_alarm(''menu'',''Reset alarm configuration'')']);
%   S_HMenuAlarmRemove=uimenu(S_HMenuAlarm,'label','Remove every alarm', ...
%     'enable','off','separator','on', ...
%     'callback',['st_alarm(''menu'',''Remove every alarm'')']);
%   S_HMenuAlarmInsert=uimenu(S_HMenuAlarm,'label','Insert every alarm', ...
%     'enable','off',...
%     'callback',['st_alarm(''menu'',''Insert every alarm'')']);
%   S_HMenuAlarmList=[];
%   labe={'Heidenhein' 'Absolute Temposonic' 'Piston force' ...
%       'Controller error' 'Controller target'};
%   for i=1:5;
%     S_HMenuAlarmList(i)=uimenu(S_HMenuAlarm,'label',labe{i}, ...
%       'enable','off', ...
%       'callback',['st_alarm(''menu'',''List'',' num2str(i) ')']);
%   end;
%   set(S_HMenuAlarmList(1),'separator','on');
% case 'menu';
%   switch act2;
%   case 'Reset alarm configuration';
%     sta1=S_Status;
%     S_Status='busy, don''t disturb!';
%     S_Message='Reading alarm data'; olstep('update');
%     cd(S_Path);
%     [A_HeidMax,A_HeidMin,A_TempAbsMax,A_TempAbsMin,A_FPisMax,A_FPisMin ...
%         ,A_ErrConMax,A_ErrConMin]=feval([S_TestName '_alarm']);
%     switch S_MenuMode;
%     case 'Local simulation'
%       D_TempAbsValue0=1000*(A_TempAbsMax+A_TempAbsMin)/2;
%     end
%     S_Message='The alarm configuration was reset.';
%     S_Status='paused';
%     S_AlarmState=0;
%     S_AlarmMess=[];
%     %    st_alarm('menu','Remove every alarm');
%     olstep('update');
%   case 'Remove every alarm';
%     for i=1:5;
%       set(S_HMenuAlarmList(i),'checked','off');
%     end;
%   case 'Insert every alarm';
%     for i=1:5;
%       set(S_HMenuAlarmList(i),'checked','on');
%     end;
%   case 'List';
%     switch get(S_HMenuAlarmList(act3),'checked')
%     case 'on'
%       set(S_HMenuAlarmList(act3),'checked','off');
%     case 'off'
%       set(S_HMenuAlarmList(act3),'checked','on');
%     end;
%   end;
% case 'update';
%   switch S_Status;
%   case {'paused'};
%     set(S_HMenuAlarmReset,'enable','on');
%     set(S_HMenuAlarmRemove,'enable','on');
%     set(S_HMenuAlarmInsert,'enable','on');
%     set(S_HMenuAlarmList,'enable','on');
%   case {'closed test' 'running' 'busy, don''t disturb!'};
%     set(S_HMenuAlarmReset,'enable','off');
%     set(S_HMenuAlarmRemove,'enable','off');
%     set(S_HMenuAlarmInsert,'enable','off');
%     set(S_HMenuAlarmList,'enable','off');
%   end;
% case 'check';
%   S_AlarmState=0;
%   S_AlarmMess=[];
%   switch act2;
%   case 'measurements'
%     hei=act3; temabs=act4; fpis=act5;
%     ic=find(hei<A_HeidMin | hei>A_HeidMax);
%     if ~isempty(ic);
%       if strcmp(get(S_HMenuAlarmList(1),'checked'),'on');
%         S_AlarmState=1;
%       end;
%       S_AlarmMess=['Heidenhein  ' num2str(ic') '  out of bounds!']
%       Heidenhein=hei'
%       Minimum=A_HeidMin'
%       Maximum=A_HeidMax'
%     end;
%     A_DisHeiRec(:,1)=min(A_DisHeiRec(:,1),hei);
%     A_DisHeiRec(:,2)=max(A_DisHeiRec(:,2),hei);
%     ic=find(temabs<A_TempAbsMin | temabs>A_TempAbsMax);
%     if ~isempty(ic);
%       if strcmp(get(S_HMenuAlarmList(2),'checked'),'on');
%         S_AlarmState=1;
%       end;
%       S_AlarmMess=['Absolute Temposonic  ' num2str(ic') '  out of bounds!']
%       AbsoluteTemposonic=temabs'
%       Minimum=A_TempAbsMin'
%       Maximum=A_TempAbsMax'
%     end;
%     A_DisTemAbsRec(:,1)=min(A_DisTemAbsRec(:,1),temabs);
%     A_DisTemAbsRec(:,2)=max(A_DisTemAbsRec(:,2),temabs);
%     ic=find(fpis<A_FPisMin | fpis>A_FPisMax);
%     if ~isempty(ic);
%       if strcmp(get(S_HMenuAlarmList(3),'checked'),'on');
%         S_AlarmState=1;
%       end;
%       S_AlarmMess=['Piston force  ' num2str(ic') '  out of bounds!']
%       PistonForce=fpis'
%       Minimum=A_FPisMin'
%       Maximum=A_FPisMax'
%     end;
%     A_RfoConRec(:,1)=min(A_RfoConRec(:,1),fpis);
%     A_RfoConRec(:,2)=max(A_RfoConRec(:,2),fpis);
%   case 'error'
%     errc=act3;
%     ic=find(errc<A_ErrConMin | errc>A_ErrConMax);
%     if ~isempty(ic);
%       if strcmp(get(S_HMenuAlarmList(4),'checked'),'on');
%         S_AlarmState=1;
%       end;
%       S_AlarmMess=['Controller error  ' num2str(ic') '  out of bounds!']
%       ControlError=errc'
%       Minimum=A_ErrConMin'
%       Maximum=A_ErrConMax'
%     end;
%     A_ErrConRec(:,1)=min(A_ErrConRec(:,1),errc);
%     A_ErrConRec(:,2)=max(A_ErrConRec(:,2),errc);
%   case 'target'
%     tar=act3;
%       tarmin=A_HeidMin.*(S_ConFB==2) ...
%         +(D_TempAbsValue0/1000-A_TempAbsMax).*(S_ConFB==3);
%       tarmax=A_HeidMax.*(S_ConFB==2) ...
%         +(D_TempAbsValue0/1000-A_TempAbsMin).*(S_ConFB==3);
%     ic=find(tar<tarmin | tar>tarmax);
%     if ~isempty(ic);
%       if strcmp(get(S_HMenuAlarmList(5),'checked'),'on');
%         S_AlarmState=1;
%       end;
%       S_AlarmMess=['Controller target  ' num2str(ic') '  out of bounds!']
%       Target=tar'
%       Minimum=tarmin'
%       Maximum=tarmax'
%     end;
%     A_DisConTargRec(:,1)=min(A_DisConTargRec(:,1),tar);
%     A_DisConTargRec(:,2)=max(A_DisConTargRec(:,2),tar);
%   end; 
% end;

