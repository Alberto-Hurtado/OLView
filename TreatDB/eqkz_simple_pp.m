function [k,z,Eabs]=eqkz_simple_pp(d,f,plotflag)
%EQKZ:    Equivalent stiffness and damping.
%           [k,z]=eqkz_simple_pp(d,f,plotflag)
%           For a given history of one cycle of displacement d and force
%           f of a sdof system, a linear equivalent stiffness k and
%           viscous damping ratio z are found. The cycle must start and end 
%           with a displacement close to zero preferably.
%           plotflag=1     to have a plot of the cycle
%
%        Ask also help on:         eqkzhilb
%
%  Example1: (linear)
%
%      K=1000, Z=0.1, Fr=10; %C=2*Z*K/(2*pi*Fr)
%      t=[0:0.05:1]/Fr;
%      d=sin(2*pi*Fr*t); %v=2*pi*Fr*cos(2*pi*Fr*t)
%      f=K*(sin(2*pi*Fr*t)+2*Z*cos(2*pi*Fr*t));
%      [keq,zeq]=eqkz_simple_pp(d,f,1)
%
%  Example2: (non linear centered)
%
%      K=1000, Z=0.1, Fr=10
%      t=[0:0.05:1]/Fr;
%      d=sin(2*pi*Fr*t);
%      ff=K*(d+2*Z*cos(2*pi*Fr*t)+0.4*d.^2+0.1);
%      [kkeq,zzeq]=eqkz_simple_pp(d,ff,1)
%
%  Example3:  (not centered)
%
%      K=1000, Z=0.1, Fr=10
%      t=[0:0.05:1]/Fr;
%      d=sin(2*pi*Fr*t) + 0.3;
%      ff=K*(d+2*Z*cos(2*pi*Fr*t)+0.4*d.^2+0.1);
%      [kkeq,zzeq]=eqkz_simple_pp(d,ff,1)
%
%  Example3:  (with force discontinuity)
%
%        K=1000, Z=0.1, Fr=10
%        t=[0:0.05:1]/Fr;
%        d=sin(2*pi*Fr*t) + 0.3;
%        ff=K*(d+2*Z*cos(2*pi*Fr*(t+2*t.^2))+0.4*d.^2+0.1);
%        [kkeq,zzeq]=eqkz_simple_pp(d,ff,1)
%
%    F.J. Molina

if nargin<3; plotflag=[]; end;
if isempty(plotflag); plotflag=0; end;

d=d(:); f=f(:);

if plotflag;
  figure;  plot(d,f); grid;
  legend('measures','location','best');
end;

N=length(d);
[dmax,imax]=max(d);
[dmin,imin]=min(d);
D=(dmax-dmin)/2;
D0=(dmax+dmin)/2;
if abs(d(1)-d(N))>D/5;
  warning('The given displacements may not represent a cycle');
end;
d=[d; d(1)]; f=[f; f(1)]; N=N+1;   %2012 Closes the loop

fav=conv(f,[0.5; 0.5]); %filter noise
Eabs=sum(fav(2:N).*diff(d)); %absorbed energy
FDAMP=Eabs/pi/D; %Equivalent elipse radius
% fd=FDAMP*sqrt(1-((d-D0)/D).^2); %elipse damping force
fd=FDAMP*sqrt(max((1-((d-D0)/D).^2),0));   %2012
if imax<imin;
  fd=[fd(1:imax); -fd(imax+1:imin); fd(imin+1:N)];
else;
  fd=[-fd(1:imin); fd(imin+1:imax); -fd(imax+1:N)];
end;
fel=f-fd;  %Elastic force 

% Linear Regression from (d,fel)
k=(N*sum(d.*fel)-sum(d)*sum(fel))/(N*sum(d.*d)-sum(d)^2); %Eq. stiff.
F0=(sum(d.*d)*sum(fel)-sum(d)*sum(d.*fel))/(N*sum(d.*d)-sum(d)^2);
Eel=k*D^2/2;  %Elastic energy
z=Eabs/4/pi/Eel;  %Equivalent damping ratio
 
% p=polyfit(d,fel,1)  %Using MATLAB function (same result)
% k1=p(1)
% F01=p(2)+k1*D0
% Eel1=k1*D^2/2;
% z1=Eabs/4/pi/Eel1

if plotflag;
  figure;
  plot(d,f,'b',d,fel,':g',d,F0+k*d+fd,'r',d,F0+k*d,':m');
  legend('measures','fel','F0+k*d+fd','F0+k*d','location','best');
  title(sprintf('k=%.4g z=%.3g',k,z));  grid;

%   figure;
%   plot(d,f,'r',d,F01+k1*(d-D0)+fd,'g',d,F01+k1*(d-D0),'b');
%   legend('measures','F0+k1*(d-D0)+fd','F0+k1*(d-D0)','location','best');
%   title(sprintf('k1=%.4g z1=%.3g',k1,z1));
%   figure;
%   plot(d,F01+k1*(d-D0),'b',d,fel,'m');
%   legend('F0+k1*(d-D0)','fel','location','best');
%   title(sprintf('k1=%.4g z1=%.3g',k1,z1));
end;

