function z=sdofrfo(ft,dt,s,inidesp)
%SDOFRESP:  Single-degree-of-freedom system response to an accelerogram.
%				First order equation.
%        z=sdofrfo(ft,dt,s,inidesp)
%        Computes the displacement response d (in m) for
%        a force ft.
%			A equation like z'-sz=ft is solved.
%        Ask also help on       psav opsplit sdofresp
%
%       
% 28/10/99  J. Molina & Placeres G.


nt=length(ft);
z=zeros(1,nt);
z(1)=inidesp;

for it=2:nt;
   t=(it-1)*dt;
   B=(ft(it)-ft(it-1))/dt;
   A=ft(it-1);
   A0=-B/s;
   B0=-(A+B/s)/s;
   k=z(it-1)+(A+B/s)/s;
   z(it)=A0*dt+B0+k*exp(s*dt);
end;
