function [k,z]=eqkz(d,f,plotflag)
%EQKZ:    Equivalent stiffness and damping.
%           [k,z]=eqkz(d,f,plotflag)
%           For a given history of one cycle of displacement d and force
%           f of a sdof system, a linear equivalent stiffness k and
%           viscous damping ratio z are found. The cycle must start and end 
%           with a displacement close to zero.
%           plotflag=1     to have a plot of the cycle
%
%        Ask also help on:   eqkzhilb
%      
%           2011: This function is equal to eqkz but cuts the excessive length of
%             the signals in order to cover only one cycle. 
%
%  Example:
%
%      K=1000, Z=0.05, Fr=10
%      t=0.05+[0:0.05:2.5]/Fr;   %2.5 cycles
%      d=sin(2*pi*Fr*t)+t/20;
%      f=K*(sin(2*pi*Fr*t)+2*Z*cos(2*pi*Fr*t));
%      [k,z]=eqkz(d,f,1)
%
%  17/8/98  J. Molina

if nargin<3; plotflag=[]; end;
if isempty(plotflag); plotflag=0; end;

d=d(:); f=f(:);

if plotflag;
  figure(1);
  plot(d,f);
  legend('original measures');
end;

%Keeps only one cycle  2011
[dmax,imax]=max(d);
[dmin,imin]=min(d);
D=(dmax-dmin)/2;
D0=(dmax+dmin)/2;
sd=sign(d-D0);
i1=0;i2=0;i=2;
while i2==0
    if i1==0
        if (sd(i)-sd(i-1))==2
           i1=i
        end
    else
         if (sd(i)-sd(i-1))==2
           i2=i
        end
    end
    i=i+1;
end
if i2==0;
  error('The given displacements do not represent a cycle (1)');
end;
[difmin,imin]=min(abs(d(i2-2+[1:3])-d(i1)));
i2=i2-2+imin
d=d(i1:i2);
f=f(i1:i2);
if plotflag;
  figure(2);
  plot(d,f);
  legend('measures 1 cycle');
end;
    
    
        

N=length(d);
[dmax,imax]=max(d);
[dmin,imin]=min(d);
D=(dmax-dmin)/2;
D0=(dmax+dmin)/2;
if abs(d(1)-d(N))>D/5;
  error('The given displacements do not represent a cycle');
end;

fav=conv(f,[0.5; 0.5]);
Eabs=sum(fav(2:N).*diff(d));
FDAMP=Eabs/pi/D;      %Vertical radius of equivalent ellipse
fd=FDAMP*sqrt(1-((d-D0)/D).^2);  %Ordinate of equivalent ellipse
if imax<imin;
  fd=[fd(1:imax); -fd(imax+1:imin); fd(imin+1:N)];
else;
  fd=[-fd(1:imin); fd(imin+1:imax); -fd(imax+1:N)];
end;
fel=f-fd;
k=(sum(d.*fel)-sum(d)*sum(fel)/N)/(sum(d.*d)-sum(d)^2/N);
Eel=k*D^2/2;
z=Eabs/4/pi/Eel;

if plotflag;
  figure(3);
  F0=(max(f)+min(f))/2;
  plot(d,f,d,F0+k.*(d-D0)+fd,d,F0+k.*(d-D0));
  legend('measures 1 cycle',sprintf('k=%.4g z=%.3g',k,z));
end;

