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
