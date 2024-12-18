function [aN,dExplNplus1,vExplNplus1]=opsplalg(aNminus1,dExplN,vExplN,vExplNminus1, ...
         fN,fNminus1,rN,rNminus1,alpha,beta,gamma,ndof,delt,mminv,c,ki)
%OPSPLALG:     Performs one step of Nakashima operator-splitting integration.
%        [a1,dExplNplus1,vExplNplus1]=opsplalg(aNminus1,dExplN,vExplN,vExplNminus1, ...
%         fN,fNminus1,rN,rNminus1,alpha,beta,gamma,ndof,delt,mminv,c,ki)
%         Performs one step of Nakashima operator-splitting integration (based 
%         on the alpha method).
%         Alternatively, this routine may also be used to perform
%         a Explicit-Newmark integration by doing ALPHA=999.
%     Data:
%            aNminus1,aN            Acceleration at instants N-1,N.
%            dExplN,dExplNplus1     Explicit displacement at instants N,N+1.
%            vExplNminus1,vExplN,dExplNplus1    Explicit velocity at instants N-1,N,N+1.
%            fNminus1,fN            External applied forces at instants N-1,N.
%            rNminus1,rN            Internal restoring forces at instants N-1,N.
%            alpha  Alpha coefficient for the alpha method 
%                                   ( -(1/3) < ALPHA < 0 )
%                   If ALPHA=999, a standard Explicit Newmark esqueme is
%                   switched instead of the operator-splitting method.
%            beta   Beta coefficient for the alpha method*. 
%            gamma  Gamma coefficient for the alpha method*. 
%            ndof   Number of degrees of freedom.
%            delt   Integration time increment.
%            mminv  Inverse of generalized mass*.
%            c      Assumed viscous damping matrix for the integration.
%            ki     Assumed stiffness matrix (implicit part of the method).
%                   This parameter is ignored when ALPHA=999 (Explicit-Newmark
%                   integration).
%      (*beta, gamma and mminv are calculated by function opsplpre)
%
%    The integration is based on the equation of motion:
%        
%                             M A + C V + R = F               
%
%                Ask also help on        opsplpre opsplit
%
%  10/9/96  J. Molina


if alpha~=999;             % OPERATOR SPLITTING
  aN=mminv*((1+alpha)*(fN-rN-c*vExplN)-alpha*(fNminus1-rNminus1-c*vExplNminus1)+...
            alpha*(gamma*delt*c+beta*delt^2*ki)*aNminus1);
  dN=dExplN+delt^2*beta*aN;
  vN=vExplN+delt*gamma*aN;
  dExplNplus1=dN+delt*vN+delt^2*(0.5-beta)*aN;
  vExplNplus1=vN+delt*(1-gamma)*aN;
else                       % EXPLICIT NEWMARK
  aN=mminv*(fN-rN-c*vExplN);
  dN=dExplN;
  vN=vExplN+(delt/2)*aN;
  dExplNplus1=dN+delt*vN+(delt^2/2)*aN;
  vExplNplus1=vN+(delt/2)*aN;
end;

