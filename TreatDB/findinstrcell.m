function index=findinstrcell(strcell,strlist)
index=[];
for j=1:length(strlist)
    str=deblank(strlist{j});
    for i=1:length(strcell)
        if ~isnan(strcell{i})
            if strcmp(deblank(strcell{i}),str)
                index=[index i];
            end
        end
    end
end
if length(index)~=length(strlist)
    argumentstr=sprintf(' ''%s '' ',strlist{:})
    index=index
    error('Not all the strings in the list were found!')
end

