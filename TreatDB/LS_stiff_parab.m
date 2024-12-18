function [K,Q,off]=LS_stiff_parab(d,r)
%LS_stiff_parab:  Least Squares identification of stiffness, inluding
%                  parabolic terms,
%                  from history of displacement and restoring force.
%
%        [K,Q,off]=LS_stiff_parab(d,r)
%
%   NDoF=2                   Number of degrees of freedom
%   Np                       Number of time instants. Np>=(NDoF+1)
%   d(Np,NDoF)               Displacement vector history
%   r(Np,NDoF)               Restoring force vector history
%   K(NDoF,NDoF)             Identified secant stiffness matrix
%   Q(NDOF,NDoF+NDoF*(NDoF-1)/2)  Identified secant stiffness matrix
%   off(NDoF,1)              Identified force offset vector
%
%       The assumed model for NDoF=2 is
%
%       r=[r1 r2]   d=[d1 d2]   dd=[d1^2 d2^2 d1*d2]
%
%       r' = off + K*d' + Q*dd'; r = off' + d*K' + dd*Q'
%
%       and the identified K and off are the Least Square Solution of
%
%       [1 d dd] [off'; K'; Q'] = r
%
%         Ask also help on        mldivide spatial_model 
%
%   EXAMPLE:
%
% K=[2 -0.5;-1 1]         % assumed
% Q=[3 -1.5 1;-3 2 -0.5]  % assumed
% off=[3 4]               % assumed
% d=rand(100,2);
% dd=[d.^2 d(:,1).*d(:,2)];
% r=(off' + K*d' + Q*dd')';
% [K_ident,Q_ident,off_ident]=LS_stiff_parab(d,r)
%
%  2023   F. J. Molina

[Np,NDoF]=size(d)

if NDoF~=2
    error('This function is valid only for 2 DoFs!')
end

Nq=NDoF+NDoF*(NDoF-1)/2

if Np*NDoF<(NDoF+1+Nq)*NDoF
    error('Insuficient number of time instants for identification!')
end

dd=[d.^2 d(:,1).*d(:,2)];
oKQ=([ones(Np,1) d dd]\r)';
off=oKQ(:,1)';
K=oKQ(:,1+[1:NDoF]);
Q=oKQ(:,1+NDoF+[1:Nq]);



