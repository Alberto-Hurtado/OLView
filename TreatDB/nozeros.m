function v=nozeros(v)
%removes components equal to zero in vector v.
%2019-10

v=v(:);
for i=length(v):-1:1
    if v(i)==0
        v(i)=[];
    end
end

    