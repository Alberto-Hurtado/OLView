function identityImage_downloadIRI=ed2fsIdentityImage(identityImage_downloadIRI,outpath)
% function identityImage_downloadIRI=ed2fsIdentityImage(identityImage_downloadIRI,outpath)
% Migrates identityImages  of an object from ELSADATA to File System
% F.J. Molina 2020 03


iarg=2;
if nargin<iarg; outpath=''; end; iarg=iarg-1;
if isempty(outpath)
    error('outpath cannot be empty!!!')
end
disp(outpath);


if ~exist(outpath,'dir')
    dos(['mkdir ' outpath]);
% elseif exist([outpath '\' outfilename],'file')
%     dos(['del ' outpath '\*.*']);
end

websaveS([outpath '\icon.png'],identityImage_downloadIRI);
        
% [path, name, ext] = fileparts(downloadIRI);
% websaveS([outpath '\' name ext],downloadIRI);
        

