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
%  *  Celestina Data Viewer (c) 2015-2019
%  *  Ignacio Lamata Martinez
%  *
%  *
%  * websaveS.m (v.0.1)
%  * Creation date: 15-May-2019 by ilm
%  * ------------------------------------------------------------------
%  * This simple script facilitates saving files from MATLAB when
%  * untrusted by default or self-signed certificates are used.
%  *
%  * PREREQUISITES:
%  * celestinaWS must have been executed previously 
%  *
%  * USAGE:
%  * Call websaveS with these two parameters: 
%  *    - Local filename to where save the file
%  *    - URL from which retrieve the file
%  *
%  * EXAMPLE:
%  *    websaveS('.\file.txt', 'https://elsadata.jrc.it:444/files/specimen0/170712185727_file.doc');
%  *

function []=websaveS(localFile, downloadIri)
global celestws_options;

% fprintf('> Saving [%s] into [%s]...\n', downloadIri, localFile);
websave(localFile, downloadIri, celestws_options);

end