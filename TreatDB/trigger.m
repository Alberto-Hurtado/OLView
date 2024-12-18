function trigpoints=trigger(y,ycri,nprev)
%trigpoints=trigger(y,ycri,nprev)
%       Gets the points in column y with absolute value greater than ycri
%       and preceded by at least NPREV points with a lower value.
%       By default,  ycri=max(abs(y))/5; nprev=5
%
%        EXAMPLES:   
%          y=[zeros(100,1); ones(100,1)];
%          trigger(y)
%          trigger([y;y])
%  
%  30/8/2001 J. Molina  

iarg=3;
if nargin<iarg; nprev=[]; end; iarg=iarg+1;
if nargin<iarg; ycri=[]; end; iarg=iarg+1;
if isempty(nprev); nprev=5; end;
if isempty(ycri); ycri=max(abs(y))/5; end;

ybin=(abs(y)>ycri);
np2=size(ybin,1);
pattern=[zeros(nprev,1);1];
npoicheck=size(pattern,1);
trigpoints=[];
j1=0;
while j1<(np2-npoicheck);
  diffe=pattern-ybin(j1+[1:npoicheck]);
  if sum(abs(diffe)==0)==npoicheck;
    trigpoints=[trigpoints;j1+npoicheck];
  end;
  j1=j1+1;
end;
