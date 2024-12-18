function ToolStruct=dll_algo_table(ToolStruct)
%dll_algo_table:     Displays a table with varibles of the dll.
%
% ELSA OLVIEW EtherCat controller. F. J. Molina 2022


global S_Status S_Step S_Time S_Times;
global S_TestName S_TestTitle;
global S_Mast ALGORAV ALGOR_T ALGORUSERINPUT STEVAR STEPSTATUS;
global PSD MST_DI1_IN ALGORALARM PUMPALARM;
global ALGORFATIGUE ALGORFATIGUEPARAM; % Fatigue 2018

% global R_Param R_Active R_State;  % Regulation of F4E 2016


if ToolStruct.Init;
    ToolStruct.Init=0;
    orient landscape;
    set(ToolStruct.Figure,'position',[0    30   660   587]);
    %   set(gcf,'position',[100   100   1000   700]);
    set(gcf,'color',[1 1 1])
    set(gca,'Visible','off');
    ToolStruct.text=text('units','normalized','position',[-0.15 1.08] ...
        ,'HorizontalAlignment','left','VerticalAlignment','Top', ...
        'fontname','Courier' ...
        ,'fontsize',10,'FontWeight','bold');
%         'fontname','Lucida Sans Typewriter' ...
    %         'fontname','Lucida Sans Typewriter Oblique' ...
end;
N=max(1,S_Step);


s='';
s=[s sprintf('Algorithm:%5s   TestName:%5s                ', ...
    ALGORUSERINPUT.DllName,ALGORUSERINPUT.TestName)];
if S_Mast.NSR==0;    s=[s sprintf('   (No SR Devices found)')]; end
s=[s sprintf('\n')];
% s=[s sprintf(' iRec:%5g   RunAlgo-F11:%4g    MstDigIn3:%4g', ...
%     ALGOIREC.iRec(N),PSD.bRunAlgo,MST_DI1_IN.MstDigIn3)];
s=[s sprintf(' CurrentStep:%5g   RunAlgo-F11:%4g    MstDigIn3:%4g', ...
    STEPSTATUS.lCurrentStep(N),PSD.bRunAlgo,MST_DI1_IN.MstDigIn3)];
s=[s sprintf('\n')];

if S_Mast.NGAcc>0;
    s=[s sprintf('\n')];
    s=[s sprintf('GAccSpan[%%]:    ') sprintf('   %7.2f',ALGORUSERINPUT.GAccSpan(N,:)')];
    s=[s sprintf('\n')];
    s=[s sprintf('IrecGAcc:      ') sprintf('   %7g',ALGOIREC.iRecGAcc(N,:)')];
    s=[s sprintf('\n')];
    s=[s sprintf('GAcc-t [m/s/s]:') sprintf('   %7.2f',ALGOR_T.GAcc_t(N,:)')];
    s=[s sprintf('\n')];
end

if S_Mast.NPatt>0;
    s=[s sprintf('\n')];
    s=[s sprintf('PattSpan[%%]:   ') sprintf('   %8.3f',ALGORUSERINPUT.PattSpan(N,:)')];
    s=[s sprintf('\n')];
    s=[s sprintf('PattISpan[%%]:  ') sprintf('   %8.3f',ALGORUSERINPUT.PattISpan(N,:)')];
    s=[s sprintf('\n')];
    s=[s sprintf('IrecPatt:      ') sprintf('   %8g',ALGOIREC.iRecPatt(N,:)')];
    s=[s sprintf('\n')];
    s=[s sprintf('Patt-t: [mm,kN]') sprintf('   %8.3f',ALGOR_T.Patt_t(N,:)')];
    s=[s sprintf('\n')];
end
if S_Mast.NRefPatt>0
    s=[s sprintf('iCyclePatt:      ') sprintf('   %8g',ALGOIREC.iCyclePatt(N,:)')];
    s=[s sprintf('\n')];    
end
for iRef=1:S_Mast.NRefPatt
    s=[s sprintf('PattRef%d:      ',iRef) sprintf('   %8.3f',ALGORFATIGUEPARAM.PattRef(N,iRef,:))];
    s=[s sprintf('\n')];    
    s=[s sprintf('PattFB%d:      ',iRef) sprintf('   %8.3f',ALGORFATIGUE.PattFB(N,iRef,:))];
    s=[s sprintf('\n')];    
end


% s=[s sprintf('\n')];
% s=[s sprintf('InterRecIn:%8g    TimeIncr:%4g    Lambda:%4g', ...
%     ALGORUSERINPUT.InterRecIn(N),ALGOR_T.TimeIncr(N),ALGORUSERINPUT.TimeLambda)];

s=[s sprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++')];
% s=[s sprintf('\nCount-t:%4g                            TimeStop:%6.4f  Time-t:%6.4f ', ...
%     ALGOR_T.Count_t(N),ALGORUSERINPUT.TimeStop,ALGOR_T.Time_t(N))];

% if S_Mast.NDof>0;
%     s=[s sprintf('\n                ')];
%     s=[s sprintf(' ---DoF %1g--- ',[1:S_Mast.NDof])];
%     s=[s sprintf('\n Dis-t [m]:    ') sprintf('% 13.4e',ALGOR_T.Dis_t(N,:))];
%     s=[s sprintf('\n Res-t [N]:    ') sprintf('% 13.4e',ALGOR_T.Res_t(N,:))];
% end

s=[s sprintf('\n                   ')];
s=[s sprintf(' ---Con %1g--- ',[1:S_Mast.NCon])];
s=[s sprintf('\n Heid-t [mm]:     ') sprintf('% 13.4e',ALGOR_T.Heid_t(N,:))];
s=[s sprintf('\n LCell-t [kN]:    ') sprintf('% 13.4e',ALGOR_T.LCell_t(N,:))];
s=[s sprintf('\n Target-t [mm]:   ') sprintf('% 13.4e',ALGOR_T.ConTarget_t(N,:))];

if S_Mast.NSR>0;
    s=[s sprintf('\n               ')];
    s=[s sprintf(' ---SRD %1g--- ',[1:S_Mast.NSR])];
    s=[s sprintf('\n DSR-t [mm]:  ') sprintf('% 13.4e',ALGOR_T.DSR_t(N,:))];
    s=[s sprintf('\n FSR-t [kN]:  ') sprintf('% 13.4e',ALGOR_T.FSR_t(N,:))];
end
s=[s sprintf('\n')];
% s=[s sprintf('                            EneAbs-t:%11.4e  EneErr-t:%11.4e', ...
%     ALGOR_T.EneAbs_t(N),ALGOR_T.EneErr_t(N))];

s=[s sprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++')];
% s=[s sprintf('\niRecAv:%5g     InterAv:%10g              TimeAv:%6.4f', ...
%     ALGORAV.iRecAv(N),ALGORAV.InterAv(N),ALGORAV.TimeAv(N))];
s=[s sprintf('\nCurrentStep:%5g  CurrentSubStep:%10g  NbrSubSteps:%10g\n  LatencyTicks:%10g', ...
    STEPSTATUS.lCurrentStep(N),STEPSTATUS.lCurrentSubStep(N),STEPSTATUS.lNbrSubSteps(N),STEPSTATUS.lLatencyTicks(N))];

% if S_Mast.NDof>0;
%     s=[s sprintf('\n               ')];
%     s=[s sprintf(' ---DoF %1g--- ',[1:S_Mast.NDof])];
%     s=[s sprintf('\n DisAv [m]:   ') sprintf('% 13.4e',ALGORAV.DisAv(N,:))];
%     s=[s sprintf('\n ResAv [N]:   ') sprintf('% 13.4e',ALGORAV.ResAv(N,:))];
% end

s=[s sprintf('\n                   ')];
s=[s sprintf(' ---Con %1g--- ',[1:S_Mast.NCon])];
s=[s sprintf('\n HeidAv [mm]:     ') sprintf('% 13.4e',ALGORAV.HeidAv(N,:))];
s=[s sprintf('\n TempAv [mm]:     ') sprintf('% 13.4e',ALGORAV.TempAv(N,:))];
s=[s sprintf('\n LCellAv [kN]:    ') sprintf('% 13.4e',ALGORAV.LCellAv(N,:))];
s=[s sprintf('\n PDForAv [kN]:    ') sprintf('% 13.4e',ALGORAV.PDForAv(N,:))];
s=[s sprintf('\n ErrAv [mm]:      ') sprintf('% 13.4e',ALGORAV.ErrAv(N,:))];
s=[s sprintf('\n ErrMax [mm]:     ') sprintf('% 13.4e',ALGORAV.ErrMax(N,:))];
s=[s sprintf('\n')];
% s=[s sprintf('                            EneAbsAv:%11.4e  EneErrAv:%11.4e', ...
%     ALGORAV.EneAbsAv(N),ALGORAV.EneErrAv(N))];

s=[s sprintf('\n-----------------------------------------------------------------------------')];
s=[s sprintf('\nALGORALARM:  Inserted-F10:%2g  Status:%2g  Code:%03g  Contr:%2g  Value: % 8.4f', ...
    ALGORALARM.AlgoAlarmInserted(N),ALGORALARM.AlgoAlarmStatus(N),ALGORALARM.AlgoAlarm(N), ...
    ALGORALARM.AlgoCon(N),ALGORALARM.AlgoAlarmValue(N))];

s=[s sprintf('\n-----------------------------------------------------------------------------')];
s=[s sprintf('\nPUMPALARM:       Inserted:%2g  Status:%2g  Code:%03g  Contr:%2g  Value: % 8.4f', ...
    PUMPALARM.PumpAlarmInserted(N),PUMPALARM.PumpAlarmStatus(N),PUMPALARM.PumpAlarm(N), ...
    PUMPALARM.PumpCon(N),PUMPALARM.PumpAlarmValue(N))];

set(ToolStruct.text,'string',s);

% disp(s);

if ALGORALARM.AlgoAlarmStatus(N)>0
    beep
end
if PUMPALARM.PumpAlarmStatus(N)>0
    beep
    load gong.mat;
    sound(y);
end


end
