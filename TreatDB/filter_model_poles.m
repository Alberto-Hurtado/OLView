function [polesHz,modes,poles]=filter_model_poles(x,u,Dt,order)
%filter_model_poles:   Time-domain identification of poles and modes.
%    [polesHz,modes,poles]=filter_model_poles(x,u,Dt,order)
%       Identifies NDoF*order poles in the discrete-time
%       free or forced response of a system with NDoF degrees of freedom.
%       Every column of x(Np,NDoF) corresponds to one
%       degree of freedom and every column of u(Np,NEXC) corresponds
%       to one excitation variable. Use u=zeros(Np,0) for the case
%       of free response.
%       'Dt' is the sampling period for the Np samples
%       of x and u.
%       The 'order' of the adjusted model should be equal or greater than 
%       the order of the pysical system. For a system governed by a
%       second-order dynamic equation, use 'order'>=2.
%     
%   polesHz(i,1)         ith frequency in Hz.
%   polesHz(i,2)         ith damping ratio.
%   modes(:,i)           ith mode.
%   poles(i)             ith pole.
%
%          Ask also help on   filter_model filter_model_hist 
%
%       More information in Appendix B of the article
%       "Monitoring Damping in Pseudo-Dynamic Tests" by F. J. Molina, G. Magonette, P. Pegon & B. Zapico
%       http://dx.doi.org/10.1080/13632469.2010.544373
%
%    EXAMPLES:
%
%f1=5; f2=8; z1=0.05; z2=0.08; dt=0.01; order=2; nt=7;
%t=dt*[1:nt]';
%x=[exp(-z1*f1*2*pi*t).*sin(2*pi*f1*t) exp(-z2*f2*2*pi*t).*sin(2*pi*f2*t)];
%u=zeros(nt,0);
%[polesHz,modes]=filter_model_poles(x,u,dt,order)
%
% 1998, 2011   F. J. Molina

ndof=size(x,2);
Na=order; Nb=order;
[A1,B,A0]=filter_model(x,u,Na,Nb);
A=[A1 zeros(ndof*Na,ndof*(Na-1))]; I=eye(ndof);
for i=1:Na-1;
  A(ndof*(i-1)+[1:ndof],ndof*i+[1:ndof])=I;
end;
[modes,d]=eig(A');
poles=log(diag(d))/Dt;

% Special reordering having into account modulus and phase
R=real(poles)*3;
I=imag(poles);
[pdum,ind]=sort((R.*R+I.*I)./(2*abs(I)+1e-30));
poles=poles(ind,:);
modes=modes(:,ind);

% Reorders by imaginary part (separates conjugate poles)
[pdum,ind]=sort(-sign(imag(poles)));
poles=poles(ind,:);
modes=modes(:,ind);

% Normalises the maximum component of every mode to 1
for imode=1:size(modes,2)  
    modes(:,imode)=modes(:,imode)./max(modes(:,imode));
end

% Converts to frequency and damping ratio
polesHz=[abs(poles)/2/pi  -cos(angle(poles))];

return

