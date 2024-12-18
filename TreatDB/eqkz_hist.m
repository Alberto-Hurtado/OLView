function [K,zeta,DAmpl,t]=eqkz_hist(d,r,Dt,Npwin,Npjump)
%eqkz_hist:    Identification of equivalent linear SDoF stiffness and damping
%                  history from displacement and restoring force dynamic or cyclic history.
%
%       [K,zeta,t]=eqkz_hist(d,r,Dt,Npwin,Npjump)
%
%   Np                      Number of input time instants.
%   d(Np,1)                 Displacement history.
%   r(Np,1)                   Restoring force history.
%   Dt                      Time increment for input histories (s). This
%                               time does not affect the results.
%   Npwin                   Number of input points for every identication
%                               window. It is recommended to cover at least one fudamental
%                               period in order to average nonlinearities.
%   Npjump                  Number of input time instants between two
%                           successive identifications.
%   Np_id                   Number of obtained identifications.
%   K(Np_id)                Identified secant stiffness.
%   zeta(Np_id)             Identified viscous equivalent damping ratio (%). 
%   DAmpl(Np_id)            Identified displacement amplitude of the cycle. 
%   t(Np_id)                Time signal for identified variables.
%
%
%         Ask also help on      spatial_model_hist
%
% EXAMPLE:
%   load psd_test_data.mat   %Experimental displacements and restoring
%                            %forces from pseudo-dynamic test
%   M=[ 23900 0;0 23650];    %Theoretical specimen mass
%   Dt=T(2)-T(1);  Npwin=100;  Npjump=10;
%
%   %Identification based on reference displacements:
%   [freq_Ref,zeta_Ref,K_Ref,C_Ref,off_Ref,t_ident]= ...
%         spatial_model_hist(RefDisp,ResForce,M,Dt,Npwin,Npjump);
%
%   %Identification based on measured displacements:
%   [freq_Meas,zeta_Meas,K_Meas,C_Meas,off_Meas,t_ident]= ...
%         spatial_model_hist(MeasDisp,ResForce,M,Dt,Npwin,Npjump);
%      
%   figure(1);
%   subplot(2,2,1);  plot(t_ident,[freq_Ref(:,1) freq_Meas(:,1)])
%   title('Mode 1');  xlabel('Time (s)'); ylabel('Frequency (Hz)'); legend({'Reference' 'Measured'});
%   subplot(2,2,2);  plot(t_ident,[zeta_Ref(:,1) zeta_Meas(:,1)])
%   title('Mode 1');  xlabel('Time (s)'); ylabel('Damping ratio %'); legend({'Reference' 'Measured'});
%   subplot(2,2,3);  plot(t_ident,[freq_Ref(:,2) freq_Meas(:,2)])
%   title('Mode 2');  xlabel('Time (s)'); ylabel('Frequency (Hz)'); legend({'Reference' 'Measured'});
%   subplot(2,2,4);  plot(t_ident,[zeta_Ref(:,2) zeta_Meas(:,2)])
%   title('Mode 2');  xlabel('Time (s)'); ylabel('Damping ratio %'); legend({'Reference' 'Measured'});
%
%  2011   F. J. Molina

Np=length(d);
if Np>=Npwin
    Np_id=1+floor((Np-Npwin)/Npjump);
else
    Np_id=0;
    warning('Npwin exceeds the available points!');
end
t=(Npwin-1)*Dt/2+[0:(Np_id-1)]'*Npjump*Dt;
zeta=zeros(Np_id,1); K=zeros(Np_id,1);  DAmpl=zeros(Np_id,1); 
for iwin=1:Np_id;
    pp=[1:Npwin]+Npjump*(iwin-1);
    [K(iwin),zeta(iwin),DAmpl(iwin)]=eqkz(d(pp),r(pp));
end;
