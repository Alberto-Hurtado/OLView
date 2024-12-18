function [freq,zeta,t]=filter_model_hist(d,u,Dt,order,Npwin,Npjump)
%filter_model_hist:    Identification of frequency and damping
%                  history from dynamic output displacement and input history.
%
%       [freq,zeta,t]=filter_model_hist(d,u,Dt,order,Npwin,Npjump)
%
%   NDoF                    Number of degrees of freedom.
%   Np                      Number of data time instants.
%   Nexc                    Number of exciation forces or ground accelerograms
%   d(Np,NDoF)              Displacement vector history.
%   u(Np,Nexc)              Excitation force or ground accelerogram vector history.
%   Dt                      Time increment for data histories (s).
%   Norders                 Number of different orders of the filter models.
%   order(Norders)          Order of every filter model to identify.
%   Npwin                   Number of data points for every identication
%                           window. The window is recommended to cover at least
%                           one fudamental period.
%   Npjump                  Number of data time instants between two
%                           successive identifications.
%   Np_id                   Number of obtained identifications.
%   freq(Np_id,NDoF,Norders)        Identified frequencies (Hz).
%   zeta(Np_id,NDoF,Norders)        Identified viscous equivalent damping ratios (%). 
%   t(Np_id,1)                      Time signal for identified variables.
%
%
%       More information in Appendix B of the article
%       "Monitoring Damping in Pseudo-Dynamic Tests" by F. J. Molina, G. Magonette, P. Pegon & B. Zapico
%       http://dx.doi.org/10.1080/13632469.2010.544373
%
%         Ask also help on      filter_model_poles spatial_model_hist
%
% EXAMPLE:
% 
%   load psd_test_data.mat   %Experimental displacements and ground
%                            %acceleration from dynamic or pseudo-dynamic test
%   Dt=T(2)-T(1);  Npwin=100;  Npjump=10; order=[2 4 6]; 
%    [freq,zeta,t_ident]=filter_model_hist(RefDisp,GroundAcc,Dt,order,Npwin,Npjump);
%    
%   N_ident=length(t_ident); N_or=length(order);
%   figure(2);
%   subplot(2,2,1);  plot(t_ident,reshape(freq(:,1,:),N_ident,N_or))
%   title('Mode 1');  xlabel('Time (s)'); ylabel('Frequency (Hz)'); legend({'order 2' 'order 4' 'order 6'});
%   subplot(2,2,2);  plot(t_ident,reshape(zeta(:,1,:),N_ident,N_or))
%   title('Mode 1');  xlabel('Time (s)'); ylabel('Damping ratio %'); legend({'order 2' 'order 4' 'order 6'});
%   subplot(2,2,3);  plot(t_ident,reshape(freq(:,2,:),N_ident,N_or))
%   title('Mode 2');  xlabel('Time (s)'); ylabel('Frequency (Hz)'); legend({'order 2' 'order 4' 'order 6'});
%   subplot(2,2,4);  plot(t_ident,reshape(zeta(:,2,:),N_ident,N_or))
%   title('Mode 2');  xlabel('Time (s)'); ylabel('Damping ratio %'); legend({'order 2' 'order 4' 'order 6'});
% 
%  2011   F. J. Molina

[Np,NDoF]=size(d);
Nexc=size(u,2);
if Np>=Npwin
    Np_id=1+floor((Np-Npwin)/Npjump);
else
    Np_id=0;
    warning('Npwin exceeds the available points!');
end
t=(Npwin-1)*Dt/2+[0:(Np_id-1)]'*Npjump*Dt;
Norders=length(order);
freq=zeros(Np_id,NDoF,Norders); zeta=zeros(Np_id,NDoF,Norders); 
for iwin=1:Np_id;
    pp=[1:Npwin]+Npjump*(iwin-1);
    dd=d(pp,:);
    if Nexc>0
        uu=u(pp,:);
        if all(uu==0);
            uu=zeros(Npwin,0);
        end;
    else
        uu=zeros(Npwin,0);
    end
    for i1=1:Norders;
        polesHz=filter_model_poles(dd,uu,Dt,order(i1));
%         [polesHz,modes,poles]=filter_model_poles(dd,uu,Dt,order(i1));
        freq(iwin,:,i1)=polesHz(1:NDoF,1)';
        zeta(iwin,:,i1)=100*polesHz(1:NDoF,2)';
    end
end

