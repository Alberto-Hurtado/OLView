ass = NET.addAssembly('AcqCtrlServiceLibDotNet')



ConnMaster = AcqCtrlServiceLibDotNet.Connection(10050,'192.168.1.30') %check port at master.ini
ConnMaster.Connect()
ConnMaster.LoadDatabase()
ConnMaster.Start()

   


Memory = ConnMaster.GetMemory('C1 - PID')
dispP = Memory.GetSignal('DispP')
dispI = Memory.GetSignal('DispI')


dispP.GetValue() % Read Value
dispP.InitValue(10) % Write Value without send it to controller
dispP.Modified = 1; % Send Values from memory container to Controller

dispP.InitValue(20) % Write Value without send it to controller
dispI.InitValue(100)  % Write Value without send it to controller
Memory.Modified = 1; % Send Values from memory to controller

---- NEW:

force = ConnMaster.GetSignalByGroup('C1','Force2')
DispP = ConnMaster.GetSignalByGroup('C1','DispP')



dispP.SetValue(10) % Send Values from memory container to controller



-------------------------------------------------- test --------------------

ass = NET.addAssembly('AcqCtrlServiceLibDotNet');
S_Mast.Address='192.168.1.30';
P_MastConn=AcqCtrlServiceLibDotNet.Connection(10050,S_Mast.Address) %2019
P_MastConn.Connect()
P_MastConn.LoadDatabase()
P_MastConn.Start()                       
                     
P_Mast.ALGORUSERINPUT=P_MastConn.GetMemory('ALGORUSERINPUT');

Signal = P_Mast.ALGORUSERINPUT.GetSignal('DllName');
a2=Signal.GetValue(); a2=char(a2);
                        
Signal = P_Mast.ALGORUSERINPUT.GetSignal('TestName');
a1=Signal.GetValue(); a1=char(a1);

sprintf('Algorithm:%5s   TestName:%5s                ', a2,a1)

------------------------------------------------------ old -----------
add='192.168.1.30';
P_Server = actxserver('AcqCtrlService.Server')
P_MastConn=P_Server.GetConnection(add)