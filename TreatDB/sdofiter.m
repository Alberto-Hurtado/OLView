function d=sdofiter(ag,dt,dtable,ftable,ztable,tol)
%SDOFITER:  Iterative non-linear single-degree-of-freedom response.
%        d=sdofiter(ag,dt,dtable,ftable,ztable,tol)
%        Computes the displacement response d (in m) for
%        the ground acceleration ag (in m/s/s) for a system with 
%        natural frequency ftable (in Hz) and a damping ratio ztable (0<zeta<1)
%        which are functions of amplitude of the displacement dtable.
%        The response is obtained iteratively starting with the frequency
%        and damping associted to zero amplitude and finishing when the 
%        displacement error is lower than the especified tol (m).
%        Ask also help on       sdofresp sdofrnl
%
%             EXAMPLES:
%               ag=rand(100,1)-0.5; dt=0.01;
%               dtable=[0; 0.02];
%               ftable=[6; 6];
%               ztable=[0.03; 0.03];
%               d=sdofiter(ag,dt,dtable,ftable,ztable,0.001);
%               plot(d);
%
% 24/8/98  J. Molina

dampl=0*ag;
iter=0;
cont=1;
while cont;
  iter=iter+1
  freq=interp1q(dtable,ftable,dampl);
  zeta=interp1q(dtable,ztable,dampl);
  d=sdofrnl(ag,dt,freq,zeta);
  if iter>1;
    err=max(abs(d-d0))
    cont=err>tol;
  end;
  d0=d;
%  dampl=abs(fhilbt(d));
  dampl=(abs(fhilbt(d))+dampl)/2;
end;
