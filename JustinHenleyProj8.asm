COMMENT ! 
	Project:		JustinHenleyProj8.asm
	Description:	Solution to Project 8, Greatest Common Divisor
	Course:			CSCI 321 VA 2020F
	Author:			Justin Henley, jahenley@mail.fhsu.edu
	Date:			2020-11-23
!

COMMENT !
	Objectives:
		1.	Implement Euclidean algorithm to find Greatest Common Divisor
		2.	Implement Euclidean algorithm using Recursive thinking
		3.	Apply loop
		4.	Apply recursive thinking
		5.	Apply Irvine32.inc library
		6.	Write user defined procedure and call user defined procedure


	Problem Description:
			The greatest common divisor (GCD) of two integers is the largest integer that will evenly divide both integers. 
			The GCD algorithm involves integer division in a loop, described by the following pseudocode:
					
					int GCD (int x, int y){
						x = abs(x)    // absolute value
						y = abs(y)
						do{
							int n = x % y
							x = y
							y = n
						}while (y > 0)
						return x
					}
					
			Implement this function in assembly language. Then go online find its recursive version and implement it in assembly language too. 
			Then write a test program that calls your two GCD procedure five times each, using the following pairs of integers:
					(5, 20), (24, 18), (11, 7), (432, 226), and (26, 13).
			After each procedure call, display the GCD

			You may refer to Programming Exercise #6 on page 285 and Programming Exercise #7 on page 350.
!

INCLUDE Irvine32.inc

; Function prototypes
TestGenerator		PROTO,	stringPtr:PTR BYTE,	xVal:SDWORD, yVal:SDWORD
NonRecursiveGCD		PROTO,	xVal:SDWORD, yVal:SDWORD
DriverRecursiveGCD	PROTO,	xVal:SDWORD, yVal:SDWORD
RecursiveGCD		PROTO,	xVal:SDWORD, yVal:SDWORD
AbsValue			PROTO,	val1:SDWORD
Modulo				PROTO,	dividend:SDWORD, divisor:SDWORD


.data
promptGCD			BYTE	"Greatest common divisor of ",0
promptRecursive		BYTE	"calculated by recursion is: ",0
promptNonRecursive	BYTE	"calculated by loop is: ",0
promptPair1			BYTE	"(5,20) ",0							; Prompt strings for each integer pair fed to the GCD functions
promptPair2			BYTE	"(24,18) ",0						; Could have been done within TestGenerator
promptPair3			BYTE	"(11,7) ",0							;	by just printing decimal values and chars, 
promptPair4			BYTE	"(432,226) ",0						;   but this is fewer lines of code when done for few test cases
promptPair5			BYTE	"(26,13) ",0

.code
main PROC
	; Calls to the TestGenerator for each of the five test pairs
	INVOKE	TestGenerator, ADDR promptPair1, 5, 20
	INVOKE	TestGenerator, ADDR promptPair2, 24, 18
	INVOKE	TestGenerator, ADDR promptPair3, 11, 7
	INVOKE	TestGenerator, ADDR promptPair4, 432, 226
	INVOKE	TestGenerator, ADDR promptPair5, 26, 13
	ret
main ENDP



;--------------------------------------
; TestGenerator
;
; Outputs a test run of both unrecursive and recursive GCD for a given integer pair
;
; Receives: stringPtr, a pointer to a null-terminated string representing "(xVal,yVal)"
;           xVal, one element of the integer pair
;			yVal, the other element of the integer pair
; Requires: NonRecursiveGCD, DriverRecursiveGCD subroutines
; Returns:  Nothing
;---------------------------------------
TestGenerator PROC,
	stringPtr:PTR BYTE,
	xVal:SDWORD,
	yVal:SDWORD

	; Display the GCD prompt
	mov		edx,OFFSET promptGCD
	call	WriteString
	mov		edx,stringPtr
	call	WriteString

	; Display the result of nonrecursive GCD
	mov		edx,OFFSET promptNonRecursive
	call	WriteString
	INVOKE	NonRecursiveGCD, xVal, yVal			; EAX = the GCD
	call	WriteDec
	call	Crlf

	; Display the result of recursive GCD
	mov		edx,OFFSET promptRecursive
	call	WriteString
	INVOKE	DriverRecursiveGCD, xVal, yVal		; EAX = the GCD
	call	WriteDec
	call	Crlf

	ret
TestGenerator ENDP



;--------------------------------------
; NonRecursiveGCD
;
; Finds the Greatest Common Divisor of two integers without recursion
;
; Receives: xVal, one element of the integer pair
;			yVal, the other element of the integer pair
; Requires: AbsValue, Modulo subroutines 
; Returns:  EAX, the Greatest Common Divisor of xVal and yVal
;---------------------------------------
NonRecursiveGCD PROC USES edx esi edi,
	xVal:SDWORD,						
	yVal:SDWORD						

	; Get absolute values of x and y
	INVOKE	AbsValue,xVal
	mov		esi,eax				; esi = abs(xVal)
	INVOKE	AbsValue,yVal
	mov		edi,eax				; edi = abs(yVal)
	
	; do-while loop
L1:
	INVOKE	Modulo, esi, edi	; EAX = x % y
	mov		esi,edi				; x = y
	mov		edi,eax				; y = x % y
	cmp		edi,0				; Check if y > 0
	ja		L1					; Loop while y > 0
	
	; Return
	mov		eax,esi				; move x to eax for return
	ret
NonRecursiveGCD ENDP



;--------------------------------------
; DriverRecursiveGCD
;
; Finds the Greatest Common Divisor of two integers by calling the recursive version of GCD
;     Gets the absolute value of xVal and yVal before recursion starts, so the recursive call doesn't
;	  waste resources repeating the absolute value operation
;
; Receives: xVal, one element of the integer pair
;			yVal, the other element of the integer pair
; Requires: AbsValue subroutine 
; Returns:  EAX, the Greatest Common Divisor of xVal and yVal
;---------------------------------------
DriverRecursiveGCD PROC,
	xVal:SDWORD,
	yVal:SDWORD

	; Get absolute values of x and y
	INVOKE	AbsValue,xVal
	mov		xVal,eax		; xVal = abs(xVal)
	INVOKE	AbsValue,yVal
	mov		yVal,eax		; yVal = abs(yVal)
	
	; Call the recursive function
	INVOKE	RecursiveGCD, xVal, yVal
	ret						; EAX = GCD of X and Y values
DriverRecursiveGCD ENDP



;--------------------------------------
; RecursiveGCD
;
; Finds the Greatest Common Divisor of two non-negative integers recursively
;
; Receives: xVal, one element of the integer pair
;			yVal, the element of the integer pair
; Requires: xVal and yVal are non-negative, Modulo subroutine 
; Returns:  EAX, the Greatest Common Divisor of xVal and yVal
;---------------------------------------
RecursiveGCD PROC,
	xVal:SDWORD,
	yVal:SDWORD

	; base case
	cmp		yVal,0			; Base case: y == 0
		jne recurse			; If not, make another recursive call
	mov		eax,xVal		; If base case, return xVal as the GCD
	jmp		return

recurse:
	INVOKE Modulo,			xVal, yVal	; EAX = x % y
	INVOKE RecursiveGCD,	yVal, EAX	; EAX = GCD(y, x % y)

return:
	ret						; EAX = GCD of the original X and Y values
RecursiveGCD ENDP



;--------------------------------------
; AbsValue
;
; Finds the absolute value of the given integer value
;
; Receives: xVal, the integer to find the absolute value of
; Requires: Nothing 
; Returns:  EAX, abs(xVal)
;---------------------------------------
AbsValue PROC,
	val1:SDWORD

	; Trick to get absolute value
	; Adapted from here: https://stackoverflow.com/a/11927940
	mov		eax,val1	; store val1 in eax
	neg		eax			
	cmovl	eax,val1	; if eax is now negative, restore the positive value
	ret
AbsValue ENDP



;--------------------------------------
; Modulo
;
; Returns divided % divisor
;
; Receives: dividend, a 32-bit integer to be the dividend in the division operation
;			divisor, a 32-bit integer to be the divisor in the division operation
; Requires: Nothing 
; Returns:  EAX, the remainder of (divided / divisor)
;---------------------------------------
Modulo PROC USES edx,
	dividend:SDWORD,
	divisor:SDWORD

	mov		eax,dividend	; store dividend in eax for division operation
	xor		edx,edx			; zero-extend x into edx for 32-bit division
	div		divisor			; divide dividend by divisor
	
	mov		eax,edx			; copy remainder to EAX for return
	ret
Modulo ENDP

END main



COMMENT !
	TEST RUN

	Greatest common divisor of (5,20) calculated by loop is: 5
	calculated by recursion is: 5
	Greatest common divisor of (24,18) calculated by loop is: 6
	calculated by recursion is: 6
	Greatest common divisor of (11,7) calculated by loop is: 1
	calculated by recursion is: 1
	Greatest common divisor of (432,226) calculated by loop is: 2
	calculated by recursion is: 2
	Greatest common divisor of (26,13) calculated by loop is: 13
	calculated by recursion is: 13
!