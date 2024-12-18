function mat2=smooth(mat1,w,smoothtype)
%SMOOTH
%    MATRIX2=SMOOTH(MATRIX1,WINDOW,smoothtype)
%      Smoothens each column of MATRIX1 using a
%      weithing WINDOW and assuming the 
%      periodicity
%            MATRIX(SIZE(MATRIX,1)+N,:)==MATRIX(N,:)
%      Before performing the convolution a 
%      normalization is done within this subroutine
%      so that the sum of all the components of
%      the window equals one.
%
%      smoothtype=0  assumes periodicity  (default)
%      smoothtype=1  assumes constant value at the ends
%   
%      Ask also help on  smoothv wwin sdf 
%                        filter conv
%
%  EXAMPLES:
%    smooth((1:10)',1)     (no effect)
%    b=smooth(rand(100,1),[1 1 1])
%
% 7/8/95 J. Molina
if nargin<3; smoothtype=[]; end;
if isempty(smoothtype); smoothtype=0; end;

nw=length(w);
w=w/sum(w);
nw1=fix(nw/2);
nw2=nw-nw1;
n=size(mat1,1);
mat2=zeros(size(mat1));
for ic=1:size(mat1,2);
  if smoothtype~=1;
    y1=[mat1((n-nw1+1):n,ic); mat1(:,ic); mat1(1:nw2,ic)];
  else;
    y1=[mat1(1,ic)*ones(nw1,1); mat1(:,ic); mat1(n,ic)*ones(nw2,1)];
  end;
  y1=conv(y1,w);
  mat2(:,ic)=y1((2*nw1+1):(2*nw1+n));
end;
