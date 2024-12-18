function ToolStruct=psdcyc_RDhist(ToolStruct)
%RDhist:     Plot of restoring force and displacement histories.
%
% ELSA OLVIEW EtherCat controller. F. J. Molina 2019


global S_Status S_Step S_Time S_Times;
global S_TestName S_TestTitle;
global S_Mast ALGORAV ALGOR_T ALGORUSERINPUT ALGOIREC;
global VARTEMP; %SLABSTRESS 2019

NTR=2; %Number of traces in the figure
M=[S_Mast.NLevel S_Mast.NLevel];   %Number of curves per trace
if ToolStruct.Init;
    ToolStruct.Init=0;
    N=1;
    orient tall;
    set(ToolStruct.Figure,'position',[-710   272   709   712]);
    itr=1;
    subplot(NTR,1,itr);
    ToolStruct.TR(itr).line=plot(zeros(2,M(itr)));
    for i=1:M(itr)
        %             ToolStruct.TR(itr).text(i)=text('units','normalized','position',[0.98 1-i/2.2/M(itr)] ...
        %                 ,'HorizontalAlignment','right','fontname','Fixedsys' ...
        %                 ,'fontsize',6,'color',get(ToolStruct.TR(itr).line(i),'color'));
        ToolStruct.TR(itr).text(i)=text('units','normalized','position',[0.98 1-i/2.2/M(itr)] ...
            ,'HorizontalAlignment','right','fontname','Fixedsys' ...
            ,'fontsize',8,'color',get(ToolStruct.TR(itr).line(i),'color'));
    end
    xlabel('Time (s)');
    ylabel('Restoring Force (kN)');
    itr=2;
    subplot(NTR,1,itr);
    ToolStruct.TR(itr).line=plot(zeros(2,M(itr)));
    for i=1:M(itr)
        ToolStruct.TR(itr).text(i)=text('units','normalized','position',[0.98 1-i/2.2/M(itr)] ...
            ,'HorizontalAlignment','right','fontname','Fixedsys' ...
            ,'fontsize',8,'color',get(ToolStruct.TR(itr).line(i),'color'));
    end
    xlabel('Time (s)');
    ylabel(sprintf('Displacement (mm)'));
    
end
N=max(S_Step,1);

if S_Mast.NDof==0
    
    itr=1;
    for iM=1:M(itr)
        set(ToolStruct.TR(itr).line(iM),'xdata',ALGOR_T.Time_t(1:N)', ...
            'ydata',VARTEMP.For(1:N,iM));
        set(ToolStruct.TR(itr).text(iM),'string',sprintf('Level%d=% 11.4g' ...
            ,iM,VARTEMP.For(N,iM)));
    end
    itr=2;
    for iM=1:M(itr)
        set(ToolStruct.TR(itr).line(iM),'xdata',ALGOR_T.Time_t(1:N)', ...
            'ydata',VARTEMP.DispMean(1:N,iM));
        set(ToolStruct.TR(itr).text(iM),'string',sprintf('Level%d=% 11.4g' ...
            ,iM,VARTEMP.DispMean(N,iM)));
    end
    
else
    
    itr=1;
    for iM=1:M(itr)
        set(ToolStruct.TR(itr).line(iM),'xdata',ALGORAV.TimeAv(1:N)', ...
            'ydata',ALGORAV.ResAv(1:N,iM)/1000);
        set(ToolStruct.TR(itr).text(iM),'string',sprintf('DoF%d=% 11.4g' ...
            ,iM,ALGORAV.ResAv(N,iM)/1000));
    end
    itr=2;
    for iM=1:M(itr)
        set(ToolStruct.TR(itr).line(iM),'xdata',ALGORAV.TimeAv(1:N)', ...
            'ydata',ALGORAV.DisAv(1:N,iM)*1000);
        set(ToolStruct.TR(itr).text(iM),'string',sprintf('DoF%d=% 11.4g' ...
            ,iM,ALGORAV.DisAv(N,iM)*1000));
    end
    
    
end

axes(get(ToolStruct.TR(1).line(1),'parent'));
title(sprintf('%s: %s.  iRecAv=%d. TimeAv=%g',ALGORUSERINPUT(1).TestName,S_TestTitle, ...
    ALGORAV.iRecAv(N),ALGORAV.TimeAv(N)));


