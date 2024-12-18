function  [r,dd]=resfovl(d,v,k,c,flim,p6)
%RESFOVL
%           [RFORCES,MODIFDISPL]=RESFOVL(DISPL,VELOC,K,C,FORCELIM)
%           Linear model restoring forces
%             RFORCES = K*DISPL + C*VELOC  
%           with consideration of overload limits FORCELIM  
%           for the forces which result in modified displacements
%           MODIFDISP.
%
%           FORCELIM=[F1MIN  F1MAX        (F1MIN<RFORCES1<F1MAX) 
%                     F2MIN  F2MAX        (F2MIN<RFORCES2<F2MAX) 
%                      ...    ... ]
%
%           This function is used
%           in combination with function OPSPLIT.
%
%        Ask also help on            resflin opsplit
%              
%
%  Example:  d=[10;10]; v=[1;1]; k=[2 -1;-1 1]; c=.1*k; flim=[-10 10;-20 20];
%            r=resfovl(d,v,k,c,flim)
%            [r,dd]=resfovl(d,v,k,c,flim)
%
%  11/7/97  J. Molina

r=k*d+c*v;
dd=d;
irovlmin=find(r<flim(:,1)-(flim(:,2)-flim(:,1))/100000);
irovlmax=find(r>flim(:,2)+(flim(:,2)-flim(:,1))/100000);
irovl=[irovlmin; irovlmax];
while ~isempty(irovl);
  rovl=[flim(irovlmin,1); flim(irovlmax,2)];
  dd(irovl)=dd(irovl)+k(irovl,irovl)\(rovl-r(irovl));
  r=k*dd+c*v;
  irovlmin=find(r<flim(:,1)-(flim(:,2)-flim(:,1))/100000);
  irovlmax=find(r>flim(:,2)+(flim(:,2)-flim(:,1))/100000);
  irovl=[irovlmin; irovlmax];
end;


