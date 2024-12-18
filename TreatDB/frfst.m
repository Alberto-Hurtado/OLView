function [frfstt,cohst,freqst]=frfst(y1st,y2st,timest,wintype1,winparam1,swin,wintype2,winparam2)
%[frfstt,cohst,freqst]=frfst(y1st,y2st,timest,wintype1,winparam1,swin,wintype2,winparam2)
%
%   Computes a frequency response function from the time domain signal structure Y1ST (input)
%   to the time domain signal structure Y2ST (output), whose associated time signal is TIMEST ( in s).
%   The result structure frfstt have FREQST (in Hz) as associated frequecy signal and COHST
%   as associated coherence.
%
%   If Y1ST and Y2ST contain NSIG signals, the frf is based on the averaged spectra.
%   WINTYPE and WINPARAM refer to the type of weigthing window to apply
%   by this subroutine before to compute the fft.
%   See function wwin for understanding the meaning of WINTYPE and WINPARAM.
%
%   Aditionally, SWIN is a smoothing window column with which the spectra are convolved
%   before computing the frf in order to smooth them (see funtion smooth);
%
% SEE ALSO:   psdfst wwin sdf4 frfv smooth
%
% EXAMPLES:
% s=struct('Project','ASR Infilled Frame','Structure','Retrofitted', ...
%     'Experiment','L24','PostProcessing','60');
% s.Signal={'000' '001' '010'};
% s=getsig(s);
% y1st=s(2); y2st=s(3); timest=s(1);
%
% swin=wwin(20,'h');
% [frf,coh,freqst]=frfst(y1st,y2st,timest,[],[],swin,[],[])
%
% EXAMPLE1:
% clear all;
% s=struct('Project','Arco ELSA','Structure','Calibration Pendulum', ...
%     'Experiment','a03','PostProcessing','70');
% s=getsig(s);
% y1st=s(2:10); y2st=s(20:28); timest=s(1);
% % swin=wwin(20,'h');
% swin=[];
% ntau=400;
% %Partial rectangular and exponetial for signals
% [frf,coh,freqst]=frfst(y1st,y2st,timest,'p',[1 ntau],swin,'e',ntau);
% %Two exponential windos for both signals
% [frf,coh,freqst]=frfst(y1st,y2st,timest,'e',ntau,swin,'e',ntau);
% % The same result, the same exponential for the two input signals
% [frf,coh,freqst]=frfst(y1st,y2st,timest,'e',ntau,swin);
%
% EXAMPLE2:
% timest=struct('Data',[0:99]','Magnitude','Time','Unit','s');
% y1st=struct('Data',sin(gm(timest)*2*pi*(1/100))+0.00001*rand(100,1),'Magnitude','Displacement','Unit','m');
% y2st=struct('Data',2*sin(gm(timest)*2*pi*(1/100)-pi/180),'Magnitude','Displacement','Unit','m');
% [frfstt,cohst,freqst]=frfst(y1st,y2st,timest,[],[],wwin(1,'h'))
% g=[];
% g.pl{1}.ysig=frfstt; g.pl{1}.ypart='(Amp)'; g.pl{1}.xsig=freqst;
% g.pl{2}.ysig=frfstt; g.pl{2}.ypart='(Pha)'; g.pl{2}.xsig=freqst;
% g.pl{3}.ysig=cohst; g.pl{3}.xsig=freqst;
% gra(g); 


iarg=1;
if nargin<iarg; y1=[]; end; iarg=iarg+1;
if nargin<iarg; y2=[]; end; iarg=iarg+1;
if nargin<iarg; timest=[]; end; iarg=iarg+1;
if nargin<iarg; wintype1=[]; end; iarg=iarg+1;
if nargin<iarg; winparam1=[]; end; iarg=iarg+1;
if nargin<iarg; swin=[]; end; iarg=iarg+1;
if nargin<iarg; wintype2=[]; end; iarg=iarg+1;
if nargin<iarg; winparam2=[]; end; iarg=iarg+1;
if isempty(wintype2); wintype2=wintype1; end;
if isempty(winparam2); winparam2=winparam1; end;
if isempty(swin); swin=1; end;


if isstruct(y1st); y1st={y1st}; end;
if isstruct(y2st); y2st={y2st}; end;
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
  if (max(difft)-min(difft))/tincr>1e-2 %Ojo se ha cambiado la tolerancia para la segnal de tiempo
%         error(sprintf('Time increment must be constant %g', ...
%         (max(difft)-min(difft))/tincr));
        warning(sprintf('Time increment must be constant %g', ...
        (max(difft)-min(difft))/tincr));
  end
else
  error('Time increment must be positive');
end
    n=length(gm(timest));
    freqst=sst(freqst,'Data',[0:(n-1)]'*(1/tincr/n));
    
    y1=gm(y1st);
    y2=gm(y2st);
    [z11, z22, z12, z21]=sdf4(y1,y2,wintype1,winparam1,swin,wintype2,winparam2);
  if size(z11,2)>1;
    z11=sum(z11')';
    z22=sum(z22')';
    z12=sum(z12')';
    z21=sum(z21')';
  end;
    frf1=z21./z11;
    frf2=z22./z12;    
    frfstt=y2st(1);
%     frfstt=sst(frfstt,'Positions',{{'' '' '' '' ''}});
    frfstt=sst(frfstt,'Data',frf1);
    cohst=y2st(1);
%    cohst=sst(cohst,'Positions',{{'' '' '' '' ''}});
    cohst=sst(cohst,'Data',real(frf1./frf2));   
%     cohst=sst(cohst,'Data',real((z21.*z12)/(z11.*z22)));   %Jan 2012
%     frfstt.PostProcessing=' ';
%     cohst.PostProcessing=' ';
%     frfstt.Name=' ';
%     cohst.Name=' ';
%     frfstt.Post_Descr=' ';
%     cohst.Post_Descr=' '; 
%     frfstt.Positions=' ';
%     cohst.Positions=' ';

%       frfstt=sst(frfstt,'Description',gst(y2st{1},'Description') '/' gst(y1st{1},'Description'));
%       cohst=sst(frfstt,'Description',gst(frfstt,'Description'));
%       frfstt=sst(frfstt,'Magnitude',gst(y2st{1},'Magnitude') '/' gst(y1st{1},'Magnitude'));
      
if(strcmp(gst(y2st(1),'Magnitude'),'Acceleration') & strcmp(gst(y1st(1),'Magnitude'),'Force'));
      frfstt=sst(frfstt,'Magnitude','Acc/Force');
  else
      frfstt=sst(frfstt,'Magnitude',' ');
  end;
      cohst=sst(cohst,'Magnitude','Coherence');    
    %frfstt.Unit=' ';
      if strcmp(gst(y1st(1),'Unit'),gst(y2st(1),'Unit'));
          frfstt=sst(frfstt,'Unit','-');
      end
      if(strcmp(gst(y2st(1),'Unit'),'m/s/s') & strcmp(gst(y1st(1),'Unit'),'N'));
          frfstt=sst(frfstt,'Unit','1/Kg');
      end
    cohst=sst(cohst,'Unit',' ');   %Antes era un simbolo de %, pero la coherencia es adimensional
