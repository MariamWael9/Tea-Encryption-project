include irvine32.inc

.data

numRounds DWORD 64
v DWORD 2 Dup (?)
key DWORD 4 Dup (?)
v0 DWORD ?
v1 DWORD ?
delta DWORD 9E3779B9h
sum DWORD ?

keystr BYTE "128-bit long key" , 0
msg BYTE "corona virus is spreading too fast there" , 0

beforemsg BYTE "the message before encryption :-  " ,0
aftermsg BYTE "the message after encryption and decryption:-  " ,0


.code
main proc

mov edx , offset beforemsg
call WriteString
mov al , 10
call Writechar
mov edx , offset msg
call WriteString
mov al , 10
call Writechar
mov al , 10
call Writechar

mov esi , offset msg
mov ecx, LENGTHOF msg-1

L1:
  ; push ecx
  mov ebx , offset keystr
 call encrypt
  mov ebx , offset keystr
 call decrypt
   add esi , 8
  ; pop ecx
   sub ecx , 7
LOOP L1
  mov edx , offset aftermsg
  call WriteString
  mov al , 10
  call Writechar
  mov edx , OFFSET msg
  call WriteString
    mov al , 10
  call Writechar
exit
main endp
   
                   ;encrypt 
   encrypt PROC USES ecx

  mov eax , [esi]
  mov v[0] , eax
  mov eax , [esi+4]
  mov v[4] , eax

  mov eax , [ebx]
  mov key[0] , eax
  mov eax , [ebx+4]
  mov key[4] , eax 
  mov eax , [ebx+8]
  mov key[8] , eax
  mov eax , [ebx+12]
  mov key[12] , eax

  mov sum , 0
  mov ecx , numRounds

  L1:
       ;equation 1
  push ecx
  mov eax , v[4]
  SHL v[4] , 4
  mov ebx , v[4]
  mov v[4], eax
  SHR v[4] , 5
  XOR ebx , v[4]
  mov edx , eax
  add ebx , edx
  mov v1 , edx

  mov edx , sum
  AND edx , 3
  mov eax , edx
  mov ecx , 4
  mul ecx
  mov edx , eax
  mov eax , key[edx]
  add eax , sum
  XOR ebx , eax
  add v[0] , ebx
        
		;equation 2
  mov eax, delta
  add sum , eax
         
		 ;equation 3
  mov eax , v[0]
  SHL v[0] , 4
  mov ebx , v[0]
  mov v[0] , eax
  SHR v[0] , 5
  XOR ebx , v[0]
  mov edx , eax
  add ebx , edx
  mov v[0] , edx

  mov edx , sum
  SHR edx , 11
  AND edx , 3
  mov eax , edx
  mov ecx , 4
  mul ecx
  mov edx , eax
  mov eax , key[edx]
  add eax , sum
  XOR eax , ebx
  mov edx , v1
  mov v[4] ,edx
  add v[4] , eax

  pop ecx
  dec ecx
  cmp ecx , 0
  jne L1
  mov eax,v[0]
  mov [esi] , eax
  mov eax,v[4]
  mov [esi+4] , eax
  jmp L2
  L2:
ret
   encrypt ENDP
       
	               ;decrypt
   decrypt PROC USES ecx
  mov eax , [esi]
  mov v[0] , eax
  mov eax , [esi+4]
  mov v[4] , eax

  mov eax , [ebx]
  mov key[0] , eax
  mov eax , [ebx+4]
  mov key[4] , eax 
  mov eax , [ebx+8]
  mov key[8] , eax
  mov eax , [ebx+12]
  mov key[12] , eax

  mov eax , delta
  mov ecx , numRounds
  mul ecx
  mov sum , eax

     L1:
	     ;equation 1
  push ecx
  mov eax , v[0]
  SHL v[0] , 4
  mov ebx , v[0]
  mov v[0] , eax
  SHR v[0] , 5
  XOR ebx , v[0]
  mov edx , eax
  add ebx , edx
  mov v0 , edx
  mov v[0] , edx

  mov edx , sum
  SHR edx , 11
  AND edx , 3
  mov eax , edx
  mov ecx , 4
  mul ecx
  mov edx , eax
  mov eax , key[edx]
  add eax , sum
  XOR eax , ebx
  sub v[4] , eax

           ; equation 2
  mov eax, delta
  sub sum , eax

           ; equation 3
  mov eax , v[4]
  SHL v[4] , 4
  mov ebx , v[4]
  mov v[4], eax
  SHR v[4] , 5
  XOR ebx , v[4]
  mov edx , eax
  add ebx , edx
  mov v[4] , edx

  mov edx , sum
  AND edx , 3
  mov eax , edx
  mov ecx , 4
  mul ecx
  mov edx , eax
  mov eax , key[edx]
  add eax , sum
  XOR ebx , eax
  mov edx , v0
  mov v[0] ,edx
  sub v[0] , ebx

  pop ecx
  dec ecx
  cmp ecx , 0
  jne L1
   mov eax,v[0]
  mov [esi] , eax
  mov eax,v[4]
  mov [esi+4] , eax
  jmp L2
  L2:
	ret
    decrypt ENDP
				
END main