classdef UniformGraphicsContainer < GraphicsContainer
    properties
        appearance = {}
        graphics_function = "plot";
    end

    methods (Access = public)
        function obj = UniformGraphicsContainer(appearance, varargin)
            obj.appearance = appearance;
            if ~isempty(varargin)
                obj.graphics_function = convertCharsToStrings(varargin{:});
            end
        end

        function addGraphic(obj, varargin)
            graphic = eval(obj.graphics_function + "(varargin{:}, obj.appearance{:})");
            obj.graphics{end + 1} = graphic;
        end
    end
end