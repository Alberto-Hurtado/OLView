function [dd,modd,freqq]=ndofresp(k,m,c,deltat,fext,ag,j,inidesp,inivel)
% NDOFRESP
%
%		NDOFRESP(k,m,zeta,deltat,fext,ag,j)	Computes the displacement for
%		a ndof system.
%
%		k		stiffness matrix
%		m		mass matrix
%		zeta	damping ratio vector column
%		deltat Time increment
%		fext	External force (columns)
%		ag		Ground acceleration (optional)
%		j     Required if ag is not empty
%     inidesp Initial displacement
%     inivel  Initial velocity
% 5/10/99 Placeres G.


iarg=1;

if nargin<iarg k=[]; end; iarg=iarg+1; 
if nargin<iarg m=[]; end; iarg=iarg+1;
if nargin<iarg c=[]; end; iarg=iarg+1;
if nargin<iarg deltat=[]; end; iarg=iarg+1;
if nargin<iarg fext=[]; end; iarg=iarg+1;
if nargin<iarg ag=[]; end; iarg=iarg+1;
if nargin<iarg j=[]; end; iarg=iarg+1;
if nargin<iarg inidesp=[]; end; iarg=iarg+1;
if nargin<iarg inivel=[]; end; iarg=iarg+1;

% number of degree of freedom
ndof=size(k,2);
if isempty(inidesp)
    inidesp=zeros(ndof,1);
end
if isempty(inivel)
    inivel=zeros(ndof,1);
end

% the matrix must be symmetric 
k=(k+k')/2;
m=(m+m')/2;
c=(c+c')/2;
% eigenvalues and eigenvectors of k and m
%c=diag(2*zeta')*sqrt(k*m);
mod=[];
freq=[];
[mod,freq]=rmodes(k,m);

% normalized modes
for jj=1:ndof
   for ii=1:ndof
      mod(ii,jj)=mod(ii,jj)/mod(jj,jj);
   end
end

[polesHz]=cmodes(k,c,m);
% frequencies and modes
%%freq=polesHz(:,1)*2*pi;
%freq=sqrt(fcuad)/(2*pi);%column vector
zeta=polesHz(1:ndof,2);
% computes the total force

if ~isempty(ag);
   if isempty(fext) 
      ftot=-ag*j'*m;
   else 
      ftot=fext-ag*j'*m;
   end
else
   ftot=fext;
end

fz=ftot*mod;


% modal mass
mm=[];
aagg=zeros(size(ftot,1),ndof);

zzz=zeros(size(ftot,1),ndof);
for ii=1:ndof
   mm(ii)=mod(:,ii)'*m*mod(:,ii);
   aagg(:,ii)=fz(:,ii)/mm(ii);
      zzz(:,ii)=sdofresp(aagg(:,ii),deltat,freq(ii)/(2*pi),zeta(ii),inidesp(ii),inivel(ii));

end

ddd=zeros(size(ftot,1),ndof);
ddd=zzz*mod';


if nargout>0
   dd=ddd;
   modd=mod;
   freqq=freq;
end
return

time=[0:deltat:15.99];
subplot(2,2,1)
plot(time,ddd(:,1))
title('level 1')
xlabel('time (s)')
ylabel('displ (mm)')
grid on

subplot(2,2,2)
plot(time,ddd(:,2))
title('level 2')
xlabel('time (s)')
ylabel('displ (mm)')
grid on

subplot(2,2,3)
plot(time,ddd(:,3))
title('level 3')
xlabel('time (s)')
ylabel('displ (mm)')
grid on

subplot(2,2,4)
plot(time,ddd(:,4))
title('level 4')
xlabel('time (s)')
ylabel('displ (mm)')
grid on


figure
plot(time,ddd)
legend('level 1','level 2','level 3','level 4')