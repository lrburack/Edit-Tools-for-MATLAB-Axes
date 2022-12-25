classdef Selector < AxesTool
    
    methods (Access = public)
        function obj = Selector(axes)
            obj@AxesTool(axes);
            
            % Add a selectionUI object to the axes if its not already there
            addpropsafe(axes, "selectionUI", SelectionUI());
        end

        function selectable_objects = selectable(obj)
            selectable_objects = findobj(obj.axes, "-property", "XData", ...
                "-and", "-property", "YData", "-not", "Tag", "selectionUI");
            for i = 1:length(selectable_objects)
                addpropsafe(selectable_objects, "selection", ...
                    zeros(1, length(selectable_objects(i).XData)));
            end
        end

        function select(obj, target_objects, x, y)
            for i = 1:length(target_objects)
                % Add the selection property to all passed objects
                addpropsafe(target_objects(i), "selection", zeros(1, length(target_objects(i).XData)));

                mask = bitor(target_objects(i).selection(:),...
                    bitand(ismember(target_objects(i).XData(:), x(:)), ...
                    ismember(target_objects(i).YData(:), y(:))));
                target_objects(i).selection = mask;
            end

            obj.updateSelectionUI(target_objects);
        end

        function updateSelectionUI(obj, target_objects)
            % Clear the current selectionUI
            obj.axes.selectionUI.deleteAll();

            for i = 1:length(target_objects)
                x = target_objects(i).XData;
                y = target_objects(i).YData;
                s = target_objects(i).selection;
                sinds = find(s == 1);
                % Add the points to the axes
                obj.axes.selectionUI.point_container.addGraphic(obj.axes, x(sinds), y(sinds));
                
                % The line selectionUI is used for adjacent selected datapoints
                start_ind = find(s == 1, 1);
                while ~isempty(start_ind)
                    end_ind = start_ind + find(s(start_ind:end) == 0, 1) - 2;
    
                    % If it didn't find a zero that means the rest of the data
                    % is selected
                    if isempty(end_ind)
                        obj.axes.selectionUI.line_container.addGraphic(obj.axes,...
                            x(start_ind:end), y(start_ind:end));
                        break;
                    end
                    
                    % If there is more than one connected point
                    if end_ind - start_ind > 0
                        obj.axes.selectionUI.line_container.addGraphic(obj.axes,...
                            x(start_ind:end_ind), y(start_ind:end_ind));
                    end
                    
                    start_ind = end_ind + find(s(end_ind + 1:end) == 1, 1);
                end
            end
        end
        
        function clearSelection(obj)
            selectable = obj.selectable();
            for i = 1:length(selectable)
                selectable(i).selection = zeros(length(selectable(i).XData), 1);
            end
            obj.axes.selectionUI.deleteAll();
        end

        function [x, y] = getSelectionXY(obj)
            selectable = obj.selectable();
            pos = [];
            for i = 1:length(selectable)
                spos =  [selectable.XData(selectable.selection),...
                    selectable.YData(selectable.selection)];

                vertcat(pos, spos);
            end

            if isempty(pos)
                x = [];
                y = [];
                return;
            end
            
            pos = unique(pos);
            x = pos(1, :);
            y = pos(2, :);
        end
    end
end