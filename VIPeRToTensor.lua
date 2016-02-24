require 'torch'


local function convertVIPeRToTorchTensor(folderPath, outputFile)

	local samplesNum = 0
	local camA = {}
	for imgName in io.popen("ls " .. folderPath .. "cam_a/"):lines() do
		local class = string.gmatch(imgName, "%w+")();
		camA[class] = imgName
		samplesNum = samplesNum + 1
	end

	local camB = {}
	for imgName in io.popen("ls " .. folderPath .. "cam_b/"):lines() do
		local class = string.gmatch(imgName, "%w+")();
		camB[class] = imgName
		samplesNum = samplesNum + 1
	end

	local label = torch.IntTensor(samplesNum)
	local data = torch.ByteTensor(samplesNum, 3, 128, 48)

	local index = 1
	for class, imgName in pairs(camA) do
		local imgA = torch.DiskFile(folderPath .. "cam_a/" .. imgName, 'r'):binary()
		local imgB = torch.DiskFile(folderPath .. "cam_b/" .. camB[class], 'r'):binary()
		imgA:seek(1)
		imgB:seek(1)
		label[index] = tonumber(class)
		label[index + 1] = tonumber(class)
		local store1 = imgA:readByte(3*128*48)
		local store2 = imgB:readByte(3*128*48)
		data[index]:copy(torch.ByteTensor(store1))
		data[index + 1]:copy(torch.ByteTensor(store2))
		index = index + 2
		imgA:close()
		imgB:close()
	end

	local out = {}
	out.data = data
	out.label = label
	print(out)
	torch.save(outputFile, out)
end

local folderPath = "./"

os.execute('wget -c http://soe.ucsc.edu/~manduchi/VIPeR.v1.0.zip')
os.execute('unzip  ' .. folderPath .. 'VIPeR.v1.0.zip')


convertVIPeRToTorchTensor(folderPath .. "VIPeR/", folderPath .. 'VIPeR.t7')
