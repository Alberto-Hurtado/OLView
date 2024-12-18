function  r=resflin(D,V,k,c,p5,p6)
%RESFLIN
%           RFORCES=RESFLIN(DISPLACEMENTS,VELOCITIES,K,C)
%           Linear model restoring forces:
%             RFORCES = K*DISPLACEMENTS + C*VELOCITIES            
%
%           This function is used
%           in combination with function OPSPLIT.
%              
%
%  Example:  d=[10;10]; v[1;1]; k=[2 -1;-1 1]; c=.1*k;
%            r=resflin(d,v,k,c)
%
%  11/7/97  J. Molina

r=k*D+c*V;