classdef BrushSelector < Selector
    properties
        user_action_triggers = ["WindowButtonDownFcn", "obj.startSelection(obj.mousePosition())",...
            "WindowButtonUpFcn", "obj.endSelection", "WindowButtonMotionFcn", ...
            "obj.updateSelection(obj.mousePosition())"]
        
        % value from 0 to 1 as a fraction of a visual field
        radius = .1
        
        cursor_container = UniformGraphicsContainer({'Curvature', [1,1], ...
            'FaceColor', [1 0 0 .4], 'EdgeColor', [1 0 0 .3], "Tag", "selectionUI"}, "rectangle")
        brush_selection_active
    end
    
    methods (Access = public)
        function obj = BrushSelector(axes)
            obj@Selector(axes);
            obj.brush_selection_active = false;
        end
        
        function startSelection(obj, position)
            if obj.brush_selection_active == true
                return;
            end
            obj.brush_selection_active = true;
            obj.clearSelection();
            obj.updateSelection(position)
        end
        
        function endSelection(obj)
            obj.brush_selection_active = false;
            obj.cursor_container.deleteAll();
        end

        % add new points to the selection array and then update the ui
        function updateSelection(obj, position)
            if ~obj.brush_selection_active
                return;
            end

            selectable = obj.selectable();
            xrad = .5 * obj.radius * (obj.axes.XLim(2) - obj.axes.XLim(1)) * 1/(obj.axes.PlotBoxAspectRatio(1));
            yrad = .5 * obj.radius * (obj.axes.YLim(2) - obj.axes.YLim(1)) * 1/(obj.axes.PlotBoxAspectRatio(2));
            
            % prevent brush from going over the edge of the screen
            fudge = .000001;
            if position(1) - xrad <= obj.axes.XLim(1)
                position(1) = obj.axes.XLim(1) + xrad + fudge;
            elseif position(1) + xrad >= obj.axes.XLim(2)
                position(1) = obj.axes.XLim(2) - xrad - fudge;
            end
            if position(2) - yrad <= obj.axes.YLim(1)
                position(2) = obj.axes.YLim(1) + yrad + fudge;
            elseif position(2) + yrad >= obj.axes.YLim(2)
                position(2) = obj.axes.YLim(2) - yrad - fudge;
            end

            obj.cursor_container.deleteAll();
            obj.cursor_container.addGraphic(obj.axes, "Position", [position(1) - xrad, position(2) - yrad, 2 * xrad, 2 * yrad])

            for i = 1:length(selectable)
                x = selectable(i).XData;
                y = selectable(i).YData;
                for ii = 1:length(x)
                    if BrushSelector.inElipse(x(ii), position(1), xrad, y(ii), position(2), yrad)
                        selectable(i).selection(ii) = 1;
                    end
                end
            end

            obj.updateSelectionUI(selectable);
        end
    end

    methods (Static)
        function inside = inElipse(x, h, rx, y, k, ry)
            inside = ((x - h) ^ 2 / rx ^ 2 + (y - k) ^ 2 / ry ^ 2) < 1;
        end
    end
end