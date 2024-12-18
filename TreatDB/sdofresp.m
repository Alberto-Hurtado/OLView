function [d,v]=sdofresp(ag,dt,freq,zeta,inidesp,inivel,naddzerag)
%SDOFRESP:  Single-degree-of-freedom system response to an accelerogram.
%        [d,v]=sdofresp(ag,dt,freq,zeta,inidesp,inivel,naddzerag)
%        Computes the displacement response d (in m) for
%        the ground acceleration ag (in m/s/s) for a linear system with a
%        natural frequency freq (in Hz) and a damping ratio zeta (0<zeta<1).
%        In the case of freq having more than one column, the response of
%        several systems may be computed simultaneosly.
%        naddzerag = number of additional null accelerogram points.
%        Ask also help on       psav opsplit
%
%             EXAMPLES:
%               ag=[ones(100,1); zeros(100,1)]; dt=0.01;
%               d=sdofresp(ag,dt,5,0.05);
%               plot(d);
%
%               ag=[ones(100,1); zeros(100,1)]; dt=0.01;
%               freq=2:0.1:6;
%               [d,v]=sdofresp(ag,dt,freq,0.05,0,0);
%               mesh(dt*[0:length(ag)-1]',freq,d');
%               rotate3d
%
% 28/1/98  J. Molina

ni=1;
if nargin<ni ag=[]; end; ni=ni+1;
if nargin<ni dt=[]; end; ni=ni+1;
if nargin<ni freq=[]; end; ni=ni+1;
if nargin<ni zeta=[]; end; ni=ni+1;
if nargin<ni inidesp=[]; end; ni=ni+1;
if nargin<ni inivel=[]; end; ni=ni+1;
if nargin<ni naddzerag=[]; end; ni=ni+1;
if isempty(dt); dt=1; end;
if isempty(inidesp);inidesp=0; end;
if isempty(inivel);inivel=0; end;
if isempty(naddzerag);naddzerag=0; end;


ag=[ag;zeros(naddzerag,1)];
nf=length(freq);
nt=length(ag);
w=2*pi*freq(:)';
w2=w.*w;
wd=w*sqrt(1-zeta^2);
EC=exp(-zeta*w*dt).*cos(wd*dt);
ES=exp(-zeta*w*dt).*sin(wd*dt);
ECS1=-zeta*w.*EC-wd.*ES;
ECS2=wd.*EC-zeta*w.*ES;
dt22=dt^2/2;
dt36=dt^3/6;
d=zeros(nt,nf);
v=zeros(nt,nf);
d(1,:)=inidesp;
v(1,:)=inivel;

for it=2:nt;
  A=-ag(it-1,ones(nf,1));
  B=(ag(it-1)-ag(it))/dt;
  B=B(ones(1,nf));
  D1=B./w2;
  D2=(A-2*zeta*B./w)./w2;
  C1=d(it-1,:)-D2;
  C2=(v(it-1,:)+zeta*w.*C1-D1)./wd;  
  d(it,:)=C1.*EC+C2.*ES+D1.*dt+D2;
  v(it,:)=C1.*ECS1+C2.*ECS2+D1;
end;
