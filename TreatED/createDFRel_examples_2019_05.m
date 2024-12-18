



display('List of existing datafile relations in ELSADATA:')
roles=getAllDataFileRelations(data);
roleNames=cell(size(roles));
for iRole=1:size(roles)
    parent=roles(iRole).parents;
    if ~isempty(parent)
        parent=roles(iRole).parents.name;
    end
    display(sprintf('  iRole=%2d  Name=%45s  Parent=%45s    Descr.=%s', ...
        iRole, roles(iRole).name,parent,roles(iRole).description))
    roleNames{iRole}=roles(iRole).name;
end

% List of existing datafile relations in ELSADATA:
%   iRole= 1  Name=                    Acquisition configuration  Parent=                  Experimental Act. data file    Descr.=Data files and documentation for the acquisition system of an experimental activity
%   iRole= 2  Name=                  Experimental Act. data file  Parent=                                    Data file    Descr.=Datafiles related to an Experimental Activity
%   iRole= 3  Name=                                     Analysis  Parent=                  Experimental Act. data file    Descr.=The data file is part of the analysis of some activity
%   iRole= 4  Name=                       Conference publication  Parent=                                  Publication    Descr.=Indicates that a conference publication is related to an activity (project, experiment, etc)
%   iRole= 5  Name=                                  Publication  Parent=                            Project data file    Descr.=Indicates that a publication is related to an activity (project, experiment, etc)
%   iRole= 6  Name=                   Construction documentation  Parent=                           Specimen data file    Descr.=Data file about the construction process of a specimen (e.g. a document, image or video)
%   iRole= 7  Name=                           Specimen data file  Parent=                                    Data file    Descr.=Datafiles related to a Specimen
%   iRole= 8  Name=                     Controller configuration  Parent=                  Experimental Act. data file    Descr.=Data files and documentation for the controller system of an experimental activity
%   iRole= 9  Name=                                    Data file  Parent=                                                 Descr.=Indicates that a data file (document, image, executable, etc) is related to [takes part in] an activity (project, experiment, etc)
%   iRole=10  Name=                                  Deliverable  Parent=                            Project data file    Descr.=This includes any final documentation, normally presented as a deliverable or an outcome of some activity
%   iRole=11  Name=                            Project data file  Parent=                                    Data file    Descr.=Datafiles related to a project
%   iRole=12  Name=                     Demolition documentation  Parent=                           Specimen data file    Descr.=Data file about the demolition process of a specimen (e.g. a document, image or video)
%   iRole=13  Name=                                     Document  Parent=                                        Media    Descr.=Indicates that a document file is related to an activity (project, experiment, etc)
%   iRole=14  Name=                                        Media  Parent=                                    Data file    Descr.=Relationship with media file such as documents, videos and images
%   iRole=15  Name=  Equipment and Instrumentation documentation  Parent=                  Experimental Act. data file    Descr.=Documentation about equipment and instrumentation, including how the boundaries of a structure are connected to a facility or the location of equipment (e.g. location of the actuators or sensors in an experiment)
%   iRole=16  Name=                            Executive summary  Parent=                            Project data file    Descr.=Indicates that an executive summary document file is related to an activity (project, experiment, etc).
%   iRole=17  Name=       Experimental Activity Log Observations  Parent=                  Experimental Act. data file    Descr.=Documentation about observations of the Experiment/Simulation log
%   iRole=18  Name=                     Geometry and coordinates  Parent=                           Specimen data file    Descr.=Additional documentation about the geometry and coordinates (location) of a specimen or specimen component
%   iRole=19  Name=                                        Image  Parent=                                        Media    Descr.=Indicates that an image file is related to an activity (project, experiment, etc).
%   iRole=20  Name=                          Journal publication  Parent=                                  Publication    Descr.=Indicates that a journal publication is related to an activity (project, experiment, etc)
%   iRole=21  Name=                       Material documentation  Parent=                           Specimen data file    Descr.=Documentation referred to a material (e.g. documents refereing to material curves that define a soil material)
%   iRole=22  Name=                               Processed data  Parent=                  Experimental Act. data file    Descr.=Relation with a data file that has been processed after it has been obtained from a system
%   iRole=23  Name=                        Scaling documentation  Parent=                           Specimen data file    Descr.=Documentation about scaling parameters used for a specimen or specimen component.
%   iRole=24  Name=                 Transportation documentation  Parent=                           Specimen data file    Descr.=Data file about the transportation process of a specimen (e.g. a document, image or video)
%   iRole=25  Name=                             Unprocessed data  Parent=                  Experimental Act. data file    Descr.=Relation with a data file that is in a RAW unprocessed format, as it has been obtained from a system
%   iRole=26  Name=                                        Video  Parent=                                        Media    Descr.=Indicates that a video file is related to an activity (project, experiment, etc)

% 2019-04:
%   iRole=27  Name=                            Testing procedure  Parent=                                     Document    Descr.=Information on the test steps
%   iRole=28  Name=                 Quality management reference  Parent=                                     Document    Descr.=Definitions and criteria for quality management
%   iRole=29  Name=                Equipment and Instrumentation  Parent=                                        Media    Descr.=Documentation about equipment and instrumentation, including how the boundaries of a structure are connected to a facility or the location of equipment (e.g. location of the actuators or sensors in an experiment)
%   iRole=30  Name=                                        Graph  Parent=                                        Image    Descr.=Indicates that a graph file is related to an activity (project, experiment, etc).
%   iRole=31  Name=                                        Photo  Parent=                                        Image    Descr.=Indicates that a picture file is related to an activity (project, experiment, etc).
%   iRole=32  Name=                                  Test report  Parent=                                     Document    Descr.=Definition of the experiment and description of the results



roleLabel='Testing procedure'
roleDescription='Information on the test steps'
roleParent='Document'
createDFRel(roleLabel,roleDescription,roleParent)

roleLabel='Quality management reference'
roleDescription='Definitions and criteria for quality management'
roleParent='Document'
createDFRel(roleLabel,roleDescription,roleParent)

% roleLabel='Equipment and Instrumentation documentation'
% deleteDFRel(roleLabel) %Gives error because there are datafiles with this relation

roleLabel='Equipment and Instrumentation'
roleDescription=['Documentation about equipment and instrumentation, ' ...
    'including how the boundaries of a structure are connected to a facility ' ...
    'or the location of equipment (e.g. location of the actuators or sensors ' ...
    'in an experiment)']
roleParent='Media'
createDFRel(roleLabel,roleDescription,roleParent)

roleLabel='Graph'
roleDescription='Indicates that a graph file is related to an activity (project, experiment, etc).'
roleParent='Image'
createDFRel(roleLabel,roleDescription,roleParent)

roleLabel='Photo'
roleDescription='Indicates that a picture file is related to an activity (project, experiment, etc).'
roleParent='Image'
createDFRel(roleLabel,roleDescription,roleParent)

roleLabel='Test report'
roleDescription='Definition of the experiment and description of the results'
roleParent='Document'
createDFRel(roleLabel,roleDescription,roleParent)


