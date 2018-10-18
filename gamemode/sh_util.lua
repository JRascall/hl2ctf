function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function EnsureFolderExists() 
    if file.Exists("hl2ctf", "DATA") == false then
        file.CreateDir("hl2ctf")
    end
end

function EnsureFileExists()
    if file.Exists("hl2ctf/mapdata.txt", "DATA") == false then file.Write("hl2ctf/mapdata.txt", "{}") end
end
