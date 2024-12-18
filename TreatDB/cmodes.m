function [polesHz,modes,poles]=cmodes(K,C,M)
%CMODES:    Complex modes and poles of a linear system with matrices of
%                   stiffness K, damping C and mass M.
%
%        [polesHz,modes,poles]=cmodes(K,C,M)
%
%   polesHz(i,1)         ith frequency in Hz.
%   polesHz(i,2)         ith damping ratio.
%   modes(:,i)           ith mode.
%   poles(i)             ith pole.
%
%         Ask also help on        eig spatial_model_hist
%   EXAMPLE:
%
%m=diag([3 9]); k=diag((2*pi)^2*[10^2 50^2])*m; c=diag(2*[0.01 0.02])*sqrt(k*m);
%[polesHz,modes,poles]=cmodes(k,c,m)
%
%  1998, 2011   F. J. Molina

NDoF=size(K,1);
zz=zeros(NDoF);
a=[C M; M zz];
b=[K zz;zz -M];
[modes,poles]=eig(b,-a);
poles=diag(poles);

% Reorders by modulus
[pdum,ind]=sort(abs(poles));
poles=poles(ind,:);
modes=modes(:,ind);

% Reorders by imaginary part (separates conjugate poles)
[pdum,ind]=sort(-sign(imag(poles)));
poles=poles(ind,:);
modes=modes(:,ind);

% Normalises the maximum component of every mode to 1
for imode=1:size(modes,2)   
    [dum,jmax]=max(modes(:,imode));
    modes(:,imode)=modes(:,imode)./modes(jmax,imode);
end

% Converts to frequency and damping ratio
polesHz=[abs(poles)/2/pi  -cos(angle(poles))];


