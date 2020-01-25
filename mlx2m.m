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

