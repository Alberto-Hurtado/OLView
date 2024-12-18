function [A,B,A0]=oemodel(x,u,Na,Nb)
%OEMODEL: MATRIX OUTPUT-ERROR MODEL IDENTIFICATION. ORDERS Na, Nb.
%    [A,B,A0]=oemodel(x,u,Na,Nb)
%       Finds the matrix coefficients A(NDOF*Na,NDOF), B(NEXC*(Nb+1),NDOF),
%       A0(1,NDOF) in the model:
%          x(n,:) = [x(n-1,:) x(n-2,:) ... x(n-Na,:)] * A + 
%              [u(n,:) u(n-1,:) u(n-2,:) ... u(n-Nb,:)] * B + A0
%       where every column of x(NTIMES,NDOF) corresponds to one
%       output or degree of freedom and every column of u(NTIMES,NEXC) corresponds
%       to one input or excitation variable. 
%            NTIMES >= NDOF*Na+NEXC*(Nb+1)+1+MAX(Na,Nb)
%       Ask also help on:       timepole freepole autreg2
%
%  EXAMPLES:
%     ndof=2; nexc=1; Na=2; Nb=2; nt=10;
%     a1=rand(ndof*Na,ndof)/4; b1=rand(nexc*(Nb+1),ndof); a01=rand(1,ndof);
%     u=rand(nt,nexc); nn=max(Na,Nb);
%     x=rand(nn,ndof);
%     for i=(nn+1):nt;
%       xx=x((i-1):-1:(i-Na),:)';
%       uu=u(i:-1:(i-Nb),:)';
%       x(i,:)=xx(:)'*a1+uu(:)'*b1+a01;
%     end;
%     [A,B,A0]=oemodel(x,u,Na,Nb)
%
%     ndof=2; nexc=0; Na=2; Nb=-1; nt=7;
%     a1=rand(ndof*Na,ndof)/4; a01=rand(1,ndof);
%     u=rand(nt,nexc); nn=max(Na,Nb);
%     x=rand(nn,ndof);
%     for i=(nn+1):nt;
%       xx=x((i-1):-1:(i-Na),:)';
%       x(i,:)=xx(:)'*a1+a01;
%     end;
%     [A,B,A0]=oemodel(x,u,Na,Nb)
%
% 12/12/98  J. Molina

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
