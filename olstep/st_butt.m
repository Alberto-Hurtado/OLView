function st_butt(act1,act2)
%S_BUTT
%           This function controls the user interface
%           functions within buttons in STEPTEST.
%
% ELSA STEPTEST. F. J. Molina 2004
%


global S_Figure
global S_HContinue S_HPause S_HCont1 S_Read
global S_Step S_EndStep
global S_Status S_Message
global S_Path S_TestProc
global S_MenuMode
global S_AlarmState S_ControlParam S_LastReadTime


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
        
        S_HCont1=uicontrol(S_Figure,'style','pushbutton',...
            'units','normalized',...
            'position',[.73  y(ste) .17 h(ste)],...
            'string','Cont. 1 step','enable','off', ...
            'callback','st_butt(''button'',''Cont. 1 step'')');
        S_Read=uicontrol(S_Figure,'style','pushbutton',...
            'units','normalized',...
            'position',[.80  y(este) .15 h(ste)],...
            'string','Read Var','enable','off', ...
            'callback','st_butt(''button'',''Read Var'')');
        S_HContinue=uicontrol(S_Figure,'style','pushbutton',...
            'units','normalized',...
            'position',[.10 y(copa) .38 h(copa)],...
            'string','CONTINUE','enable','off', ...
            'callback','st_butt(''button'',''CONTINUE'')');
        S_HPause=uicontrol(S_Figure,'style','pushbutton',...
            'units','normalized',...
            'position',[.52 y(copa) .38 h(copa)],...
            'string','PAUSE','enable','off', ...
            'callback','st_butt(''button'',''PAUSE'')');
        S_LastReadTime=clock; %resets reference time for remote monitoring mode
    case 'button';
        switch act2;
            case 'Cont. 1 step';
                S_Message='Cont. 1 step button was pressed'
                S_Status='running'; olstep('update');
                cd(S_Path);
                if ~strcmp(S_MenuMode,'Remote monitoring');
                    if S_Step<S_EndStep;
                        feval(S_TestProc,'send target');
                        if ~S_AlarmState;
                            S_Step=S_Step+1;
                            feval(S_TestProc,'measure and compute');
                            S_Message='A single step was done';
                            S_Status='busy, don''t disturb!'; olstep('update');
                            st_tools('tool','execute');
                            feval(S_TestProc,'save MAT data');
                            if S_Step==S_EndStep;
                                feval(S_TestProc,'save SI files');
                            end;
                        end;
                    else;
                        S_Message='The end step was reached';
                    end
                else         %Remote monitoring  (test must be executed elsewhere)
                    feval(S_TestProc,'read MAT data');
                    st_tools('tool','execute');
                end
                S_Status='paused'; olstep('update');
            case 'Read Var';
                S_Message='Read Var button was pressed'
                S_Status='running'; olstep('update');
                cd(S_Path);
                if ~strcmp(S_MenuMode,'Remote monitoring');
                    transmit('read');;
                    st_tools('tool','execute');
                else         %Remote monitoring  (test must be executed elsewhere)
                    feval(S_TestProc,'read MAT data');
                    st_tools('tool','execute');
                end
                S_Status='paused'; olstep('update');
            case 'CONTINUE';
                S_Message='CONTINUE button was pressed'
                S_Status='running';
                cd(S_Path);
                while strcmp(S_Status,'running');
                    olstep('update');
                    if ~strcmp(S_MenuMode,'Remote monitoring');
                        if S_Step<S_EndStep;
                            feval(S_TestProc,'send target');
                            if strcmp(S_MenuMode,'Real data transmission');
                                feval(S_TestProc,'save MAT data');
                            end
                            if S_AlarmState;
                                S_Status='paused';
                            else;
                                st_tools('tool','execute');
                                drawnow;                       %Allows interruptions
                                S_Step=S_Step+1;
                                feval(S_TestProc,'measure and compute');
                            end;
                        else;
                            S_Message='The end step was reached';
                            S_Status='paused';
                        end;
                    else         %Remote monitoring  (test must be executed elsewhere)
                        st_tools('tool','execute');
                        drawnow;                       %Allows interruptions
                        while etime(clock,S_LastReadTime)< ...
                                (S_ControlParam.StepTime+S_ControlParam.LatencyTime)/1000
                        end
                        S_LastReadTime=clock;
                        feval(S_TestProc,'read MAT data');
                    end
                end;
                st_tools('tool','execute');
                S_Status='busy, don''t disturb!'; olstep('update');
                if ~strcmp(S_MenuMode,'Remote monitoring');
                    feval(S_TestProc,'save MAT data');
                    if S_Step==S_EndStep;
                        feval(S_TestProc,'save SI files');
                    end;
                end;
                S_Status='paused';
                olstep('update');
            case 'PAUSE';
                S_Status='paused';
                S_Message='PAUSE button was pressed. Press CONTINUE to continue'
                olstep('update');
        end;
    case 'update';
        switch S_Status;
            case 'closed test';
                set(S_HCont1,'enable','off');
                set(S_Read,'enable','off');
                set(S_HContinue,'enable','off');
                set(S_HPause,'enable','off');
            case 'paused';
                if S_AlarmState;
                    set(S_HCont1,'enable','off');
                    set(S_Read,'enable','off');
                    set(S_HContinue,'enable','off');
                else;
                    set(S_HCont1,'enable','on');
                    set(S_Read,'enable','on');
                    set(S_HContinue,'enable','on');
                end;
                
                set(S_HPause,'enable','off');
            case 'running';
                set(S_HCont1,'enable','off');
                set(S_Read,'enable','off');
                set(S_HContinue,'enable','off');
                set(S_HPause,'enable','on');
            case 'busy, don''t disturb!';
                set(S_HCont1,'enable','off');
                set(S_Read,'enable','off');
                set(S_HContinue,'enable','off');
                set(S_HPause,'enable','on');
        end;
end;
