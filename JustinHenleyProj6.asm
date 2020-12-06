COMMENT ! 
	Project:		JustinHenleyProj6.asm
	Description:	Solution to Project 6, Boolean Calculator
	Course:			CSCI 321 VA 2020F
	Author:			Justin Henley, jahenley@mail.fhsu.edu
	Date:			2020-10-25
!

COMMENT !
	Objectives:
		1.	Implement a menu
		2.	Apply Table-Driven Selection technique (Read section 6.5.4)
		3.	Implement user defined procedures
		4.	Call user defined procedures
		5.	Apply Irvine32.inc library
	
	Problem Description:
		Create a program that functions as a simple Boolean calculator for 32-bit integers. It should display a menu that asks the user to make a selection from the following list:
			1.	X AND Y
			2.	X OR Y
			3.	NOT X
			4.	X XOR Y
			5.	Exit Program
		When the user makes a choice, call the corresponding procedure, which is one of the following four:
			1.	AND_op: Prompt the user for two hexadecimal integers. AND them together and display the result in hexadecimal
			2.	OR_op: Prompt the user for two hexadecimal integers. OR them together and display the result in hexadecimal.
			3.	NOT_op: Prompt the user for a hexadecimal integer. NOT the integer and display the result in hexadecimal.
			4.	XOR_op: Prompt the user for two hexadecimal integers. Exclusive-OR them together and display the result in hexadecimal.
		You may refer to Programming Exercises #5 and #6 on page 239

!

INCLUDE Irvine32.inc

.data

; Table Definition
CaseTable BYTE '1'				; lookup value
	DWORD AND_op					; address of procedure
EntrySize = ($ - CaseTable)		; size of a single table entry
	BYTE '2'
	DWORD OR_op
	BYTE '3'
	DWORD NOT_op
	Byte '4'
	DWORD XOR_op
	Byte '5'
	DWORD Quit
NumberOfEntries = ($ - CaseTable) / EntrySize

; Menu and Prompt for user entry
menu BYTE "1. x AND y",13,10,"2. x OR y",13,10,"3. NOT x",13,10,"4. x XOR y",13,10,"5. Exit Program",13,10,10,0
promptMenu BYTE "Enter integer> ",0

; Prompts for X and Y values, output, and exit
promptX BYTE		"Input the first 32-bit hexadecimal operand:    ",0
promptY BYTE		"Input the second 32-bit hexadecimal operand:   ",0
promptResult BYTE	"The 32-bit hexadecimal result is:              ",0
promptExit BYTE		"Thank you for using Justin Henley's FHSU Boolean Calculator.",13,10,0

; Operation Header Labels
andHead BYTE		"Boolean AND",13,10,13,10,0
orHead BYTE			"Boolean OR",13,10,13,10,0
notHead BYTE		"Boolean NOT",13,10,13,10,0
xorHead BYTE		"Boolean XOR",13,10,13,10,0

.code
main PROC

beginning:
	; Display menu and prompt user for input
	mov edx,OFFSET menu					; Point EDX to the menu 
	call WriteString					; Write the menu to terminal
	mov edx,OFFSET promptMenu			; Point EDX to the menu prompt
	call WriteString					; Write the prompt to terminal
	call ReadChar						; Reads a single char into AL, does not echo the character
	call WriteChar						; Echo the user-entered character from AL
	call Crlf
	call Crlf							; Whitespace

	; Call relevant procedure based on user entry
	mov ebx,OFFSET CaseTable			; Point EBX to the table
	mov ecx,NumberOfEntries				; loop counter for table
searchTable:
	cmp al,[ebx]						; Does the input match this table lookup value?
		jne nextEntry					; No: continue search
	call NEAR PTR [ebx + 1]				; Yes: call the procedure
	jmp endSearch						; Exit the search
nextEntry:
	add ebx,EntrySize					; Point to the next lookup entry
	loop searchTable					; Repeat search until ECX == 0
endSearch:	

; Repeat main, only exit is through "5. Exit program"
	call Crlf
	call Crlf							; Whitespace
	call WaitMsg						; Wait for anykey before clearing and repeating
	call Clrscr							; Clear the terminal
	jmp beginning						; jump back to the top of main

main ENDP


;--------------------------------------
; AND_op
;
; Prompts user for two 32-bit hex integers, and displays the result of X AND Y
;
; Receives: Nothing
; Requires: Nothing
; Returns:  Nothing
;---------------------------------------
AND_op PROC USES eax ebx edx
	; Prompt user for two 32-bit hex integers
	mov edx,OFFSET andHead				; Point EDX to the header label
	call WriteString					; Write the header label, whitespace included
	mov edx,OFFSET promptX				; Point EDX to the entry prompt
	call WriteString					; Write the entry prompt to terminal
	call ReadHex						; Read X into EAX
	mov ebx,eax							; Copy X to EBX so that Y can be read into EAX
	mov edx,OFFSET promptY				; Point EDX to the second entry prompt
	call WriteString					; Write the entry prompt to terminal
	call ReadHex						; Read Y into EAX

	; Process result
	and eax,ebx							; Perform AND operation on X and Y

	; Output result to terminal
	mov edx,OFFSET promptResult			; Point EDX to the result prompt
	call WriteString					; Write the result prompt
	call WriteHex						; Write the result value, a 32-bit hex integer

	ret									; Returns nothing
AND_op ENDP


;--------------------------------------
; OR_op
;
; Prompts user for two 32-bit hex integers, and displays the result of X OR Y
;
; Receives: Nothing
; Requires: Nothing
; Returns:  Nothing
;---------------------------------------
OR_op PROC USES eax ebx edx
	; Prompt user for two 32-bit hex integers
	mov edx,OFFSET orHead				; Point EDX to the header label
	call WriteString					; Write the header label, whitespace included
	mov edx,OFFSET promptX				; Point EDX to the entry prompt
	call WriteString					; Write the entry prompt to terminal
	call ReadHex						; Read X into EAX
	mov ebx,eax							; Copy X to EBX so that Y can be read into EAX
	mov edx,OFFSET promptY				; Point EDX to the second entry prompt
	call WriteString					; Write the entry prompt to terminal
	call ReadHex						; Read Y into EAX

	; Process result
	or eax,ebx							; Perform OR operation on X and Y

	; Output result to terminal
	mov edx,OFFSET promptResult			; Point EDX to the result prompt
	call WriteString					; Write the result prompt
	call WriteHex						; Write the result value, a 32-bit hex integer

	ret									; Returns nothing
OR_op ENDP


;--------------------------------------
; NOT_op
;
; Prompts user for one 32-bit hex integer, and displays the result of NOT X
;
; Receives: Nothing
; Requires: Nothing
; Returns:  Nothing
;---------------------------------------
NOT_op PROC USES eax edx
	; Prompt user for two 32-bit hex integers
	mov edx,OFFSET notHead				; Point EDX to the header label
	call WriteString					; Write the header label, whitespace included
	mov edx,OFFSET promptX				; Point EDX to the entry prompt
	call WriteString					; Write the entry prompt to terminal
	call ReadHex						; Read X into EAX

	; Process result
	not eax								; Perform NOT operation on X

	; Output result to terminal
	mov edx,OFFSET promptResult			; Point EDX to the result prompt
	call WriteString					; Write the result prompt
	call WriteHex						; Write the result value, a 32-bit hex integer	

	ret									; Returns nothing
NOT_op ENDP


;--------------------------------------
; XOR_op
;
; Prompts user for two 32-bit hex integers, and displays the result of X XOR Y
;
; Receives: Nothing
; Requires: Nothing
; Returns:  Nothing
;---------------------------------------
XOR_op PROC USES eax ebx edx
	; Prompt user for two 32-bit hex integers
	mov edx,OFFSET xorHead				; Point EDX to the header label
	call WriteString					; Write the header label, whitespace included
	mov edx,OFFSET promptX				; Point EDX to the entry prompt
	call WriteString					; Write the entry prompt to terminal
	call ReadHex						; Read X into EAX
	mov ebx,eax							; Copy X to EBX so that Y can be read into EAX
	mov edx,OFFSET promptY				; Point EDX to the second entry prompt
	call WriteString					; Write the entry prompt to terminal
	call ReadHex						; Read Y into EAX

	; Process result
	xor eax,ebx							; Perform XOR operation on X and Y

	; Output result to terminal
	mov edx,OFFSET promptResult			; Point EDX to the result prompt
	call WriteString					; Write the result prompt
	call WriteHex						; Write the result value, a 32-bit hex integer	

	ret									; Returns nothing
XOR_op ENDP


;--------------------------------------
; Quit
;
; Exits the program
;
; Receives: Nothing
; Requires: Nothing
; Returns:  Nothing
;---------------------------------------
Quit PROC
	mov edx,OFFSET promptExit			; Point EDX to the exit prompt
	call WriteString					; Write the exit prompt to the terminal
	call WaitMsg						; Wait for user to proceed to exit
	call Crlf							; Whitespce
	exit								; Exits the program
Quit ENDP


END main



COMMENT !

	SAMPLE RUN
	
	1. x AND y
	2. x OR y
	3. NOT x
	4. x XOR y
	5. Exit Program

	Enter integer> 1

	Boolean AND

	Input the first 32-bit hexadecimal operand:    12345678
	Input the second 32-bit hexadecimal operand:   11112222
	The 32-bit hexadecimal result is:              10100220

	Press any key to continue...


	1. x AND y
	2. x OR y
	3. NOT x
	4. x XOR y
	5. Exit Program

	Enter integer> 2

	Boolean OR

	Input the first 32-bit hexadecimal operand:    12345678
	Input the second 32-bit hexadecimal operand:   11112222
	The 32-bit hexadecimal result is:              1335767A

	Press any key to continue...    


	1. x AND y
	2. x OR y
	3. NOT x
	4. x XOR y
	5. Exit Program

	Enter integer> 3

	Boolean NOT

	Input the first 32-bit hexadecimal operand:    12345678
	The 32-bit hexadecimal result is:              EDCBA987

	Press any key to continue...  

	1. x AND y
	2. x OR y
	3. NOT x
	4. x XOR y
	5. Exit Program

	Enter integer> 4

	Boolean XOR

	Input the first 32-bit hexadecimal operand:    12345678
	Input the second 32-bit hexadecimal operand:   11112222
	The 32-bit hexadecimal result is:              0325745A

	Press any key to continue... 


	1. x AND y
	2. x OR y
	3. NOT x
	4. x XOR y
	5. Exit Program

	Enter integer> 5

	Thank you for using Justin Henley's FHSU Boolean Calculator.
	Press any key to continue...

!