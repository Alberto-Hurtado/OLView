function [yst,ytimest,np]=rformst(xst,res,p1,p2,intype,xtimest)
% [yst,ytimest,np]=rformst(xst,RESOLUTION,p1,p2,INTERPOLATIONTYPE,xtimest)
%        Remakes the format of data-base structure signal by
%        reading from each one the interval specified
%        by points P1 and P2 and taking one averaged
%        point every RESOLUTION points. Time signal xtimest must be
%        common for all the input signals xst.
%        If RESOLUTION is negative, the format is enlarged
%        interpolating abs(RESOLUTION)-1 new points between
%        every two old points.
%        NP is the new number of samplings.
%        There are two possible interpolation techniques:
%
%        INTERPOLATIONTYPE='linear'     (default)
%        INTERPOLATIONTYPE='fft'        (with assumed periodicity)
%
%  SEE ALSO:       smoothout
%
%  EXAMPLES:   
%     xtimest.Data=[0:0.2:500]; xst.Data=[0:0.2:500]*10;
%     [yst,ytimest]=rformst(xst,5,1001,2000,[],xtimest);
%     zst=rformst({xst xtimest},-5,1001,2000);
%     gr.pl{1}.xsig={xtimest ytimest zst{2}}; gr.pl{1}.ysig={xst yst{1} zst{1}}; gra(gr);
%
%     yst=rformst(xst,-5,1001,2000)        (gives 5000 points, linear interp.)
%     yst=rformst(xst,-5,1001,2000,'fft')  (fft interpolation)
%
%JM02

iarg=2;
if nargin<iarg; res=[]; end; iarg=iarg+1;
if nargin<iarg; p1=[]; end; iarg=iarg+1;
if nargin<iarg; p2=[]; end; iarg=iarg+1;
if nargin<iarg; intype=[]; end; iarg=iarg+1;
if nargin<iarg; xtimest=[]; end; iarg=iarg+1;
nsig=length(xst);
if isstruct(xst); xst={xst}; end;
if isempty(p1); p1=1; end;
if isempty(p2); p2=length(cell2mat(gst(xst(1),'Data'))); end;
if isempty(res); res=1; end;
if isempty(intype); intype='linear'; end;
if isempty(xtimest); xtimest.Data=xst{1}.Data*0; end;

res=round(res);p1=round(p1);p2=round(p2);

yst=xst;
ytimest=xtimest;
if res>1;
  points=p1:res:(p2-res+1);
  poires=[0:(res-1)]';
  poiaver=points(ones(res,1),:)+poires(:,ones(1,length(points)));
  for isig=1:nsig;
    yst{isig}.Data=mean(reshape(yst{isig}.Data(poiaver),res,length(points)))';
  end
  ytimest.Data=mean(reshape(ytimest.Data(poiaver),res,length(points)))';
elseif res==1;
  for isig=1:nsig;
    yst{isig}.Data=yst{isig}.Data(p1:p2);
  end;
  ytimest.Data=ytimest.Data(p1:p2); 
elseif res<0;
  ares=abs(res);
  ytimev=ytimest.Data(p1:p2);ytimev=ytimev(:);
  np1=length(ytimev);
  ytimev(np1+1)=2*ytimev(np1)-ytimev(np1-1);
  wl=(ares-[0:ares-1])/ares;
  ytimev=ytimev(1:np1,ones(1,ares)).*wl(ones(np1,1),:)+...
        ytimev([2:(np1+1)],ones(1,ares)).*(1-wl(ones(np1,1),:));
  ytimest.Data=reshape(ytimev',ares*np1,1);
  if strcmp(intype,'linear');
    for isig=1:nsig;
      yv=yst{isig}.Data(p1:p2);yv=yv(:);
      yv(np1+1)=2*yv(np1)-yv(np1-1);
      yv=yv(1:np1,ones(1,ares)).*wl(ones(np1,1),:)+...
        yv([2:(np1+1)],ones(1,ares)).*(1-wl(ones(np1,1),:));
      yst{isig}.Data=reshape(yv',ares*np1,1);
    end
  elseif strcmp(intype,'fft');
    for isig=1:nsig;
      yv=ares*fft(yst{isig}.Data(p1:p2));yv=yv(:);
      yv=[yv(1:floor(np1/2)); yv(floor(np1/2)+1)/2; zeros((ares-1)*np1-1,1);...
          yv(floor(np1/2)+1)/2; yv(floor(np1/2)+2:np1)];
      yst{isig}.Data=real(ifft(yv));
    end
  else;
    error(['Unknown interpolation type:' intype]);
  end;
end;
% resets initial time to zero
ytimest.Data=ytimest.Data-ytimest.Data(1);
np=length(ytimest.Data);

