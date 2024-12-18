function [ffourtst,freqst]=fftst(yst,timest,wintype,winparam,swin)
%[ffourtst,freqst]=fftst(yst,timest,wintype,winparam,swin)
%               Computes the Fast Fourier Transform function (FFT)
%               from the time domain signal structure(s) YST,
%               whose associated time signal is TIMEST.
%               The result structure(s) FFOURTST have FREQST 
%               as associated frequecy signal.
%               WINTYPE and WINPARAM refer to
%               the type of weigthing window to apply
%               by this subroutine before to compute the FFT.
%               See function wwin for understanding the
%               meaning of WINTYPE and WINPARAM.
%               SWIN is column window with which the
%               spectra are convolved 
%               in order to smooth them (see funtion smooth);
%
% SEE ALSO:   wwin sdf4 frfst smooth
%
% EXAMPLES:
%    yst1=[]; yst1.Data=rand(32,1)-0.5;
%    timest=[]; timest.Data=0.1*[0:31]'; timest.Magnitude='Time'; timest.Unit='s';
%    [ffourtst,freqst]=fftst(yst1,timest);
%    gr=[];  gr.pl{1}.xsig=freqst;  gr.pl{1}.ysig=ffourtst;  gra(gr);
%
%    yst2=[]; yst2.Data=rand(32,1);
%    [ffourtst,freqst]=fftst({yst1 yst2},timest,'h');
%    swin=wwin(20,'h');
%    [ffourtst,freqst]=fftst({yst1 yst2},timest,'h',[],swin);
%
% JM04 RA04

iarg=1;
if nargin<iarg; y1=[]; end; iarg=iarg+1;
if nargin<iarg; timest=[]; end; iarg=iarg+1;
if nargin<iarg; wintype=[]; end; iarg=iarg+1;
if nargin<iarg; winparam=[]; end; iarg=iarg+1;
if nargin<iarg; swin=[]; end; iarg=iarg+1;
if isempty(swin); swin=1; end;

if isstruct(yst); yst={yst}; end;
if isstruct(timest); timest={timest}; end;
% if iscell(timest); timest=timest{:}; end;
freqst=timest;
if strcmp(gst(timest,'Magnitude'),'Time')
    freqst=sst(freqst,'Magnitude','Frequency');
else
    error('Time magnitude must be ''Time''');
end

if strcmp(gst(timest,'Unit'),'s')
    freqst=sst(freqst,'Unit','Hz')
else
    error('Time units must be ''s''');
end

difft=diff(gm(timest));
tincr=mean(difft);
if tincr>0;
  if (max(difft)-min(difft))/tincr<1e-2 %Ojo se ha cambiado la tolerancia para la segnal de tiempo
    n=length(gm(timest));
    freqst=sst(freqst,'Data',[0:(n-1)]'*(1/tincr/n));
    
  else
    error('Time increment must be constant');
  end
else
  error('Time increment must be positive');
end

y1=gm(yst);
[n,m]=size(y1);
w1=wwin(n,wintype,winparam);
y1=y1.*w1(:,ones(1,m));
fft1=fft(y1);
fft1=smooth(fft1,swin);
ffourtst=yst(1);
ffourtst=sst(ffourtst,'Positions',{{'' '' '' '' ''}});
ffourtst=sst(ffourtst,'Data',fft1);
% ffourtst=sst(ffourtst,'Magnitude','-');
ffourtst=sst(ffourtst,'Unit',' ');

