function psdcyctr(action,mode)
%psdcyctr:     reads or writes the values of the signals of the controller.
%                    ACQCTRL_SERVICE must be 'CLASSIC' (based on Remote
%                    Control) or '2019'.
%
% ELSA OLVIEW. F. J. Molina 2022
%
%

global D_Status D_Message;
global S_HTextDStatus S_HTextDMess;
global S_Step
global P_Server P_MastConn P_AcqNodConn
global S_Mast P_Mast
global S_TestName S_Path S_GeomProc S_MenuMode;

global Blocks %2020
global D_CurrentTrue
global STEPVAR STEPSTATUS

global ALGORAV ALGOR_T ALGORUSERINPUT ALGOIREC
% global ALGORFATIGUE ALGORFATIGUEPARAM MIXEDCONTROL; % Fatigue 2018
global PSD MST_DI1_IN ALGORALARM PUMPALARM
global VARTEMP
global C_ALGO

global S_AcqNod P_AcqNod
global DATA  %AcqNod 

global ACQCTRL_SERVICE


% global D_Status D_Message;
% global S_Step S_Time S_Times;
% global S_HTextDStatus S_HTextDMess;
% global P_Server P_MastConn P_AcqNodConn;
% global S_Mast P_Mast ALGORAV ALGOR_T ALGORUSERINPUT ALGOIREC;
% global ALGORFATIGUE ALGORFATIGUEPARAM MIXEDCONTROL; % Fatigue 2018
% global PSD MST_DI1_IN ALGORALARM PUMPALARM;
global S_AcqNod P_AcqNod Tempo_IN DATA;  %Variables from acq node 2017
global R_Param R_Active R_State;  % Regulation of F4E 2016
global R_Sim;  % Simulation of Regulation of F4E 2016
global VARTEMP;  % IRESIST 2021

% one of the following two lines should be commented depending on the
% selected service:
ACQCTRL_SERVICE = 'CLASSIC'; %comment this line if not applicable
% ACQCTRL_SERVICE = '2019'; %comment this line if not applicable


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






C_ALGO_varnameCon={'Tempo2Net' 'HeideNet' 'Force1Net'};


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
                
                Blocks={};
                
                Block={};
                Block.node='Mast';
                Block.name='ALGORUSERINPUT';
                Block.memoryName=Block.name;
                Block.constant.varNames={'DllName' 'TestName' 'TimeStop' 'TimeLambda'};
                Block.scalar.varNames={'InterRecIn'};
                Block.vect(1).lengthName='S_Mast.NGAcc';
                Block.vect(1).varNames={'GAccSpan'};
                Block.vect(2).lengthName='S_Mast.NPatt';
                Block.vect(2).varNames={'PattSpan' 'PattISpan'};
                Blocks=[Blocks(:)' {Block}];
                
                Block={};
                Block.node='Mast';
                Block.name='ALGOIREC';
                Block.memoryName=Block.name;
                Block.scalar.varNames={'iRec'};
                Block.vect(1).lengthName='S_Mast.NGAcc';
                Block.vect(1).varNames={'iRecGAcc'};
                Block.vect(2).lengthName='S_Mast.NPatt';
                Block.vect(2).varNames={'iRecPatt'};
                Block.vect(3).lengthName='S_Mast.NRefPatt';
                Block.vect(3).varNames={'iCyclePatt'};
                Blocks=[Blocks(:)' {Block}];
                
                Block={};
                Block.node='Mast';
                Block.name='PSD';
                Block.memoryName=Block.name;
                Block.constant.varNames={'bRunAlgo'};
                Blocks=[Blocks(:)' {Block}];
                
                Block={};
                Block.node='Mast';
                Block.name='MST_DI1_IN';
%                 Block.memoryName='MST - DI 1-IN';
                Block.memoryName='MST_DI_1_IN';   %RTX controller
                Block.constant.varNames={'MstDigIn3'};
                Blocks=[Blocks(:)' {Block}];
                
                Block={};
                Block.node='Mast';
                Block.name='ALGORALARM';
                Block.memoryName=Block.name;
                Block.scalar.varNames={'AlgoAlarmInserted' 'AlgoAlarmStatus' 'AlgoAlarm' 'AlgoCon' 'AlgoAlarmValue'};
                Blocks=[Blocks(:)' {Block}];
                
                Block={};
                Block.node='Mast';
                Block.name='PUMPALARM';
                Block.memoryName=Block.name;
                Block.scalar.varNames={'PumpAlarmInserted' 'PumpAlarmStatus' 'PumpAlarm' 'PumpCon' 'PumpAlarmValue'};
                Blocks=[Blocks(:)' {Block}];
                
                Block={};
                Block.node='Mast';
                Block.name='ALGORAV';
                Block.memoryName=Block.name;
                Block.scalar.varNames={'iRecAv' 'TimeAv' 'EneAbsAv' 'EneErrAv' 'InterAv'};
                Block.vect(1).lengthName='S_Mast.NDof';
                Block.vect(1).varNames={'DisAv' 'ResAv'};
                Block.vect(2).lengthName='S_Mast.NCon';
                Block.vect(2).varNames={'HeidAv' 'TempAv' 'TempAbsAv' 'LCellAv' ...
                    'PDForAv' 'ErrAv' 'ErrMax' 'ServoAv' 'DisConTargetAv' 'MixAAv' 'MixBAv'};
                Block.vect(3).lengthName='S_Mast.NPatt';
                Block.vect(3).varNames={'PattAv'};
                Blocks=[Blocks(:)' {Block}];
                
                Block={};
                Block.node='Mast';
                Block.name='ALGOR_T';
                Block.memoryName=Block.name;
                Block.scalar.varNames={'Count_t' 'Time_t' 'TimeIncr' 'EneAbs_t' 'EneErr_t'};
                Block.vect(1).lengthName='S_Mast.NDof';
                Block.vect(1).varNames={'Dis_t' 'Res_t'};
                Block.vect(2).lengthName='S_Mast.NCon';
                Block.vect(2).varNames={'Heid_t' 'LCell_t' 'DisConTarget_t' 'Force2_t' 'Speed_t' 'Lvdt_t'};
                Block.vect(3).lengthName='S_Mast.NGAcc';
                Block.vect(3).varNames={'GAcc_t'};
                Block.vect(4).lengthName='S_Mast.NPatt';
                Block.vect(4).varNames={'Patt_t'};
                Blocks=[Blocks(:)' {Block}];
                
                Block={};
                Block.node='Mast';
                Block.name='MIXEDCONTROL';
                Block.memoryName=Block.name;
                Block.vect(1).lengthName='S_Mast.NCon';
                Block.vect(1).varNames={'MixA' 'MixB'};
                Blocks=[Blocks(:)' {Block}];
                
%                 Block={};                  %IRESIST
%                 Block.node='Mast';
%                 Block.name='VARTEMP';
%                 Block.memoryName=Block.name;
%                 Block.vect(1).lengthName='S_Mast.NLevel';
%                 Block.vect(1).varNames={'Drift' 'Shear' 'ErrorMean' 'Rot' 'DispMean' 'For' ...
%                     'DispSouth' 'DispNorth' 'ForSouth' 'ForNorth' ...
%                     'DriftSouth' 'DriftNorth' 'ShearSouth' 'ShearNorth'}; %IRESIST
%                 Blocks=[Blocks(:)' {Block}];
                
%                 Block={};
%                 Block.node='AcqNod';
%                 Block.name='DATA';
%                 Block.memoryName=Block.name;
%                 Block.scalar.varNames={'VDispl' 'VForce'};
%                 Block.vect(1).lengthName='S_AcqNod.NTempo';
%                 Block.vect(1).varNames={'Tempo'};
%                 Block.vect(2).lengthName='S_AcqNod.NHeide';
%                 Block.vect(2).varNames={'Heide'};
%                 Block.vect(3).lengthName='S_AcqNod.NGefran';
%                 Block.vect(3).varNames={'Gefran'};
%                 Block.vect(4).lengthName='S_AcqNod.NSG';
%                 Block.vect(4).varNames={'SG'};
%                 Blocks=[Blocks(:)' {Block}];
                
                switch ACQCTRL_SERVICE
                    case 'CLASSIC'
                        if strcmp(D_Status,'Not initialized');
                            P_Server = actxserver('AcqCtrlService.Server')
                            P_MastConn=P_Server.GetConnection(S_Mast.Address)
                            if ~isempty(S_AcqNod.Address)
                                P_AcqNodConn=P_Server.GetConnection(S_AcqNod.Address)
                            end
                            for iBlock=1:length(Blocks)
                                Block=Blocks{iBlock};
                                eval(['P_' Block.node '.' Block.name '=P_' Block.node 'Conn.GetMemory(''' Block.memoryName ''');']);
                            end
                            
                            
                            for iCon=1:S_Mast.NCon
%                                 P_Mast.C_ALGO(iCon)=P_MastConn.GetMemory(['C' num2str(iCon) ' - ALGO']);
                                P_Mast.C_ALGO(iCon)=P_MastConn.GetMemory(['C' num2str(iCon) '_ALGO']);   %2022
                            end
                        end;
                    case '2019'
                        if strcmp(D_Status,'Not initialized');
                            P_Server = NET.addAssembly('AcqCtrlServiceLibDotNet')
                            P_MastConn = AcqCtrlServiceLibDotNet.Connection(10050,S_Mast.Address) %check port at master.ini
                            P_MastConn.Connect()
                            P_MastConn.LoadDatabase()
                            P_MastConn.Start()
                            %                             P_Mast.STEPVAR=P_MastConn.GetMemory('STEPVAR');
                            %                             P_Mast.STEPSTATUS=P_MastConn.GetMemory('STEPSTATUS');
                            P_Mast.ALGORUSERINPUT=P_MastConn.GetMemory('ALGORUSERINPUT');
                            P_Mast.ALGOIREC=P_MastConn.GetMemory('ALGOIREC');
                            P_Mast.PSD=P_MastConn.GetMemory('PSD');     %2015
                            P_Mast.MST_DI1_IN=P_MastConn.GetMemory('MST - DI 1-IN');
                            P_Mast.ALGORALARM=P_MastConn.GetMemory('ALGORALARM');
                            P_Mast.PUMPALARM=P_MastConn.GetMemory('PUMPALARM');
                            P_Mast.ALGORAV=P_MastConn.GetMemory('ALGORAV');
                            P_Mast.ALGOR_T=P_MastConn.GetMemory('ALGOR_T');
                            P_Mast.MIXEDCONTROL=P_MastConn.GetMemory('MIXEDCONTROL');
                            for iCon=1:S_Mast.NCon
                                P_Mast.C_ALGO(iCon)=P_MastConn.GetMemory(['C' num2str(iCon) ' - ALGO']);
                            end
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
                psdcycPONY22tr('read');
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
                psdtradtr('read');
                
            case 'read'
                D_Message='Reading measurements'
                set(S_HTextDMess,'string',sprintf('%s',D_Message));
                
                switch ACQCTRL_SERVICE
                    case 'CLASSIC'
                        value_fun = 'Value';
                    case '2019'
                        value_fun = 'GetValue()';
                end
                
                for iBlock=1:length(Blocks)
                    Block=Blocks{iBlock};
                    if isfield(Block,'constant')
                        for isig=1:length(Block.constant.varNames)
                            eval(['Signal = P_' Block.node '.' Block.name '.GetSignal(''' ...
                                Block.constant.varNames{isig} ''');']);
                            eval([Block.name '.' Block.constant.varNames{isig}  ...
                                '=Signal.' value_fun ';']);
                        end
                    end
                    if isfield(Block,'scalar')
                        for isig=1:length(Block.scalar.varNames)
                            eval(['Signal = P_' Block.node '.' Block.name '.GetSignal(''' ...
                                Block.scalar.varNames{isig} ''');']);
                            eval([Block.name '.' Block.scalar.varNames{isig} '(S_Step1)' ...
                                '=Signal.' value_fun ';']);
                        end
                    end
                    if isfield(Block,'vect')
                        for ivect=1:length(Block.vect)
                            eval(['vectLength=' Block.vect(ivect).lengthName ';']);
                            for isig=1:length(Block.vect(ivect).varNames)
                                for i=1:vectLength
                                    eval(['Signal = P_' Block.node '.' Block.name '.GetSignal(''' ...
                                        Block.vect(ivect).varNames{isig} sprintf('%02d',i) ''');']);
                                    eval([Block.name '.' Block.vect(ivect).varNames{isig} '(S_Step1,i)' ...
                                        '=Signal.' value_fun ';']);
                                end
                            end
                        end
                    end
                end
                
                % C_ALGO
                for iCon=1:S_Mast.NCon
                    for ivar=1:length(C_ALGO_varnameCon)
                        Signal = P_Mast.C_ALGO(iCon).GetSignal(C_ALGO_varnameCon{ivar});
                        eval(['C_ALGO.' C_ALGO_varnameCon{ivar} '(S_Step1,iCon)' ...
                            '=Signal.' value_fun ';']);
                    end
                end
                
                D_Message='Measurements were read'
                set(S_HTextDMess,'string',sprintf('%s',D_Message));
                D_Status='ready to write';
                set(S_HTextDStatus,'string',sprintf('TR status: %s',D_Status));
                
                if R_Active;     % Regulation of F4E
                    D_Message='Writting CommandValue';
                    set(S_HTextDMess,'string',sprintf('%s',D_Message));
                    Signal = P_Mast.ALGORUSERINPUT.GetSignal('PattISpan01');
                    Signal.Value = R_State.Command(1);
                    
                    a=Signal.Value
                    
                    P_Mast.ALGORUSERINPUT.Modified = 1;
                    D_Message='CommandValue was written';
                    set(S_HTextDMess,'string',sprintf('%s',D_Message));
                end
                
                
                % ForceValue =ksimul*TargetValue+ForceValue; %prueba
                
            case 'write';
                D_Message='Writting TargetValue'
                set(S_HTextDMess,'string',sprintf('%s',D_Message));
                
                STEPVAR.bStartOfStep(S_Step1)=1.00*D_CurrentTrue;
                
                sprintf('STEPVAR.bStartOfStep(S_Step1)=%g',STEPVAR.bStartOfStep(S_Step1))
                
                
                SignalNameList={};
                newValueList=[];
                iSignal=0;
                
                
                D_Message='TargetValue was written'
                set(S_HTextDMess,'string',sprintf('%s',D_Message));
                D_Status='ready to read';
                set(S_HTextDStatus,'string',sprintf('TR status: %s',D_Status));
        end;
    case 'Local simulation';
        D_Message='Local simulation mode'
        set(S_HTextDMess,'string',sprintf('%s',D_Message));
        switch action;
            case 'initialize';
                D_Status='ready to read';
                R_Active=0; % Regulation
                %             R_State.Command=[0 0]; % Regulation of SACOMP 2015
                R_State.Command=0; % Regulation of F4E 2016
                ALGORUSERINPUT.TestName='simulation';
            case 'read';
                
                Temp=R_Sim.Patt+(rand(1,1)-0.5)*0.01
                Tempnet=max([0 abs(Temp)-R_Sim.Tgap])*sign(Temp)
                F=R_Sim.k*Tempnet+(rand(1,1)-0.5)*0.2
                ALGORAV.iRecAv(S_Step)=S_Step;
                ALGORAV.TimeAv(S_Step)=S_Time;
                ALGOR_T.Time_t(S_Step)=S_Time;
                ALGORAV.TempAv(S_Step,1)=Temp;
                ALGORAV.HeidAv(S_Step,1)=Tempnet/1000;
                ALGORAV.LCellAv(S_Step,1)=F;
                ALGORAV.PDForAv(S_Step,1)=F+1;
                ALGOR_T.LCell_t(S_Step,1)=F;
                if R_Active;                        % Simulation  Regulation of F4E 2016
                    R_Sim.Patt=R_Sim.Patt+R_State.Command*100/100*1*0.01;
                end
                Tempo_IN.Tempo(S_Step,1:2)=[1  1.01]*F/R_Sim.k/10;
                DATA.Heide(S_Step,3:4)=[1.02  1.03]*F/R_Sim.k/10;
                DATA.Heide(S_Step,1:2)=[1.02  1.03]*F/R_Sim.k/1000;
                DATA.Gefran(S_Step,1:4)=[0.2  0.4 0.6  0.8]*F/R_Sim.k/1000;
        end;
end;







