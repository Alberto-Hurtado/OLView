function [PSAst,freqst,periodst,SDst,PSVst]=psast(AGst,timest, ...
    zetalist,fmax,delf,noTail,noZeroFreq)
% function [PSAst,freqst,periodst,SDst,PSVst]=psast(AGst,timest, ...
%     zetalist,fmax,delf,noTail,noZeroFreq)
%
%        Computes the pseudo-acceleration response spectrum for
%        the ground acceleration (in m/s/s) contained in signal structure
%        AGst and writes the result in signal structure(s) PSAst for frequencies
%        between zero and FMAX (in Hz) with an increment DELF and
%        for the damping ratios 0<=ZETA<1 contained in ZETALIST.
%        The spectral displacement and pseudovelocity may also be
%        respectively writen in signal structure(s) SDst and PSVst. 
%        freqst and periodst are the associated frequency and period signal structure 
%        for the obtained spectra.
%        If noTail==1, the response is analysed only for the given duration
%        of the accelerogram.  %2014
%        If noZeroFreq==1, the zero-frequency point is not included in the
%        output.  %2017
%        Ask also help on       psdfst 
%
%             EXAMPLE:
% ag=[ones(100,1); zeros(100,1)]; t=[0:199]'*0.01;
% AGst={struct('Magnitude','Acceleration','Unit','m/s/s','Data',ag)};
% timest={struct('Magnitude','Time','Unit','s','Data',t)};
% [PSAst,freqst,periodst,SDst,PSVst]=psast(AGst,timest,[0.05 0.10],20.0,0.1);
% gr=[]; gr.pl{1}.ysig=PSAst; gr.pl{1}.xsig=periodst; gr.pl{2}.ysig=SDst; gr.pl{2}.xsig=freqst; gra(gr);
%
%
% JM 04

iarg=3;
if nargin<iarg; zetalist=[]; end;iarg=iarg+1;
if nargin<iarg; fmax=[]; end;iarg=iarg+1;
if nargin<iarg; delf=[]; end;iarg=iarg+1;
if nargin<iarg; noTail=[]; end;iarg=iarg+1;
if nargin<iarg; noZeroFreq=[]; end;iarg=iarg+1;
if isempty(zetalist); zetalist=0.05; end;
if isempty(fmax); fmax=20; end;
if isempty(delf); delf=0.1; end;
if isempty(noTail); noTail=0; end;
if isempty(noZeroFreq); noZeroFreq=0; end;

nz=length(zetalist);

if isstruct(AGst); AGst={AGst}; end;
if isstruct(timest); timest={timest}; end;
freqst=timest; periodst=timest;

if strcmp(gst(timest,'Magnitude'),'Time')
  freqst=sst(freqst,'Magnitude','Frequency');
  periodst=sst(periodst,'Magnitude','Period');
else
  error('Time magnitude must be ''Time''');
end

if strcmp(gst(timest,'Unit'),'s')
  freqst=sst(freqst,'Unit','Hz');
  periodst=sst(periodst,'Unit','s');
else
  error('Time units must be ''s''');
end

difft=diff(gm(timest));
delt=mean(difft);
if delt>0;
  if (max(difft)-min(difft))/delt>1e-2 
    error('Time increment must be constant');
  end
else
  error('Time increment must be positive');
end

if noTail==1    %2014
    ag=gm(AGst);
    ntag=length(gm(AGst));
    nt=ntag;
else
    ag=[gm(AGst); zeros(round(.5/delf/delt+1),1)];
    ntag=length(gm(AGst));
    nt=ntag+.5/delf/delt;
end
f=(delf:delf:fmax)';
nf=length(f);
w=2*pi*f;
w2=w.*w;
for iz=1:nz;
  zeta=zetalist(iz);
  wd=w*sqrt(1-zeta^2);
  EC=exp(-zeta*w*delt).*cos(wd*delt);
  ES=exp(-zeta*w*delt).*sin(wd*delt);
  ECS1=-zeta*w.*EC-wd.*ES;
  ECS2=wd.*EC-zeta*w.*ES;
  delt22=delt^2/2;
  delt36=delt^3/6;
  d0=0;
  v0=0;
  d1=zeros(nf,1);
  v1=zeros(nf,1);
  dmax=zeros(nf+1,1);
%   for it=1:nt;
  for it=1:nt-1;  %2014
    A=-ag(it);
    A=A(ones(nf,1));
    B=(ag(it)-ag(it+1))/delt;
    B=B(ones(nf,1));
    D1=B./w2;
    D2=(A-2*zeta*B./w)./w2;
    C1=d1-D2;
    C2=(v1+zeta*w.*C1-D1)./wd;  
    d1=C1.*EC+C2.*ES+D1.*delt+D2;
    v1=C1.*ECS1+C2.*ECS2+D1;
    if nt<=ntag;
      d0=d0+v0*delt-ag(it)*delt22+(ag(it)-ag(it+1))*delt36;
      v0=v0-ag(it)*delt+(ag(it)-ag(it+1))*delt22;
    end;
    dmax=max([dmax abs([d0; d1])]')';
  end;
  sd=dmax;
  if noZeroFreq==1
      sd(1)=[];
      psa=w2.*sd;
      psv=w.*sd;
  else
      psa=[0; w2].*sd;
      psv=[0; w].*sd;
  end
  PSAst(iz)=AGst;
  PSAst(iz)=sst(PSAst(iz),'Data',psa);      
%   PSAst(iz)=sst(PSAst(iz),'Positions',{{[' zeta=' num2str(zeta)]}},5);
  PSAst(iz)=sst(PSAst(iz),'Positions',{{[' \xi=' num2str(zeta)]}},5);   %2016-03
  SDst(iz)=PSAst(iz);
  SDst(iz)=sst(SDst(iz),'Data',sd);      
  PSVst(iz)=PSAst(iz);
  PSVst(iz)=sst(PSVst(iz),'Data',psv);      
end;
PSAst=sst(PSAst,'Description','Pseudo');
PSAst=sst(PSAst,'Magnitude','Acceleration');
PSAst=sst(PSAst,'Unit','m/s/s');
SDst=sst(SDst,'Description','Spectral');
SDst=sst(SDst,'Magnitude','Displacement');
SDst=sst(SDst,'Unit','m');
PSVst=sst(PSVst,'Description','Pseudo');
PSVst=sst(PSVst,'Magnitude','Velocity');
PSVst=sst(PSVst,'Unit','m/s');
if noZeroFreq==1
    freqst=sst(freqst,'Data',f);
    periodst=sst(periodst,'Data',1./f);
else
    freqst=sst(freqst,'Data',[0; f]);
    periodst=sst(periodst,'Data',1./[0; f]);
end








