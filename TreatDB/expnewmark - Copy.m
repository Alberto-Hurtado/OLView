function [d,v,a]=expnewmark(f,k,c,m,delt,dinit,vinit,ainit)

NT=size(f,1);
NDoF=size(f,2);
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
