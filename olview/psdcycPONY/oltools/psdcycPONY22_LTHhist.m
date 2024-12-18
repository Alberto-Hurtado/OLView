function ToolStruct=psdcyc_LTHhist(ToolStruct)
%LThistcyc:     Plot of Load Cell histories Temposonics histories and cross cycles.
%
% ELSA OLVIEW EtherCat controller. F. J. Molina 2017


global S_Status S_Step S_Time S_Times;
global S_TestName S_TestTitle;
global S_Mast ALGORAV ALGOR_T ALGORUSERINPUT ALGOIREC;

NTR=3; %Number of traces in the figure
M=[S_Mast.NCon S_Mast.NCon S_Mast.NCon];   %Number of curves per trace
if ToolStruct.Init;
    ToolStruct.Init=0;
    N=1;
    orient tall;
    set(ToolStruct.Figure,'position',[1203         -14         732         571
]);
    itr=1;
        subplot(NTR,1,itr);
        ToolStruct.TR(itr).line=plot(zeros(2,M(itr)));
        for i=1:M(itr)
            ToolStruct.TR(itr).text(i)=text('units','normalized','position',[0.98 1-i/2.2/M(itr)] ...
                ,'HorizontalAlignment','right','fontname','Fixedsys' ...
                ,'fontsize',8,'color',get(ToolStruct.TR(itr).line(i),'color'));
        end
        xlabel('Time (s)');
        ylabel('LCellAv (kN)');
    itr=2;
        subplot(NTR,1,itr);
        ToolStruct.TR(itr).line=plot(zeros(2,M(itr)));
        for i=1:M(itr)
            ToolStruct.TR(itr).text(i)=text('units','normalized','position',[0.98 1-i/2.2/M(itr)] ...
                ,'HorizontalAlignment','right','fontname','Fixedsys' ...
                ,'fontsize',8,'color',get(ToolStruct.TR(itr).line(i),'color'));
        end
        xlabel('Time (s)');
        ylabel(sprintf('Temposonics (mm)'));
    itr=3;
        subplot(NTR,1,itr);
        ToolStruct.TR(itr).line=plot(zeros(2,M(itr)));
        for i=1:M(itr)
            ToolStruct.TR(itr).text(i)=text('units','normalized','position',[0.98 1-i/2.2/M(itr)] ...
                ,'HorizontalAlignment','right','fontname','Fixedsys' ...
                ,'fontsize',8,'color',get(ToolStruct.TR(itr).line(i),'color'));
        end
        xlabel('Time (s)');
        ylabel(sprintf('Heidenhain (mm)'));
end
N=max(S_Step,1); 

itr=1;
for iM=1:M(itr)
  set(ToolStruct.TR(itr).line(iM),'xdata',ALGORAV.TimeAv(1:N)', ...
    'ydata',ALGORAV.LCellAv(1:N,iM)); 
  set(ToolStruct.TR(itr).text(iM),'string',sprintf('C%d=% 11.4g' ...
    ,iM,ALGORAV.LCellAv(N,iM)));
end
itr=2;
for iM=1:M(itr)
  set(ToolStruct.TR(itr).line(iM),'xdata',ALGORAV.TimeAv(1:N)', ...
    'ydata',ALGORAV.TempAv(1:N,iM)); 
  set(ToolStruct.TR(itr).text(iM),'string',sprintf('C%d=% 11.4g' ...
    ,iM,ALGORAV.TempAv(N,iM)));
end
itr=3;
for iM=1:M(itr)
  set(ToolStruct.TR(itr).line(iM),'xdata',ALGORAV.TimeAv(1:N)', ...
    'ydata',ALGORAV.HeidAv(1:N,iM)); 
  set(ToolStruct.TR(itr).text(iM),'string',sprintf('C%d=% 11.4g' ...
    ,iM,ALGORAV.HeidAv(N,iM)));
end

axes(get(ToolStruct.TR(1).line(1),'parent'));
title(sprintf('%s: %s.  iRecAv=%d. TimeAv=%g',ALGORUSERINPUT(1).TestName,S_TestTitle, ...
    ALGORAV.iRecAv(N),ALGORAV.TimeAv(N)));


