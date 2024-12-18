function [k,z]=eqkzhibl(d,f,plotflag)
%EQKZHILB:  Equiv. stiffness and damping based on Hilbert transform.
%           [k,z]=eqkzhilb(d,f,plotflag)
%           For a given history of displacement d and force
%           f of a sdof system, a linear equivalent stiffness k and
%           viscous damping ratio z are found. 
%           plotflag=1     to have a plot of the results
%
%        Ask also help on:         eqkz
%
%  Example:
%      K=1000, Z=0.05
%      t=0:0.05:1;
%      d=sin(2*pi*t);
%      f=K*(sin(2*pi*t)+2*Z*cos(2*pi*t));
%      [k,z]=eqkzhilb(d,f,1)
%
%  29/1/99  J. Molina

if nargin<3; plotflag=[]; end;
if isempty(plotflag); plotflag=0; end;

d=d(:); f=f(:); n=size(d,1);

if plotflag;
  figure;
  plot(d,f);
  legend('measures');
end;

dimag=imag(fhilbt(d));


%  [d dimag 1] * [k; h; Off] = f
khOff=[d dimag ones(n,1)]\f;
%pp=[ceil(n/4):floor(3*n/4)]';
%khOff=[d(pp) dimag(pp) ones(size(pp))]\f(pp);
k=khOff(1); h=khOff(2); Off=khOff(3);
z=h/2/k;

if plotflag;
  F0=(max(f)+min(f))/2;
  plot(d,f,d,Off+k*d+h*dimag);
  legend('measures',sprintf('k=%.4g z=%.3g',k,z));
end;

