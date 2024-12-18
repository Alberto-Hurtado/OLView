function w=wwin(n,wintyp,par)
%w=wwin(n,wintyp,par)
%          Generates a column n-long weigthing window W.
%
%          wwin(n,'r')          Rectangular window (default)
%                   w=ones(n,1)                            
%                                                 
%          wwin(n,'p',[m1 m2])         Partial rectangular window 
%                   w=[zeros(m1-1,1); ones(m2-m1+1,1); zeros(n-m2,1)]                            
%                                                 __
%          wwin(n,'h')          Hanning window  _/  \_
%                   w=(1-cos(2*pi*(1:n)'/(n+1)))/2
%
%          wwin(n,'e',ntau)     Exponential window 
%                   w=exp(-(0:(n-1))'/ntau)
%
% SEE ALSO:   sdf4 psdfst frfst smoothout
%
% EXAMPLES:
%
%                     w=wwin(20,'h')
%                     w=wwin(10,'e',1)
%                     w=wwin(10,'p',[2 7])
%
%JM01

if nargin<2; wintyp=[]; end;
if isempty(wintyp); wintyp='r'; end;
wintyp=lower(wintyp);

switch wintyp
case 'r';
  w=ones(n,1);
case 'p';
  m1=par(1);m2=par(2);
  w=[zeros(m1-1,1); ones(m2-m1+1,1); zeros(n-m2,1)];
case 'h';
  w=(1-cos(2*pi*(1:n)'/(n+1)))/2;
case 'e';
  ntau=par;
  w=exp(-(0:(n-1))'/ntau);
otherwise
  error('Unknown type of weigthing window');
end;
