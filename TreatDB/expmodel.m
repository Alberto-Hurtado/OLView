function ff=expmodel(uu,finit,k0,kinf,f0)
%EXPMODEL
%           F=EXPMODEL(U,FINIT,K0,KINF,F0)
%           For a given displacement history U and an initial value of the
%           force FINIT, gives the resulting history of forces F following
%           a exponential hysteretic model characterized by the parameters:
%              K0:      Tangent initial stiffness
%              KINF:    Tangent asymptotic stiffness
%              F0:      Force ordinate of the asymptotic straight line
%
%  Example:  f=expmodel([0 10 20 30 20 10 0]',0,8,2,17)
%
%  30/10/95  J. Molina

[nt,ncol]=size(uu);
ff=zeros(nt,ncol);
alpha=f0/(k0-kinf);
for icol=1:ncol;
   u=uu(:,icol);
   f=zeros(nt,1);
   du=diff(u);
   f(1)=finit;
   for it=1:(nt-1);
      if du(it)>0;
         %    y1=(f(it)-kinf*u(it))/f0;
         %    x=-alpha*log(1-y1);
         z1=(f0-f(it)+kinf*u(it))/f0;
         if z1>0;
            x=-alpha*log(z1);
            f(it+1)=kinf*u(it+1)+f0*(1-exp(-(x+du(it))/alpha));
         else;
            f(it+1)=kinf*u(it+1)+f0;
         end;
      elseif du(it)<0;
         %    y1=(kinf*u(it)-f(it))/f0;
         %    x=-alpha*log(1-y1);
         z1=(f0+f(it)-kinf*u(it))/f0;
         if z1>0;
            x=-alpha*log(z1);
            f(it+1)=kinf*u(it+1)-f0*(1-exp(-(x-du(it))/alpha));
         else;
            f(it+1)=kinf*u(it+1)-f0;
         end;
      else;
         f(it+1)=f(it);
      end;
   end;
   ff(:,icol)=f;
end;


