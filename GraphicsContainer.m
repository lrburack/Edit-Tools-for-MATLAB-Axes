classdef GraphicsContainer < handle
    properties
        graphics
    end

    methods
        function obj = GraphicsContainer()
            obj.graphics = {};
        end

        function addGraphic(obj, graphics_obj)
            obj.graphics{end + 1} = graphics_obj;
        end

        function deleteAll(obj)
            for i = 1:length(obj.graphics)
                delete(obj.graphics{i});
            end
            obj.graphics = {};
        end
    end
end