function [dExplNplus1,vExplNplus1,beta,gamma,mminv]= ...
           opsplpre(aN,dExplN,vExplN,alpha,ndof,delt,m,c,ki)
%OPSPLPRE:  Fisrt step ofNakashima operator-splitting integration.
%       [dExplNplus1,vExplNplus1,beta,gamma,mminv]= ...
%           opsplpre(aN,dExplN,vExplN,alpha,ndof,delt,m,c,ki)
%         Performs first step of Nakashima operator-splitting integration (based 
%         on the alpha method).
%     Data:
%            aN            Acceleration at instants N-1,N.
%            dExplN,dExplNplus1     Explicit displacement at instants N,N+1.
%            vExplN,dExplNplus1    Explicit velocity at instants N-1,N,N+1.
%            alpha  Alpha coefficient for the alpha method 
%                                   ( -(1/3) < ALPHA < 0 )
%                   If ALPHA=999, a standard Explicit Newmark esqueme is
%                   switched instead of the operator-splitting method.
%            beta   Beta coefficient for the alpha method. 
%            gamma  Gamma coefficient for the alpha method. 
%            mminv  Inverse of generalized mass.
%            ndof   Number of degrees of freedom.
%            delt   Integration time increment.
%            m      Mass matrix for the integration.
%            c      Assumed viscous damping matrix for the integration.
%            ki     Assumed stiffness matrix (implicit part of the method).
%                   This parameter is ignored when ALPHA=999 (Explicit-Newmark
%                   integration).
%
%                Ask also help on        opsplalg opsplit
%
%  10/9/96  J. Molina

if alpha~=999;             % OPERATOR SPLITTING
  beta=(1-alpha)^2/4;
  gamma=(1-2*alpha)/2;
  mminv=inv(m+gamma*delt*(1+alpha)*c+beta*delt^2*(1+alpha)*ki);
  dN=dExplN+delt^2*beta*aN;
  vN=vExplN+delt*gamma*aN;
  dExplNplus1=dN+delt*vN+delt^2*(0.5-beta)*aN;
  vExplNplus1=vN+delt*(1-gamma)*aN;
else                       % EXPLICIT NEWMARK
  beta=0;
  gamma=1/2;
  mminv=inv(m+delt/2*c);
  dN=dExplN;
  vN=vExplN+(delt/2)*aN;
  dExplNplus1=dN+delt*vN+(delt^2/2)*aN;
  vExplNplus1=vN+(delt/2)*aN;
end;
