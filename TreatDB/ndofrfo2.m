function dd=ndofrfo(k,m,c,deltat,fext,ag,j,inidesp,inivel,dampsel)
% NDOFRFO
%
%		NDOFRFO(k,m,c,deltat,fext,ag,j,inidesp,inivel)	Computes the displacement for
%		a ndof system.
%
%		k		stiffness matrix
%		m		mass matrix
%		c  	damping matrix
%		deltat Time increment
%		fext	External force (columns)
%		ag		Ground acceleration (optional). Column vector
%		j     Required if ag>0
%     inidesp Initial displacement
%     inivel  Initial velocity
% 28/10/99 J. Molina & Placeres G.


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
if nargin<iarg dampsel=[]; end; iarg=iarg+1;


% number of degree of freedom
dof=size(k,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matrix AA and BB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

zer=zeros(dof);
if isempty(c)   c=zeros(dof); end
if isempty(k)   k=zeros(dof); end
if isempty(m)   m=zeros(dof); end

AA=[c m;m zer];
BB=[k zer;zer -m];
D=inv(AA)*BB;
[modes,poles]=eig(D);
poles=-diag(poles);

if strcmp(dampsel,'pos')
  for ii=1:length(poles)
    if real(poles(ii))>0 poles(ii)=i*abs(poles(ii))*sign(imag(poles(ii))); end
  end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% modal matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

modA=modes.'*AA*modes;
modB=modes.'*BB*modes;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% total force
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lf=max(size(fext,1),length(ag));
ftot=zeros(lf,2*dof);
if ~isempty(ag);
   if isempty(fext) 
      ftot(:,1:dof)=-ag*j*m;
   else 
      ftot(:,1:dof)=fext-ag*j*m;
   end
else
   ftot(:,1:dof)=fext;
end
inidesp=inidesp(:);
inivel=inivel(:);
y0=[inidesp;inivel];

z0=inv(modes)*y0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% uncoupling equations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zz=zeros(lf,2*dof);
invmodes=inv(modes);

for ii=1:2*dof
   % Ai=modA(ii,ii);
   ft=invmodes*inv(AA)*ftot';
   z=sdofrfo(ft(ii,:),deltat,poles(ii),z0(ii));
   
   zz(:,ii)=z(:);
end

ddd=modes*zz.';

if nargout>0
   dd=ddd.';
end


