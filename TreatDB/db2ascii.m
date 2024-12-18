% writes text files from database signals


cd('D:\users\LAB\Dispass\Dispassp\_db2ascii')

s = [];
s.Project='Dispass';
s.Structure='JARRET BC1BN';
Explist={'d03'};
PPlist={'70'};

for iExp=1:length(Explist)
  s.Experiment=Explist{iExp};
  for iPP=1:length(PPlist)
    s.PostProcessing=PPlist{iPP};
    sig=getsig(s);
    filehead=sprintf('%s%shead.txt',s.Experiment,s.PostProcessing);
    repsig(sig,filehead)
    A=cell2mat(gst(sig,'Data')).';
    disp(size(A));
    filedata=sprintf('%s%sdata.txt',s.Experiment,s.PostProcessing);
    eval(['save ' filedata ' A -ascii']);
  end
end


s = [];
s.Project='BabyFrame';
s.Structure='Original';
Explist={'h35'};
PPlist={'60' '62' '63'};

for iExp=1:length(Explist)
  s.Experiment=Explist{iExp};
  for iPP=1:length(PPlist)
    s.PostProcessing=PPlist{iPP};
    sig=getsig(s);
    filehead=sprintf('%s%shead.txt',s.Experiment,s.PostProcessing);
    repsig(sig,filehead)
    A=cell2mat(gst(sig,'Data')).';
    disp(size(A));
    filedata=sprintf('%s%sdata.txt',s.Experiment,s.PostProcessing);
    eval(['save ' filedata ' A -ascii']);
  end
end



s = [];
s.Project='Dispass';
s.Structure='Frame+BC1BN';
Explist={'d24' 'd28'};
PPlist={'60' '62' '63'};

for iExp=1:length(Explist)
  s.Experiment=Explist{iExp};
  for iPP=1:length(PPlist)
    s.PostProcessing=PPlist{iPP};
    sig=getsig(s);
    filehead=sprintf('%s%shead.txt',s.Experiment,s.PostProcessing);
    repsig(sig,filehead)
    A=cell2mat(gst(sig,'Data')).';
    disp(size(A));
    filedata=sprintf('%s%sdata.txt',s.Experiment,s.PostProcessing);
    eval(['save ' filedata ' A -ascii']);
  end
end

