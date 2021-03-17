TITLE Project4 Program(template.asm)

; Author: Senna Titcomb
; Last Modified : 2 / 12 / 2021
; OSU email address : titcombs@oregonstate.edu
; Course number / section: 271 / 001
; Assignment Number : Program 4                Due Date : Feb 14
; Description: Write a program to calculate composite numbers.

INCLUDE Irvine32.inc


; (insert constant definitions here)
	upperlimit = 301
	lowerlimit = 0

.data
; (insert variable definitions here)
	titlemessage BYTE "Welcome to the Composite Number Spreadsheet", 0dh, 0ah, 0
	programmer BYTE "Programmed by Senna Titcomb", 0dh, 0ah, 0
	instruction1 BYTE "This program is capable of generating a list of composite numbers.", 0dh, 0ah, 0
	instruction2 BYTE "Simply let me know how many you would like to see.", 0dh, 0ah, 0
	instruction3 BYTE "I’ll accept orders for up to 300 composites.", 0
	getvalue BYTE "How many composites do you want to view? [1 .. 300]: ", 0
	error BYTE "Out of range. Please try again.", 0dh, 0ah, 0
	result BYTE "Thank you for using my program!", 0dh, 0ah, 0
	value DWORD 4
	alignment BYTE "   ", 0
	counter SDWORD ?
	loopcounter DWORD 0
	displaycounter DWORD 0
	counter2 DWORD 0
	divider DWORD 1
	remainder DWORD 0
	

.code
main PROC
	call Clrscr
	call intro

	call getUserData

	call showComposites

	call goodbye

; (insert executable instructions here)

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

intro PROC
	; print titlemessage
	mov edx, OFFSET titlemessage
	call WriteString
	mov edx, OFFSET programmer
	call WriteString

	; print instructions
	mov edx, OFFSET instruction1
	call WriteString
	mov edx, OFFSET instruction2
	call WriteString
	mov edx, OFFSET instruction3
	call Crlf

	ret
intro ENDP

getUserData PROC
	;is input valid?
	mov edx, OFFSET getvalue
	call WriteString
	call ReadInt
	mov counter, eax	;number of composites to print
	mov eax, counter
	call validate
	ret
getUserData ENDP

validate PROC
	validLoop :
		cmp eax, lowerlimit		;is value greater than 0 ?
		jle invalid		;less than jump to error
		cmp eax, upperlimit		;is value less than 301 ?
		jge invalid		;greater than jump to error message
		jmp finish
	invalid :
		mov edx, OFFSET error
		call WriteString
		call getUserData	;invalid num, ask again
	finish :
	ret
validate ENDP

showComposites PROC
	;printoutcomposites
	checkvalues:
		call isComposite
		cmp eax, 2		;checks composite
		jle notcomp		;does number have 2 or more factors
		mov eax, value
		call WriteDec
		inc loopcounter
		inc displaycounter
		mov eax, 0		;resets values
		mov counter2, eax
		mov eax, 1
		mov divider, eax
		mov eax, displaycounter
		cmp eax, 10
		jl display
		call Crlf		;newline every 10
		mov eax, 0
		mov displaycounter, eax
		jmp notcomp
		display:
			mov edx, OFFSET alignment	;prints 3 spaces
			call WriteString
		notcomp:
			inc value
			mov eax, counter
			cmp eax, loopcounter
			jg checkvalues
	ret
showComposites ENDP

isComposite PROC
	;checking calculations
	check:
		mov eax, value
		cdq
		mov ebx, divider
		div ebx
		mov remainder, edx
		mov eax, remainder
		cmp eax, 0		;does number divide equally
		jg nodivide
		inc counter2
	nodivide:			;counter does not increase 
		mov eax, value
		cmp eax, divider
		je finish
		inc divider
		jmp check
	finish:
		mov eax, counter2	;move count of divisors
	
	ret
isComposite ENDP

goodbye PROC
	mov edx, OFFSET result	;prints goodbye message
	call WriteString
	ret
goodbye ENDP

END main
