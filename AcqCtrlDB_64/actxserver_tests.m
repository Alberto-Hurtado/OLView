Projects = actxserver('AcqCtrlDB.Projects')
 
Projects =
 
	COM.AcqCtrlDB_Projects

% Project = Projects.GetProject('SAFECAST ELSA')
% Error using COM.AcqCtrlDB_Projects/GetProject
% Invoke Error, Dispatch Exception:
% Source: Automation Object [Projects]
% Description: Data Source Name not initialized
%  
% Project.DataSourceName = 'ElsaDB'
% 
% Project = 
% 
%     DataSourceName: 'ElsaDB'
% 
% Project = Projects.GetProject('SAFECAST ELSA')
% Error using COM.AcqCtrlDB_Projects/GetProject
% Invoke Error, Dispatch Exception:
% Source: Automation Object [Projects]
% Description: Data Source Name not initialized
 
Projects.DataSourceName = 'ElsaDB'
 
Projects =
 
	COM.AcqCtrlDB_Projects

Project = Projects.GetProject('SAFECAST ELSA')
 
Project =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IProject

Project.invoke
	Load = void Load(handle)
	Save = void Save(handle)
	New = void New(handle)
	Delete = void Delete(handle)
	NewStructure = Variant NewStructure(handle, string)
	ListStructure = Variant ListStructure(handle)
	GetStructure = Variant GetStructure(handle, string)
	StructureExist = int32 StructureExist(handle, string)
	GetStructures = Variant GetStructures(handle)
	GetKeywords = Variant GetKeywords(handle)
	SetKeywords = void SetKeywords(handle, string)
	GetFreeKeywords = Variant GetFreeKeywords(handle)
	SetFreeKeywords = void SetFreeKeywords(handle, string)
	GetDocumentFolder = Variant GetDocumentFolder(handle)
Project.ListStructure

ans = 

    'Prototype 1'
    'Prototype 2'
    'Prototype 3'
    'Prototype 4'

Projects.ProjectExist('SAFECAST ELSA')

ans =

     1

NewProject = Projects.NewProject('AcqCtrlDB64')
 
NewProject =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IProject

NewProject.Description = 'test with acqctrldb64'
 
NewProject =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IProject

NewProject.get
           Name: 'AcqCtrlDB64'
    Description: 'test with acqctrldb64'
         Status: ''
      StartDate: '00:00:00'
        EndDate: '00:00:00'
       Modified: 1

NewProject.Save
NewStructure = NewProject.NewStructure('Str1')
 
NewStructure =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IStructure

NewProject.Save
NewStructure.get
           Name: 'Str1'
       Modified: 0
    Description: ''

NewStructure.Description = 'desc1'
 
NewStructure =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IStructure

NewStructure.Save
NewExperiment = NewStructure.NewExperiment('Exp1')
 
NewExperiment =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IExperiment

NewPP = NewExperiment.NewPostProcessing('PP1')
 
NewPP =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IPostProcessing

NewSignal = NewPP.NewSignal('s1')
 
NewSignal =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IPPSignal

a=[1;2;3]

a =

     1
     2
     3

NewSignal.Data = single(a)
Invoke Error, Dispatch Exception:
Source: Automation Object [PPSignal]
Description: Invalid Variant Type Passed, Must be a Vector
 
b = single(a)

b =

     1
     2
     3

NewSignal.Data = a
Invoke Error, Dispatch Exception:
Source: Automation Object [PPSignal]
Description: Invalid Variant Type Passed : 2005 Float(VT_R4, Single) requested
 
NewSignal.Data = b
Invoke Error, Dispatch Exception:
Source: Automation Object [PPSignal]
Description: Invalid Variant Type Passed, Must be a Vector
 
c=a'

c =

     1     2     3

NewSignal.Data = c
Invoke Error, Dispatch Exception:
Source: Automation Object [PPSignal]
Description: Invalid Variant Type Passed : 2005 Float(VT_R4, Single) requested
 
NewSignal.Data = single(c)
Invoke Error, Dispatch Exception:
Source: Automation Object [PPSignal]
Description: Invalid Variant Type Passed, Must be a Vector
 
acell={1,2,3}

acell = 

    [1]    [2]    [3]

NewSignal.Data = acell
Invoke Error, Dispatch Exception:
Source: Automation Object [PPSignal]
Description: Invalid Variant Type Passed : 200c Float(VT_R4, Single) requested
 
NewSignal.Data = single(acell)
Error using single
Conversion to single from cell is not possible.
 
acell={single(1),single(2),single(3)}

acell = 

    [1]    [2]    [3]

NewSignal.Data = acell
Invoke Error, Dispatch Exception:
Source: Automation Object [PPSignal]
Description: Invalid Variant Type Passed : 200c Float(VT_R4, Single) requested
 
NewPP.get
           Name: 'PP1'
       Modified: 0
    Description: ''

NewPP.invoke
	New = void New(handle)
	Load = void Load(handle)
	Save = void Save(handle)
	Delete = void Delete(handle)
	ListSignal = Variant ListSignal(handle)
	GetSignal = Variant GetSignal(handle, string)
	NewSignal = Variant NewSignal(handle, string)
	SignalExist = int32 SignalExist(handle, string)
	GetSignalWithoutData = Variant GetSignalWithoutData(handle, string)
	GetSignals = Variant GetSignals(handle)
	GetDocumentFolder = Variant GetDocumentFolder(handle)
edit putdoc
Error using edit (line 66)
Neither 'putdoc' nor 'putdoc.m' could be found.
 
edit putdocu
DocFolder = NewPP.GetDocumentFolder()
 
DocFolder =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IDocumentFolder

DocFolder.invoke
	ListDocument = Variant ListDocument(handle)
	NewDocument = Variant NewDocument(handle, string)
	GetDocument = Variant GetDocument(handle, string)
	DocumentExist = int32 DocumentExist(handle, string)
	Load = void Load(handle)
	Save = void Save(handle)
	New = void New(handle)
	Delete = void Delete(handle)
	NewFolder = Variant NewFolder(handle, string)
	GetFolder = Variant GetFolder(handle, string)
	ListFolder = Variant ListFolder(handle)
	GetFolders = Variant GetFolders(handle)
	GetParent = Variant GetParent(handle)
	GetDocuments = Variant GetDocuments(handle)
NewFolder = DocFolder.NewFolder('fold1')
 
NewFolder =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IDocumentFolder

NewDoc = NewFolder.NewDocument('doc1')
 
NewDoc =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IDocument

NewDoc.invoke
	New = void New(handle)
	Load = void Load(handle)
	Save = void Save(handle)
	Delete = void Delete(handle)
	SaveToFile = void SaveToFile(handle, string)
	ChunkLoad = void ChunkLoad(handle)
	ChunkDump = int32 ChunkDump(handle, char, int32)
	ChunkWrite = int32 ChunkWrite(handle, char, int32, int32)
	SaveNoFile = void SaveNoFile(handle)
NewDoc.get
           Name: 'doc1'
    Description: ''
       Modified: 0
         Source: ''
        Version: 0
           Size: 0
           Type: 'Presentation'
        Private: 0

NewDoc.Source= 'C:\Users\molina\Desktop\BoardingPass.pdf'
 
NewDoc =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IDocument

NewDoc.Save
Error using Interface.AcqCtrlDB_1.0_Type_Library.IDocument/Save
Invoke Error, Dispatch Exception:
Source: Automation Object [Document]
Description: SQL Error State:28000, Native Error Code: 4818, ODBC Error: [Microsoft][ODBC SQL Server Driver][SQL Server]Login failed for
user 'sa'.

 