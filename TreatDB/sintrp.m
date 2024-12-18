function curve=sintrp(points,values)
%SINTRP
%        CURVE=SINTRP(POINTS,VALUES) generates a continuous
%            CURVE which interpolates the VALUES
%            at the POINTS with a piecewise sinosoidal
%            function.
%
%        EXAMPLES:
%               sintrp([1 10 20 35],[0 1 1 -2])
%               sv(1:2,sintrp([1 10 20 35],[0 1 1 -2]))
%
% 15/7/95 J. Molina

curve(1:points(1),1)=values(ones(points(1),1));
for ip1=1:(size(points,2)-1);
  p1=points(ip1); p2=points(ip1+1);
  va1=values(ip1); va2=values(ip1+1);
  p12=p2-p1;
  curve((p1+1):p2,1)=(va1+(va2-va1)*(1-cos((1:p12)/p12*pi))/2)';
end;
