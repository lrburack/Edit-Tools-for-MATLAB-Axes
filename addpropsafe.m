function addpropsafe(obj, propname, value)
    try
        addprop(obj, propname);
    catch
        return;
    end

    set(obj, propname, value)
end

