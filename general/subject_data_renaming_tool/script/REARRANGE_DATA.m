clear; close all; clc;

% ==== SETTINGS: =========================================================
inputCfg.path          = '../ex_old_data/';
outputCfg.path         = '../ex_new_data/';

inputCfg.SubCodes      = {'1234', '0987'};
inputCfg.SubNums       = 1:numel(inputCfg.SubCodes);
outputCfg.SubCodes     = {'Sub_1', 'Sub_2'};
outputCfg.SubNums       = 1:numel(outputCfg.SubCodes);

inputCfg.dataNames     = {'anatomy_sourcemodel', '3-Restin'};
outputCfg.dataNames    = {'src', 'data_clean'};

outputCfg.namesFormat  = 'name_subCode_name_subNum_subNum';   % use 'name', 'subCode', 'subNum',
% eg: 'name_subNum','subCode_name',
%     'subNum_name'

% ========================================================================
% ASSUMPTION ! Only one file matching name is present in subject directory.

%%
addpath './functions/'
addpath './functions/kakearney-subdir-pkg-7f6f8de/subdir/'

iCount = 0;
for iSub = 1:numel(inputCfg.SubNums)
    for iData = 1:numel(inputCfg.dataNames)
        iCount = iCount + 1;
        
        % search
        listInputFiles{iCount} = searchRecursively(inputCfg.dataNames{iData}, [inputCfg.path, inputCfg.SubCodes{iSub}, '/']);
        
        % prepare changes list
        outputName = strrep(outputCfg.namesFormat, 'name', outputCfg.dataNames{iData});
        outputName = strrep(outputName, 'subCode', outputCfg.SubCodes{iSub});
        outputName = strrep(outputName, 'subNum', num2str(outputCfg.SubNums(iSub)));
        listOutputFiles{iCount} = [outputCfg.path, outputCfg.SubCodes{iSub}, '/', outputName, '.mat'];
        
    end
end

%% ask questions (interactive)
% list OK? YES-> proceed, NO-> manually edit list of changes and manually proceed

for iFile = 1:iCount
    LIST_FILE_CHANGES{iFile} = [listInputFiles{iFile}, ' -> ', listOutputFiles{iFile}];
end

disp('Here is the list of planned copies: ')
disp(LIST_FILE_CHANGES')

doAsk = 1;
while(doAsk)
    prompt = 'Do you agree with it? y/n [y]: ';
    answer = input(prompt,'s');
    
    switch answer
        case 'n'
            doAsk = 0;
            disp('OK you can manually edit LIST_CHANGES variable and then run rest of the script from section ''PROCESS''.');
            return
        case 'y'
            doAsk = 0;
            disp('OK. So I proceed with changes ... Please wait ...')
        otherwise
            warning('Wrong option (is small case?) !)')
            doAsk = 1;
    end
end



%% PROCESS
% verbosely show old_path/old_name -> newpath/new_name and save that info
% to text file

for iFile = 1:iCount
    
    disp(['Processing: ', num2str(iFile), ' / ', num2str(iCount), ' ...']);
    
    [filepath, name, ext] = fileparts(listOutputFiles{iFile});
    if(~exist(filepath, 'dir'))
        mkdir(filepath)
    end
    
    copyfile(listInputFiles{iFile}, listOutputFiles{iFile})
    
end
disp('DONE !')


%% FINISH

stamp = datestr(datetime('now'),'yyyy_MM_dd_HH-mm-ss');

% save subject codes change information
for iSub = 1:numel(inputCfg.SubCodes)
    LIST_SUB_CODES_CHANGES{iSub} = [inputCfg.SubCodes{iSub}, ',', outputCfg.SubCodes{iSub}];
end
fid = fopen(['./', stamp, '_subjCodes_change.txt'],'w');
CT = LIST_SUB_CODES_CHANGES.';
fprintf(fid,'%s\n', CT{:});
fclose(fid);


% save list of changes information
fid = fopen(['./', stamp, '_files_change.txt'],'w');
CT = LIST_FILE_CHANGES.';
fprintf(fid,'%s\n', CT{:});
fclose(fid);



