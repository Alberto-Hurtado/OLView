function matr=gm(sig,points)
%matr=gm(sig,points)
% It gives in a matrix the data from a structure
% matr=cell2mat(gst(sig,'Data',points));
% JM '02

if nargin<2;points=[];end


matr=cell2mat(gst(sig,'Data',points));