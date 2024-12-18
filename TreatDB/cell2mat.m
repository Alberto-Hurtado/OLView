function amat=cell2mat(acell)
%amat=cell2mat(acell)
%      Transforms a cell of rows or of columns into a rectangular matrix of numbers. 
%
% SEE ALSO:     gst char
%
% EXAMPLES:
%
% a1=rand(3,1); a2=rand(3,1);
% [a1 a2]
% a={a1 a2}
% b=cell2mat(a)
%
% a1=rand(1,3); a2=rand(1,3);
% [a1; a2]
% a={a1; a2}
% b=cell2mat(a)
%
%JM01

if iscell(acell);
  nn=size(acell);
  mm=size(acell{1});
  
  amat=zeros([nn mm]);
  for i=1:nn(1)
    for j=1:nn(2)
      amat(i,j,:)=acell{i,j}(:);
    end
  end
  if nn(1)==1 & mm(2)==1
    amat=permute(amat,[3 2 1 4]);
  end
  amat=squeeze(amat);
else
  amat=acell;
end;


