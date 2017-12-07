#!/usr/bin/osascript

-- set l to {"eita", "cana", "bora", "pra", "cima"}

-- set idx to 1

-- repeat while idx <= length of l
-- 	if idx < length of l
-- 		log (item idx of l) & (item (idx+1) of l)
-- 	else
-- 		log (item idx of l)
-- 	end if
-- 	set idx to idx + 2
-- end repeat

set eita to "abababa"

on numOccurences(textVal, charVal)
	set ans to 0
	repeat with c in textVal
		if (c as string) = charVal
			set ans to (ans + 1)
		end if
	end repeat
	return ans
end numOccurences

-- log "haha"
log numOccurences("\n\n\naaa\n", "\n")



-- on getListFromFile(listName, maxPerString)
-- 	set ans to {}
-- 	set foo to (open for access (POSIX file ("raw/" & listName & ".txt")))
-- 	set txt to paragraphs of (read foo for (get eof foo) as «class utf8»)
-- 	set curCount to 0
-- 	set cur to ""
-- 	repeat with nextLine in txt
-- 		if length of nextLine > 0
-- 			if curCount = maxPerString
-- 				set curCount to 0
-- 				if length of cur > 0
-- 					set ans to (ans & {cur})
-- 					set cur to ""
-- 				end if
-- 			end if
-- 			if length of cur > 0
-- 				set cur to (cur & "\n")
-- 			end if
-- 			set cur to (cur & nextLine)
-- 			set curCount to (curCount + 1)
-- 		end if
-- 	end repeat
-- 	close access foo
-- 	if length of cur > 0
-- 		set ans to (ans & {cur})
-- 	end if	
-- 	return ans
-- end getListFromFile


-- set ret to getListFromFile("ioi", 3)
-- repeat with haha in ret
-- 	log haha & ":"
-- end repeat


-- on getTokens(txt, delimiter)
-- 	set ans to {}
-- 	set cur to ""
-- 	set tokenNum to 0
-- 	repeat with c in txt
-- 		if c as string = delimiter
-- 			if length of cur is greater than 0 and not (cur = "HM")
-- 				set tokenNum to tokenNum + 1
-- 				if not tokenNum = 2
-- 					copy cur to the end of ans
-- 				end if
-- 			end if
-- 			set cur to ""
-- 		else
-- 			set cur to cur & c
-- 		end if
-- 	end repeat
-- 	if length of cur is greater than 0
-- 		copy cur to the end of ans
-- 	end if
-- 	return ans
-- end getTokens

-- on getRevWinnersList(category)
-- 	set ans to {}
-- 	set foo to (open for access (POSIX file ("raw/" & category & ".txt")))
-- 	set txt to paragraphs of (read foo for (get eof foo) as «class utf8»)
-- 	set kMedals to {"GOLD", "SILVER", "BRONZE", "HM"}
-- 	set curMedalIdx to 0
-- 	repeat with nextLine in txt
-- 		if length of nextLine is greater than 0 then
-- 			set tokens to {item (curMedalIdx+1) of kMedals} & getTokens(nextLine, "\t")
-- 			copy tokens to the end of ans
-- 			set ans to ans & {tokens}
-- 		else
-- 			set curMedalIdx to (curMedalIdx + 1) mod 4
-- 		end if
-- 	end repeat
-- 	close access foo
-- 	return reverse of ans
-- end getRevWinnersList


-- on getWinnerDesc(info)
-- 	set ans to (item 3 of info)
-- 	set ans to ans & ("\n" & (item 4 of info) & " - " & (item 5 of info) & "/" & (item 6 of info))
-- 	set ans to ans & ("\n(" & (item 2 of info) & "º Lugar)")
-- 	return ans
-- end getRevWinnersList

-- repeat with x in getRevWinnersList("p2")
-- 	log getWinnerDesc(x) & "\n"
-- end repeat





