%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function m2mlx(method, rename, varargin)
    %% Converts m files to mlx files
    % `mlx2m(method, rename, foldersWithSubFolder, foldersWithoutSubFolder)`
    % 
    % # Arguments:
    % `m2mlx(method::String, rename::Bool, [folders::Array{String}/Cell{Char}],[folders::Array{String}/Cell{Char}])`
    %
    %  - method: can be `"all","all_exclude","specific","GUI_all","GUI_specific"`
    %  - folders (optional):
    %   - if method is `"all_exclude"`: pass the folder names that should be excluded
    %   - if method is `"specific"`: pass the folder names that should be included.
    %       - 3rd argument are the folders that their subfolders are considered
    %       - 4th argument are the folders that their subfolders are ignored.
    %
    %  Folders specified can have a relative as well as absolute path.
    %
    % # Example
    % Choose the method, and run the function.
    % ```matlab
    % m2mlx("all", true);
    % ```
    %
    % Pass a 2nd and 3rd input to include/exclude specific folders if you chose "all_exclude" or "specificFolders"
    % ```matlab
    % m2mlx("specified", true, ["Functions"],[pwd]);
    % m2mlx("specified", true, ["Functions"],[]);
    % m2mlx("exclude", true, ["Functions"],[]);
    % ```

    disp("m to mlx conversion started")
    %% files collect

    % '**/*.m' % means all under that folder
    % '*.m' % means only files in the root folder

    switch method

        % To include all
        case 'all'
            mFiles=dir('**/*.m');

        case 'all_exclude'
            mFiles=dir('**/*.m');

            % folders with their subfolders to be excluded
            excludedFoldersWSub = varargin{1};

            if ~isempty(excludedFoldersWSub)
                % 1
                mFiles = dir(fullfile([excludedFoldersWSub(i),"**/*.m"]));
                % 2:end
                for i=2:length(excludedFoldersWSub)
                    mFiles = [mFiles; dir(fullfile([excludedFoldersWSub(i),"**/*.m"]))];
                end
            end

            % folders without their subfolders to be excluded
            if nargin == 2
                excludedFoldersWOSub = varargin{2};

                if ~isempty(excludedFoldersWOSub)
                    for i=1:length(excludedFoldersWOSub)
                        mFiles = [mFiles; dir(fullfile([excludedFoldersWOSub(i),"*.m"]))];
                    end
                end
            end

            % excluding files of that folder
            removeList=zeros(size(mFilesExclude));
            iRem=1;
            for i=1:size(mFiles,1)
                if  ismember({mFiles(i).folder},{mFilesExclude(:).folder})
                    removeList(iRem)=i;
                    iRem=iRem+1;
                end
            end

            mFiles(removeList)=[];

        % To include all under a folder with GUI
        case 'GUI_all'
            d = uigetdir(pwd, 'Select a folder');
            mFiles = dir(fullfile(d, '**/*.m'));

        % To include a specific folder with GUI
        case 'GUI_specific'
            d = uigetdir(pwd, 'Select a folder');
            mFiles = dir(fullfile(d, '*.m'));

            while d~=0  % continue until user press cancel
                d = uigetdir(pwd, 'Select a folder');
                mFiles = [mFiles;dir(fullfile(d, '*.m'))];
            end

        % To include specific folders
        case 'specific'

            % folders with their subfolders
            includedFoldersWSub = varargin{1};

            if ~isempty(includedFoldersWSub)
                % 1
                mFiles = dir(fullfile([includedFoldersWSub(i),"**/*.m"]));
                % 2:end
                for i=2:length(includedFoldersWSub)
                    mFiles = [mFiles; dir(fullfile([includedFoldersWSub(i),"**/*.m"]))];
                end
            end

            % folders without their subfolders
            if nargin == 2
                includedFoldersWOSub = varargin{2};

                if ~isempty(includedFoldersWOSub)
                    for i=1:length(includedFoldersWOSub)
                        mFiles = [mFiles; dir(fullfile([includedFoldersWOSub(i),"*.m"]))];
                    end
                end
            end
    end


    %% create m folder and folder structure for storing files
    if isfolder('mlx')
        %     disp('Warning: m folder already exists!')
        %     warning('off','MATLAB:MKDIR:DirectoryExists')
        answer = questdlg('mlx folder already exists. Do you want to remove it? ', ...
        'm Folder removal', ...
        'Yes','No','Yes');
        % Handle response
        switch answer
        case 'Yes'
            rmdir mlx s
        case 'No'
            warning('off','MATLAB:MKDIR:DirectoryExists')
            disp('Warning: overwriting files')
        end
    end

    currentFolder = pwd;
    mFolders=fullfile('mlx',erase(unique({mFiles.folder}),currentFolder));
    for i=1:length(mFolders)
        mkdir(mFolders{i})
    end

    %% start conversion
    mlxFiles=mFiles;
    for i=1:length(mFiles)

        mFiles(i).path=fullfile(mFiles(i).folder, mFiles(i).name);
        if rename
            % adds an M to the end to avoid conflicts
            mlxFiles(i).path=fullfile('mlx',erase(mFiles(i).folder,currentFolder),[mFiles(i).name(1:end-4),'M.mlx']);
        else
            mlxFiles(i).path=fullfile('mlx',erase(mFiles(i).folder,currentFolder),[mFiles(i).name(1:end-4),'.mlx']);
        end

        matlab.internal.liveeditor.openAndSave(mFiles(i).path,mlxFiles(i).path)

        % progress bar:
        per=floor(i/length(mFiles)*100);
        fprintf([repmat('.',1,round(per/2)),'%d%%',repmat('.',1,round(per/2)),'|\n'],per)
    end

    disp("finished")

end
