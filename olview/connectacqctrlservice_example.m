
P_Server = actxserver('AcqCtrlService.Server');
master_Address='192.168.1.30';
Connection=P_Server.GetConnection(master_Address);
Memory = Connection.GetMemory('C1 - PID');

Signal = Memory.GetSignal('DispP'); %for reading
Signal.Value

Signal.Value = 2.9;       %for writing
Memory.Modified = 1;

