% Reorders numbering of acq signals.
% Before running these lines, prepare your
% not-ordered list in a file varnames.txt as this 
%
% szSignal11=C1 - ALGO.PartI
% szSignal12=C1 - ALGO.PartD
% szSignal13=C1 - AD 1-IN.Spool
% szSignal14=C1 - AD 2-IN.Pressure1
% szSignal15=C1 - AD 2-IN.Pressure2
% szSignal16=C1 - DA 1-OUT.Servo1
% szSignal17=C1 - CTRL.OffsetRef
% szSignal18=C1 - CTRL.FeedbTransdFlag
% szSignal1=C2 - ALGO.MixedFeedbackValue
% szSignal2=C2 - ALGO.Tempo1Net
% szSignal3=C2 - ALGO.Tempo2Net
% szSignal57=keep always this dummy line!!
%
% Then, run this script in the same folder and
% copy the resulting ordered list from
% the command window  
%

fid1=fopen('varnames.txt')
C = textscan(fid1,'szSignal%d=%s %s %s %s')
fclose(fid1);
% [C{2}{1} ' ' C{3}{1} ' ' C{4}{1} ' ' C{5}{1}]
% [C{2}{14} ' ' C{3}{14} ' ' C{4}{14} ' ' C{5}{14}]
% [C{2}{40} ' ' C{3}{40} ' ' C{4}{40} ' ' C{5}{40}]
% [C{2}{75} ' ' C{3}{74} ' ' C{4}{74} ' ' C{5}{74}]


nfields=size(C,2)
nvar=size(C{1},1)-1 %A dummy signal is required at the end!
comm='s=[s deblank(sprintf(''szSignal%d=';
for ifield=2:nfields
    comm=[comm '%s '];
end
comm=[comm '\n'',ivar'];
for ifield=2:nfields
    comm=[comm sprintf(',C{%d}{ivar}',ifield)];
end
comm=[comm ')) sprintf(''\n'')];'];
s=sprintf('dwSignalNumber=%d\n\n',nvar);
for ivar=1:nvar
%     s=[s deblank(sprintf('szSignal%d=%s %s %s %s\n',ivar,C{2}{ivar}, ...
%         C{3}{ivar},C{4}{ivar},C{5}{ivar})) sprintf('\n')];
    eval(comm); 
end

disp(s)
