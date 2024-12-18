function ToolStruct=psdcyc_PDF_Lcyc(ToolStruct)
%PDF_Lcyc:     Plot of PDFor versus Load Cell.
%
% ELSA OLVIEW EtherCat controller. F. J. Molina 2017
%


global S_Step
global S_TestName S_TestTitle;
global S_Mast ALGORAV ALGOR_T ALGORUSERINPUT

NTR=S_Mast.NCon; %Number of traces per master
M=2;   %Number of curves per trace
if ToolStruct.Init;
  ToolStruct.Init=0;
  N=1;
  orient landscape;
  set(ToolStruct.Figure,'position',[10    35   661   397]);
      for itr=1:NTR
          subplot(1,NTR,itr);
          ToolStruct.TR(1,itr).line=plot(zeros(2,M));
          for i=1:M
              ToolStruct.TR(1,itr).text(i)=text('units','normalized','position',[0.98 1-i/2.2/M] ...
                  ,'HorizontalAlignment','right','fontname','Fixedsys' ...
                  ,'fontsize',6,'color',get(ToolStruct.TR(1,itr).line(i),'color'));
          end
          xlabel(['LCell Force (kN) Con ' num2str(itr)]);
          ylabel(['Force (kN) Master Con ' num2str(itr)]);
      end
end
N=max(S_Step,1);
      for itr=1:NTR
      set(ToolStruct.TR(1,itr).line(1),'xdata',ALGORAV.LCellAv(1:N,itr), ...
          'ydata',ALGORAV.PDForAv(1:N,itr));
      set(ToolStruct.TR(1,itr).text(1),'string',sprintf('PDFor=%11.4g' ...
          ,ALGORAV.PDForAv(N,itr)));
      
      set(ToolStruct.TR(1,itr).line(2),'xdata',ALGORAV.LCellAv(1:N,itr), ...
          'ydata',ALGORAV.LCellAv(1:N,itr));
      set(ToolStruct.TR(1,itr).text(2),'string',sprintf('LCell=%11.4g' ...
          ,ALGORAV.LCellAv(N,itr)));
      
      end
  
axes(get(ToolStruct.TR(1).line(1),'parent'));
title(sprintf('%s: %s.  lCurrentStepAv=%d',char(ALGORUSERINPUT.TestName),S_TestTitle, ...
    ALGORAV.lCurrentStepAv(N)));

