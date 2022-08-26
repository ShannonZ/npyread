%npyinfo('F:\Python\CS-Recon\g.npy');
function info = npyinfo(filename)
%function info = npyinfo(filename) Read metadata from npy file header
% Input:
%¡¡filename - Name of the NPY file, specified as a character vector or string scalar.
%
% Output:
%  info     - NPY metadata, returned as a structure.
%
% Ref: https://numpy.org/devdocs/reference/generated/numpy.lib.format.html


try
    fid = fopen(filename);
    dtypesMatlab = {'uint8','uint16','uint32','uint64','int8','int16','int32','int64','single','double', 'logical', 'complex8', 'complex16'};
    dtypesNPY = {'u1', 'u2', 'u4', 'u8', 'i1', 'i2', 'i4', 'i8', 'f4', 'f8', 'b1', 'c8', 'c16'};
    
    %The first 6 bytes are a magic string: exactly \x93NUMPY.
    info.MagicString = fread(fid, [1,6], 'uint8=>char*1');
    
    if ~strcmp(info.MagicString(2:end),'NUMPY')
        error('npyinfo:InvalidFileType', ['Error: ',filename,' is not a npy-formated file']);
    end
    
    info.MajorVersion = fread(fid, 1, 'uint8'); %  unsigned byte: the major version number of the file format, e.g. \x01.
    info.MinorVersion = fread(fid, 1, 'uint8'); %  unsigned byte: the minor version number of the file format, e.g. \x00. 
    
    %2 bytes form a little-endian unsigned short int: the length of the header data HEADER_LEN.
    info.HeaderLength = fread(fid, 1, 'uint16=>uint16');  
    
    % len(magic string) + 2 + len(length) + HEADER_LEN 
    info.TotalHeaderLength = 10+info.HeaderLength;
    
    % The dictionary contains three keys:
    % 
    % ¡°descr¡±dtype.descr
    % An object that can be passed as an argument to the numpy.dtype constructor to create the array¡¯s dtype.
    % 
    % ¡°fortran_order¡±bool
    % Whether the array data is Fortran-contiguous or not. Since Fortran-contiguous arrays are a common form of non-C-contiguity, we allow them to be written directly to disk for efficiency.
    % 
    % ¡°shape¡±tuple of int
    % The shape of the array.
    arrayFormat = fread(fid, [1 info.HeaderLength], 'char=>char');
    fclose(fid);
    
catch me
    fclose(fid);
    rethrow(me);
end

r = regexp(arrayFormat, '''descr''\s*:\s*''(.*?)''', 'tokens');
dtNPY = r{1}{1};    

info.LittleEndian = ~strcmp(dtNPY(1), '>');

info.DataType = dtypesMatlab{strcmp(dtNPY(2:end), dtypesNPY)};

r = regexp(arrayFormat, '''fortran_order''\s*:\s*(\w+)', 'tokens');
info.FortranOrder = strcmp(r{1}{1}, 'True');

r = regexp(arrayFormat, '''shape''\s*:\s*\((.*?)\)', 'tokens');
info.ArrayShape = sscanf(r{1}{1},'%d,%d')';