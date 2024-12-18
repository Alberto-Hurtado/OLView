function ToolStruct=psdtrad_LD_loops(ToolStruct)
%psdtard_LD_loops:     Force-displacement loops.
%
% ELSA OLVIEW EtherCat controller. F. J. Molina 2020


global S_Step
global S_TestName S_TestTitle
global S_Mast ALGORAV ALGOR_T ALGORUSERINPUT

NTR=3; %Number of traces in the figure
M=[1 2 2];   %Number of curves per trace
if ToolStruct.Init;
    ToolStruct.Init=0;
    N=1;
    orient tall;
    set(ToolStruct.Figure,'position',[8   205   634   908]);
    itr=1;
        subplot(NTR,1,itr);
        ToolStruct.TR(itr).line=plot(zeros(2,M(itr)));
        for i=1:M(itr)
            ToolStruct.TR(itr).text(i)=text('units','normalized','position',[0.98 1-i/2.2/M(itr)] ...
                ,'HorizontalAlignment','right','fontname','Fixedsys' ...
                ,'fontsize',8,'color',get(ToolStruct.TR(itr).line(i),'color'));
        end
        xlabel('DispAv (mm)');
        ylabel('LCellAv (kN)');
    itr=2;
        subplot(NTR,1,itr);
        ToolStruct.TR(itr).line=plot(zeros(2,M(itr)));
        for i=1:M(itr)
            ToolStruct.TR(itr).text(i)=text('units','normalized','position',[0.98 1-i/2.2/M(itr)] ...
                ,'HorizontalAlignment','right','fontname','Fixedsys' ...
                ,'fontsize',8,'color',get(ToolStruct.TR(itr).line(i),'color'));
        end
        xlabel('DispAv (mm)');
        ylabel('LCellAv (kN)');
    itr=3;
        subplot(NTR,1,itr);
        ToolStruct.TR(itr).line=plot(zeros(2,M(itr)));
        for i=1:M(itr)
            ToolStruct.TR(itr).text(i)=text('units','normalized','position',[0.98 1-i/2.2/M(itr)] ...
                ,'HorizontalAlignment','right','fontname','Fixedsys' ...
                ,'fontsize',8,'color',get(ToolStruct.TR(itr).line(i),'color'));
        end
        xlabel('DispAv (mm)');
        ylabel('LCellAv (kN)');
end
N=max(S_Step,1); 

itr=1;
for iM=1:1
  set(ToolStruct.TR(itr).line(iM),'xdata',ALGORAV.TempAv(1:N,2), ...
    'ydata',ALGORAV.LCellAv(1:N,2)); 
  set(ToolStruct.TR(itr).text(iM),'string',sprintf('TempAv%d=% 11.4g' ...
    ,2,ALGORAV.TempAv(N,2)));
end
itr=2;
for iM=1:2
  set(ToolStruct.TR(itr).line(iM),'xdata',ALGORAV.HeidAv(1:N,iM*2-1), ...
    'ydata',ALGORAV.LCellAv(1:N,3)); 
  set(ToolStruct.TR(itr).text(iM),'string',sprintf('HeidAv%d=% 11.4g' ...
    ,iM*2-1,ALGORAV.HeidAv(N,iM*2-1)));
end
itr=3;
for iM=1:2
  set(ToolStruct.TR(itr).line(iM),'xdata',ALGORAV.HeidAv(1:N,iM*2), ...
    'ydata',ALGORAV.LCellAv(1:N,4)); 
  set(ToolStruct.TR(itr).text(iM),'string',sprintf('HeidAv%d=% 11.4g' ...
    ,iM*2,ALGORAV.HeidAv(N,iM*2)));
end

axes(get(ToolStruct.TR(1).line(1),'parent'));
title(sprintf('%s: %s.  lCurrentStepAv=%d',char(ALGORUSERINPUT.TestName),S_TestTitle, ...
    ALGORAV.lCurrentStepAv(N)));


