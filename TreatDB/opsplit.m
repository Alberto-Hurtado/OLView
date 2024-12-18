function opsplit(m,c,mj,ki,alpha,dInit,vInit,aInit,tend,delt,span,vag,vf,vd,vv, ...
                       va,vr,viag,resfunc,p3,p4,p5,p6) 
%OPSPLIT:       Nakashima operator-splitting integration.
%         OPSPLIT(M,C,MJ,KI,ALPHA,DInit,VInit,AInit,TEND,DELT,SPAN,VAG,VF,VD,VV, ...
%                        VA,VR,VIAG,RESTFORCFUNC,P3,P4,P5,P6)
%         Performs a PsD-like Nakashima operator-splitting integration (based 
%         on the alpha method) for a system whose restoring forces are given
%         by a function.
%         Alternatively, this routine may also be used to perform
%         a Explicit-Newmark integration by doing ALPHA=999.
%     Data:
%            M      Assumed mass matrix for the PsD integration.
%            C      Assumed damping matrix for the PsD integration.
%            MJ     Product of mass by influence vector for the
%                                   specified ground motion.
%            KI     Presumed stiffness matrix (implicit part of the method).
%                   This parameter is ignored when ALPHA=999 (Explicit-Newmark
%                   integration)
%            ALPHA  Alpha coefficient for the alpha method 
%                                   ( -(1/3) < ALPHA < 0 )
%                   If ALPHA=999, a standard Explicit Newmark esqueme is
%                   adopted instead of the operator-splitting method.
%            DInit  Initial relative explicit displacements
%            VInit  Initial relative explicit velocities
%            AInit  Initial relative accelerations
%            TEND   Final time of integration
%            DELT   Integration time increment 
%            SPAN   Intensity factor multiplying ground motion
%                      and the other applied external forces
%     Input andres vectors:
%            VAG    Vector containing ground motion acceleration
%            VF     List of vectors containing other external forces
%                    (Vectors VAG and VF must all have the same time 
%                      increment and number of points)
%                   If the duration of this vector is smaller than  TEND,
%                     zeros are appended.
%     Output andres vectors:
%            VD     List of vectors for relative explicit displacements    
%            VV     List of vectors for relative explicit velocities    
%            VA     List of vectors for relative accelerations    
%            VR     List of vectors for restoring forces 
%            VIAG   Vector for obtained interpolated weighted ground acc.
%                     (absolute acc can be obtained by adding this term)
%     Specimen restoring force function:
%            RESTFORCFUNC    Name of the function of the form:
%                  RFORCES=EVAL([RESTFORCFUNC '(DISPL,VELOC,P3,P4,P5,P6)'])
%                            For a case of a linear specimen
%                            (R = P3 DISPL + P4 VELOC), make
%                  RESTFORCFUNC='resflin'
%                  P3= specimen stiffness matrix
%                  P4= specimen damping matrix
%
%    The integration is based on the equation of motion:
%        
%       M A + C V + R = F - MJ Ag                    
%
%                Ask also help on        resflin opsplpre opsplalg
%
%                EXAMPLES:
%
%       opsplit(100,0,100,110,-0.3,0,0,0,10.5,.01,1.0,1,2, ...
%                      11,21,31,41,50,'resflin',100,100)
%       opsplit(100,0,100,110,999,0,0,0,10.5,.01,1.0,1,2, ...
%                      11,21,31,41,50,'resflin',100,100)
%       m=[1 0; 0 1]; k=[2 -1;-1 1]; c=.1*k; j=[1; 1];
%       d0=[0; 0]; v0=[0; 0]; a0=[0; 0];
%       opsplit(m,0*m,m*j,1.1*k,-0.3,d0,v0,a0,10.5,.01,1.0,1,2:3, ...
%                      11:12,21:22,31:32,41:42,50,'resflin',k,c)
%
%  11/09/97  J. Molina

iarg=1;
if nargin<iarg; m=[]; end; iarg=iarg+1;
if nargin<iarg; c=[]; end; iarg=iarg+1;
if nargin<iarg; mj=[]; end; iarg=iarg+1;
if nargin<iarg; ki=[]; end; iarg=iarg+1;
if nargin<iarg; alpha=[]; end; iarg=iarg+1;
if nargin<iarg; dInit=[]; end; iarg=iarg+1;
if nargin<iarg; vInit=[]; end; iarg=iarg+1;
if nargin<iarg; aInit=[]; end; iarg=iarg+1;
if nargin<iarg; tend=[]; end; iarg=iarg+1;
if nargin<iarg; delt=[]; end; iarg=iarg+1;
if nargin<iarg; span=[]; end; iarg=iarg+1;
if nargin<iarg; vag=[]; end; iarg=iarg+1;
if nargin<iarg; vf=[]; end; iarg=iarg+1;
if nargin<iarg; vd=[]; end; iarg=iarg+1;
if nargin<iarg; vv=[]; end; iarg=iarg+1;
if nargin<iarg; va=[]; end; iarg=iarg+1;
if nargin<iarg; vr=[]; end; iarg=iarg+1;
if nargin<iarg; viag=[]; end; iarg=iarg+1;
if nargin<iarg; resfunc=[]; end; iarg=iarg+1;
if nargin<iarg; p3=[]; end; iarg=iarg+1;
if nargin<iarg; p4=[]; end; iarg=iarg+1;
if nargin<iarg; p5=[]; end; iarg=iarg+1;
if nargin<iarg; p6=[]; end; iarg=iarg+1;

ndof=size(m,1);
deltag=getdelt(vag);
agval=span*getval(vag)';
ntag=getnpoi(vag);
fval=span*getval(vf)';
nt=floor(tend/delt);
ag=zeros(1,nt);
ag(1)=agval(1);
dConMeas=zeros(ndof,nt);
rConMeas=zeros(ndof,nt);
dAlg=zeros(ndof,nt);
vAlg=zeros(ndof,nt);
a=zeros(ndof,nt);
r=zeros(ndof,nt);
dAlgN=dInit;
vAlgN=vInit;
aN=aInit;
agN=agval(1);
fextN=fval(1);
%
%     Measure:    dConMeasNminus1 = current specimen measured displacement 
%
dConMeasNminus1=zeros(ndof,1);
for N=1:nt;
  %
  %     Convert to specimen coordinates:  dCon = dConfun( dAlg ) 
  %
  dConN=dAlgN;
  vConN=vAlgN;
  %
  %     Impose ramp from dConMeasNminus1 to dConN
  %     Measure  specimen displacement and restoring force
  %
  dConMeasN=dConN;        %null control error is assumed
  rConMeasN=eval([resfunc '(dConN,vConN,p3,p4,p5,p6)']); %simulated specimen
  %
  %     Convert to algorithm coordinates:  r = ralgo( rCon ) 
  %
  rN=rConMeasN;
  %
  %     Reading of accelerogram and other external loads
  %
  t_1=(N-1)*delt;
  if rem(N-1,ceil(nt/10))==0; disp(['t=' num2str(t_1)]); end;
  itleft=floor(t_1/deltag);
  itag=itleft+1;
  if (itag+1)<=ntag;
    agN=agval(itag)+(t_1-itleft*deltag)/ ...
                     deltag*(agval(itag+1)-agval(itag));
    fextN=fval(:,itag)+(t_1-itleft*deltag)/ ...
                     deltag*(fval(:,itag+1)-fval(:,itag));
  else;
    agN=0;
    fextN=zeros(ndof,1);
  end;
  fN=fextN-mj*agN;
  %
  %     Computation of acceleration, displacement and velocity
  %
  if N==1;
    [dAlgNplus1,vAlgNplus1,beta,gamma,mminv]= ...
           opsplpre(aN,dAlgN,vAlgN,alpha,ndof,delt,m,c,ki);
  else;
    [aN,dAlgNplus1,vAlgNplus1]=opsplalg(aNminus1,dAlgN,vAlgN,vAlgNminus1, ...
         fN,fNminus1,rN,rNminus1,alpha,beta,gamma,ndof,delt,mminv,c,ki);
  end;
  %
  %     Recording of current state
  %
  dConMeas(:,N)=dConMeasN; rConMeas(:,N)=rConMeasN;
  dAlg(:,N)=dAlgN; vAlg(:,N)=vAlgN; a(:,N)=aN; r(:,N)=rN;
  ag(N)=agN; 
  %
  %     Variable updating
  %
  dAlgNminus1=dAlgN; dAlgN=dAlgNplus1;
  vAlgNminus1=vAlgN; vAlgN=vAlgNplus1;
  aNminus1=aN; rNminus1=rN; fNminus1=fN;
  dConMeasNminus1=dConMeasN;
end;
setval(vd,dAlg');
setval(vv,vAlg');
setval(va,a');
setval(vr,r');
setval(viag,ag');
setdelt([vd(:)' vv(:)' va(:)' vr(:)' viag],delt);
settname([vd(:)' vv(:)' va(:)' vr(:)' viag],'Time');
settunit([vd(:)' vv(:)' va(:)' vr(:)' viag],'[Sec]');
setname(vd,'displacement'); setunit(vd,'(m)');
setname(vv,'velocity'); setunit(vv,'(m/s)');
setname(va,'acceleration'); setunit(va,'(m/s/s)');
setname(vr,'rest. force'); setunit(vr,'(N)');
setname(viag,'weigh. acc.'); setunit(viag,'(m/s/s)');
for idof=1:ndof;
  setcom([vd(idof) vv(idof) va(idof) vr(idof)],['dof ' num2str(idof)]);
end;
setcom(viag,'ground');

