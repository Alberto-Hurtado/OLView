function nAttempts=writeSure(Signal,newValue,blockpointer,tolerance,waitSecs)
%                 Signal = P_Mast.STEPVAR.GetSignal('bStartOfStep');
%                 Signal.Value = STEPVAR.bStartOfStep(S_Step1);
%                 P_Mast.STEPVAR.Modified = 1;

if nargin < 5
%     waitSecs = 0.1
%     waitSecs = 0.050
    waitSecs = 0.042
end
if nargin < 4
    tolerance = 1e-8;
end
nAttempts = 0;
while abs(Signal.Value - newValue) > tolerance
    LastReadTime=clock;
    Signal.Value = newValue;
    blockpointer.Modified = 1;
    nAttempts = nAttempts + 1;
    while etime(clock,LastReadTime) < waitSecs    % wait for service update of values
    end
end


% >> Signal = P_Mast.STEPSTATUS.GetSignal('bEndOfStep')
%  
% Signal =
%  
% 	Interface.AcqCtrlService_1.0_Type_Library.ISignal
% 
% >> methods(Signal)
% 
% Methods for class Interface.AcqCtrlService_1.0_Type_Library.ISignal:
% 
% addproperty     events          loadobj         set             
% delete          get             release         
% deleteproperty  invoke          saveobj         
% 
% >> help Signal
% 	Signal is a variable of type Interface.AcqCtrlService_1.0_Type_Library.ISignal.
% 
% >> help Signal.get
% 	Signal is a variable of type Interface.AcqCtrlService_1.0_Type_Library.ISignal.
