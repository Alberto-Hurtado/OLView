function file2ctrl(inFile,node,tolerance,waitSecs)
%file2ctrl:     send input file to master or acq node through Remote Control
%
% ELSA OLVIEW and OLSTEP. F. J. Molina 2020
% 2023. it has been made intentionally slower and redundant in order to
% try to get more reliable transfer.
%
% The value of ACQCTRL_SERVICE is assigned at transmit (OLSTEP) or
% psdtradtr (OLVIEW) functions.



global D_Status D_Message;
global S_HTextDStatus S_HTextDMess;
global P_MastConn P_AcqNodConn;
global ACQCTRL_SERVICE

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

if nargin < 4
    waitSecs = [];
end
if nargin < 3
    tolerance = [];
end
if isempty(waitSecs)
    waitSecs = 0.042;
end
if isempty(tolerance)
    tolerance = 1e-6;
end

disp(['reading input file: ' inFile]);
[num,txt,tabData] = xlsread(inFile);
nVar=size(tabData,1)-1
colBlockName=find(strcmp(tabData(1,:),'Block name'));
colVarName=find(strcmp(tabData(1,:),'Variable name'));
colValue=find(strcmp(tabData(1,:),'Variable value'));


switch node
    case 'Master'
        Conn = P_MastConn;
    case 'Acq'
        Conn = P_AcqNodConn;
end

disp(['Sending input values to ' node]);

for iVar=1:nVar
    row=iVar+1;
    blockName=tabData{row,colBlockName};
    varName=tabData{row,colVarName};
    value=tabData{row,colValue};
    if iVar==1
        P_Block=Conn.GetMemory(blockName);    %this is valid for 'CLASSIC' and '2019'
        oldBlockName=blockName;
        tomodify=0;
%     elseif  ~strcmp(blockName,oldBlockName)   %2020
%     elseif  ~strcmp(blockName,oldBlockName) || mod(iVar,5)==0
    else     %2023. In order to try to get more reliable transfer!
        if tomodify
            D_Message='Writting Block Values';
            set(S_HTextDMess,'string',sprintf('%s',D_Message));
            P_Block.Modified = 1;   %this is valid for 'CLASSIC' and '2019'
            D_Message='Values were written';
            set(S_HTextDMess,'string',sprintf('%s',D_Message));
        end
        P_Block=Conn.GetMemory(blockName);    %this is valid for 'CLASSIC' and '2019'
        oldBlockName=blockName;
        tomodify=0;
    end
    Signal = P_Block.GetSignal(varName);    %this is valid for 'CLASSIC' and '2019'
    
    switch ACQCTRL_SERVICE
        case 'CLASSIC'
%             if abs(Signal.Value-value) > tolerance
            if true     %2023. In order to try to get more reliable transfer!
                Signal.Value = value;
                tomodify=1;
            end
        case '2019'
%             if abs(double(Signal.GetValue())-value) > tolerance
            if true     %2023. In order to try to get more reliable transfer!
                Signal.InitValue(value);
                tomodify=1;
            end
    end

    if  iVar==nVar
        D_Message='Writting Block Values';
        set(S_HTextDMess,'string',sprintf('%s',D_Message));
        P_Block.Modified = 1;   %this is valid for 'CLASSIC' and '2019'
        D_Message='Values were written';
        set(S_HTextDMess,'string',sprintf('%s',D_Message));
    end
    
    
end

disp(['Checking current values in ' node ' ...']);


LastReadTime=clock;
while etime(clock,LastReadTime) < waitSecs    % wait for service update of values
end

confirmed_value=1;
for iVar=1:nVar    
    row=iVar+1;
    blockName=tabData{row,colBlockName};
    varName=tabData{row,colVarName};
    value=tabData{row,colValue};
    if iVar==1 ||  ~strcmp(blockName,oldBlockName)
        P_Block=Conn.GetMemory(blockName);      %this is valid for 'CLASSIC' and '2019'
        oldBlockName=blockName;
    end
    Signal = P_Block.GetSignal(varName);   %this is valid for 'CLASSIC' and '2019'
    
    switch ACQCTRL_SERVICE
        case 'CLASSIC'
            if abs(Signal.Value-value) > tolerance
                confirmed_value=0;
                disp(sprintf('Signal %s is still %g instead of %g!!',varName,Signal.Value,value))
            end
        case '2019'
            if abs(double(Signal.GetValue())-value) > tolerance
                confirmed_value=0;
                disp(sprintf('Signal %s is still %g instead of %g!!',varName,double(Signal.GetValue()),value))
            end
    end

end
if confirmed_value
    disp('     CONGRATULATIONS: sent values have been confirmed OK!!!');
else
    disp('     WARNING: sent values were NOT adopted correctly!!!');
end



