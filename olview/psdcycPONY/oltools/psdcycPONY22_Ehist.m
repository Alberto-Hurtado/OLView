function ToolStruct=psdcyc_Ehis(ToolStruct)
%Ehist:     Plot of Energy histories.
%
% ELSA OLVIEW. F. J. Molina 2021
%


global S_Status S_Step S_Time S_Times;
global S_TestName S_TestTitle;
global S_Mast ALGORAV ALGOR_T ALGORUSERINPUT ALGOIREC;

NTR=1; %Number of traces in the figure
M=2;   %Number of curves per trace
if ToolStruct.Init;
    ToolStruct.Init=0;
    N=1;
    orient tall;
    set(ToolStruct.Figure,'position',[3   639   562   355]);
    for itr=1:NTR
        subplot(NTR,1,itr);
        ToolStruct.TR(itr).line=plot(zeros(2,M(itr)));
        for i=1:M(itr)
            ToolStruct.TR(itr).text(i)=text('units','normalized','position',[0.98 1-i/2.2/M(itr)] ...
                ,'HorizontalAlignment','right','fontname','Fixedsys' ...
                ,'fontsize',8,'color',get(ToolStruct.TR(itr).line(i),'color'));
        end
        xlabel('Time (s)');
        ylabel(sprintf('Energy Av (J)'));
    end
end
N=max(S_Step,1);

for itr=1:NTR
    set(ToolStruct.TR(itr).line(1),'xdata',ALGORAV.TimeAv(1:N)', ...
        'ydata',ALGORAV.EneAbsAv(1:N)');
    set(ToolStruct.TR(itr).text(1),'string',sprintf('Abs=%11.4g' ...
        ,ALGORAV.EneAbsAv(N)));
    
    set(ToolStruct.TR(itr).line(2),'xdata',ALGORAV.TimeAv(1:N)', ...
        'ydata',ALGORAV.EneErrAv(1:N)');
    set(ToolStruct.TR(itr).text(2),'string',sprintf('Err=%11.4g' ...
        ,ALGORAV.EneErrAv(N)));
    
end

axes(get(ToolStruct.TR(1).line(1),'parent'));
title(sprintf('%s: %s.  iRecAv=%d. TimeAv=%g',ALGORUSERINPUT(1).TestName,S_TestTitle, ...
    ALGORAV.iRecAv(N),ALGORAV.TimeAv(N)));

