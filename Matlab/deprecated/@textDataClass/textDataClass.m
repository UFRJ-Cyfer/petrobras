classdef textDataClass
    %TEXTDATACLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        textStruct
        pathname
        filename
        CP
        separationIndexes
    end
    methods
        function obj = textDataClass(pathname, filename, CP, separationIndexes)
            if nargin > 3
                obj.pathname = pathname;
                obj.filename = filename;
                obj.CP = CP;
                obj.separationIndexes = separationIndexes;
                obj = obj.readTXTFile;
            else
 
            end
        end
    end
    
end


    