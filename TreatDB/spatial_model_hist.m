function [freq,zeta,K,C,off,t]=spatial_model_hist(d,r,M,Dt,Npwin,Npjump)
%spatial_model_hist:    Identification of frequency, stiffness and damping
%                  history from displacement and restoring force dynamkic history.
%
%       [freq,zeta,K,C,off,t]=spatial_model_hist(d,r,M,Dt,Npwin,Npjump)
%
%   NDoF                    Number of degrees of freedom.
%   Np                      Number of input time instants.
%   d(Np,NDoF)              Displacement vector history.
%   r(Np,NDoF)              Restoring force vector history.
%   M(NDoF,NDoF)            Mass matrix.
%   Dt                      Time increment for input histories (s).
%   Npwin                   Number of input points for every identication
%                           window. Npwin>=(2*NDoF+1), but the window is
%                           recommended to cover at least one fudamental
%                           period in order to average nonlinearities.
%   Npjump                  Number of input time instants between two
%                           successive identifications.
%   Np_id                   Number of obtained identifications.
%   freq(Np_id,NDoF)        Identified frequencies (Hz).
%   zeta(Np_id,NDoF)        Identified viscous equivalent damping ratios (%). 
%   K(NDoF,NDoF,Np_id)      Identified secant stiffness matrix.
%   C(NDoF,NDoF,Np_id)      Identified viscous equivalent damping matrix.
%   off(NDoF,Np_id)         Identified force offset vector.
%   t(Np_id,1)              Time signal for identified variables.
%
%
%       More information in Appendix A of the article
%       "Monitoring Damping in Pseudo-Dynamic Tests" by F. J. Molina, G. Magonette, P. Pegon & B. Zapico
%       http://dx.doi.org/10.1080/13632469.2010.544373
%
%         Ask also help on      spatial_model cmodes filter_model_hist
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

[Np,NDoF]=size(d);
v=zeros(Np,NDoF);
v(1,:)=(d(2,:)-d(1,:))/Dt;
for i=2:(Np-1)
    v(i,:)=(d(i+1,:)-d(i-1,:))/2/Dt;
end
v(Np,:)=(d(Np,:)-d(Np-1,:))/Dt;
if Np>=Npwin
    Np_id=1+floor((Np-Npwin)/Npjump);
else
    Np_id=0;
    warning('Npwin exceeds the available points!');
end
t=(Npwin-1)*Dt/2+[0:(Np_id-1)]'*Npjump*Dt;
freq=zeros(Np_id,NDoF); zeta=zeros(Np_id,NDoF); 
K=zeros(NDoF,NDoF,Np_id); C=zeros(NDoF,NDoF,Np_id); off=zeros(NDoF,Np_id); 
for iwin=1:Np_id;
    pp=[1:Npwin]+Npjump*(iwin-1);
    [K(:,:,iwin),C(:,:,iwin),off(:,iwin)]=spatial_model(d(pp,:),v(pp,:),r(pp,:));
    [polesHz]=cmodes(K(:,:,iwin),C(:,:,iwin),M);
    freq(iwin,:)=polesHz(1:NDoF,1)';
    zeta(iwin,:)=100*polesHz(1:NDoF,2)';
end;
