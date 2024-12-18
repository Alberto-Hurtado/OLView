function useralgoin(inFile,node,tolerance,waitSecs)
%sendinput:     send input file to master or acq node through Remote Control
%
% ELSA OLSTEP. F. J. Molina 2020
%
%

global D_Status D_Message;
global S_HTextDStatus S_HTextDMess;
global P_MastConn P_AcqNodConn;

if nargin < 4
    waitSecs = 0.042;
end
if nargin < 3
    tolerance = 1e-6
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
        P_Block=Conn.GetMemory(blockName);   
        oldBlockName=blockName;
        tomodify=0;
    elseif  ~strcmp(blockName,oldBlockName)
%     elseif  ~strcmp(blockName,oldBlockName) || mod(iVar,5)==0
%     else
        if tomodify
            D_Message='Writting Block Values';
            set(S_HTextDMess,'string',sprintf('%s',D_Message));
            P_Block.Modified = 1;
            D_Message='Values were written';
            set(S_HTextDMess,'string',sprintf('%s',D_Message));
        end
        P_Block=Conn.GetMemory(blockName);   
        oldBlockName=blockName;
        tomodify=0;
    end
    Signal = P_Block.GetSignal(varName);
    
    if abs(Signal.Value-value) > tolerance
        Signal.Value = value;
        tomodify=1;
    end
    
    if  iVar==nVar
        D_Message='Writting Block Values';
        set(S_HTextDMess,'string',sprintf('%s',D_Message));
        P_Block.Modified = 1;
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
        P_Block=Conn.GetMemory(blockName);   
        oldBlockName=blockName;
    end
    Signal = P_Block.GetSignal(varName);
    if abs(Signal.Value-value) > tolerance 
        confirmed_value=0;
        disp(sprintf('Signal %s is still %g instead of %g!!',varName,Signal.Value,value))
    end
end
if confirmed_value
    disp('     CONGRATULATIONS: sent values have been confirmed OK!!!');
else
    disp('     WARNING: sent values were NOT adopted correctly!!!');
end



