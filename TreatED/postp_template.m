function [pp,ppdescr,s0]=postp_template(ppSource,ppElaboration,ppSampling,ppVersion,ppVersionDescr, ...
    experiment,structure,project,exp_descr,struc_descr,proj_descr)
% function [pp,ppdescr,s0]=postp_template(ppSource,ppElaboration,ppSampling,ppVersion,ppVersionDescr, ...
%    experiment,structure,project)
% Returns the postprocessing name and description. Creates the template
% empty signal with the general parameters.
% New csv format 2022
% F.J. Molina 2023 02


%% maps for the description of the postprocessing types
[desSourceMap,desElaborationMap,desSamplingMap]=postp_type_maps();

pp = sprintf('%s-%s-%s',ppSource,ppElaboration,ppSampling);
ppdescr = sprintf('%s | %s | %s',desSourceMap(ppSource),desElaborationMap(ppElaboration), ...
    desSamplingMap(ppSampling))
if ~isempty(ppVersion)
    pp = sprintf('%s-%s',pp,ppVersion);
end
if ~isempty(ppVersionDescr)
    ppdescr = sprintf('%s | %s',ppdescr,ppVersionDescr);
end
pp = pp
ppdescr = ppdescr

%%%%%%%%% Template empty signal with general parameters %%%%%%%%%%
s0=cell(1,1);
s0=sst(s0,'PostProcessing',pp); s0=sst(s0,'PostP_Descr',ppdescr);
s0=sst(s0,'ppSource',ppSource); s0=sst(s0,'ppElaboration',ppElaboration);
s0=sst(s0,'ppSampling',ppSampling); s0=sst(s0,'ppVersion',ppVersion);
s0=sst(s0,'ppVersionDescr',ppVersionDescr);
s0=sst(s0,'Experiment',experiment); s0=sst(s0,'Exp_Descr',exp_descr);
s0=sst(s0,'Structure',structure); s0=sst(s0,'Struc_Descr',struc_descr);
s0=sst(s0,'Project',project); s0=sst(s0,'Proj_Descr',proj_descr);
s0=sst(s0,'Positions',{{'' '' '' '' '' ''}});

return

