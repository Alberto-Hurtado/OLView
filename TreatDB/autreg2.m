function [a,a0]=autreg2(x,n)
%AUTREG2
% 	[A,A0] = AUTREG2(X,N) finds the coefficients of an
%       Nth order auto-regressive
% 	process that models the time series X as follows:
% 	   X(n) = -A(2)*X(n-1) - A(3)*X(n-2) - ...
%                - A(N+1)*X(n-N-1) - A0
% 	Here, X is the input time series (a 
%       column vector), and N is the order of 
% 	denominator polynomial A(z), i.e. A = [ 1 A(2) ... A(N+1) ].
%       If X contains more than one column, each
%       column is considered as an independent observation
%       of the same process (only one A set is identified)
%
%  EXAMPLE:
%     [a,a0]=autreg([1 .99 .98 .99 1 .99 .97]',2)
%
% 4/8/95  J. Molina



[np,nob]=size(x);
neq1=np-n;
B=zeros(neq1*nob,n+nob);
b=zeros(neq1*nob,1);
for iob=1:nob;
  for i=1:n;
    B(((iob-1)*neq1+1):(iob*neq1),i)=x(i:(i+neq1-1),iob);
  end;
  B(((iob-1)*neq1+1):(iob*neq1),n+iob)=ones(neq1,1);
  b(((iob-1)*neq1+1):(iob*neq1))=-x((n+1):np,iob);
end;
beta=B\b;
a=[1 beta(n:-1:1)'];
a0=beta(n+1:n+nob);


