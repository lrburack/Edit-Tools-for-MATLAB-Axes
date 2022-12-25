classdef SelectionUI < dynamicprops & matlab.mixin.SetGet
    properties
        point_container = UniformGraphicsContainer({'MarkerEdgeColor', 'r', ...
            'MarkerEdgeAlpha', .4, 'MarkerFaceColor', 'r', 'MarkerFaceAlpha', .3, ...
            'SizeData', 22, "Tag", "selectionUI"}, "scatter")
        line_container = UniformGraphicsContainer({'Color', [1 0 0 .2] , ...
            'LineWidth', 6, "Tag", "selectionUI"})
    end

    methods (Access = public)
        function obj = SelectionUI()
            % Empty constructor
        end

        function deleteAll(obj)
            prop_vals = struct2cell(get(obj));
            for i = 1:length(prop_vals)
                if isa(prop_vals{i}, "GraphicsContainer")
                    prop_vals{i}.deleteAll();
                else
                    delete(prop_vals{i});
                end
            end
        end
    end
end