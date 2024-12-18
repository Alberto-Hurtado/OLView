%  *
%  *    ____     _           _   _
%  *   / ___|___| | ___  ___| |_(_)_ __   __ _
%  *  | |   / _ \ |/ _ \/ __| __| | '_ \ / _` |
%  *  | |__|  __/ |  __/\__ \ |_| | | | | (_| |
%  *   \____\___|_|\___||___/\__|_|_| |_|\__,_|
%  *
%  * ============
%  *  CELESTINA
%  * ============
%  *  Celestina Data Viewer (c) 2015-2018
%  *  Ignacio Lamata Martinez & Javier Molina 
%  *
%  *
%  * startCelestinaWS.m (v.0.9)
%  * Creation date: 8-Mar-2017 by jm/ilm
%  * Modification date: 9-Mar-2017 by ilm
%  *                    27-Jul-2017 by ilm (certificate installation)
%  *                       Sep-2017 by ilm (adaptation to v2016b+ and
%  *                                        improvement of script)
%  *                       Oct-2017 by ilm (use of java.opts)
%  *                       Jun-2018 by ilm (conversion to PEM and use in
%  *                                       weboptions for createWSDLClient)
%  * ------------------------------------------------------------------
%  * This script sets up the Celestina Data Viewer Web Services with Matlab.
%  * The necessary files are created in the current directory, and all
%  * certificates (server and client) are installed.
%  * After this script has finished installing and configuring everything
%  * it is not strictly necessary to call it again: The Web Service can be 
%  * used directly from the files created, as long as the java path is
%  * included (javaaddpath('./+wsdl/data.jar')). However, you can run the
%  * script again prior calling the Web Services to make sure it will work.
%  *
%  * USAGE:
%  * Call startCelestinaWS. This might require to restart Matlab and to run
%  * the script again.
%  *
%  * WEB SERVICES USAGE:
%  *
%  * Services are called by using:
%  *     SERVICE_NAME(data, INPUT_PARAM1, INPUT_PARAM2 ...)
%  * Objects are created by using:
%  *     wsdl.data.OBJECT_CLASS   e.g. p1 = wsdl.data.Project
%  * or:
%  *     data.getOBJECT_METHOD    e.g. p1 = data.getProjectObject
%  *
%  * Command examples:
%  *   methods(data) --> List all available services and get object methods
%  *   getProjectsIds(data) --> Call service getProjectIds
%  *   getProject(data, 'http://jrc.org/celestina#proj1) --> Call service
%  *                           getProject with the specified parameter

function startCelestinaWS
global SERVER_CERTFILE TRUSTSTORE SERVER_CERTALIAS CLIENT_CERTFILE INSTALLEDCERT_FILE TEMPROOTPEM;
% Custom variables. Change this as necessary ------------------------------
JDK_DIR = 'C:\Program Files\Java\jdk1.7.0_79'; 
CXF_DIR = 'C:\Program Files\apache\apache-cxf-2.7.18';
HOST = 'elsadata';
SERVER_CERTFILE = ...
    'C:\Users\molina\Documents\MATLAB\2018_06_11_WS\elsadata.cer';
SERVER_CERTALIAS = 'ELSADATA';
CLIENT_CERTFILE = 'C:\Users\molina\Documents\MATLAB\2018_06_11_WS\Javier_Admin.p12';
% Other variables (normally you do not need to change this) ---------------
TRUSTSTORE = [SERVER_CERTFILE '.jks'];
TEMPROOTPEM = [SERVER_CERTFILE '.pem'];
PROTOCOL = 'https';
INSTALLED_FILE = 'installed_ws';
INSTALLEDCERT_FILE = 'installed_cert';
% -------------------------------------------------------------------------
fprintf('\n\n');
disp('    ____     _           _   _');
disp('   / ___|___| | ___  ___| |_(_)_ __   __ _');
disp('  | |   / _ \ |/ _ \/ __| __| | ''_ \ / _` |');
disp('  | |__|  __/ |  __/\__ \ |_| | | | | (_| |');
disp('   \____\___|_|\___||___/\__|_|_| |_|\__,_|');
fprintf('\n\n');

if (~exist(INSTALLED_FILE,'file'))
    fprintf('\tInstalling Web Services for the first time\n');
    fprintf('[*]\tInstalling certificates...\n');
    installServerAndClientCertificates();
    fprintf('[*]\tCreating Web Services in current directory...\n');
    matlab.wsdl.setWSDLToolPath('JDK',JDK_DIR,'CXF',CXF_DIR);
    %options = weboptions('CertificateFilename',TEMPROOTPEM);
    %matlab.wsdl.createWSDLClient([PROTOCOL '://' HOST '/CelestinaDataViewer/data?wsdl'], options);
    matlab.wsdl.createWSDLClient([PROTOCOL '://' HOST '/CelestinaDataViewer/data?wsdl']);
    javaaddpath('./+wsdl/data.jar');
    fprintf('[*]\tCleaning validations...');
    novalidate;
    fprintf('\t... Done\n');
    fclose(fopen(INSTALLED_FILE, 'w'));
else
    fprintf('\tWeb Services (and certificates) seem to have been already installed. If you wish to reinstall everything, just delete the files with name "%s" and "%s" in the current directory\n', INSTALLED_FILE, INSTALLEDCERT_FILE);
    javaaddpath('./+wsdl/data.jar');
end
fprintf('[*]\tListing services and object creation methods available:');
methods(data);
end

function installServerAndClientCertificates
    global INSTALLEDCERT_FILE;
    if (~exist(INSTALLEDCERT_FILE,'file'))
        fprintf('[*]\tInstalling server certificate...\n');
        installServerCertificate;
        fprintf('[*]\tConfiguring client and server certificates...\n');
        temp_javaoptsFile = 'java.opts';
        createJavaOpts(temp_javaoptsFile);
        fclose(fopen(INSTALLEDCERT_FILE, 'w'));
        fprintf('Matlab needs to be restarted. Now please restart Matlab and execute the script again\n');
        exitMatlab;
    else
        fprintf('Server and Client certificates seem to have been already created. To force recreation, delete the file [%s] and run the script again\n', INSTALLEDCERT_FILE);
    end
end

function installServerCertificate
    global SERVER_CERTFILE TRUSTSTORE SERVER_CERTALIAS TEMPROOTPEM;
    createJKSfromCER(SERVER_CERTFILE, TRUSTSTORE, SERVER_CERTALIAS, TEMPROOTPEM);
end

function createJKSfromCER(certFile, jksFile, alias, pemFile)
    keytool = fullfile(matlabroot,'sys','java','jre',computer('arch'),'jre','bin','keytool');
    fprintf('[*]\tImporting server certificate [%s] into JKS keystore [%s]...\n', certFile, jksFile);
    fprintf('[*]\t(You will be prompted to set a new password. Remember it, this is the JKS you will have to use later.)\n');
    command = sprintf('"%s" -import -file "%s" -trustcacerts -keystore "%s" -alias "%s" -noprompt', keytool, certFile, jksFile, alias);
    dos(command);
    fprintf('[*]\tConverting server certificate [%s] into PEM [%s]...\n', jksFile, pemFile);
    command = sprintf('"%s" -exportcert -file "%s" -rfc -keystore "%s" -alias "%s" -noprompt', keytool, pemFile, jksFile, alias);
    dos(command);
    
end

function createJavaOpts(temp_javaoptsFile)
    createTempJavaOpts(temp_javaoptsFile);
    moveTempJavaOpts(temp_javaoptsFile);
end

function createTempJavaOpts(temp_javaoptsFile)
    global TRUSTSTORE CLIENT_CERTFILE;
    fprintf('[*]\tCreating temporary java.opts file in current directory...\n');
    fileID = fopen(temp_javaoptsFile,'w');
    fprintf(fileID,'-Djavax.net.ssl.keyStoreType=PKCS12\n');
    fprintf(fileID,'-Djavax.net.ssl.keyStore=%s\n',CLIENT_CERTFILE);
    fprintf(fileID,'-Djavax.net.ssl.keyStorePassword=INPUT_P12_PASSWORD\n');
    fprintf(fileID,'-Djavax.net.ssl.trustStoreType=JKS\n');
    fprintf(fileID,'-Djavax.net.ssl.trustStore=%s\n',TRUSTSTORE);
    fprintf(fileID,'-Djavax.net.ssl.trustStorePassword=INPUT_JKS_PASSWORD\n');
    fclose(fileID);
    fprintf('[*]\tFile [%s] created...\n', temp_javaoptsFile);
    fprintf('\tNow open file [%s] in the current directory and edit the password fields\n', temp_javaoptsFile);
    fprintf('\tThe JKS password is the one you have chosen in the previous step.\n\tThe P12 password is the one you chose when creating your account in the Celestina Data Viewer application\n\tIf you have no user and connect as PUBLIC, you can remove the keyStore lines\n');
    input('Once you finish, press ENTER to continue... ', 's');
end

function moveTempJavaOpts(temp_javaoptsFile)
    global SERVER_CERTFILE;
    javaoptsFile = fullfile(matlabroot,'bin',computer('arch'),'java.opts');
    fprintf('[*]\tMoving file [%s] to [%s]...\n', temp_javaoptsFile, javaoptsFile);
    rootcerts = fullfile(matlabroot,'sys','certificates','ca','rootcerts.pem');
    fprintf('\tNote: This step involves the use of a java.opts file at [%s] which will change your standard keystore in order to be less intrusive. However, this might change the way you interact with other secure systems. If you want to restore the standard keystore and still use CDV, just edit the java.opts file to remove trustStore lines and include the server certificate [%s] into [%s].\n', javaoptsFile, SERVER_CERTFILE, rootcerts);
    if (exist(javaoptsFile,'file'))
        fprintf('[*]\tThe file [%s] already exists. A backup will be made and the file will be overwritten. Please, merge the backup file manually if you consider it necessary.\n', javaoptsFile);
        backupFile(javaoptsFile);
    end
    moveResult = movefile(temp_javaoptsFile, javaoptsFile,'f');
    if (moveResult == 0)
        fprintf('There has been an error moving the file [%s] to [%s]. Please, do it manually\n', temp_javaoptsFile, javaoptsFile);
    end
end

% function checkWritePermission(fileName)
%      [fid,errmsg] = fopen(fileName, 'a');
%      if ~isempty(errmsg)&&strcmp(errmsg,'Permission denied') 
%          fprintf('\nError: You do not have write permission to access [%s].\n',fileName);
%          fprintf('Please, restart Matlab with higher permissions.\n');
%          exitMatlab;
%      else
%        fclose(fid);
%      end
% end

function backupFile(fileName)
    dt = datestr(now, 'yyyy-mm-dd_MMSS');
    backupFileName = [fileName '_' dt '.org'];
    fprintf('[*]\tBacking up file [%s] as [%s]...\n', fileName,  backupFileName);
    copyfile(fileName,  backupFileName, 'f');
 end

function exitMatlab
    input('Press ENTER to exit Matlab... ', 's');
    exit
end

function novalidate
% This function "fixes" some of the weird validations that Matlab does on
% the Web Service objects, by removing the validation alltogether.
NOVALIDATE_DIR = './+wsdl/+data/';
NOVALIDATE_MASK = '*.m';

files=dir([NOVALIDATE_DIR NOVALIDATE_MASK]);
for i=1:length(files)
    fname=files(i).name;
    disp(['  - ' fname]);
    fid=fopen([NOVALIDATE_DIR fname],'r');
    content=fscanf(fid,'%c');
    fclose(fid);
    pattern = '([\w @().]*)checkFields';
    replace = '% COMMENTED: $0';
    contentModified = regexprep(content,pattern,replace);
    fid=fopen([NOVALIDATE_DIR fname],'w');
    fprintf(fid,'%c',contentModified);
    fclose(fid);
end

% Other functions ---------------------------------------------------------
% This works for pre-R2016b versions
% function installCertificate(certfile, alias)
%     keytool = fullfile(matlabroot,'sys','java','jre',computer('arch'),'jre','bin','keytool');
%     cacerts = fullfile(matlabroot,'sys','java','jre',computer('arch'),'jre','lib','security','cacerts');
%     checkWritePermission(cacerts);
%     if (~exist([cacerts '.org'],'file'))
%         fprintf('[*]\tImporting server certificate in keystore...\n');
%         copyfile(cacerts,[cacerts '.org'], 'f');
          % NOTE: This command assumes the default Java keystore password
%         command = sprintf('"%s" -import -file "%s" -keystore "%s" -alias "%s" -storepass changeit -noprompt',keytool,certfile,cacerts, alias);
%         dos(command);
%         fprintf('Certificate importation completed.\n');
%         fprintf('Matlab needs to be restarted. Now please restart Matlab and execute the script again\n');
%         exitMatlab;
%     else
%         fprintf('Skipping importing certificate - Apparently the certificate has already been installed (if you are sure it is not installed, rename file [%s] to attempt a re-importation)\n', [cacerts '.org']);
%     end
% end

% This works for pos-R2016b versions
% function installCertificate(certfile, alias)
%     keytool = fullfile(matlabroot,'sys','java','jre',computer('arch'),'jre','bin','keytool');
%     cacerts = fullfile(matlabroot,'sys','java','jre',computer('arch'),'jre','lib','security','cacerts');
%     dt = datestr(now, 'yyyy-mm-dd_MMSS');
%     cacerts_bckup = [cacerts '_' dt '.org'];
%     rootcerts = fullfile(matlabroot,'sys','certificates','ca','rootcerts.pem');
%     rootcerts_bckup = [rootcerts '_' dt '.org'];
%     temp_keystore = fullfile('.', [alias '.jks']);
%     % NOTE: This assumes the default Java keystore password: 'changeit'
%     temp_password = 'changeit';
%     temp_pem = fullfile('.', [alias '.pem']);
%     checkWritePermission(cacerts);
%     checkWritePermission(rootcerts);
%     if (~exist(temp_pem,'file'))
%         fprintf('[*]\tImporting server certificate into keystore (cacerts)...\n');
%         fprintf('[*]\tBacking up old cacerts ["%s"] as "%s"...\n', cacerts, cacerts_bckup);
%         copyfile(cacerts, cacerts_bckup, 'f');
%         command = sprintf('"%s" -import -file "%s" -keystore "%s" -alias "%s" -storepass "%s" -noprompt', keytool, certfile, cacerts, alias, temp_password);
%         dos(command);
%         fprintf('[*]\tCreating server certificate in temporary keystore (JKS)...\n');
%         command = sprintf('"%s" -import -file "%s" -trustcacerts -keystore "%s" -alias "%s" -storepass "%s" -noprompt', keytool, certfile, temp_keystore, alias, temp_password);
%         dos(command);
%         fprintf('[*]\tConverting JKS into PEM...\n');
%         command = sprintf('"%s" -exportcert -alias "%s" -file "%s" -rfc -keystore "%s" -storepass "%s" -noprompt', keytool, alias, temp_pem, temp_keystore, temp_password);         
%         dos(command);
%         fprintf('[*]\tBacking up old rootcerts ["%s"] as "%s"...\n', rootcerts, rootcerts_bckup);
%         copyfile(rootcerts,[rootcerts dt '.org'], 'f');
%         fprintf('[*]\tCopying PEM into rootcerts...\n');
%         copyfile(temp_pem,rootcerts, 'f');
%         fprintf('Creation of temporary trusted keystore completed.\n');
%         fprintf('Matlab needs to be restarted. Now please restart Matlab and execute the script again\n');
%         exitMatlab;
%     else
%         fprintf('Skipping creation of temporary trusted keystore .PEM and importation of server certificate in cacerts - Apparently the certificate has already been installed (if you are sure it is not installed, rename file [%s] to attempt a re-importation)\n', temp_pem);
%     end
% end


end