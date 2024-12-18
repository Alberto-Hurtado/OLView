a = [];
a.Project='SteelQuake';
a.Structure='Frame';
a.Experiment='q40';
a.PostProcessing='90';
sig=getsig(a);
gr=[];
gr.pl{1}.ysig=sig([2 4]);
gr.pl{1}.xsig=sig(1);
gr.pl{1}.ypart=' ';
gr.pl{1}.ypart='(Re)';
gr.pl{1}.ypart={'(Re)' '(Im)'};
%gr.pl{1}.ypart='(Im)';
%gr.pl{1}.ypart='(Amp)';
%gr.pl{1}.ypart='(Pha)';
gra(gr);
 