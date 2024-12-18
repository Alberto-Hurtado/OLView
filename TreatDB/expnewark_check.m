


t=[0:0.001:1]';
f=700*cos(2*pi*1*t);
m=300;
k=(2*pi*2)^2*m;
c=0.1*2*sqrt(k*m);
dinit=400/k;vinit=-2*dinit;
ainit=(inv(m)*(f(1,:)'-k*dinit'-c*vinit'))';
delt=t(2)-t(1);

[d,v,a]=expnewmark(f,k,c,m,delt,dinit,vinit,ainit);






dan=sdofresp(-f/m,delt,sqrt(k/m)/2/pi,c/2/sqrt(k*m),d(1),v(1));
figure(1)
plot(t,d,t,dan)
