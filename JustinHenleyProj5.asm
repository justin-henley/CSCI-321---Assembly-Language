COMMENT ! 
	Project:        JustinHenleyProj5.asm
	Description:    Solution to Project 5, Random String Generator
	Course:         CSCI 321 VA 2020F
	Author:         Justin Henley, jahenley@mail.fhsu.edu
	Date:           2020-10-02
!

INCLUDE Irvine32.inc

.data
STRING_SIZE = 11                        ; The size of the randomly generated strings, INCLUDING the null terminator. Must be >= 2
NUM_OF_STRINGS = 20                     ; The number of strings to be generated. Must be >= 1
string BYTE (STRING_SIZE + 1) DUP(?)    ; Holds each randomly generated string until the next is generated

.code
main PROC

	mov ecx,NUM_OF_STRINGS          ; Set the loop counter
	mov eax,STRING_SIZE             ; Pass the random string size to RandomString in EAX
	mov edx,OFFSET string           ; Pass a pointer in EDX to an array of BYTE to hold the string
	call Randomize                  ; Set the seed for RandomRange

generate:                               ; The loop to generate 20 random strings
	call RandomString               ; Generate a random string
	call WriteString                ; Write the string to the console
	call Crlf

	loop generate                   ; Iterate over the generate loop

	; Pause and prompt the user before exiting
	call WaitMsg
	call Crlf

	exit
main ENDP


;--------------------------------------
; RandomString
;
; Generates an ALL CAPS random string of a given length, stored in a byte array at a given address.
;
; Receives: EAX, the length of the string to be generated, INCLUDING the null terminator
;           EDX, the pointer to the BYTE array that will hold the string
; Requires: The array pointed to by EDX must be large enough to hold the generated string
;			EAX >= 2, otherwise an exception will be thrown at runtime
; Returns:  Nothing (The string is stored in the pointed array)
;---------------------------------------

RandomString PROC USES eax ecx edx
	
	mov ecx, STRING_SIZE - 1                        ; Set loop counter to STRING-LENGTH - 1

charGenerate:                                           ; Loop over STRING_LENGTH - 1
	
	; Generate a random integer and cast it to a capital letter ASCII value (65 to 90)
	mov eax,25                                      ; Range of 26, for 26 capital letters, passed into RandomRange
	call RandomRange                                ; Generate the random int, passed back in EAX

	; Insert that value into the string
	add eax,65                                      ; Generate a valid ASCII capital letter
	mov [edx], eax                                  ; Copy the letter to the string

	; Increment EDX to the next character index
	inc edx

	loop charGenerate                               ; Go to the next character

	mov edx,0                                       ; Append the null terminator in the final position

	ret
RandomString ENDP

END main

COMMENT !
	SAMPLE RUN #1: STRING_SIZE = 5, NUM_OF_STRINGS = 20
	
	JTPJ
	UCAL
	BNUY
	JBCH
	WAON
	DOHG
	TTFL
	SYJC
	NAGL
	RLSB
	TXNL
	SCRO
	CYNT
	OSRS
	LMXN
	ULNJ
	HHEW
	GHSF
	IGUF
	FPFO
	Press any key to continue...
!

COMMENT !
	SAMPLE RUN #2: STRING_SIZE = 11, NUM_OF_STRINGS = 20

	TPCXUPIMJB
	FYJSRKARXW
	HRFSXEUIEP
	WIVXCRQFLW
	EPLKPUBKHT
	PEYPJCNGWV
	YGKNWWLQKD
	CAXFLAUXRP
	EUUDMBLVJL
	CSWGCXMJCW
	ERSDRWEHGB
	NASRQEKDMQ
	EMDNTVPDDQ
	FMBMEUHULN
	WUXALKLGMN
	BRILWQSDVG
	SWYLUNVGKU
	PFYAJWPHRW
	MDOXLMOGRM
	COATEUNKHK
	Press any key to continue...
!