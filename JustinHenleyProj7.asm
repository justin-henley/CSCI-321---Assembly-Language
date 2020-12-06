COMMENT ! 
	Project:		JustinHenleyProj7.asm
	Description:	Solution to Project 7, Bitwise Multiplication
	Course:			CSCI 321 VA 2020F
	Author:			Justin Henley, jahenley@mail.fhsu.edu
	Date:			2020-11-10
!

COMMENT !
	Objectives:
		1.	Implement Bitwise Multiplication algorithm
		2.	Apply loop
		3.	Write user defined procedure
		4.	Use user defined procedure
		5.	Apply Irvine32.inc library

	Problem Description:
			Write a procedure named BitwiseMultiply that multiplies any unsinged 32-bit integer by EAX,
		using only shifting and addition. Pass the integer to the procedure in the EBX register and return 
		the product in the EAX register. Write a short test program that calls the procedure and displays
		the product (We will assume that the product is never larger than 32 bits). This is a fairly 
		challenging program to write. One possible approach is to use a loop to shift the multiplier to 
		the right, keeping track of the number of shifts that occur before the Carry flag is set. 
		The resulting shift count can then be applied to the SHL instruction, using the multiplicand as 
		the destination operand. Then the same process must be repeated until you find the last 1 bit in 
		the multiplier (Refer to Programming Exercise #7 on page 285)


!

INCLUDE Irvine32.inc

.data
; Prompt Strings
promptTitle			BYTE	"Bitwise Multiplication of Unsigned Integers",0
promptMultiplicand	BYTE	"Enter the multiplicand: ",0
promptMultiplier	BYTE	"Enter the multiplier: ",0
promptBad			BYTE	"Invalid input, please enter again: ",0
promptProduct		BYTE	"The product is ",0
promptRepeat		BYTE	"Do you want to do another calculation? y/n (all lowercase): ",0

; operation values
multiplier			DWORD	?
multiplicand		DWORD	?
product				DWORD	?


.code
main PROC

beginning:
	; Display title
	call Crlf									; Whitespace
	mov edx,OFFSET promptTitle					; Point EDX to the Title prompt
	call WriteString							; Write the title to terminal
	call Crlf
	call Crlf									; Whitespace

	; Get multiplier from user
	mov edx,OFFSET promptMultiplier				; Point EDX to Multiplier entry prompt
	call PromptDec32							; Prompt user for valid 32-bit decimal integer
	mov multiplier,eax							; Store multiplier

	; Get multiplicand from user
	mov edx,OFFSET promptMultiplicand			; Point EDX to Multiplicand entry prompt
	call PromptDec32							; Prompt user for valid 32-bit decimal integer
	mov multiplicand,eax						; Store multiplicand

	; Calculate product
	mov eax,multiplier							; Copy multiplier to EAX
	mov ebx,multiplicand						; Copy multiplicand to EBX
	call BitwiseMultiply						; Calculate product
	mov product,eax								; Store product

	; Display result
	mov edx,OFFSET promptProduct				; Point EDX to Result prompt
	call WriteString
	mov eax,product								; Copy the product to EAX for printing
	call WriteDec
	call Crlf
	call Crlf									; Whitespace

	; Prompt for repeat or exit
	mov edx,OFFSET promptRepeat					; Point EDX to Repeat prompt
	call WriteString
	call ReadChar								; AL = user entry, y = repeat
	call Crlf
	call Crlf									; Whitespace

	cmp al,'y'									; If user wants to repeat
		je beginning							; Repeat

	; Exit code
	call WaitMsg								; Wait for user before exiting
	exit
main ENDP


;--------------------------------------
; BitwiseMultiply
;
; Multiplies any unsigned 32-bit integer by EAX, using only shifting and addition
;
; Receives: EAX, an unsigned 32-bit multiplier
;           EBX, an unisigned 32-bit multiplicand
; Requires: Both factors are unsigned binary 
; Returns:  EAX, the result of multiplying EAX and EBX, truncated to 32 bits
;---------------------------------------

BitwiseMultiply PROC USES ebx ecx
.data
	acc		DWORD ?								; Accumulator for product
	factor	DWORD ?								; copy of multiplicand

.code	
	mov acc,0
	mov ecx,32									; Set loop counter for 32-bit integer
	mov factor,ebx								; Save the value of the multiplicand

L1:
	shl eax,1									; Pop highest bit out of multiplier into Carry
		jnc cont								; If Carry is 0, continue to next bit in multiplier
	mov ebx,factor								; Copy factor to ebx
	dec ecx										; Needs (cl - 1) on next line, but couldn't write it correctly
	shl ebx,cl									; Multiply by 2^(ecx), the current bit value from multiplier
	inc ecx										; Restore ecx after shift
	add acc,ebx									; Add product to accumulator

cont:
	loop L1										; Iterate over loop

	mov eax,acc									; Return accumulated product
	ret
BitwiseMultiply ENDP



;--------------------------------------
; PromptDec32
;
; Prompts a user for a 32-bit decimal integer until valid input
;
; Receives: EDX, pointing to the prompt string for input
; Requires: User eventually enters a valid 32-bit integer
; Returns:  EAX, the valid 32-bit user-supplied integer
;---------------------------------------
PromptDec32 PROC
	call WriteString							; Write prompt in EDX to terminal
read:
	call ReadDec								; Read multiplier from user
	jnc valid									; Continue if valid entry

	mov edx,OFFSET promptBad					; Warn invalid entry
	call WriteString
	jmp read									; Repeat input

valid:											; Reached once valid multiplier is entered
	ret
PromptDec32 ENDP

END main



COMMENT !
SAMPLE RUN 
	
	Bitwise Multiplication of Unsigned Integers

	Enter the multiplier: 123
	Enter the multiplicand: 2
	The product is 246

	Do you want to do another calculation? y/n (all lowercase):


	Bitwise Multiplication of Unsigned Integers

	Enter the multiplier: 2
	Enter the multiplicand: 123
	The product is 246

	Do you want to do another calculation? y/n (all lowercase):


	Bitwise Multiplication of Unsigned Integers

	Enter the multiplier: 1234
	Enter the multiplicand: 5678
	The product is 7006652

	Do you want to do another calculation? y/n (all lowercase):


	Bitwise Multiplication of Unsigned Integers

	Enter the multiplier:
	Invalid input, please enter again: 4321
	Enter the multiplicand:
	Invalid input, please enter again: 8765
	The product is 37873565

	Do you want to do another calculation? y/n (all lowercase):

	Press any key to continue...

END SAMPLE RUN
!