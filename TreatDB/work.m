function w=work(f,d)
%w=work(f,d)
%         Computes the work w of the force f through the
%         displacement d by using the difference formula:
%
%              w(i)=w(i-1)+(f(i)+f(i-1))/2*(d(i)-d(i-1))
%
% SEE ALSO:   dericen
%
% EXAMPLES:
%
%  d=[0:10:100]';f=d.^2;
%  [d f work(f,d)]
%  [d f 2*f work([f 2*f],[d d])]
%  [d f 2*f cell2mat(work({f 2*f},{d d}))]
%
%  d=[0 0 0 0 1 2 3]'; f=10*ones(7,1);
%  [d f work(f,d)]
%
%JM01

if iscell(f);
  ncol=length(f);
else
  ncol=size(f,2);
end;

if iscell(f);
  w=cell(1,ncol);
  for i=1:ncol
    ff=filter([0.5 0.5],1,f{i});
    dd=filter([1 -1],1,d{i});
    np=length(ff);
    ww=ff(2:np).*dd(2:np);
    w{i}=[0; filter(1,[1 -1],ww)];
  end
else
  w=zeros(size(f));
  for i=1:ncol
    ff=filter([0.5 0.5],1,f(:,i));
    dd=filter([1 -1],1,d(:,i));
    np=length(ff);
    ww=ff(2:np).*dd(2:np);
    w(:,i)=[0; filter(1,[1 -1],ww)];
  end
end
