function d=sdofrnl(ag,dt,freq,zeta)
%SDOFRNL:  Non-linear single-degree-of-freedom response to an accelerogram.
%        d=sdofresp(ag,dt,freq,zeta)
%        Computes the displacement response d (in m) for
%        the ground acceleration ag (in m/s/s) for a system with a
%        natural frequency freq (in Hz) and a damping ratio zeta (0<zeta<1).
%        The frequency and the damping are not constant. Their time histories
%        freq and zeta are given in the same way as ag.
%        Ask also help on       sdofresp psav opsplit
%
%             EXAMPLES:
%               ag=[ones(100,1)]; dt=0.01;
%               f=[2*ones(50,1); 6*ones(50,1)];
%               z=[0.03*ones(50,1); 0.08*ones(50,1)];
%               d=sdofrnl(ag,dt,f,z);
%               plot(d);
%
% 24/8/98  J. Molina

nt=length(ag);
w=2*pi*freq;
w2=w.*w;
wd=w.*sqrt(1-zeta.^2);
EC=exp(-zeta.*w*dt).*cos(wd*dt);
ES=exp(-zeta.*w*dt).*sin(wd*dt);
ECS1=-zeta.*w.*EC-wd.*ES;
ECS2=wd.*EC-zeta.*w.*ES;
dt22=dt^2/2;
dt36=dt^3/6;
d=zeros(nt,1);
v=zeros(nt,1);
for it=2:nt;
  A=-ag(it-1);
  B=(ag(it-1)-ag(it))/dt;
  D1=B/w2(it-1);
  D2=(A-2*zeta(it-1)*B/w(it-1))/w2(it-1);
  C1=d(it-1)-D2;
  C2=(v(it-1)+zeta(it-1)*w(it-1)*C1-D1)/wd(it-1);  
  d(it)=C1*EC(it-1)+C2*ES(it-1)+D1*dt+D2;
  v(it)=C1*ECS1(it-1)+C2*ECS2(it-1)+D1;
end;
