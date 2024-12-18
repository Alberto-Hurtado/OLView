function ToolStruct=psdtrad_LTHhist(ToolStruct)
%LThistcyc:     Plot of Load Cell histories Temposonics histories and cross cycles.
%
% ELSA OLVIEW EtherCat controller. F. J. Molina 2017


global S_Step
global S_TestName S_TestTitle
global S_Mast ALGORAV ALGOR_T ALGORUSERINPUT

NTR=3; %Number of traces in the figure
M=[S_Mast.NCon S_Mast.NCon S_Mast.NCon*2];   %Number of curves per trace
if ToolStruct.Init;
    ToolStruct.Init=0;
    N=1;
    orient tall;
    set(ToolStruct.Figure,'position',[ 1278          59         634         908]);
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
        xlabel('StepAv');
        ylabel('LCellAv (kN)');
    itr=2;
        subplot(NTR,1,itr);
        ToolStruct.TR(itr).line=plot(zeros(2,M(itr)));
        for i=1:M(itr)
            ToolStruct.TR(itr).text(i)=text('units','normalized','position',[0.98 1-i/2.2/M(itr)] ...
                ,'HorizontalAlignment','right','fontname','Fixedsys' ...
                ,'fontsize',8,'color',get(ToolStruct.TR(itr).line(i),'color'));
        end
        xlabel('StepAv');
        ylabel(sprintf('Temposonics (mm)'));
    itr=3;
        subplot(NTR,1,itr);
        ToolStruct.TR(itr).line=plot(zeros(2,M(itr)));
        for i=1:M(itr)
            ToolStruct.TR(itr).text(i)=text('units','normalized','position',[0.98 1-i/2.2/M(itr)] ...
                ,'HorizontalAlignment','right','fontname','Fixedsys' ...
                ,'fontsize',8,'color',get(ToolStruct.TR(itr).line(i),'color'));
        end
        xlabel('StepAv');
        ylabel(sprintf('Heidenhain & TargetAv (mm)'));

end
N=max(S_Step,1); 

itr=1;
for iM=1:S_Mast.NCon
  set(ToolStruct.TR(itr).line(iM),'xdata',ALGORAV.lCurrentStepAv(1:N)', ...
    'ydata',ALGORAV.LCellAv(1:N,iM)); 
  set(ToolStruct.TR(itr).text(iM),'string',sprintf('LCell%d=% 11.4g' ...
    ,iM,ALGORAV.LCellAv(N,iM)));
end
itr=2;
for iM=1:S_Mast.NCon
  set(ToolStruct.TR(itr).line(iM),'xdata',ALGORAV.lCurrentStepAv(1:N)', ...
    'ydata',ALGORAV.TempAv(1:N,iM)); 
  set(ToolStruct.TR(itr).text(iM),'string',sprintf('C%d=% 11.4g' ...
    ,iM,ALGORAV.TempAv(N,iM)));
end
itr=3;
for iM=1:S_Mast.NCon
  set(ToolStruct.TR(itr).line(iM),'xdata',ALGORAV.lCurrentStepAv(1:N)', ...
    'ydata',ALGORAV.HeidAv(1:N,iM)); 
  set(ToolStruct.TR(itr).text(iM),'string',sprintf('C%d=% 11.4g' ...
    ,iM,ALGORAV.HeidAv(N,iM)));
end
for iCon=1:S_Mast.NCon
    iM=S_Mast.NCon + iCon;
  set(ToolStruct.TR(itr).line(iM),'xdata',ALGORAV.lCurrentStepAv(1:N)', ...
    'ydata',ALGORAV.ConTargetAv(1:N,iCon)); 
  set(ToolStruct.TR(itr).text(iM),'string',sprintf('Targ%d=% 11.4g' ...
    ,iCon,ALGORAV.ConTargetAv(N,iCon)));
end

axes(get(ToolStruct.TR(1).line(1),'parent'));
title(sprintf('%s: %s.  lCurrentStepAv=%d',char(ALGORUSERINPUT.TestName),S_TestTitle, ...
    ALGORAV.lCurrentStepAv(N)));


