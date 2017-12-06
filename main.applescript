#!/usr/bin/osascript

-- TODO
set kYear to "2017"
set kObiEdition to "XXVII"
set kIcMembers to {{"Prof. Dr. Rodolfo Jardim de Azevedo", "Diretor do Instituto de Computação da Unicamp "}, {"Prof. Dr. Ricardo de Oliveira Anido", "Professor do Instituto de  Computação da Unicamp\n\nCoordenador da OBI" & kYear}}

on getTokens(txt, delimiter)
	set ans to {}
	set cur to ""
	set tokenNum to 0
	repeat with c in txt
		if c as string = delimiter
			if length of cur is greater than 0 and not (cur = "HM")
				set tokenNum to tokenNum + 1
				if not tokenNum = 2
					copy cur to the end of ans
				end if
			end if
			set cur to ""
		else
			set cur to cur & c
		end if
	end repeat
	if length of cur is greater than 0
		copy cur to the end of ans
	end if
	return ans
end getTokens

on getRevWinnersList(category)
	set ans to {}
	set foo to (open for access (POSIX file ("raw/" & category & ".txt")))
	set txt to paragraphs of (read foo for (get eof foo) as «class utf8»)
	set kMedals to {"OURO", "PRATA", "BRONZE", "HONRA AO MÉRITO"}
	set curMedalIdx to 0
	repeat with nextLine in txt
		if length of nextLine is greater than 0 then
			set tokens to {item (curMedalIdx+1) of kMedals} & getTokens(nextLine, "\t")
			set ans to ans & {tokens}
		else
			set curMedalIdx to (curMedalIdx + 1) mod 4
		end if
	end repeat
	close access foo
	return reverse of ans
end getRevWinnersList

on getWinnerDesc(info)
	set ans to (item 3 of info)
	set ans to ans & ("\n" & (item 4 of info) & " - " & (item 5 of info) & "/" & (item 6 of info))
	set ans to ans & ("\n(" & (item 2 of info) & "º Lugar)")
	return ans
end getWinnerDesc

on createTitleAndSubtitleSlide(thisDocument, title, subtitle)
	tell application "Keynote"
		activate
		tell thisDocument
			set thisSlide to ¬
				make new slide with properties {base slide:master slide "Title & Subtitle"}
			tell thisSlide
				set the object text of the default title item to title
				set the object text of the default body item to subtitle
			end tell
		end tell
	end tell	
end createTitleAndSubtitleSlide

on createTitleAndBulletsSlide(thisDocument, title, body)
	tell application "Keynote"
		activate
		tell thisDocument
			set thisSlide to ¬
				make new slide with properties {base slide:master slide "Title & Bullets"}
			tell thisSlide
				set the object text of the default title item to title
				set the object text of the default body item to body
			end tell
		end tell
	end tell	
end createTitleAndBulletsSlide

on createSlidesOfCategory(thisDocument, curCat, winnersList)
	tell application "Keynote"
		activate
		tell thisDocument
			set winnersCount to length of winnersList
			set idx to 1
			set curMedal to ""
			set curMedalLabel to ""
			set curCatLabel to "MODALIDADE " & curCat
			set thisSlide to ¬
				make new slide with properties {base slide:master slide "Title - Center"}
			tell thisSlide
				set the object text of the default title item to curCatLabel
			end tell
			repeat while idx <= winnersCount
				set newMedal to (item 1 of (item idx of winnersList))
				if not newMedal = curMedal
					set curMedal to newMedal
					set curMedalLabel to "MEDALHA DE " & curMedal
					my createTitleAndSubtitleSlide(thisDocument, curMedalLabel, curCatLabel)
				end if
				set title to (curMedalLabel & "\n" & curCatLabel)
				set body to my getWinnerDesc(item idx of winnersList)
				if idx < winnersCount and (item 1 of (item (idx+1) of winnersList)) = curMedal
					set body to (body & "\n" & my getWinnerDesc(item (idx+1) of winnersList)) -- TODO fix spaces
					set idx to (idx+1)
				end if
				my createTitleAndBulletsSlide(thisDocument, title, body)
				set idx to (idx + 1)
			end repeat
		end tell
	end tell	
end createSlidesOfCategory

tell application "Keynote"
	activate
	set thisDocument to ¬
		make new document with properties {document theme:theme "awards_template"}
	tell thisDocument
		-- cover
		set the base slide of the first slide to master slide "Title & Bullets"
		tell first slide
			set the object text of the default title item to "OBI" & kYear
			set the object text of the default body item to kObiEdition & " Olimpíada Brasileira de Informática"
		end tell

		-- ic members
		repeat with icMember in kIcMembers
			my createTitleAndSubtitleSlide(thisDocument, item 1 of icMember, item 2 of icMember)
		end repeat

		-- medals
		repeat with catEntry in {{"INICIAÇÃO NÍVEL 1", "ini1"}, {"INICIAÇÃO NÍVEL 2", "ini2"}}
			set cat to (item 1 of catEntry)
			set winnersList to my getRevWinnersList(item 2 of catEntry)
			my createSlidesOfCategory(thisDocument, cat, winnersList)
		end repeat

	end tell
end tell




-- set thisSlide to ¬
-- 	make new slide with properties {base slide:master slide "Title & Bullets"}
-- tell thisSlide
-- 	set the object text of the default title item to "TITLE"
-- 	set the object text of the default body item to ¬
-- 		"Bullet Point 1" & return & "Bullet Point 2" & return & "Bullet Point 3"

-- tell application "Keynote"
-- 	activate
-- 	if not (exists document 1) then error number -128
-- 	tell front document
-- 		make new slide at after the last slide
-- 	end tell
-- end tell