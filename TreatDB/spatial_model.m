function [K,C,off]=spatial_model(d,v,r)
%spatial_model:    Least Squares identification of stiffness and damping
%                  from history of displacement, velocity and restoring force.
%
%        [K,C,off]=spatial_model(d,v,r)
%
%   NDoF                   Number of degrees of freedom
%   Np                     Number of time instants. Np>=(2*NDoF+1)
%   d(Np,NDoF)             Displacement vector history
%   v(Np,NDoF)             Velocity vector history
%   r(Np,NDoF)             Restoring force vector history
%   K(NDoF,NDoF)           Identified secant stiffness matrix
%   C(NDoF,NDoF)           Identified viscous equivalent damping matrix
%   off(NDoF,1)            Identified force offset vector
%
%       The assumed model is
%
%       r' = K*d' + C*v' + off; r = d*K' + v*C' + off'
%
%       and the identified K, C and off are the Least Square Solution of
%
%       [d v 1] [K'; C'; off'] = r
%
%       More information in Appendix A of the article
%       "Monitoring Damping in Pseudo-Dynamic Tests" by F. J. Molina, G. Magonette, P. Pegon & B. Zapico
%       http://dx.doi.org/10.1080/13632469.2010.544373
%
%         Ask also help on        mldivide spatial_model_hist cmodes 
%
%   EXAMPLE:
%
% K=[2 -0.5;-1 1]; C=0.1*K;  %are assumed
% Dt=0.01; d=rand(100,2);
% v=zeros(size(d)); for i=2:99; v(i,:)=(d(i+1,:)-d(i-1,:))/2/Dt;end
% v(1,:)=v(2,:); v(100,:)=v(99,:); r=(K*d'+C*v')';
% [K_ident,C_ident,off_ident]=spatial_model(d,v,r)
%
%  2011   F. J. Molina

[Np,NDoF]=size(d);
if Np<(2*NDoF+1)
    error('Insuficient number of time instants for identification!')
end
KCo=([d v ones(Np,1)]\r)';
K=KCo(:,1:NDoF);
C=KCo(:,NDoF+[1:NDoF]);
off=KCo(:,2*NDoF+1);


