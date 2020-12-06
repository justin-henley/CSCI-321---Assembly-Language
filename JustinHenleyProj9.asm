COMMENT ! 
	Project:		JustinHenleyProj9.asm
	Description:	Solution to Project 9, A String Find Procedure
	Course:			CSCI 321 VA 2020F
	Author:			Justin Henley, jahenley@mail.fhsu.edu
	Date:			2020-11-29
!

; NOTE: I met the requirements of the extra credit assignment

COMMENT !
	Problem Description:
		Write a procedure named Str_find that searches for the first matching occurrence 
		of a source string inside a target string and returns the matching position. 
		The input prameters should be a pointer to the source string and a point to 
		the target string. If a match is found, the procedure sets the Zero flag and 
		EAX points to the matching position in the target string. Otherwise, the Zero flag
		is clear and EAX is undefined.

	Extra Credit:

		You may notice that in my solution, I only take lower case y/n because I used “call 
		ReadChar” and “call WriteChar” to get the user’s choice and display the user’s choice.
		If user try to type capital Y, the program will exit since it will read the “shift” 
		key as user’s input. Any input different from lower case y will be consider a NO 
		choice

		Modify your solution so that it all handle the following two cases:
		1.	If can take upper case letter as user’s choice
		2.	If user’s choice is NOT Y, y, N, or n, prompt error message and ask user to 
			reenter choice.
!

INCLUDE Irvine32.inc

; Function prototypes
GetString			PROTO,	buffer:PTR BYTE, max:DWORD,	prompt:PTR BYTE
Str_Find			PROTO,	src:PTR BYTE, tar:PTR BYTE
Substr_Cmp			PROTO,	src:PTR BYTE, srcLen:DWORD, tar:PTR BYTE


.data
STRING_MAX = 100									; max chars for each string
sourceString	BYTE	STRING_MAX+1 DUP(?)			; the string being searched for, with room for null terminator
targetString	BYTE	STRING_MAX+1 DUP(?)			; the string being searched, which may or may not contain the source string
promptSource	BYTE	"Enter source string (the string to search for): ",0
promptTarget	BYTE	"Enter target string (the string to search from): ",0
promptRepeat	BYTE	"Do you want to do another search? Y/n: ",0
promptFoundA	BYTE	"Source string found at position ",0
promptFoundB	BYTE	" in Target string (counting from zero).",0
promptNotFound	BYTE	"Source string was not found in target string.",0
repeatChoice	BYTE	2 DUP(?)					; Room for a single character choice and null terminator
validYes		BYTE	"yY",0
validNo			BYTE	"nN",0						; For extra-credit repeat input checking, a cheap imitation of regex
invalidChoice	BYTE	"Error: Invalid Choice",0	; Error message before reprompt

.code
main PROC
begin:
	; Prompt user for source and target strings
	INVOKE GetString, ADDR sourceString, STRING_MAX, ADDR promptSource
	INVOKE GetString, ADDR targetString, STRING_MAX, ADDR promptTarget

	; Search for target within source
	INVOKE Str_Find, ADDR sourceString, ADDR targetString
	jnz notFound

	; Print index of found string
	mov edx,OFFSET promptFoundA
	call WriteString
	call WriteDec
	mov edx,OFFSET promptFoundB
	call WriteString
	call Crlf
	jmp again

	; String was not found
notFound:	
	mov edx,OFFSET promptNotFound
	call WriteString
	call Crlf

	; Prompt for repeat
	; Meets requirements of extra credit assignment
again:
	call Crlf
	INVOKE GetString, ADDR repeatChoice, 2, ADDR promptRepeat	; Prompt user for choice to repeat or not
	call Crlf
	INVOKE Str_Find, ADDR repeatChoice, ADDR validYes			; Check if choice is 'y' or 'Y'
	je begin													; If so, repeat
	INVOKE Str_Find, ADDR repeatChoice, ADDR validNo			; Otherwise, check if choice is 'n' or 'N'
	je last														; If so, jump to end of program
	mov edx,OFFSET invalidChoice								
	call WriteString											; Warn user of invalid input
	jmp again													; Reprompt until user gives valid response
			
last:															

main ENDP



;--------------------------------------
; GetString
;
; Stores a user-entered string to the given char array
;
; Receives:	buffer, the address of the string buffer
;			max, the maximum size of the string
;			prompt, the prompt for the user to enter the string
; Requires:	Nothing
; Returns:	Nothing
; Postcondition:	The string buffer has been filled with the user-entered string 
;---------------------------------------
GetString PROC USES ecx edx,
	buffer:PTR BYTE,
	max:DWORD,
	prompt:PTR BYTE
	
	; Display the prompt for input
	mov edx,prompt
	call WriteString

	; Take user input up to the maximum size
	mov edx,buffer
	mov ecx,max
	call ReadString

	ret
GetString ENDP


;--------------------------------------
; Str_Find
;
; Searches for the source string within the target string
;
; Receives: src, the string to search for
;			tar, the string being searched within
; Requires: Str_Length, Substr_Cmp
; Postcondition:	If the source string was found within the target string, ZF=1 and EAX = index of first char of found string
;					If not found, ZF = 0 and EAX = undefined
;---------------------------------------
Str_Find PROC,
	src:PTR BYTE,
	tar:PTR BYTE

	mov esi,src				; ESI = src[0]
	mov edi,tar				; EDI = tar[0]
	INVOKE Str_Length, src	
	mov ebx,eax				; EBX = src length
	INVOKE Str_Length, tar
	mov ecx,eax				; ECX = tar length

	; Guard clauses
	cmp ebx,0
	je noMatch					; exit if src length == 0
	cmp ecx,0	
	je noMatch					; exit if tar length == 0
	cmp ebx,ecx
	ja noMatch					; exit if src is longer than tar, no possible match
	cmp ebx,ecx
	jne L1						; go to search if tar is longer than src 
	INVOKE Str_Compare, src,tar	; special search if src length == tar length
	je specialMatch				; if equal, match found
	jmp noMatch					; else, no match possible


L1:
	; Search character, by character until match of src[0] found
	sub ecx,ebx				
	inc ecx					; ECX = tar length - src length + 1, because the 0th position needs to be compared as well
	LODSB					; EAX = src[0]'s character
	cld						; direction = forward

charSearch:
	repne scasb				; repeat until find src[0] in EDI (the target)
	jnz noMatch				; no match found in tar

	; Char match found.  We know src[0] == [edi - 1], so compare the rest
	
	INVOKE Substr_Cmp, esi, ebx, edi		; Otherwise, compare the strings from src[1] and tar[found+1](EDI)
	jne charSearch			; no match, keep searching

match:
	dec edi					; scasb passes the matched char
specialMatch:				; if (src length == 1 || src length == tar length), edi should not be decremented
	mov eax,edi				; mov memory position of found match to eax
	sub eax,tar				; found - tar = index
	xor esp,esp				; sets zero flag
	jmp finish
	
noMatch:
	test esp,esp			; clears zero flag

finish:
	ret
Str_Find ENDP


;--------------------------------------
; Substr_Cmp
;
; Compares the source string within the target substring
;
; Receives: src, the source string to compare to
;			srcLen, the length of the source
;			tar, the substring being compared
; Requires: tar must point to a substring at least as long as srcLen
; Postcondition:	If the source string was found within the target string, ZF = 1
;					If not found, ZF = 0 
;---------------------------------------
Substr_Cmp PROC,
	src:PTR BYTE,
	srcLen:DWORD,
	tar:PTR BYTE

	pushad
	mov esi,src
	mov edi,tar
	mov ecx,srcLen
	dec ecx							; this function is passed src[1], but still has the length of the whole source, so it is modified here									

	repe cmpsb						; Compare each character from source and the substring of target beginning at EDI
	
	popad

	ret
Substr_Cmp ENDP


END main

COMMENT !
	Sample Run
	---------------------------

	Enter source string (the string to search for):
	Enter target string (the string to search from):
	Source string was not found in target string.
	
	Do you want to do another search? Y/n:

	Error: Invalid Choice
	Do you want to do another search? Y/n: q

	Error: Invalid Choice
	Do you want to do another search? Y/n: R

	Error: Invalid Choice
	Do you want to do another search? Y/n: 1

	Error: Invalid Choice
	Do you want to do another search? Y/n: 123

	Error: Invalid Choice
	Do you want to do another search? Y/n: Y

	Enter source string (the string to search for): a
	Enter target string (the string to search from): f
	Source string was not found in target string.

	Do you want to do another search? Y/n: y

	Enter source string (the string to search for): a
	Enter target string (the string to search from): a
	Source string found at position 0 in Target string (counting from zero).

	Do you want to do another search? Y/n: y

	Enter source string (the string to search for): abc
	Enter target string (the string to search from): c
	Source string was not found in target string.

	Do you want to do another search? Y/n: y

	Enter source string (the string to search for): c
	Enter target string (the string to search from): abc
	Source string found at position 2 in Target string (counting from zero).

	Do you want to do another search? Y/n: y

	Enter source string (the string to search for): b
	Enter target string (the string to search from): abc
	Source string found at position 1 in Target string (counting from zero).

	Do you want to do another search? Y/n: Y

	Enter source string (the string to search for): a
	Enter target string (the string to search from): abc
	Source string found at position 0 in Target string (counting from zero).

	Do you want to do another search? Y/n: y

	Enter source string (the string to search for): ef
	Enter target string (the string to search from): abcdef
	Source string found at position 4 in Target string (counting from zero).

	Do you want to do another search? Y/n: Y

	Enter source string (the string to search for): ab
	Enter target string (the string to search from): abcdef
	Source string found at position 0 in Target string (counting from zero).

	Do you want to do another search? Y/n: y

	Enter source string (the string to search for): a
	Enter target string (the string to search from): b
	Source string was not found in target string.

	Do you want to do another search? Y/n: y

	Enter source string (the string to search for): abc
	Enter target string (the string to search from): ab
	Source string was not found in target string.

	Do you want to do another search? Y/n: N
!