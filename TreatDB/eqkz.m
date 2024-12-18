function [k,z,DAmpl]=eqkz(d,f,plotflag)
%EQKZ:    Equivalent stiffness and damping.
%           [k,z,DAmpl]=eqkz(d,f,plotflag)
%           For a given history of one cycle of displacement d and force
%           f of a sdof system, a linear equivalent stiffness k and
%           viscous damping ratio z are found. The cycle must start and end 
%           with a displacement close to zero.
%           plotflag=1     to have a plot of the cycle
%           DAmpl is the displacement amplitude of the cycle   %2012
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
%      [k,z,DAmpl]=eqkz(d,f,1)
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

%Keeps only one cycle  2012
dmax=d(1);dmin=d(1);
top_is_passed=0; bottom_is_passed=0;
for i=2:length(d);
    if d(2)>d(1)
        if ~top_is_passed
            if d(i)<d(i-1)
                top_is_passed=1;
            else
                if d(i)>dmax
                    dmax=d(i);
                end
            end
        else
            if ~bottom_is_passed
                if d(i)>d(i-1)
                    bottom_is_passed=1;
                else
                    if d(i)<dmin
                        dmin=d(i);
                    end
                end
            end
        end
    else
        if ~bottom_is_passed
            if d(i)>d(i-1)
                bottom_is_passed=1;
            else
                if d(i)<dmin
                    dmin=d(i);
                end
            end
        else
            if ~top_is_passed
                if d(i)<d(i-1)
                    top_is_passed=1;
                else
                    if d(i)>dmax
                        dmax=d(i);
                    end
                end
            end
        end
    end
end
dmax=dmax
dmin=dmin

 
    
% [dmax,imax]=max(d);
% [dmin,imin]=min(d);
DAmpl=(dmax-dmin)/2;
D0=(dmax+dmin)/2;
% D0=(d(1)+d(2))/2;
%           2011: This function is equal to eqkz but cuts the excessive length of
%             the signals in order to cover only one cycle. 
sd=sign(d-D0);
i1=0;i2=0;i=2;
while i2==0
    if i1==0
        if abs(sd(i)-sd(i-1))==2
           i1=i
           sense=sd(i)-sd(i-1)
        end
    else
         if (sd(i)-sd(i-1))==sense
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
DAmpl=(dmax-dmin)/2;
D0=(dmax+dmin)/2;
if abs(d(1)-d(N))>DAmpl/5;
  error('The given displacements do not represent a cycle');
end;

fav=conv(f,[0.5; 0.5]);
Eabs=sum(fav(2:N).*diff(d));
FDAMP=Eabs/pi/DAmpl;      %Vertical radius of equivalent ellipse
fd=FDAMP*sqrt(1-((d-D0)/DAmpl).^2);  %Ordinate of equivalent ellipse
if imax<imin;
  fd=[fd(1:imax); -fd(imax+1:imin); fd(imin+1:N)];
else;
  fd=[-fd(1:imin); fd(imin+1:imax); -fd(imax+1:N)];
end;
fel=f-fd;
k=(sum(d.*fel)-sum(d)*sum(fel)/N)/(sum(d.*d)-sum(d)^2/N);
Eel=k*DAmpl^2/2;
z=Eabs/4/pi/Eel;

if plotflag;
  figure(3);
  F0=(max(f)+min(f))/2;
  plot(d,f,d,F0+k.*(d-D0)+fd,d,F0+k.*(d-D0));
  legend('measures 1 cycle',sprintf('k=%.4g z=%.3g',k,z));
end;

