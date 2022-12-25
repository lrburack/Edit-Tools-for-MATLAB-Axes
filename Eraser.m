classdef Eraser < AxesTool
    properties
        user_action_triggers = ["WindowButtonDownFcn", ...
            "obj.startErasing(obj.mousePosition())",...
            "WindowButtonUpFcn", "obj.endErasing", "WindowButtonMotionFcn", ...
            "obj.updateEraser(obj.mousePosition())"]
        
%         brush_container = UniformGraphicsContainer({'Color', 'b', 'LineWidth', .5})
        
        % value from 0 to 1 as a fraction of a visual field
        radius = .1
        
        cursor_container = UniformGraphicsContainer({'Curvature', [1,1], ...
            'FaceColor', [1 0 0 .4], 'EdgeColor', [1 0 0 .3], "Tag", "selectionUI"}, "rectangle")
        eraser_active = false;
    end
    
    methods (Access = public)
        function obj = Eraser(axes)
            obj@AxesTool(axes);
        end
        
        function startErasing(obj, position)
            if obj.eraser_active == true
                return;
            end
            obj.eraser_active = true;
            obj.updateEraser(position)
        end
        
        function endErasing(obj)
            obj.eraser_active = false;
            obj.cursor_container.deleteAll();
        end

        function updateEraser(obj, position)
            if ~obj.eraser_active
                return;
            end

            eraseable = findobj(obj.axes, "-property", "XData", "-property", "YData");
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

            for i = 1:length(eraseable)
                x = eraseable(i).XData;
                y = eraseable(i).YData;
                keep = ones(1, length(x));
                for ii = 1:length(x)
                    if Eraser.inElipse(x(ii), position(1), xrad, y(ii), position(2), yrad)
                        keep(ii) = 0;
                    end
                end
                f = find(keep == 1);
                eraseable(i).XData = eraseable(i).XData(f);
                eraseable(i).YData = eraseable(i).YData(f);

            end
        end
    end

    methods (Static)
        function inside = inElipse(x, h, rx, y, k, ry)
            inside = ((x - h) ^ 2 / rx ^ 2 + (y - k) ^ 2 / ry ^ 2) < 1;
        end
    end
end