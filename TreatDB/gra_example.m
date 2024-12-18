%=================================================
gr=[]; gr.pl={}; %         GRAPH STRUCTURE:
%=================================================
  plpl=[];  %<<<<<<<<<<<<<<<<<<<<<<BEGIN SINGLE PLOT<<<<<<<<<<<<<
  s={};  %---------------------begin abcisas----------
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','000'); s={s{:} ss};
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','000'); s={s{:} ss};
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','000'); s={s{:} ss};
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','000'); s={s{:} ss};
  plpl.xsig=getsig(s);  %------end abcisas------------
  s={};  %---------------------begin ordinates--------
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','001'); s={s{:} ss};
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','002'); s={s{:} ss};
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','003'); s={s{:} ss};
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','004'); s={s{:} ss};
  plpl.ysig=getsig(s);  %------end ordinates----------
  gr.pl={gr.pl{:} plpl};  %>>>>>>>>END SINGLE PLOT>>>>>>>>>>>>>>>
%=================================================
  plpl=[];  %<<<<<<<<<<<<<<<<<<<<<<BEGIN SINGLE PLOT<<<<<<<<<<<<<
  s={};  %---------------------begin abcisas----------
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','000'); s={s{:} ss};
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','000'); s={s{:} ss};
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','000'); s={s{:} ss};
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','000'); s={s{:} ss};
  plpl.xsig=getsig(s);  %------end abcisas------------
  s={};  %---------------------begin ordinates--------
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','005'); s={s{:} ss};
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','006'); s={s{:} ss};
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','007'); s={s{:} ss};
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','008'); s={s{:} ss};
  plpl.ysig=getsig(s);  %------end ordinates----------
  gr.pl={gr.pl{:} plpl};  %>>>>>>>>END SINGLE PLOT>>>>>>>>>>>>>>>
%=================================================
  plpl=[];  %<<<<<<<<<<<<<<<<<<<<<<BEGIN SINGLE PLOT<<<<<<<<<<<<<
  s={};  %---------------------begin abcisas----------
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','001'); s={s{:} ss};
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','002'); s={s{:} ss};
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','003'); s={s{:} ss};
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','004'); s={s{:} ss};
  plpl.xsig=getsig(s);  %------end abcisas------------
  s={};  %---------------------begin ordinates--------
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','005'); s={s{:} ss};
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','006'); s={s{:} ss};
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','007'); s={s{:} ss};
    ss=struct('Project','Dual Frame','Structure','Dual Frame CFRP','Experiment','d08','PostProcessing','62','Signal','008'); s={s{:} ss};
  plpl.ysig=getsig(s);  %------end ordinates----------
  gr.pl={gr.pl{:} plpl};  %>>>>>>>>END SINGLE PLOT>>>>>>>>>>>>>>>
%=================================================
gra(gr);  %    EXECUTE THE GRAPH:
%=================================================



