function ToolStruct=psdcyc_RDhist(ToolStruct)
%RDhist:     Plot of restoring force and displacement histories.
%
% ELSA OLVIEW EtherCat controller. F. J. Molina 2019


global S_Status S_Step S_Time S_Times;
global S_TestName S_TestTitle;
global S_Mast ALGORAV ALGOR_T ALGORUSERINPUT ALGOIREC;
global VARTEMP;
global C_ALGO


NTR=3; %Number of traces in the figure
M=[1 2 2];   %Number of curves per trace
if ToolStruct.Init;
    ToolStruct.Init=0;
    N=1;
    orient tall;
    set(ToolStruct.Figure,'position',[11    19   593   800]);
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
        xlabel('Temposonics C2 (mm)');
        ylabel('Force C2 (kN)');
    itr=2;
        subplot(NTR,1,itr);
        ToolStruct.TR(itr).line=plot(zeros(2,M(itr)));
        for i=1:M(itr)
            ToolStruct.TR(itr).text(i)=text('units','normalized','position',[0.98 1-i/2.2/M(itr)] ...
                ,'HorizontalAlignment','right','fontname','Fixedsys' ...
                ,'fontsize',8,'color',get(ToolStruct.TR(itr).line(i),'color'));
        end
        xlabel('Heidenhain C1 C3 (mm)');
        ylabel('Force C3(kN)');
    itr=3;
        subplot(NTR,1,itr);
        ToolStruct.TR(itr).line=plot(zeros(2,M(itr)));
        for i=1:M(itr)
            ToolStruct.TR(itr).text(i)=text('units','normalized','position',[0.98 1-i/2.2/M(itr)] ...
                ,'HorizontalAlignment','right','fontname','Fixedsys' ...
                ,'fontsize',8,'color',get(ToolStruct.TR(itr).line(i),'color'));
        end
        xlabel('Heidenhain C2 C4 (mm)');
        ylabel('Force C4(kN)');
end
N=max(S_Step,1); 


itr=1;
iM=1;
  set(ToolStruct.TR(itr).line(iM),'xdata',C_ALGO.Tempo2Net(1:N,2), ...
    'ydata',C_ALGO.Force1Net(1:N,2)); 
  set(ToolStruct.TR(itr).text(iM),'string',sprintf('C%d=% 11.4g' ...
    ,2,C_ALGO.Force1Net(N,2)));

itr=2;
iM=1;
  set(ToolStruct.TR(itr).line(iM),'xdata',C_ALGO.HeideNet(1:N,1), ...
    'ydata',C_ALGO.Force1Net(1:N,3)); 
  set(ToolStruct.TR(itr).text(iM),'string',sprintf('Heide%d=% 11.4g' ...
    ,1,C_ALGO.HeideNet(N,1)));
iM=2;
  set(ToolStruct.TR(itr).line(iM),'xdata',C_ALGO.HeideNet(1:N,3), ...
    'ydata',C_ALGO.Force1Net(1:N,3)); 
  set(ToolStruct.TR(itr).text(iM),'string',sprintf('Heide%d=% 11.4g' ...
    ,3,C_ALGO.HeideNet(N,3)));

itr=3;
iM=1;
  set(ToolStruct.TR(itr).line(iM),'xdata',C_ALGO.HeideNet(1:N,2), ...
    'ydata',C_ALGO.Force1Net(1:N,4)); 
  set(ToolStruct.TR(itr).text(iM),'string',sprintf('Heide%d=% 11.4g' ...
    ,2,C_ALGO.HeideNet(N,2)));
iM=2;
  set(ToolStruct.TR(itr).line(iM),'xdata',C_ALGO.HeideNet(1:N,4), ...
    'ydata',C_ALGO.Force1Net(1:N,4)); 
  set(ToolStruct.TR(itr).text(iM),'string',sprintf('Heide%d=% 11.4g' ...
    ,4,C_ALGO.HeideNet(N,4)));


% axes(get(ToolStruct.TR(1).line(1),'parent'));
% title(sprintf('%s: %s.  iRecAv=%d. TimeAv=%g',ALGORUSERINPUT(1).TestName,S_TestTitle, ...
%     ALGORAV.iRecAv(N),ALGORAV.TimeAv(N)));


