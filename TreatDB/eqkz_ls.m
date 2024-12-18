function [k,z,D,Eabs]=eqkz_ls(d,f,plotflag)
%EQKZ_LS:   Equivalent stiffness and damping. Least square stiffness.
%           [k,z]=eqkz_le(d,f,plotflag)
%           For a given history of one cycle of displacement d
%           and restoring force f of a sdof system,
%           a linear equivalent stiffness k and
%           viscous damping ratio z are found.
%
%           k     least-square estimated stiffness
%           z     damping ratio estimation
%           D     half of pick-to-pick displacement
%           Eabs  absorbed energy
%
%           plotflag=1     to have a plot of the cycle
%
%
%  Example1: (linear)
%
%      K=1000, Z=0.1, Fr=10; C=2*Z*K/(2*pi*Fr);
%      t=[0:0.05:1]/Fr;
%      d=sin(2*pi*Fr*t); v=2*pi*Fr*cos(2*pi*Fr*t);
%      f=K*d+C*v;
%      [keq,zeq]=eqkz_ls(d,f,1)
%
%  Example2: (non linear centered)
%
%      K=1000, Z=0.1, Fr=10; C=2*Z*K/(2*pi*Fr);
%      t=[0:0.05:1]/Fr;
%      d=sin(2*pi*Fr*t); v=2*pi*Fr*cos(2*pi*Fr*t);
%      ff=K*(d+0.4*d.^2+0.1)+C*v;
%      [kkeq,zzeq]=eqkz_ls(d,ff,1)
%
%  Example3:  (not centered)
%
%      K=1000, Z=0.1, Fr=10;  C=2*Z*K/(2*pi*Fr);
%      t=[0:0.05:1]/Fr;
%      d=sin(2*pi*Fr*t) + 0.3; v=2*pi*Fr*cos(2*pi*Fr*t);
%      ff=K*(d+0.4*d.^2+0.1)+C*v;
%      [kkeq,zzeq]=eqkz_ls(d,ff,1)
%
%  Example4:  (with force discontinuity)
%
%        K=1000, Z=0.1, Fr=10
%        t=[0:0.05:1]/Fr;
%        d=sin(2*pi*Fr*t) + 0.3;
%        ff=K*(d+2*Z*cos(2*pi*Fr*(t+2*t.^2))+0.4*d.^2+0.1);
%        [kkeq,zzeq]=eqkz_ls(d,ff,1)
%
%    F.J. Molina 2017

if nargin<3; plotflag=[]; end;
if isempty(plotflag); plotflag=0; end;

d=d(:); f=f(:);

if plotflag;
    figure(3);  plot(d,f); grid;
    legend('measures','location','best');
end;

N=length(d);
[dmax,imax]=max(d);
[dmin,imin]=min(d);
D=(dmax-dmin)/2;
D0=(dmax+dmin)/2;
if abs(d(1)-d(N))>D/5
    warning('The given displacements may not represent a cycle');
end;
if abs(d(1)-d(N))>D/N
    d=[d; d(1)]; f=[f; f(1)]; N=N+1;   %Closes the loop
end

fav=conv(f,[0.5; 0.5]); 
Eabs=sum(fav(2:N).*diff(d)); %absorbed energy

% Linear Regression from (d,f)
k=(N*sum(d.*f)-sum(d)*sum(f))/(N*sum(d.*d)-sum(d)^2); %Eq. stiff.
F0=(sum(d.*d)*sum(f)-sum(d)*sum(d.*f))/(N*sum(d.*d)-sum(d)^2);
Eel=k*D^2/2;  %Elastic energy
z=Eabs/4/pi/Eel;  %Equivalent damping ratio

% p=polyfit(d,f,1)  %Using MATLAB function (same result)
% k=p(1)
% F0=p(2)+k*D0
% Eel=k*D^2/2;
% z=Eabs/4/pi/Eel

if plotflag;
    figure(4);
    plot(d,f,'b',d,F0+k*d,':m');
    legend('measures','F0+k*d','location','best');
    title(sprintf('k=%.4g z=%.3g',k,z));  grid;
end;

end

