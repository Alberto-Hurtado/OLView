function ToolStruct=psdcyc_MixBhist(ToolStruct)
%LThistcyc:     Plot of Load Cell histories Temposonics histories and cross cycles.
%
% ELSA OLVIEW EtherCat controller. F. J. Molina 2017


global S_Step
global S_TestName S_TestTitle;
global S_Mast ALGORAV ALGOR_T ALGORUSERINPUT
% global DATA;

NTR=S_Mast.NCon; %Number of traces in the figure
% M=[2 2 2];   %Number of curves per trace
M=[1 1 1];   %Number of curves per trace
SGchName={'V' 'N' 'M'};
SGchUnit={'kN' 'kN' 'kNm'};
if ToolStruct.Init;
    ToolStruct.Init=0;
    N=1;
    orient tall;
    set(ToolStruct.Figure,'position',[ 1282          22         634        1092]);
    for itr=1:NTR
        subplot(NTR,1,itr);
        ToolStruct.TR(itr).line=plot(zeros(2,M(itr)));
        for i=1:M(itr)
            ToolStruct.TR(itr).text(i)=text('units','normalized','position',[0.98 1-i/2.2/M(itr)] ...
                ,'HorizontalAlignment','right','fontname','Fixedsys' ...
                ,'fontsize',8,'color',get(ToolStruct.TR(itr).line(i),'color'));
        end
        xlabel('StepAv');
%         ylabel(['MixB' num2str(itr) ' CLC ' SGchName{itr} ' (' SGchUnit{itr} ')']);
        ylabel(['MixB' num2str(itr) ' ' SGchName{itr} ' (' SGchUnit{itr} ')']);
    end
end
N=max(S_Step,1); 

for itr=1:NTR
    iM=1;
    set(ToolStruct.TR(itr).line(iM),'xdata',ALGORAV.lCurrentStepAv(1:N)', ...
        'ydata',ALGORAV.MixBAv(1:N,itr));
    set(ToolStruct.TR(itr).text(iM),'string',sprintf('MixB=% 11.4g' ...
        ,ALGORAV.MixBAv(N,itr)));
%     iM=2;
%     set(ToolStruct.TR(itr).line(iM),'xdata',ALGORAV.lCurrentStepAv(1:N)', ...
%         'ydata',DATA.CLC(1:N,itr));
%     set(ToolStruct.TR(itr).text(iM),'string',sprintf('CLC=% 11.4g' ...
%         ,DATA.CLC(N,itr)));
end
axes(get(ToolStruct.TR(1).line(1),'parent'));
title(sprintf('%s: %s.  lCurrentStepAv=%d',char(ALGORUSERINPUT.TestName),S_TestTitle, ...
    ALGORAV.lCurrentStepAv(N)));



