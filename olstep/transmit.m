function transmit(action)
%transmit:     reads or writes the values of the signals of the controller.
%                    ACQCTRL_SERVICE must be 'CLASSIC' (based on Remote
%                    Control) or '2019'.
%
% ELSA OLSTEP. F. J. Molina 2020
%
%

global D_Status D_Message;
global S_HTextDStatus S_HTextDMess;
global S_Step
global P_Server P_MastConn P_AcqNodConn
global S_Mast P_Mast
global S_TestName S_Path S_GeomProc S_MenuMode;
global D_CurrentTrue
global STEPVAR STEPSTATUS

global ALGORAV ALGOR_T ALGORUSERINPUT
global MIXEDCONTROL
global PSD MST_DI1_IN ALGORALARM PUMPALARM
global VARTEMP

global S_AcqNod P_AcqNod
global CLC_V CR CRAvLevel;  %AcqNod SLABSTRESS 2019

global ACQCTRL_SERVICE


% one of the following two lines should be commented depending on the
% selected service:
% ACQCTRL_SERVICE = 'CLASSIC'; %comment this line if not applicable
ACQCTRL_SERVICE = '2019'; %comment this line if not applicable


%%
% ACQCTRL_SERVICE = 'CLASSIC'; %comment this line if not applicable
%
% P_Server = actxserver('AcqCtrlService.Server');
% master_Address='192.168.1.21';
% Connection=P_Server.GetConnection(master_Address);
% Memory = Connection.GetMemory('C1 - PID');
%
% Signal = Memory.GetSignal('DispP'); %for reading
% Signal.Value
%
% Signal.Value = 3;       %for writing
% Memory.Modified = 1;

%%
% ACQCTRL_SERVICE = '2019'; %comment this line if not applicable
%
% ass = NET.addAssembly('AcqCtrlServiceLibDotNet')
% ConnMaster = AcqCtrlServiceLibDotNet.Connection(10050,'192.168.1.30') %check port at master.ini
% ConnMaster.Connect()
% ConnMaster.LoadDatabase()
% ConnMaster.Start()
% 
% Memory = ConnMaster.GetMemory('C1 - PID')
% dispP = Memory.GetSignal('DispP')
% dispI = Memory.GetSignal('DispI')
% 
% dispP.GetValue() % Read Value
% 
% dispP.InitValue(20) % Write Value without send it to controller
% dispI.InitValue(100)  % Write Value without send it to controller
% Memory.Modified = 1; % Send Values from memory to controller


%%
% STEPVAR: (Background to Foreground)
% bStartOfStep: Flag used to verify the availability of the data coming from A
% fMinStepTime: Duration of the step ramp
% fLatencyTime: Latency after the STEP ramp
% lAverageNumber: Number of average steps after latency
% fMaxStepSpeed01: Maximum STEP speed Controller 1
% fMaxStepSpeed02: Maximum STEP speed Controller 2
% fMaxStepSpeed03: Maximum STEP speed Controller 3
% dNewTarget01: New STEP target Dof 1
% dNewTarget02: New STEP target Dof 2
% dNewTarget03: New STEP target Dof 3
%
%
% STEPSTATUS
% bEndOfStep: Flag used to say that the STEP data are ready
% lCurrentStep: Current STEP number
% lCurrentSubStep: Current sub-STEP number
% lNbrSubSteps: Current number of ramp sub-STEP
% lLatencyTicks: Current number latency sub-STEP
% lNumOfWaitStepsMinus1: Number of missed sub-STEP waiting for A
% dAverageOutput01: End of STEP Average output value Dof 1
% dAverageOutput02: End of STEP Average output value Dof 2
% dAverageOutput03: End of STEP Average output value Dof 3
% dAverageTargetError01: End of STEP Average target error Dof 1
% dAverageTargetError02: End of STEP Average target error Dof 2
% dAverageTargetError03: End of STEP Average target error Dof 3



% STEPVAR_varname={'bStartOfStep' 'fMinStepTime' 'fLatencyTime'};
STEPVAR_varname={'bStartOfStep'};
STEPVAR_varnameDof={'dNewTarget'};
% STEPVAR_varnameCon={'fMaxStepSpeed'};
STEPVAR_varnameCon={};

STEPSTATUS_varname={'bEndOfStep' 'lCurrentStep' 'lCurrentSubStep' 'lNbrSubSteps' 'lLatencyTicks' 'lNumOfWaitStepsMinus1'};
STEPSTATUS_varnameDof={'dAverageOutput' 'dAverageTargetError'};


ALGORUSERINPUT_varname={'DllName' 'TestName'};   % 'TestName', 'DllName' are constants
PSD_varname={'bRunAlgo'};
MST_DI1_IN_varname={'MstDigIn3'};
ALGORALARM_varname={'AlgoAlarmInserted' 'AlgoAlarmStatus' 'AlgoAlarm' 'AlgoCon' 'AlgoAlarmValue'};
PUMPALARM_varname={'PumpAlarmInserted' 'PumpAlarmStatus' 'PumpAlarm' 'PumpCon' 'PumpAlarmValue'};
ALGORAV_varname={'lCurrentStepAv'};
ALGORAV_varnameCon={'HeidAv' 'TempAv' 'TempAbsAv' 'LCellAv' ...
    'PDForAv' 'ErrAv' 'ErrMax' 'ServoAv' 'ConTargetAv' 'MixAAv' 'MixBAv'};
ALGOR_T_varname={'lCurrentStep_t' 'lCurrentSubStep_t' 'lNumOfWaitSteps_t'};
ALGOR_T_varnameDof={'dOutput_t'};
ALGOR_T_varnameCon={'Heid_t' 'LCell_t' 'ConTarget_t'};
MIXEDCONTROL_varnameCon={'MixA' 'MixB'}; 
% VARTEMP_varnameLevel={'Drift' 'Shear' 'ErrorMean' 'Rot' 'DispMean' 'For'};  % SLABSTRESS 2019


%%

if S_Step==0
    S_Step1=1;
else
    S_Step1=S_Step;
end

switch S_MenuMode;
    case 'Real data transmission';
        switch action;
            case 'initialize'
                switch ACQCTRL_SERVICE
                    case 'CLASSIC'
                        if strcmp(D_Status,'Not initialized');
                            P_Server = actxserver('AcqCtrlService.Server')
                            P_MastConn=P_Server.GetConnection(S_Mast.Address)
                            P_Mast.STEPVAR=P_MastConn.GetMemory('STEPVAR');
                            P_Mast.STEPSTATUS=P_MastConn.GetMemory('STEPSTATUS');
                            P_Mast.ALGORUSERINPUT=P_MastConn.GetMemory('ALGORUSERINPUT');
                            P_Mast.PSD=P_MastConn.GetMemory('PSD');     %2015
                            P_Mast.MST_DI1_IN=P_MastConn.GetMemory('MST - DI 1-IN');
                            P_Mast.ALGORALARM=P_MastConn.GetMemory('ALGORALARM');
                            P_Mast.PUMPALARM=P_MastConn.GetMemory('PUMPALARM');
                            P_Mast.ALGORAV=P_MastConn.GetMemory('ALGORAV');
                            P_Mast.ALGOR_T=P_MastConn.GetMemory('ALGOR_T');
                            P_Mast.MIXEDCONTROL=P_MastConn.GetMemory('MIXEDCONTROL');
                            %                         P_Mast.VARTEMP=P_MastConn.GetMemory('VARTEMP');    % SLABSTRESS 2019
                            if ~isempty(S_AcqNod.Address)    %2017
                                P_AcqNodConn=P_Server.GetConnection(S_AcqNod.Address)
                                %                         P_AcqNod.Tempo_IN=P_AcqNodConn.GetMemory('Tempo-IN');
                                %                         P_AcqNod.DATA=P_AcqNodConn.GetMemory('DATA');
                                for iBlock=1:length(S_AcqNod.BlockNames)
                                    blockName=S_AcqNod.BlockNames{iBlock};
                                    eval(sprintf( ...
                                        'P_AcqNod.%s=P_AcqNodConn.GetMemory(blockName);',blockName));
                                end
                            end
                        end;
                        Signal = P_Mast.STEPSTATUS.GetSignal('bEndOfStep');
                        D_CurrentTrue=Signal.Value;
                    case '2019'
                        if strcmp(D_Status,'Not initialized');
                            P_Server = NET.addAssembly('AcqCtrlServiceLibDotNet')
                            P_MastConn = AcqCtrlServiceLibDotNet.Connection(10050,S_Mast.Address) %check port at master.ini
                            P_MastConn.Connect()
                            P_MastConn.LoadDatabase()
                            P_MastConn.Start()
                            P_Mast.STEPVAR=P_MastConn.GetMemory('STEPVAR');
                            P_Mast.STEPSTATUS=P_MastConn.GetMemory('STEPSTATUS');
                            P_Mast.ALGORUSERINPUT=P_MastConn.GetMemory('ALGORUSERINPUT');
                            P_Mast.PSD=P_MastConn.GetMemory('PSD');     %2015
                            P_Mast.MST_DI1_IN=P_MastConn.GetMemory('MST - DI 1-IN');
                            P_Mast.ALGORALARM=P_MastConn.GetMemory('ALGORALARM');
                            P_Mast.PUMPALARM=P_MastConn.GetMemory('PUMPALARM');
                            P_Mast.ALGORAV=P_MastConn.GetMemory('ALGORAV');
                            P_Mast.ALGOR_T=P_MastConn.GetMemory('ALGOR_T');
                            P_Mast.MIXEDCONTROL=P_MastConn.GetMemory('MIXEDCONTROL');
                            %                         P_Mast.VARTEMP=P_MastConn.GetMemory('VARTEMP');    % SLABSTRESS 2019
                            if ~isempty(S_AcqNod.Address)
                                P_AcqNodConn = AcqCtrlServiceLibDotNet.Connection(10050,S_AcqNod.Address) %check port
                                P_AcqNodConn.Connect()
                                P_AcqNodConn.LoadDatabase()
                                P_AcqNodConn.Start()
                                for iBlock=1:length(S_AcqNod.BlockNames)
                                    blockName=S_AcqNod.BlockNames{iBlock};
                                    eval(sprintf( ...
                                        'P_AcqNod.%s=P_AcqNodConn.GetMemory(blockName);',blockName));
                                end
                            end
                        end;
                        Signal = P_Mast.STEPSTATUS.GetSignal('bEndOfStep');
                        D_CurrentTrue=Signal.GetValue();
                end
                D_CurrentTrue=~D_CurrentTrue;
                transmit('read');
                D_Status='ready to read';
                D_Message='Transmission was initialised by MATLAB';
                set(S_HTextDStatus,'string',sprintf('TR status: %s',D_Status));
                set(S_HTextDMess,'string',sprintf('%s',D_Message));
                
            case 'wait and read'
                D_Message='Waiting for EndOfStep at master before reading measurements'
                set(S_HTextDMess,'string',sprintf('%s',D_Message));
                EndOfStep=(~D_CurrentTrue);
                while EndOfStep~=D_CurrentTrue
                    Signal = P_Mast.STEPSTATUS.GetSignal('bEndOfStep');
                    switch ACQCTRL_SERVICE
                        case 'CLASSIC'
                            EndOfStep=Signal.Value;
                        case '2019'
                            EndOfStep=Signal.GetValue();
                    end
                end
                STEPSTATUS.bEndOfStep(S_Step1)=EndOfStep;
                D_CurrentTrue=~D_CurrentTrue;
                transmit('read');
                
            case 'read'
                D_Message='Reading measurements'
                set(S_HTextDMess,'string',sprintf('%s',D_Message));
                
                switch ACQCTRL_SERVICE
                    case 'CLASSIC'
                        value_fun = 'Value';
                    case '2019'
                        value_fun = 'GetValue()';
                end
                
                for ivar=1:length(STEPSTATUS_varname)
                    Signal = P_Mast.STEPSTATUS.GetSignal(STEPSTATUS_varname{ivar});
                    eval(['STEPSTATUS.' STEPSTATUS_varname{ivar} '(S_Step1)' ...
                        '=Signal.' value_fun ';']);
                    
                    %                         sprintf(['STEPSTATUS.' STEPSTATUS_varname{ivar} '(S_Step1) = %g'], ...
                    %                             eval(['STEPSTATUS.' STEPSTATUS_varname{ivar} '(S_Step1)']))
                    
                end
                for iDof=1:S_Mast.NDof
                    for ivar=1:length(STEPSTATUS_varnameDof)
                        Signal = P_Mast.STEPSTATUS.GetSignal([STEPSTATUS_varnameDof{ivar} sprintf('%02d',iDof)]);
                        eval(['STEPSTATUS.' STEPSTATUS_varnameDof{ivar} '(S_Step1,iDof)' ...
                            '=Signal.' value_fun ';']);
                        
                        %                         sprintf(['STEPSTATUS.' STEPSTATUS_varnameDof{ivar} '(S_Step1,iDof) = %g'], ...
                        %                             eval(['STEPSTATUS.' STEPSTATUS_varnameDof{ivar} '(S_Step1,iDof)']))
                        
                    end
                end              
                
                % ALGORUSERINPUT
                for ivar=1:length(ALGORUSERINPUT_varname)
                    Signal = P_Mast.ALGORUSERINPUT.GetSignal(ALGORUSERINPUT_varname{ivar});
                    eval(['ALGORUSERINPUT.' ALGORUSERINPUT_varname{ivar} ...
                        '=Signal.' value_fun ';']);
                end
                
                % PSD
                for ivar=1:length(PSD_varname)
                    Signal = P_Mast.PSD.GetSignal(PSD_varname{ivar});
                    eval(['PSD.' PSD_varname{ivar} '(S_Step1)' ...
                        '=Signal.' value_fun ';']);
                end
                
                % MST_DI1_IN
                for ivar=1:length(MST_DI1_IN_varname)
                    Signal = P_Mast.MST_DI1_IN.GetSignal(MST_DI1_IN_varname{ivar});
                    eval(['MST_DI1_IN.' MST_DI1_IN_varname{ivar} '(S_Step1)' ...
                        '=Signal.' value_fun ';']);
                end
                
                % ALGORALARM
                for ivar=1:length(ALGORALARM_varname)
                    Signal = P_Mast.ALGORALARM.GetSignal(ALGORALARM_varname{ivar});
                    eval(['ALGORALARM.' ALGORALARM_varname{ivar} '(S_Step1)' ...
                        '=Signal.' value_fun ';']);
                end
                
                % PUMPALARM
                for ivar=1:length(PUMPALARM_varname)
                    Signal = P_Mast.PUMPALARM.GetSignal(PUMPALARM_varname{ivar});
                    eval(['PUMPALARM.' PUMPALARM_varname{ivar} '(S_Step1)' ...
                        '=Signal.' value_fun ';']);
                end
                
                % ALGORAV
                for ivar=1:length(ALGORAV_varname)
                    Signal = P_Mast.ALGORAV.GetSignal(ALGORAV_varname{ivar});
                    eval(['ALGORAV.' ALGORAV_varname{ivar} '(S_Step1)' ...
                        '=Signal.' value_fun ';']);
                end
                for iCon=1:S_Mast.NCon
                    for ivar=1:length(ALGORAV_varnameCon)
                        Signal = P_Mast.ALGORAV.GetSignal([ALGORAV_varnameCon{ivar} sprintf('%02d',iCon)]);
                        eval(['ALGORAV.' ALGORAV_varnameCon{ivar} '(S_Step1,iCon)' ...
                            '=Signal.' value_fun ';']);
                    end
                end
                
                % ALGOR_T
                for ivar=1:length(ALGOR_T_varname)
                    Signal = P_Mast.ALGOR_T.GetSignal([ALGOR_T_varname{ivar}]);
                    eval(['ALGOR_T.' ALGOR_T_varname{ivar} '(S_Step1)' ...
                        '=Signal.' value_fun ';']);
                end
                for iDof=1:S_Mast.NDof
                    for ivar=1:length(ALGOR_T_varnameDof)
                        Signal = P_Mast.ALGOR_T.GetSignal([ALGOR_T_varnameDof{ivar} sprintf('%02d',iDof)]);
                        eval(['ALGOR_T.' ALGOR_T_varnameDof{ivar} '(S_Step1,iDof)' ...
                            '=Signal.' value_fun ';']);
                    end
                end
                for iCon=1:S_Mast.NCon
                    for ivar=1:length(ALGOR_T_varnameCon)
                        Signal = P_Mast.ALGOR_T.GetSignal([ALGOR_T_varnameCon{ivar} sprintf('%02d',iCon)]);
                        eval(['ALGOR_T.' ALGOR_T_varnameCon{ivar} '(S_Step1,iCon)' ...
                            '=Signal.' value_fun ';']);
                    end
                end
                
                % MIXEDCONTROL
                for iCon=1:S_Mast.NCon
                    for ivar=1:length(MIXEDCONTROL_varnameCon)
                        Signal = P_Mast.MIXEDCONTROL.GetSignal([MIXEDCONTROL_varnameCon{ivar} sprintf('%02d',iCon)]);
                        eval(['MIXEDCONTROL.' MIXEDCONTROL_varnameCon{ivar} '(S_Step1,iCon)' ...
                            '=Signal.' value_fun ';']);
                    end
                end
                
                %                         % VARTEMP   SLABSTRESS 2019
                %                         for iLevel=1:S_Mast.NLevel
                %                             for ivar=1:length(VARTEMP_varnameLevel)
                %                                 Signal = P_Mast.VARTEMP.GetSignal([VARTEMP_varnameLevel{ivar} sprintf('%d',iLevel)]);
                %                                 eval(['VARTEMP.' VARTEMP_varnameLevel{ivar} '(S_Step1,iLevel)' ...
                %                                     '=Signal.Value;']);
                %                             end
                %                         end
                
                
                
                
                D_Message='Measurements were read'
                set(S_HTextDMess,'string',sprintf('%s',D_Message));
                D_Status='ready to write';
                set(S_HTextDStatus,'string',sprintf('TR status: %s',D_Status));
                
                
                % ForceValue =ksimul*TargetValue+ForceValue; %prueba
                
            case 'write';
                D_Message='Writting TargetValue'
                set(S_HTextDMess,'string',sprintf('%s',D_Message));
                
%                 STEPVAR.bStartOfStep(S_Step1)=1.00*D_CurrentTrue;
                STEPVAR.bStartOfStep(S_Step1)=D_CurrentTrue;
                disp('without 1.00*')
                
                sprintf('STEPVAR.bStartOfStep(S_Step1)=%g',STEPVAR.bStartOfStep(S_Step1))
                %             PutObjectProp(uint32(D_StartOfStep(iMast)),'Value',1.00*D_CurrentTrue); %2009-07-24
                
                % %                 for ivar=2:length(STEPVAR_varname)
                % %                     Signal = P_Mast.STEPVAR.GetSignal(STEPVAR_varname{ivar});
                % %                     eval(['Signal.Value = STEPVAR.' STEPVAR_varname{ivar} '(S_Step1);']);
                % %                     P_Mast.STEPVAR.Modified = 1;
                % %                 end
                %                 for iDof=1:S_Mast.NDof
                %                     for ivar=1:length(STEPVAR_varnameDof)
                %                         Signal = P_Mast.STEPVAR.GetSignal([STEPVAR_varnameDof{ivar} sprintf('%02d',iDof)]);
                %                         eval(['Signal.Value = STEPVAR.' STEPVAR_varnameDof{ivar} '(S_Step1,iDof);']);
                %                         P_Mast.STEPVAR.Modified = 1;
                %                     end
                %                 end
                %                 for iCon=1:S_Mast.NCon
                %                     for ivar=1:length(STEPVAR_varnameCon)
                %                         Signal = P_Mast.STEPVAR.GetSignal([STEPVAR_varnameCon{ivar} sprintf('%02d',iCon)]);
                %                         eval(['Signal.Value = STEPVAR.' STEPVAR_varnameCon{ivar} '(S_Step1,iCon);']);
                %                         P_Mast.STEPVAR.Modified = 1;
                %                     end
                %                 end
                
                
                SignalNameList={};
                newValueList=[];
                iSignal=0;
                
                for ivar=1:length(STEPVAR_varname)
                    iSignal = iSignal+1;
                    SignalNameList{iSignal} = STEPVAR_varname{ivar};
                    newValueList(iSignal) = eval(['STEPVAR.' STEPVAR_varname{ivar} '(S_Step1);']);
                end
                for iDof=1:S_Mast.NDof
                    for ivar=1:length(STEPVAR_varnameDof)
                        iSignal = iSignal+1;
                        SignalNameList{iSignal} = [STEPVAR_varnameDof{ivar} sprintf('%02d',iDof)];
                        newValueList(iSignal) = eval(['STEPVAR.' STEPVAR_varnameDof{ivar} '(S_Step1,iDof);']);
                    end
                end
                for iCon=1:S_Mast.NCon
                    for ivar=1:length(STEPVAR_varnameCon)
                        iSignal = iSignal+1;
                        SignalNameList{iSignal} = [STEPVAR_varnameDof{ivar} sprintf('%02d',iCon)];
                        newValueList(iSignal) = eval(['STEPVAR.' STEPVAR_varnameDof{ivar} '(S_Step1,iCon);']);
                    end
                end
                
                sprintf('Step %d: New targets = %g %g %g',S_Step1,STEPVAR.dNewTarget(S_Step1,1:S_Mast.NCon))
                               
                nAttempts=writeBlockSure(SignalNameList,newValueList,P_Mast.STEPVAR,ACQCTRL_SERVICE)
                
                D_Message='TargetValue was written'
                set(S_HTextDMess,'string',sprintf('%s',D_Message));
                D_Status='ready to read';
                set(S_HTextDStatus,'string',sprintf('TR status: %s',D_Status));
        end;
    case 'Local simulation';
        D_Message='Local simulation mode'
        set(S_HTextDMess,'string',sprintf('%s',D_Message));
        switch action;
            case 'read';
                %             HeidValue = TargetValue;
                %             TempValue = TargetValue;
                %             TempAbsValue = -TargetValue+D_TempAbsValue0/1000;      %Temposonics positive when going in Jul/2004
                %             %     TempAbsValue = TargetValue+D_TempAbsValue0/1000;      %Temposonics positive when going out Jan/2004
                %             ForceValue =ksimul*TargetValue+csimul*VelValue;
        end;
end;
