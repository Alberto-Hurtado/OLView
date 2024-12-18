cd C:\Users\molina\Documents\MATLAB\2018_06_11_WS

startCelestinaWS


% 
%     ____     _           _   _
%    / ___|___| | ___  ___| |_(_)_ __   __ _
%   | |   / _ \ |/ _ \/ __| __| | '_ \ / _` |
%   | |__|  __/ |  __/\__ \ |_| | | | | (_| |
%    \____\___|_|\___||___/\__|_|_| |_|\__,_|
% 
% 
% 	Web Services (and certificates) seem to have been already installed. If you wish to reinstall everything, just delete the files with name "installed_ws" and "installed_cert" in the current directory
% [*]	Listing services and object creation methods available:
% Methods for class data:
% 
% data                       getSignalsOfExperiment     
% delDataFileRelation        getSpecimen                
% delEquipment               getSpecimenComponentTypes  
% delMaterialType            getSpecimens               
% delParticipant             getSpecimensIds            
% delPhysicalPropertyType    saveDataFileRelation       
% display                    saveEquipment              
% getAllDataFileRelations    saveExperiment             
% getEquipment               saveMaterialType           
% getExperiment              saveParticipant            
% getExperiments             saveParticipants           
% getExperimentsIds          savePhysicalPropertyType   
% getMaterialTypes           saveProject                
% getParticipants            saveSpecimen               
% getPhysicalPropertyTypes   testWS                     
% getProject                 testWSParamException       
% getProjectByName           uploadDataFile             
% getProjects                uploadSignals              
% getProjectsIds             whoAmI                     
% getSignal                  
% 
% Static methods:
% 
% getBasic                   getPhysicalProperty        
% getDataFile                getPlan2D                  
% getDevice                  getPoint2D                 
% getExpSetupElementType     getProjectObject           
% getExperimentalActivity    getSignalData              
% getGeneralData             getSpecimenObject          
% getGeneralDataType         getTypeAndUnit             
% getParticipant             
% getParticipantNature       


whoAmI(data)

% ans =
% 
% PUBLIC

help data.getProjectByName

%  getProjectByName  
%    project = getProjectByName(obj,name)  
%      Inputs:
%        obj - data object
%        name - string
%      Output:
%        project - Project object
%  
%   See also data.


project1 = getProjectByName(data,'ESECMaSE ELSA')



% project1 = 
% 
%   Project with properties:
% 
%       experimentalActs: [62x1 wsdl.data.ExperimentalActivity]
%              specimens: [2x1 wsdl.data.Specimen]
%              datafiles: [1x1 wsdl.data.DataFile]
%            description: 'Enhanced Safety and Efficient Construction of Masonry Structures in Europe. COLL-CT-2003-500291.'
%       formattedEndDate: '27/03/2008'
%     formattedStartDate: '23/08/2007'
%                     id: 'http://elsadata.jrc.ec.europa.eu/celestina#project236'
%               keywords: {8x1 cell}
%                   name: 'ESECMaSE ELSA'
%           participants: [1x1 wsdl.data.Participant]
%                purpose: []
%              shortName: 'ESECMaSE ELSA'
% 
             
             
prop_table=ed2fsProjectProp(project1,'ESECMaSE_FS')

% prop_table = 
% 
%     'description'           'Enhanced Safety and Efficient Construction of Masonry Structu…'
%     'formattedEndDate'      '27/03/2008'                                                     
%     'formattedStartDate'    '23/08/2007'                                                     
%     'id'                    'http://elsadata.jrc.ec.europa.eu/celestina#project236'          
%     'keywords'              'masonry##hammer excitation##calcium silicate##dynamic testing…'
%     'name'                  'ESECMaSE ELSA'                                                  
%     'purpose'                                                                              []
%     'shortName'             'ESECMaSE ELSA'                                                  

project1.datafiles(1)

%   DataFile with properties:
% 
%                       crc: []
%               description: 'AUTOCAD drawings for the locations and numbering of instr…'
%               downloadIRI: 'http://139.191.131.63/files/project236/170712190035_b5pLW…'
%                fileFormat: []
%     formattedCreationDate: []
%                        id: 'http://jrc.ec.europa.eu/celestina#document27800'
%                      name: 'Instrumentation'
%                   roleIri: 'http://www.celestina-integrations.com/data#hasImage'
%                 roleLabel: 'Image'
%                 shortName: []
%              thumbnailIRI: []
             
dataf_table=ed2fsDatafiles(project1.datafiles,'ESECMaSE_FS\Datafiles')
% dataf_table = 
% 
%     'name'               'roleLable'    'description'            
%     'Instrumentation'    'Image'        'AUTOCAD drawings for …'



specimensRef=project1.specimens;
specimensRef(1)
%   Specimen with properties:
% 
%              datafiles: []
%            description: 'Calcium Silicate Brick Units House'
%       formattedEndDate: []
%     formattedStartDate: []
%                     id: 'http://elsadata.jrc.ec.europa.eu/celestina#specimen355'
%               keywords: []
%                   name: 'Calc. Silic. Brick'
%           participants: []
%                purpose: []
%              shortName: []

[specimens,specimens_table]=ed2fsSpecimens(specimensRef, ...
    'ESECMaSE_FS\Specimens')
% specimens = 
% 
%   1x2 Specimen array with properties:
% 
%     datafiles
%     description
%     formattedEndDate
%     formattedStartDate
%     id
%     keywords
%     name
%     participants
%     purpose
%     shortName
% 
% 
% specimens_table = 
% 
%     'name'                  'description'                           'id'                                      
%     'Calc. Silic. Brick'    'Calcium Silicate Brick Units House'    'http://elsadata.jrc.ec.europa.eu/celes…'
%     'Clay Brick'            'Clay Brick Units House'                'http://elsadata.jrc.ec.europa.eu/celes…'


experimentsRef=project1.experimentalActs;

% experimentsRef = 
% 
%   62x1 ExperimentalActivity array with properties:
% 
%     devices
%     nature
%     outputSignals
%     plans
%     project
%     setupDescription
%     setupId
%     setupName
%     specimens
%     datafiles
%     description
%     formattedEndDate
%     formattedStartDate
%     id
%     keywords
%     name
%     participants
%     purpose
%     shortName

% [experiments,experiments_table]=ed2fsExperiments( ...
%     experimentsRef,'ESECMaSE_FS\Experiments')
[experiments,experiments_table]=ed2fsExperiments( ...
    experimentsRef(1:3),'ESECMaSE_FS\Experiments')


% experiments = 
% 
%   1x3 ExperimentalActivity array with properties:
% 
%     devices
%     nature
%     outputSignals
%     plans
%     project
%     setupDescription
%     setupId
%     setupName
%     specimens
%     datafiles
%     description
%     formattedEndDate
%     formattedStartDate
%     id
%     keywords
%     name
%     participants
%     purpose
%     shortName
% 
% 
% experiments_table = 
% 
%     'name'    'description'                      'setupName'
%     'a01'     'Slab Formwork Removal,Static;'             []
%     'a02'     'Slab Formwork Removal,Static;'             []
%     'e01'     'Hammer test Calibration:'                  []

    
experiments(1)
% ans = 
% 
%   ExperimentalActivity with properties:
% 
%                devices: []
%                 nature: [1x1 wsdl.data.GeneralDataType]
%          outputSignals: [15x1 wsdl.data.SignalData]
%                  plans: []
%                project: [1x1 wsdl.data.Project]
%       setupDescription: []
%                setupId: []
%              setupName: []
%              specimens: [1x1 wsdl.data.Specimen]
%              datafiles: [18x1 wsdl.data.DataFile]
%            description: 'Slab Formwork Removal,Static;'
%       formattedEndDate: '23/08/2007'
%     formattedStartDate: '23/08/2007'
%                     id: 'http://elsadata.jrc.ec.europa.eu/celestina#exp_comp2766'
%               keywords: []
%                   name: 'a01'
%           participants: []
%                purpose: []
%              shortName: []

    