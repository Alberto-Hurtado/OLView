function [Y]=getsteps_old(X,s,ss) 

 
%   [Y]=getsteps(X,s,ss)
%   
%       Compares the elements of array X, if the difference of two nearby 
%   elements is less then 's', takes one of them, stores elected elements
%   in a new array A, sorts array A in ascending order, checks array A for
%   similar values (the difference of two nearby elements is less then 'ss') 
%   and, if there are some, takes one of them. 
%       Outputs array Y (which includes the ordinates of steps, 
%                        in column form and in ascending order).
%
%   15/09/09    Hayk Poghosyan

if nargin < 3, ss=1; end
if nargin < 2, s=.1; end

m=1; r=1; p=1; 
n=length(X);
if n>2
    for k=1:(n-1)
        if abs(X(k+1)-X(k))<s  % 's' is the domain of noise
            if k<(n-1)
                if abs(X(k+2)-X(k+1))>s
                    A(m)=X(k); 
                    m=m+1; 
                end
            else  A(m)=X(k);
            end
        end
    end
    if m==1
        %  m==1 means we have only noise 
        %            or we have no noise.
        if abs(X(k+1)-X(k))<s
            A(m)=X(k); 
            % M=mean(A); display (M);
            % display 'M is the mean value of the noise'
            error('there is only noise');
        else
            error('there is no noise'); 
        end
    end
else error('there are less then 3 values')
end
if m>1
       A=sort(A); % Sorts array elements in ascending order
       % display (A)
    for p=1:(length(A)-1) % or p=1:(m-1)
        if abs(A(p+1)-A(p))>ss
            Y(r)=A(p);
            r=r+1;
        end
    end
    Y(r)=A(p+1);
    Y=Y';     
end