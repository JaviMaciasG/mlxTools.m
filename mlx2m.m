    switch method

        % To include all
        case 'all'
            mlxFiles=dir('**/*.mlx');

        case 'all_exclude'
            mlxFiles=dir('**/*.mlx');

            % folders with their subfolders to be excluded
            excludedFoldersWSub = varargin{1};

            if ~isempty(excludedFoldersWSub)
                % 1
                mlxFiles = dir(fullfile([excludedFoldersWSub(i),"**/*.mlx"]));
                % 2:end
                for i=2:length(excludedFoldersWSub)
                    mlxFiles = [mlxFiles; dir(fullfile([excludedFoldersWSub(i),"**/*.mlx"]))];
                end
            end

            % folders without their subfolders to be excluded
            if nargin == 2
                excludedFoldersWOSub = varargin{2};

                if ~isempty(excludedFoldersWOSub)
                    for i=1:length(excludedFoldersWOSub)
                        mlxFiles = [mlxFiles; dir(fullfile([excludedFoldersWOSub(i),"*.mlx"]))];
                    end
                end
            end

            % excluding files of that folder
            removeList=zeros(size(mlxFilesExclude));
            iRem=1;
            for i=1:size(mlxFiles,1)
                if  ismember({mlxFiles(i).folder},{mlxFilesExclude(:).folder})
                    removeList(iRem)=i;
                    iRem=iRem+1;
                end
            end

            mlxFiles(removeList)=[];

        % To include all under a folder with GUI
        case 'GUI_all'
            d = uigetdir(pwd, 'Select a folder');
            mlxFiles = dir(fullfile(d, '**/*.mlx'));

        % To include a specific folder with GUI
        case 'GUI_specific'
            d = uigetdir(pwd, 'Select a folder');
            mlxFiles = dir(fullfile(d, '*.mlx'));

            while d~=0  % continue until user press cancel
                d = uigetdir(pwd, 'Select a folder');
                mlxFiles = [mlxFiles;dir(fullfile(d, '*.mlx'))];
            end

        % To include specific folders
        case 'specific'

            % folders with their subfolders
            includedFoldersWSub = varargin{1};

            if ~isempty(includedFoldersWSub)
                % 1
                mlxFiles = dir(fullfile([includedFoldersWSub(i),"**/*.mlx"]));
                % 2:end
                for i=2:length(includedFoldersWSub)
                    mlxFiles = [mlxFiles; dir(fullfile([includedFoldersWSub(i),"**/*.mlx"]))];
                end
            end

            % folders without their subfolders
            if nargin == 2
                includedFoldersWOSub = varargin{2};

                if ~isempty(includedFoldersWOSub)
                    for i=1:length(includedFoldersWOSub)
                        mlxFiles = [mlxFiles; dir(fullfile([includedFoldersWOSub(i),"*.mlx"]))];
                    end
                end
            end
    end

    %% create m folder and folder structure for storing files
    if isfolder('m')
    %     disp('Warning: m folder already exists!')
    %     warning('off','MATLAB:MKDIR:DirectoryExists')
        answer = questdlg('m folder already exists. Do you want to remove it? ', ...
            'm Folder removal', ...
            'Yes','No','Yes');
        % Handle response
        switch answer
            case 'Yes'
                rmdir m s
            case 'No'
                warning('off','MATLAB:MKDIR:DirectoryExists')
                disp('Warning: overwriting files')
        end
    end

    currentFolder = pwd;
    mFolders=fullfile('m',erase(unique({mlxFiles.folder}),currentFolder));
    for i=1:length(mFolders)
    mkdir(mFolders{i})
    end

    %% start conversion
    mFiles=mlxFiles;
    for i=1:length(mlxFiles)

        mlxFiles(i).path=fullfile(mlxFiles(i).folder, mlxFiles(i).name);
        if rename
            mFiles(i).path=fullfile('m',erase(mlxFiles(i).folder,currentFolder),[mlxFiles(i).name(1:end-4),'M.m']);
            % adds an M to the end to avoid conflicts
        else
            mFiles(i).path=fullfile('m',erase(mlxFiles(i).folder,currentFolder),[mlxFiles(i).name(1:end-4),'.m']);
        end

        matlab.internal.liveeditor.openAndConvert(mlxFiles(i).path,mFiles(i).path)

        % progress bar:
        per=floor(i/length(mlxFiles)*100);
        fprintf([repmat('.',1,round(per/2)),'%d%%',repmat('.',1,round(per/2)),'|\n'],per)
    end

    disp('finished')

end
