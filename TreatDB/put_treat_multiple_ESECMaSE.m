function put_treat_multiple
global AUTOMATIC_SEL_TREAT  %4-April-2008

%The first choice of every menu will be taken without asking
%Note: 'clear all' statement in the treatments must be substituted by 'clear var'
AUTOMATIC_SEL_TREAT=1  

% for i=11:21
for i=19:21
    experiment=sprintf('m%02d',i)
    cd([labpath '\ESECMaSE\Experiments\' experiment '\Prog_Treat'])
    eval([experiment 'dbav'])
    eval([experiment 'db7'])
end

clear AUTOMATIC_SEL_TREAT

return


