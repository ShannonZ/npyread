%npyread('F:\Python\CS-Recon\g.npy');
function data = npyread(filename)
% Function to read data stored in NPY files into matlab variable.

info = npyinfo(filename);

if info.LittleEndian
    fid = fopen(filename, 'r', 'l');
else
    fid = fopen(filename, 'r', 'b');
end

try
    shape = info.ArrayShape;
    fread(fid, info.TotalHeaderLength, 'uint8');
    if strcmp(info.DataType, "complex8") == 1
        data = fread(fid, prod(shape)*2, 'single=>single');
        data = data(1:2:end) + 1j * data(2:2:end);
    elseif strcmp(info.DataType, "complex16") == 1
        data = fread(fid, prod(shape)*2, 'double=>double');
        data = data(1:2:end) + 1j * data(2:2:end);
    else
        data = fread(fid, prod(shape), [info.DataType '=>' info.DataType.DataType]);
    end

    if length(shape)>1 && ~info.FortranOrder
        data = reshape(data, shape(end:-1:1));
        data = permute(data, length(shape):-1:1);
    elseif length(shape)>1
        data = reshape(data, shape);
    end

    fclose(fid);

catch me
    fclose(fid);
    error('npyread:Error',me.message)
end
