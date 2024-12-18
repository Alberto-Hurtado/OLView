function y=fhilbt(v,wintype,winparam)
%FHILBT:  Fast Hilbert-transform analytical signal. 
%        Y=FHILBT(V,WINTYPE,WINPARAM) computes the
%               Hilbert transform (say h(t))
%               of time domain real V data (say v(t))
%               and gives the analytical complex signal (y(t)=v(t)+ i*h(t)).
%               The modulus of the result gives an envelope of the
%               original function v(t).
%               WINTYPE and WINPARAM refer to
%               the type of weigthing window to apply 
%               by this subroutine before to compute the required fft.
%               See function wwin for understanding the
%               meaning of WINTYPE and WINPARAM.
%               Ask also help on   ifftv wwin psdfv xsdfv frfv
%                                  fft ifft
%
%   EXAMPLES:
%      dt=0.01; t=dt*[0:1023]';
%      v=sdofresp(rand(1024,1)-0.5,dt,5,0.05);
%      y=fhilbt(v);
%      plot(t,v,t,abs(y));
%
% 24/8/98  J. Molina

iarg=1;
if nargin<iarg; v=[]; end; iarg=iarg+1;
if nargin<iarg; wintype=[]; end; iarg=iarg+1;
if nargin<iarg; winparam=[]; end; iarg=iarg+1;

transp=0;
if size(v,1)==1;
  v=v';
  transp=1;
end;
[n,mcol]=size(v);
y=zeros(n,mcol);
for icol=1:mcol;
  x=v(:,icol).*wwin(n,wintype,winparam);
  if mod(n,2)==0;
    ffth=fft(x).*[0;i*ones(n/2-1,1);0;-i*ones(n/2-1,1)];
  else;
    ffth=fft(x).*[0;i*ones((n-1)/2,1);-i*ones((n-1)/2,1)];
  end;
  y(:,icol)=x+i*ifft(ffth);
end;
if transp;
  y=y';
end;



