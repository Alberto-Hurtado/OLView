cd C:\Users\molina\Documents\MATLAB\2018_04_17_WS

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


project1 = getProjectByName(data,'CaSCo ELSA')



% project1 = 
% 
%   Project with properties:
% 
%       experimentalActs: [196x1 wsdl.data.ExperimentalActivity]
%              specimens: [3x1 wsdl.data.Specimen]
%              datafiles: []
%            description: 'CaSCo: CONSISTENT SEMIACTIVE SYSTEM CONTROL Competitive and Sustainable Growth Program Proj…'
%       formattedEndDate: '24/04/2003'
%     formattedStartDate: '11/02/2002'
%                     id: 'http://elsadata.jrc.ec.europa.eu/celestina#project162'
%               keywords: {4x1 cell}
%                   name: 'CaSCo ELSA'
%           participants: [1x1 wsdl.data.Participant]
%                purpose: []
%              shortName: 'CaSCo ELSA'             
             

experimentsRef=project1.experimentalActs;

% experimentsRef = 
% 
%   196x1 ExperimentalActivity array with properties:
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

exp_names=cell(length(experimentsRef),1);
for iex=1:length(experimentsRef)
    exp_names{iex}=experimentsRef(iex).name;
    disp(sprintf('%d    %s',iex,exp_names{iex}));
end

find(strcmp(exp_names,'c2008'))
% ans =
%     46


[experiments,experiments_table]=ed2fsExperiments( ...
    experimentsRef(45),'E:\2018_04_24_ELSADATA_FS\CaSCo_ELSA\Experiments')

[experiments,experiments_table]=ed2fsExperiments( ...
    experimentsRef(46),'E:\2018_04_24_ELSADATA_FS\CaSCo_ELSA\Experiments')


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

    