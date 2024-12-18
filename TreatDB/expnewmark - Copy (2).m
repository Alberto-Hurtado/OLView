function [d,v,a,timev]=expnewmark(ff,k,c,m,delt,dinit,vinit,ainit,ares)

NDoF=size(ff,2);
np1=size(ff,1);
timev=[0:np1-1]'*delt;

% if ares>1    %excitation is linearly interpolated dividing time increment by ares
%   ytimev=ytimest.Data(p1:p2);ytimev=ytimev(:);
  delt=delt/ares;
  timev(np1+1)=2*timev(np1)-timev(np1-1);
  wl=(ares-[0:ares-1])/ares;
  timev=timev(1:np1,ones(1,ares)).*wl(ones(np1,1),:)+...
        timev([2:(np1+1)],ones(1,ares)).*(1-wl(ones(np1,1),:));
  timev=reshape(timev',ares*np1,1);
    for isig=1:NDoF;
      yv=ff(:,isig);
      yv(np1+1)=2*yv(np1)-yv(np1-1);
      yv=yv(1:np1,ones(1,ares)).*wl(ones(np1,1),:)+...
        yv([2:(np1+1)],ones(1,ares)).*(1-wl(ones(np1,1),:));
      f(:,isig)=reshape(yv',ares*np1,1);
    end
% end;




NT=size(f,1)
d=zeros(NT,NDoF);v=d;a=d;

T=1;
d(T,:)=dinit;
a(T,:)=ainit;
v(T,:)=vinit+delt*0.5*a(T,:);

% a(T,:)=(inv(m)*(f(T,:)'-k*d(T,:)'-c*v(T,:)'))';
d(T+1,:)=d(T,:)+delt*(v(T,:)+delt*0.5*a(T,:));
m1inv=inv(m+0.5*delt*c);
for T=2:NT
    vExplT=v(T-1,:)+0.5*delt*a(T-1,:);
    a(T,:)=(m1inv*(f(T,:)'-k*d(T,:)'-c*vExplT'))';
    v(T,:)=v(T-1,:)+0.5*delt*(a(T-1,:)+a(T,:));
    if T<NT
        d(T+1,:)=d(T,:)+delt*(v(T,:)+delt*0.5*a(T,:));
    end
end


return
