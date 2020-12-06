COMMENT ! 
	Project:        JustinHenleyProj4.asm
	Description:    Solution to Project 4, Reverses a string
	Course:         CSCI 321 VA 2020F
	Author:         Justin Henley, jahenley@mail.fhsu.edu
	Date:           2020-10-01
!

COMMENT !
	Problem Description:
	
	Write a program with a loop and indirect address that copies a string from source to target. 
	Revising the character order in the process. Use the following variables:

		source BYTE "This is the string that will be reversed", 0
		target BYTE SIZEOF source DUP('#')

	You may refer to the Programming Exercise #7 on Page 138 of the textbook.
!


.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO,dwExitCode:DWORD

.data
	source BYTE "This is the string that will be reversed", 0
	target BYTE SIZEOF source DUP('#')

.code
main PROC

	mov ecx, (SIZEOF source) - 1    ; set loop counter
	mov esi,0                       ; set index for source string at 0	
	mov edi,(SIZEOF source) - 2     ; set index for target string at length - 2

stringLoop:                             ; for copying the reversed string
	mov al,source[esi]              ; copy the current character to AL
	mov target[edi],al              ; copy the character from AL to the target
	inc esi                         ; increment the index for the source string
	dec edi                         ; decrement the index for the target string
	loop stringLoop                 ; iterate over loop until finished
	
	mov target[SIZEOF source - 1],0 ; add terminating 0 to target

	INVOKE ExitProcess,0
main ENDP
END main