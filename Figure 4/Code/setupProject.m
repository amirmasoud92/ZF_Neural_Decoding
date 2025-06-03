function paths = setupProject(startDir)
% SETUPPROJECT  Find project folders (Code / Data / Utils) and update path.
%
%   paths = setupProject          % start search at the folder containing this file
%   paths = setupProject(pwd)     % start search at current working directory
%
% RETURNS
%   paths.code   – absolute path to the Code   folder
%   paths.data   – absolute path to the Data   folder
%   paths.utils  – absolute path to the Utils  folder
%   paths.root   – absolute path to the project root
%
% SIDE EFFECTS
%   Adds `Utils` (recursively) to the MATLAB path.
%   Changes working directory to `Code` (comment out `cd` line if unwanted).

    %% Decide where to begin the upward search ---------------------------
    if nargin == 0 || isempty(startDir)
        % Folder that *this* function lives in:
        startDir = fileparts(mfilename('fullpath'));
    end
    startDir = char(startDir);   % ensure char (handles string inputs)

    %% Walk upward until a "Code" folder is found -------------------------
    currentDir = startDir;
    while true
        candidate = fullfile(currentDir, 'Code');
        if exist(candidate, 'dir')
            break   % <-- found it!
        end

        % Move one level up; stop if we reach the filesystem root
        parentDir = fileparts(currentDir);
        if isempty(parentDir) || strcmp(parentDir, currentDir)
            error('setupProject:NotFound', ...
                  'No "Code" directory was found above "%s".', startDir);
        end
        currentDir = parentDir;
    end

    %% Build the full set of project paths --------------------------------
    paths.code  = candidate;
    paths.root  = currentDir;
    paths.data  = fullfile(currentDir, 'Data');
    paths.utils = fullfile(currentDir, 'Utils');

    %% Safety checks ------------------------------------------------------
    assert(exist(paths.data,  'dir') == 7, '"Data" folder is missing.');
    assert(exist(paths.utils, 'dir') == 7, '"Utils" folder is missing.');

    %% Put Utils on the MATLAB path (recursively) -------------------------
    addpath(genpath(paths.utils));

    %% Make Code the current folder (optional) ----------------------------
    cd(paths.code);

    %% Nice-to-know --------------------------------------------------------
    fprintf('[setupProject] Project root : %s\n', paths.root);
    fprintf('[setupProject] Code  folder : %s\n', paths.code);
    fprintf('[setupProject] Data  folder : %s\n', paths.data);
    fprintf('[setupProject] Utils folder : %s\n', paths.utils);
end
