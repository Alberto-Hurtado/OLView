function dd=ndofrfo(k,m,c,deltat,fext,ag,j,inidesp,inivel,dampsel,foff)
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
%		ag		Ground acceleration in columns (optional)
%		j     Required if ag>0   (NdofxNacc)
%       inidesp Initial displacement
%       inivel  Initial velocity
%       dampsel=='pos' to reduce cut positive exponential response
%       foff    Offset forces
% 28/10/02 J. Molina & Placeres G.


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
if nargin<iarg foff=[]; end; iarg=iarg+1;

inidesp=inidesp(:);
inivel=inivel(:);
foff=foff(:);

% number of degrees of freedom
dof=size(k,2);
if isempty(foff);
    foff=zeros(dof,1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matrix AA and BB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

zer=zeros(dof);
if isempty(c)   c=zer; end

AA=[c m;m zer];
BB=[k zer;zer -m];
D=AA\BB;
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
     ftot(:,1:dof)=-ag*j'*m';
 else 
       ftot(:,1:dof)=fext-ag*j'*m';
   end
else
    ftot(:,1:dof)=fext;
end
y0=[inidesp;inivel];

z0=modes\y0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% uncoupling equations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zz=zeros(2*dof,lf);
ft=modes\(AA\(ftot'-[foff(:,ones(lf,1));zeros(dof,lf)]));

for ii=1:2*dof
   zz(ii,:)=sdofrfo(ft(ii,:),deltat,poles(ii),z0(ii));
end

ddd=modes*zz;

if nargout>0
   dd=ddd.';
end


