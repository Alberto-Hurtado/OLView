function ToolStruct=dll_algo_tableSTEP(ToolStruct)
%dll_algo_table:     Displays a table with varibles of the dll.
%
% ELSA OLVIEW EtherCat controller. F. J. Molina 2015


global S_Step
global S_TestName S_TestTitle;
global S_Mast
global ALGORAV ALGOR_T ALGORUSERINPUT
global MIXEDCONTROL
global PSD MST_DI1_IN ALGORALARM PUMPALARM
global VARTEMP


if ToolStruct.Init;
    ToolStruct.Init=0;
    orient landscape;
    set(ToolStruct.Figure,'position',[ 1930          50         660         456]);
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
    char(ALGORUSERINPUT.DllName),char(ALGORUSERINPUT.TestName))];
s=[s sprintf('\n')];
% s=[s sprintf(' iRec:%5g   RunAlgo-F11:%4g    MstDigIn3:%4g', ...
%     ALGOIREC.iRec(N),PSD.bRunAlgo(N),MST_DI1_IN.MstDigIn3(N))];
s=[s sprintf(' RunAlgo-F11:%4g    MstDigIn3:%4g', ...
    PSD.bRunAlgo(N),MST_DI1_IN.MstDigIn3(N))];
s=[s sprintf('\n')];


s=[s sprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++')];
% s=[s sprintf('\nCount-t:%4g                            TimeStop:%6.4f  Time-t:%6.4f ', ...
%     ALGOR_T.Count_t(N),ALGORUSERINPUT.TimeStop(N),ALGOR_T.Time_t(N))];
s=[s sprintf('\nlCurrentStep-t:%4g    lCurrentSubStep-t:%4g    lNumOfWaitSteps-t:%4g ', ...
    ALGOR_T.lCurrentStep_t(N),ALGOR_T.lCurrentSubStep_t(N),ALGOR_T.lNumOfWaitSteps_t(N))];

if S_Mast.NDof>0;
    s=[s sprintf('\n                ')];
    s=[s sprintf(' ---DoF %1g--- ',[1:S_Mast.NDof])];
    s=[s sprintf('\n dOutput-t [m]:    ') sprintf('% 13.4e',ALGOR_T.dOutput_t(N,:))];
end

s=[s sprintf('\n                   ')];
s=[s sprintf(' ---Con %1g--- ',[1:S_Mast.NCon])];
s=[s sprintf('\n Heid-t [mm]:     ') sprintf('% 13.4e',ALGOR_T.Heid_t(N,:))];
s=[s sprintf('\n LCell-t [kN]:    ') sprintf('% 13.4e',ALGOR_T.LCell_t(N,:))];
s=[s sprintf('\n ConTarget-t [mm]:   ') sprintf('% 13.4e',ALGOR_T.ConTarget_t(N,:))];

s=[s sprintf('\n')];

s=[s sprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++')];
s=[s sprintf('\nlCurrentStepAv:%5g ',ALGORAV.lCurrentStepAv(N))];

s=[s sprintf('\n                   ')];
s=[s sprintf(' ---Con %1g--- ',[1:S_Mast.NCon])];
s=[s sprintf('\n HeidAv [mm]:     ') sprintf('% 13.4e',ALGORAV.HeidAv(N,:))];
s=[s sprintf('\n TempAv [mm]:     ') sprintf('% 13.4e',ALGORAV.TempAv(N,:))];
s=[s sprintf('\n LCellAv [kN]:    ') sprintf('% 13.4e',ALGORAV.LCellAv(N,:))];
s=[s sprintf('\n PDForAv [kN]:    ') sprintf('% 13.4e',ALGORAV.PDForAv(N,:))];
s=[s sprintf('\n ErrAv [mm]:      ') sprintf('% 13.4e',ALGORAV.ErrAv(N,:))];
s=[s sprintf('\n ErrMax [mm]:     ') sprintf('% 13.4e',ALGORAV.ErrMax(N,:))];
s=[s sprintf('\n ConTargetAv :    ') sprintf('% 13.4e',ALGORAV.ConTargetAv(N,:))];
s=[s sprintf('\n MixAAv :         ') sprintf('% 13.4e',ALGORAV.MixAAv(N,:))];
s=[s sprintf('\n MixBAv :         ') sprintf('% 13.4e',ALGORAV.MixBAv(N,:))];
s=[s sprintf('\n')];

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
