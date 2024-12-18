function [K,off]=LS_stiff(d,r)
%LS_stiff:  Least Squares identification of stiffness
%                  from history of displacement and restoring force.
%
%        [K,off]=LS_stiff(d,r)
%
%   NDoF                   Number of degrees of freedom
%   Np                     Number of time instants. Np>=(NDoF+1)
%   d(Np,NDoF)             Displacement vector history
%   r(Np,NDoF)             Restoring force vector history
%   K(NDoF,NDoF)           Identified secant stiffness matrix
%   off(NDoF,1)            Identified force offset vector
%
%       The assumed model is
%
%       r' = K*d' + off; r = d*K' + off'
%
%       and the identified K and off are the Least Square Solution of
%
%       [d 1] [K'; off'] = r
%
%         Ask also help on        mldivide spatial_model 
%
%   EXAMPLE:
%
% K=[2 -0.5;-1 1];  off=[3 4];  % assumed
% Dt=0.01; d=rand(100,2);
% r=(K*d'+off')';
% [K_ident,off_ident]=LS_stiff(d,r)
%
%  2019   F. J. Molina

[Np,NDoF]=size(d);
if Np<(NDoF+1)
    error('Insuficient number of time instants for identification!')
end
Ko=([d ones(Np,1)]\r)';
K=Ko(:,1:NDoF);
off=Ko(:,NDoF+1)';


