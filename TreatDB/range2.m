function matrix=range2(rows,columns)
%RANGE2
%         MATRIX=RANGE2(ROWS,COLUMNS)
%         Generates a MATRIX with as many rows as elements are in ROWS
%         and as many columns as elements are in COLUMNS.
%         The value of each coefficient is defined by
%              MATRIX(I,J)=ROWS(I)+COLUMN(J)
%
% EXAMPLES:  
%                      a=range2(120:10:140,[2 6 7])
%   30/8/95 J. Molina  
rows=rows(:);
n=length(rows);
columns=columns(:)';
m=length(columns);
matrix=kron(rows,ones(1,m))+kron(ones(n,1),columns);
