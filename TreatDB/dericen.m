function adot=dericen(a,t)
%adot=dericen(a,t)
%       Computes the derivative with
%       respect to time t of a by using the central difference 
%       formula:
%            adot(i)=(a(i+1)-a(i-1))/(t(i+1)-t(i-1))
%
% SEE ALSO:   work
%
% EXAMPLES:
%
%  t=[0:10:100]';a=t.^2;
%  [t a dericen(a,t)]
%  [t a 2*a dericen([a 2*a],t)]
%  [t a 2*a cell2mat(dericen({a 2*a},t))]
%
%JM01

t=cell2mat(t);
if size(t,2)>1; t=t.'; end;
if size(t,2)>1; error('t must be a column matrix!'); end;
tt=filter([1 0 -1],1,t);
if iscell(a);
  ncol=length(a);
else
  ncol=size(a,2);
end;

if iscell(a);
  adot=cell(1,ncol);
  for i=1:ncol
    aa=filter([1 0 -1],1,a{i});
    np=length(aa);
    ad=aa(3:np)./tt(3:np);
    adot{i}=[ad(1); ad(1:(np-2)); ad(np-2)];
  end
else
  adot=zeros(size(a));
  for i=1:ncol
    aa=filter([1 0 -1],1,a(:,i));
    np=length(aa);
    ad=aa(3:np)./tt(3:np);
    adot(:,i)=[ad(1); ad(1:(np-2)); ad(np-2)];
  end
end
