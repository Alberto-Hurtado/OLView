function nAttempts=writeBlockSure(SignalNameList,newValueList,blockObject,ACQCTRL_SERVICE,tolerance,waitSecs)
%writeBlockSure:     writes the values of a list of signals within the
%                    same memory block of the controller.
%                    ACQCTRL_SERVICE must be 'CLASSIC' (based on Remote
%                    Control) or '2019'.
%
% ELSA OLSTEP. F. J. Molina 2020
%
%






%%
% ACQCTRL_SERVICE = 'CLASSIC';
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
% ACQCTRL_SERVICE = '2019';
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
if nargin < 6
    waitSecs = [];
end
if nargin < 5
    tolerance = [];
end
if isempty(waitSecs)
    waitSecs = 0.042;
end
if isempty(tolerance)
    tolerance = 1e-6;
end

nSignal = length(SignalNameList);
for iSignal = 1:nSignal
    Signal{iSignal} = blockObject.GetSignal(SignalNameList{iSignal}); %this is valid for 'CLASSIC' and '2019'
end

nAttempts = 0;
confirmedValues = 0;
while ~confirmedValues
    for iSignal = 1:nSignal
        switch ACQCTRL_SERVICE
            case 'CLASSIC'
                Signal{iSignal}.Value = newValueList(iSignal);
            case '2019'
                Signal{iSignal}.InitValue(newValueList(iSignal));
        end
    end
    blockObject.Modified = 1; %this is valid for 'CLASSIC' and '2019'
    nAttempts = nAttempts + 1;
    LastReadTime=clock;
    while etime(clock,LastReadTime) < waitSecs    % wait for service update of values
    end
    confirmedValues = 1;
    for iSignal = 1:nSignal
        switch ACQCTRL_SERVICE
            case 'CLASSIC'
                if abs(Signal{iSignal}.Value - newValueList(iSignal)) > tolerance
                    confirmedValues = 0;
                end
            case '2019'
                if abs(Signal{iSignal}.GetValue() - newValueList(iSignal)) > tolerance
                    confirmedValues = 0;
                end
        end
    end
end


