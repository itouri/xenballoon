@domNumArray = []
@domParamArray = Array.new(10).map{Array.new(4,0)}
@returnArray = []

#OK!
def getDomNum
	str = `#{"xm list | sed 's/  */ /' | cut -f2 -d' ' | sed 's/ID//g' | sed 's/0//g'"}`
	@domNumArray = str.split(" ")
end

#using only DEBUG!
def DEBUG_printDomParamArray

	for a in @domNumArray
		a = a.to_i
		b = 0
		while b < 4
			print("[" + a.to_s + "]");print("[" + b.to_s + "]")
			print(@domParamArray[a][b])
			print("\n")
		b = b + 1
		end
	end
end

#OK!
#get 4 params from each DomU and set to domParamArray that 
#formatted domParamArray[domID][Comitted_AS,cacheHitRate,netWorkIn,netWorkOut]
def getParams
	for i in @domNumArray
		cmdArray = []
		cmdArray.push("xenstore-read /local/domain/" + i + "/xenbalInfo/Comitted_AS")
		cmdArray.push("xenstore-read /local/domain/" + i + "/xenbalInfo/cacheHitRate")
		cmdArray.push("xenstore-read /local/domain/" + i + "/xenbalInfo/netWorkIn")
		cmdArray.push("xenstore-read /local/domain/" + i + "/xenbalInfo/netWorkOut")

		k = 0
		while k < 4
			cmd = cmdArray[k]
			i = i.to_i
			#num = @domNumArray[i]
			#num = num.to_i
			#print(cmd+"\n")
			@domParamArray[i][k] = `#{cmd}`.to_i
		k = k + 1
		end
	end
	DEBUG_printDomParamArray()
end

#OK!
def calcAllocMem
	for i in @domNumArray do
		i = i.to_i
		as = @domParamArray[i][0].to_i
		hr = @domParamArray[i][1].to_i
		ni = @domParamArray[i][2].to_i
		no = @domParamArray[i][3].to_i

		result = as + hr + ni + no

		@returnArray[i] = result
		#print(result);print("\n")
	end

end

#OK!
def sendParams
	for i in @domNumArray do
		cmd = "xenstore-write /local/domain/" + i + "/xenbalInfo/allocMem "
		i = i.to_i
		#cmd = cmd + "check"
		cmd = cmd + @returnArray[i].to_s
		`#{cmd}`
	end
end

#main

getDomNum()
#while 1 do

	getParams()
	calcAllocMem()
	sendParams()

	#sleep(1)
#end