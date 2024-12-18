function s2plot(s)
% Copy signals created in Matlab desktop to a list
% in order to be used with plotdb (Copy ans to x/y)
% JM 02
%
% EXAMPLE
% s=struct('Project','Dispass','Structure','Frame+BC1BN', ...
%     'Experiment','d24','PostProcessing','60');
% s.Signal={'002' '003'};
% getsig(s);
% s2plot(s);

global s2plotlist; 
s2plotlist = s;
return