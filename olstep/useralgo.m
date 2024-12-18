function useralgo(act1)
% function psd(act1)
% %PSD:     Pseudodynamic integration procedure
% %
% % ELSA STEPTEST. F. J. Molina 2004
% %

global D_Status D_Message;
global S_HTextDStatus S_HTextDMess;
global S_Step S_EndStep 
global P_Server P_MastConn
global S_Mast P_Mast S_AcqNod
global STEPVAR STEPSTATUS

global S_TestName S_Path S_GeomProc S_MenuMode

global TABTARGETS


switch act1;
case 'open the test';
  cd(S_Path);
%   [S_NDof,S_TEnd,S_Delt]=feval([S_TestName '_useralgo']);
  TABTARGETS = feval([S_TestName '_useralgo']);
  S_Step=0;
  z=zeros(S_EndStep+1,1);
  STEPVAR.bStartOfStep=z;
  STEPVAR.fMinStepTime=z;
  STEPVAR.fLatencyTime=z;
  STEPVAR.lAverageNumber=z;
  STEPSTATUS.bEndOfStep=z;
  STEPSTATUS.lCurrentStep=z;
  STEPSTATUS.lCurrentSubStep=z;
  STEPSTATUS.lNbrSubSteps=z;
  STEPSTATUS.lLatencyTicks=z;
  STEPSTATUS.lNumOfWaitStepsMinus1=z;
  z=zeros(S_EndStep+1,S_Mast.NDof);
  STEPVAR.dNewTarget=z;
  STEPSTATUS.dAverageOutput=z;
  STEPSTATUS.dAverageTargetError=z;
  z=zeros(S_EndStep+1,S_Mast.NCon);
  STEPVAR.fMaxStepSpeed=z;
  
  for iCon=1:S_Mast.NCon  %Next target is read from pattern table
      STEPVAR.dNewTarget(1,iCon) = TABTARGETS{2,iCon+2};
  end
  
   transmit('initialize');

case 'send target';
%   if strcmp(D_Status,'Not initialized');
%     transmit('initialize');
%     %     Dummy initializing lecture (call without outputs):
%     %     transmit('Dummy initializing read');
%     %     %     Impose dummy initializing step:
%     transmit('write');
%   end;
%   if S_Step==0;
%     transmit('read');
%   end;
  %     Impose ramp from DisConMeasN to DisConTargNplus1
    transmit('write');
%   transmit('write',S_DisConTarg(:,N+1),S_MenuMode);

case 'measure and compute';
  %     Measure  specimen displacement and restoring force
    transmit('wait and read');
%   [S_DisHei(:,N),S_DisTem(:,N),S_DisTemAbs(:,N),S_RfoCon(:,N)]= ...
%     transmit('read',S_DisConTarg(:,N),S_MenuMode,S_KSimul ...
%       ,S_CSimul,VelTarg);
  %     Computation of acceleration, displacement and velocity
%   if N==1;
%     [S_DisAlg(:,N+1),S_VelAlg(:,N+1),S_Beta,S_Gamma,S_MMinv]= ...
%       opsplpre(S_AccAlg(:,1),S_DisAlg(:,1),S_VelAlg(:,1), ...
%       S_Alpha,S_NDof,S_Delt,S_Mass,S_Damp,S_KImp);
%   else;
%     [S_AccAlg(:,N),S_DisAlg(:,N+1),S_VelAlg(:,N+1)]= ...
%       opsplalg(S_AccAlg(:,N-1),S_DisAlg(:,N),S_VelAlg(:,N), ...
%       S_VelAlg(:,N-1),S_FexAlg(:,N),S_FexAlg(:,N-1), ...
%       S_RfoAlg(:,N),S_RfoAlg(:,N-1),S_Alpha,S_Beta,S_Gamma, ...
%       S_NDof,S_Delt,S_MMinv,S_Damp,S_KImp);
%     S_EneAlg(:,N)=enealg(S_EneAlg(:,N-1), ...
%       S_RfoAlg(:,N-1:N),S_DisAlg(:,N-1:N),S_VelAlg(:,N-1:N), ...
%       S_FexAlg(:,N-1:N),S_DisAlgMeas(:,N-1:N),S_Mass,S_Damp);
%     S_EneCon(:,N)=enecon(S_EneCon(:,N-1), ...
%       S_RfoCon(:,N-1:N),S_DisConTarg(:,N-1:N),S_DisConMeas(:,N-1:N));
%   end;
    tabSteps=size(TABTARGETS,1);
    if S_Step < tabSteps
        for iCon=1:S_Mast.NCon  %Next target is read from pattern table
            STEPVAR.dNewTarget(S_Step,iCon) = TABTARGETS{S_Step+1,iCon+2};
        end
    else
        for iCon=1:S_Mast.NCon  %Next target is read from pattern table
            STEPVAR.dNewTarget(S_Step,iCon) = TABTARGETS{tabSteps,iCon+2};
        end
    end
    

case 'save MAT data';
case 'read MAT data'
case 'save SI files';
end;
return;








