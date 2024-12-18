function [z11,z22,z12,z21]=sdf4(y1,y2,wintype1,winparam1,swin,wintype2,winparam2)
%function [z11,z22,z12,z21]=sdf4(y1,y2,wintype1,winparam1,swin,wintype2,winparam2)
%               Computes up to 4 kinds of spectral density function(s):
%               power spectral densities Z11 and Z22 and
%               crossed one Z12 and Z21
%               (frequency domain) from column(s)
%               Y1 and column(s) Y2 (time domain).
%               WINTYPE1, WINTYPE2 and WINPARAM1, WINPARAM2 refer to
%               the type of weigthing window to apply
%               by this subroutine before to compute the fft. A different 
%               type of window can be applied to y1 and y2.
%               See function wwin for understanding the
%               meaning of WINTYPE and WINPARAM.
%               SWIN is a column window with which the
%               spectra are convolved 
%               in order to smooth them (see funtion smooth);
%
% SEE ALSO:   wwin psdfst frfst smooth
%
% EXAMPLES:
%   
%  swin=wwin(20,'h');
% 
%  [z11,z22,z12,z21]=sdf4(rand(1024,2),rand(1024,2),'h',[],swin,'h',[]);
%
%  
%JM01





iarg=1;
if nargin<iarg; y1=[]; end; iarg=iarg+1;
if nargin<iarg; y2=[]; end; iarg=iarg+1;
if nargin<iarg; wintype1=[]; end; iarg=iarg+1;
if nargin<iarg; winparam1=[]; end; iarg=iarg+1;
if nargin<iarg; swin=[]; end; iarg=iarg+1;
if nargin<iarg; wintype2=[]; end; iarg=iarg+1;
if nargin<iarg; winparam2=[]; end; iarg=iarg+1;
if isempty(wintype2); wintype2=wintype1; end;
if isempty(winparam2); winparam2=winparam1; end;
if isempty(swin); swin=1; end;

[n,m]=size(y1);
w1=wwin(n,wintype1,winparam1);
y1=y1.*w1(:,ones(1,m));
w2=wwin(n,wintype2,winparam2);
fft1=fft(y1);
z11=fft1.*conj(fft1)/n;
z11=smooth(z11,swin);
if nargout>1;
  y2=y2.*w2(:,ones(1,m));
  fft2=fft(y2);
  z22=fft2.*conj(fft2)/n;
  z12=fft1.*conj(fft2)/n;
  z21=fft2.*conj(fft1)/n;
  z22=smooth(z22,swin);
  z12=smooth(z12,swin);
  z21=smooth(z21,swin);
end;
