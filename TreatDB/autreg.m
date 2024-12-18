function a=autreg(x,n)
%AUTREG
% 	A = AUTREG(X,N) finds the coefficients of an Nth order auto-regressive
% 	process that models the time series X as follows:
% 	   X(n) = -A(2)*X(n-1) - A(3)*X(n-2) - ... - A(N+1)*X(n-N-1)
% 	Here, X is the input time series (a vector), and N is the order of 
% 	denominator polynomial A(z), i.e. A = [ 1 A(2) ... A(N+1) ].
%
%  EXAMPLE:
%     a=autreg([1 .99 .98 .99 1 .99]',2)
%
% 4/8/95  J. Molina

np=length(x);
neq=np-n;
B=zeros(neq,n);
for i=1:n;
  B(:,i)=x(i:(i+neq-1));
end;
b=-x((n+1):np);
beta=B\b;
a=[1 beta(n:-1:1)'];



