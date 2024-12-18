function [A,B,A0]=filter_model(x,u,Na,Nb)
%filter_model: FILTER MODEL IDENTIFICATION. ORDERS Na, Nb.
%    [A,B,A0]=filter_model(x,u,Na,Nb)
%       Finds the matrix coefficients A(NDoF*Na,NDoF), B(Nexc*(Nb+1),NDoF),
%       A0(1,NDoF) in the model:
%          x(n,:) = [x(n-1,:) x(n-2,:) ... x(n-Na,:)] * A + 
%              [u(n,:) u(n-1,:) u(n-2,:) ... u(n-Nb,:)] * B + A0
%       where every column of x(Np,NDoF) corresponds to one
%       output or degree of freedom and every column of u(Np,Nexc) corresponds
%       to one input or excitation variable. 
%            Np >= NDoF*Na+Nexc*(Nb+1)+1+MAX(Na,Nb)
%       Ask also help on:       mldivide filter_model_poles filter_model_hist
%
%       More information in Appendix B of the article
%       "Monitoring Damping in Pseudo-Dynamic Tests" by F. J. Molina, G. Magonette, P. Pegon & B. Zapico
%       http://dx.doi.org/10.1080/13632469.2010.544373
%
%  EXAMPLES:
%     NDoF=2; Nexc=1; Na=2; Nb=2; nt=10;
%     a1=rand(NDoF*Na,NDoF)/4       %assumed
%     b1=rand(Nexc*(Nb+1),NDoF)     %assumed
%     a01=rand(1,NDoF)              %assumed
%     u=rand(nt,Nexc); nn=max(Na,Nb);
%     x=rand(nn,NDoF);
%     for i=(nn+1):nt;
%       xx=x((i-1):-1:(i-Na),:)';
%       uu=u(i:-1:(i-Nb),:)';
%       x(i,:)=xx(:)'*a1+uu(:)'*b1+a01;
%     end;
%     [A,B,A0]=filter_model(x,u,Na,Nb)
%
%     NDoF=2; Nexc=0; Na=2; Nb=-1; nt=7;
%     a1=rand(NDoF*Na,NDoF)/4      %assumed
%     a01=rand(1,NDoF)             %assumed
%     u=rand(nt,Nexc); nn=max(Na,Nb);
%     x=rand(nn,NDoF);
%     for i=(nn+1):nt;
%       xx=x((i-1):-1:(i-Na),:)';
%       x(i,:)=xx(:)'*a1+a01;
%     end;
%     [A,B,A0]=filter_model(x,u,Na,Nb)
%
% 1998,2011  F.J. Molina

[nt,ndof]=size(x);
nexc=size(u,2);
NDOF=ndof*Na;
NEXC=nexc*(Nb+1);
NN=max(Na,Nb);
NT=nt-NN;
if NT < NDOF+NEXC+1;
  error(sprintf('Not enough data: NTIMES < %d = NDOF*Na+NEXC*(Nb+1)+1+MAX(Na,Nb)  !' ...
    ,NDOF+NEXC+1+NN));
end;
Xnew=x(nt+[1-NT:0],:);
Xold=zeros(NT,NDOF);
for i=1:Na;
  Xold(:,ndof*(i-1)+[1:ndof])=x(nt-i+[1-NT:0],:);
end;
U=zeros(NT,NEXC);
for i=0:Nb;
  U(:,nexc*i+[1:nexc])=u(nt-i+[1-NT:0],:);
end;

% [Xold U 1] * [A; B; A0] = Xnew
ABA0=[Xold U ones(NT,1)]\Xnew;
A=ABA0(1:NDOF,:);
B=ABA0((NDOF+1):(NDOF+NEXC),:);
A0=ABA0(NDOF+NEXC+1,:);
