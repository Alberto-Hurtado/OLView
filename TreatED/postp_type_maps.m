function [desSourceMap,desElaborationMap,desSamplingMap]=postp_type_maps()
% function [desSourceMap,desElaborationMap,desSamplingMap]=postp_type_maps()
% Returns the maps for the description of the postprocessing types
% New csv format 2022
% F.J. Molina 2022 04

%% Postprocessing-types dictinary
keySource = {'CTRL' 'STD' 'PHYS' 'HYBR'}
desSource = {'controller node' 'standard acq node' 'physical DoFs' 'hybrid system DoFs'}
desSourceMap = containers.Map(keySource,desSource);
keyElaboration = {'ORIG' 'DER' 'IDEN'}
desElaboration = {'measured (or controller computed)' 'derived by posttreatment' 'identified by posttreatment'}
desElaborationMap = containers.Map(keyElaboration,desElaboration);
keySampling = {'av' 'ins' 'con' 're'}
desSampling = {'record average' 'instantaneous' 'constant average' 'resampled'}
desSamplingMap = containers.Map(keySampling,desSampling);

%% examples of use
%desSourceMap('HYBR')
%desElaborationMap('IDEN')
%desSamplingMap('re')

return

