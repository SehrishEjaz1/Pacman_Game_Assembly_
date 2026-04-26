[org 0x100]

jmp start

canMoveR: db 0
canMoveL: db 0
canMoveU: db 0
canMoveD: db 0 
timerflag: db 0
ghost1_pos: dw 1838
ghost2_pos: dw 1992
ghost3_pos: dw 1850
ghost4_pos: dw 2004
ghost3_col: db 00001010b
ghost4_col: db 00001100b
ghost1_col: db 00001110b
ghost2_col: db 00001111b
pacman_position: dw 3718

score dw 0
msg db 'Score: '
exiting: db 'Enter E to exit!'

game_end: db 'GAME OVER!' 

exit_screen:
mov ah, 0x13
mov al, 1
mov bh, 0
mov bl, 0x0c
mov cx, 15
mov dh, 12
mov dl, 30
push ds
pop es
mov bp, exiting
int 10h
ret

exit_option:
mov ah, 0x13
mov al, 1
mov bh, 0
mov bl, 0x0c
mov cx, 15
mov dh, 20
mov dl, 30
push ds
pop es
mov bp, exiting
int 10h
mov ah, 0
int 16h
cmp ah, 0x12
je end_of_game
ret

exit_final:
mov ah, 0x13
mov al, 1
mov bh, 0
mov bl, 0x0c
mov cx, 9
mov dh, 12
mov dl, 30
push ds
pop es
mov bp, game_end
int 10h
int 10h
ret

display_score:
    push ax
    push bx
    push cx
    push dx
	push es
    inc word [score]    ; Increment
    mov ah, 0x13        ; BIOS
    mov al, 1           ; Mode
    mov bh, 0           ; Page
    mov bl, 0x07        ; Attribute
    mov cx, 7           ; Length
    mov dh, 0           ; Row
    mov dl, 0           ; Column
    push ds             ; DS
    pop es              ; ES
    mov bp, msg         ; String
    int 10h             ; Display
    mov ax, [score]     ; Score
    call printnum       ; Print
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
    ret                 ; Return

printnum:
    push ax             ; Save
    push bx             ; Save
    push cx             ; Save
    push dx             ; Save
    mov bx, 10          ; Base
    xor cx, cx          ; Counter
convert_loop:
    xor dx, dx          ; Clear
    div bx              ; Divide
    add dl, '0'         ; ASCII
    push dx             ; Stack
    inc cx              ; Count
    test ax, ax         ; Check
    jnz convert_loop   ; Loop
print_loop:
    pop dx              ; Digit
    mov ah, 0x0E        ; Teletype
    mov al, dl          ; Character
    mov bh, 0           ; Page
    int 10h             ; Print
    loop print_loop    ; Loop
    pop dx              ; Restore
    pop cx              ; Restore
    pop bx              ; Restore
    pop ax              ; Restore 
    ret                 ; Return  

oldkb: dd 0


line1: db '  ____     _       ____   __   __      _     __    _ ', 0
line2: db' |    \   / \    /  __/  |  \_/  |    / \   |  \  | | ', 0
line3: db' |  __/  / _ \  |  |     |       |   / _ \  |   \ | | ', 0
line4: db' | |    / / \ \  \  \__  | |\_/| |  / / \ \ | |\ \| | ', 0
line5: db' |_|   /_/   \_\  \____\ |_|   |_| /_/   \_\|_|  \__| ', 0
line6: db'                                        ',0
line7: db 'Press Enter to Start',0
line8: db 'Ramiza Munir - (23L-0862)', 0
line9: db 'Sehrish Ejaz - (23F-0744)', 0
line10: db 'COAL Spring 2025', 0
tickcount: dw 0

delay:

push cx
mov cx, 0xffff
l0:
dec cx
cmp cx, 0
jne l0

pop cx

ret

move_ghost1:
mov ax, 0xb800
mov es, ax
mov di, [ghost1_pos]
mov si, di
sub si, 480

l12_ghost1:
mov ah, 00001110b  ; Yellow
mov al, ' '
stosw
stosw
add di, 156
stosw
stosw
call delay
call delay
call delay
call delay
call delay
sub di, 164
mov al, 0x0A
mov ah, 00001110b
stosw
stosw
call delay
call delay
call delay
call delay
call delay
sub di, 164
cmp di, si
jne l12_ghost1

mov [ghost1_pos], di

ret

move_ghost2:
mov ax, 0xb800
mov es, ax
mov di, [ghost2_pos]
mov si, di
sub si, 640

l12_ghost2:
mov ah, 00001111b  ; White
mov al, ' '
stosw
stosw
add di, 156
stosw
stosw
call delay
call delay
call delay
call delay
call delay
sub di, 164
mov al, 0x0A
mov ah, 00001111b
stosw
stosw
call delay
call delay
call delay
call delay
call delay
sub di, 164
cmp di, si
jne l12_ghost2

mov [ghost2_pos], di

ret

move_ghost3:
mov ax, 0xb800
mov es, ax
mov di, [ghost3_pos]
mov si, di
sub si, 480

l12_ghost3:
mov ah, 00001010b  ; Green
mov al, ' '
stosw
stosw
add di, 156
stosw
stosw
call delay
call delay
call delay
call delay
call delay
sub di, 164
mov al, 0x0A
mov ah, 00001010b
stosw
stosw
call delay
call delay
call delay
call delay
call delay
sub di, 164
cmp di, si
jne l12_ghost3

mov [ghost3_pos], di

ret

move_ghost4:
mov ax, 0xb800
mov es, ax
mov di, [ghost4_pos]
mov si, di
sub si, 640

l12_ghost4:
mov ah, 00001100b  ; Red
mov al, ' '
stosw
stosw
add di, 156
stosw
stosw
call delay
call delay
call delay
call delay
call delay
sub di, 164
mov al, 0x0A
mov ah, 00001100b
stosw
stosw
call delay
call delay
call delay
call delay
call delay
sub di, 164
cmp di, si
jne l12_ghost4

mov [ghost4_pos], di

ret


kbisr:		push ax
			in al, 0x60 ; read char from keyboard port

			cmp al, 0xc8 ; has the up been released
			jne nextcmp ; no, try next comparison
			
			cmp word [cs:timerflag], 1; is the flag already set
			je exit ; yes, leave the ISR
			
			mov word [cs:timerflag], 1; set flag to start printing
			jmp exit ; leave the ISR
			
nextcmp:	cmp al, 0x48 ; has the up been pressed
			jne nextcmp1 ; no, chain to old ISR
			mov word [cs:timerflag], 0; reset flag to stop printing
			jmp exit ; leave the interrupt routine
			
nextcmp1:   cmp al, 0xcb ; has the left been released
			jne nextcmp2 ; no, try next comparison
			
			cmp word [cs:timerflag], 1; is the flag already set
			je exit ; yes, leave the ISR
			
			mov word [cs:timerflag], 1; set flag to start printing
			jmp exit ; leave the ISR
			
nextcmp2:	cmp al, 0x4b ; has the left been pressed
			jne nextcmp3 ; no, chain to old ISR
			mov word [cs:timerflag], 0; reset flag to stop printing
			jmp exit ; leave the interrupt routine
			
nextcmp3:   cmp al, 0xcd ; has the right been released
			jne nextcmp4 ; no, try next comparison
			
			cmp word [cs:timerflag], 1; is the flag already set
			je exit ; yes, leave the ISR
			
			mov word [cs:timerflag], 1; set flag to start printing
			jmp exit ; leave the ISR
			
nextcmp4:	cmp al, 0x4d ; has the right been pressed
			jne nextcmp5 ; no, chain to old ISR
			mov word [cs:timerflag], 0; reset flag to stop printing
			jmp exit ; leave the interrupt routine
			
nextcmp5:   cmp al, 0xd0 ; has the left been released
			jne nextcmp6 ; no, try next comparison
			
			cmp word [cs:timerflag], 1; is the flag already set
			je exit ; yes, leave the ISR
			
			mov word [cs:timerflag], 1; set flag to start printing
			jmp exit ; leave the ISR
			
nextcmp6:	cmp al, 0x50 ; has the left been pressed
			jne nomatch ; no, chain to old ISR
			mov word [cs:timerflag], 0; reset flag to stop printing
			jmp exit ; leave the interrupt routine
			
nomatch:	pop ax
			jmp far [cs:oldkb] ; call original ISR

exit:		mov al, 0x20
			out 0x20, al ; send EOI to PIC
			pop ax
			iret ; return from interrupt

timer:

push ax

inc word[tickcount]
cmp word[tickcount], 18
jne skipall
mov word[tickcount], 0

cmp byte[timerflag], 1
jne skipall

call move_g1
call move_g2
call move_g3
call move_g4

skipall:	
mov al, 0x20
out 0x20, al ; send EOI to PIC
pop ax
iret ; return from interrupt

;--------------------------------------------------------
move_g1:

mov di, [ghost1_pos]

mov si, di
sub si, 1 ; left check

mov ah, [es:si]

cmp ah, 0x0C
je check_r1
cmp ah, 0x04
je check_r1 ; go right

mov cx, 1
push cx
call move_left1
ret

check_r1:
mov si, di
add di, 1

mov ah, [es:si]

cmp ah, 0x0C
je check_u1
cmp ah, 0x04
je check_u1 ; go up

mov cx, 1
push cx
call move_right1
ret

check_u1:
mov si, di
sub di, 159

mov ah, [es:si]

cmp ah, 0x0C
je check_d1
cmp ah, 0x04
je check_d1 ; go up

mov cx, 1
push cx
call move_up1
ret

check_d1:

mov si, di
add di, 159

mov ah, [es:si]

cmp ah, 0x0C
je end_g1
cmp ah, 0x04
je end_g1 ; go up

mov cx, 1
push cx
call move_down1

end_g1:
ret

ret
move_down1:

push bp
mov bp, sp

mov cx, [bp+4]
mov di, [ghost1_pos]

mov ah, [ghost1_col] 

downloop1:
sub di, 4
mov al, '.'
stosw
stosw
add di, 156

mov al, 0x0a
stosw
stosw
call delay
call delay
call delay

loop downloop1

mov [ghost1_pos], di

pop bp
ret 2

move_right1:

push bp
mov bp, sp

mov cx, [bp+4]
mov di, [ghost1_pos]

mov ah, [ghost1_col] 

rightloop1: 

sub di, 4
mov al, '.'
stosw
stosw
mov al, 0x0a
stosw
stosw
call delay
call delay

loop rightloop1

mov [ghost1_pos], di

pop bp
ret 2

move_up1:

push bp
mov bp, sp

mov cx, [bp+4]
mov di, [ghost1_pos]

mov ah, [ghost1_col] 

uploop1:
sub di, 164
mov al, 0x0a
stosw
stosw
add di, 156
mov al, '.'
stosw
stosw
call delay
call delay
call delay
sub di, 160
loop uploop1
mov [ghost1_pos], di

pop bp
ret 2

move_left1:

push bp
mov bp, sp

mov bx, 0xb800
mov es, bx

mov cx, [bp+4]
mov di, [ghost1_pos]

mov ah, [ghost1_col] 

leftloop1: 

sub di, 10
mov al, 0x0a
stosw
stosw
mov al, '.'
stosw
add di, 2
stosw
sub di, 2
call delay
call delay

loop leftloop1

mov [ghost1_pos], di
pop bp
ret 2

;--------------------------------------------------------

move_g2:

mov di, [ghost2_pos]

mov si, di
sub si, 1 ; left check

mov ah, [es:si]

cmp ah, 0x0C
je check_r2
cmp ah, 0x04
je check_r2 ; go right

mov cx, 1
push cx
call move_left2
ret

check_r2:
mov si, di
add di, 1

mov ah, [es:si]

cmp ah, 0x0C
je check_u2
cmp ah, 0x04
je check_u2; go up

mov cx, 1
push cx
call move_right2
ret

check_u2:
mov si, di
sub di, 159

mov ah, [es:si]

cmp ah, 0x0C
je check_d2
cmp ah, 0x04
je check_d2 ; go up

mov cx, 1
push cx
call move_up2
ret

check_d2:

mov si, di
add di, 159

mov ah, [es:si]

cmp ah, 0x0C
je end_g2
cmp ah, 0x04
je end_g2 ; go up

mov cx, 1
push cx
call move_down2

end_g2:
ret

ret



move_down2:

push bp
mov bp, sp

mov cx, [bp+4]
mov di, [ghost2_pos]

mov ah, [ghost2_col] 

downloop2:
sub di, 4
mov al, '.'
stosw
stosw
add di, 156

mov al, 0x0a
stosw
stosw
call delay
call delay
call delay

loop downloop2

mov [ghost2_pos], di

pop bp
ret 2

move_right2:

push bp
mov bp, sp

mov cx, [bp+4]
mov di, [ghost2_pos]

mov ah, [ghost2_col] 

rightloop2: 

sub di, 4
mov al, '.'
stosw
stosw
mov al, 0x0a
stosw
stosw
call delay
call delay

loop rightloop2

mov [ghost2_pos], di

pop bp
ret 2

move_up2:

push bp
mov bp, sp

mov cx, [bp+4]
mov di, [ghost2_pos]

mov ah, [ghost2_col] 

uploop2:
sub di, 164
mov al, 0x0a
stosw
stosw
add di, 156
mov al, '.'
stosw
stosw
call delay
call delay
call delay
sub di, 160
loop uploop2
mov [ghost2_pos], di

pop bp
ret 2

move_left2:

push bp
mov bp, sp

mov bx, 0xb800
mov es, bx

mov cx, [bp+4]
mov di, [ghost2_pos]

mov ah, [ghost2_col] 

leftloop2: 

sub di, 10
mov al, 0x0a
stosw
stosw
mov al, '.'
stosw
add di, 2
stosw
sub di, 2
call delay
call delay

loop leftloop2

mov [ghost2_pos], di
pop bp
ret 2


;---------------------------------------------------------

move_g3:

mov di, [ghost3_pos]

mov si, di
sub si, 1 ; left check

mov ah, [es:si]

cmp ah, 0x0C
je check_r3
cmp ah, 0x04
je check_r3 ; go right

mov cx, 1
push cx
call move_left3
ret

check_r3:
mov si, di
add di, 1

mov ah, [es:si]

cmp ah, 0x0C
je check_u3
cmp ah, 0x04
je check_u3 ; go up

mov cx, 1
push cx
call move_right3
ret

check_u3:
mov si, di
sub di, 159

mov ah, [es:si]

cmp ah, 0x0C
je check_d3
cmp ah, 0x04
je check_d3 ; go up

mov cx, 1
push cx
call move_up3
ret

check_d3:

mov si, di
add di, 159

mov ah, [es:si]

cmp ah, 0x0C
je end_g3
cmp ah, 0x04
je end_g3; go up

mov cx, 1
push cx
call move_down3

end_g3:
ret

ret

move_down3:

push bp
mov bp, sp

mov cx, [bp+4]
mov di, [ghost3_pos]

mov ah, [ghost3_col] 

downloop3:
sub di, 4
mov al, '.'
stosw
stosw
add di, 156

mov al, 0x0a
stosw
stosw
call delay
call delay
call delay

loop downloop3

mov [ghost3_pos], di

pop bp
ret 2

move_right3:

push bp
mov bp, sp

mov cx, [bp+4]
mov di, [ghost3_pos]

mov ah, [ghost3_col] 

rightloop3: 

sub di, 4
mov al, '.'
stosw
stosw
mov al, 0x0a
stosw
stosw
call delay
call delay

loop rightloop3

mov [ghost3_pos], di

pop bp
ret 2

move_up3:

push bp
mov bp, sp

mov cx, [bp+4]
mov di, [ghost3_pos]

mov ah, [ghost3_col] 

uploop3:
sub di, 164
mov al, 0x0a
stosw
stosw
add di, 156
mov al, '.'
stosw
stosw
call delay
call delay
call delay
sub di, 160
loop uploop3
mov [ghost3_pos], di

pop bp
ret 2

move_left3:

push bp
mov bp, sp

mov bx, 0xb800
mov es, bx

mov cx, [bp+4]
mov di, [ghost3_pos]

mov ah, [ghost3_col] 

leftloop3: 

sub di, 10
mov al, 0x0a
stosw
stosw
mov al, '.'
stosw
add di, 2
stosw
sub di, 2
call delay
call delay

loop leftloop3

mov [ghost3_pos], di
pop bp
ret 2

;--------------------------------------------------------

move_g4:

mov di, [ghost4_pos]

mov si, di
sub si, 1 ; left check

mov ah, [es:si]

cmp ah, 0x0C
je check_r4
cmp ah, 0x04
je check_r4; go right

mov cx, 1
push cx
call move_left4
ret

check_r4:
mov si, di
add di, 1

mov ah, [es:si]

cmp ah, 0x0C
je check_u4
cmp ah, 0x04
je check_u4 ; go up

mov cx, 1
push cx
call move_right4
ret

check_u4:
mov si, di
sub di, 159

mov ah, [es:si]

cmp ah, 0x0C
je check_d4
cmp ah, 0x04
je check_d4 ; go up

mov cx, 1
push cx
call move_up4
ret

check_d4:

mov si, di
add di, 159

mov ah, [es:si]

cmp ah, 0x0C
je end_g4
cmp ah, 0x04
je end_g4 ; go up

mov cx, 1
push cx
call move_down4

end_g4:
ret

ret

move_down4:

push bp
mov bp, sp

mov cx, [bp+4]
mov di, [ghost4_pos]

mov ah, [ghost4_col] 

downloop4:
sub di, 4
mov al, '.'
stosw
stosw
add di, 156

mov al, 0x0a
stosw
stosw
call delay
call delay
call delay

loop downloop4

mov [ghost4_pos], di

pop bp
ret 2

move_right4:

push bp
mov bp, sp

mov cx, [bp+4]
mov di, [ghost4_pos]

mov ah, [ghost4_col] 

rightloop4: 

sub di, 4
mov al, '.'
stosw
stosw
mov al, 0x0a
stosw
stosw
call delay
call delay

loop rightloop4

mov [ghost4_pos], di

pop bp
ret 2

move_up4:

push bp
mov bp, sp

mov cx, [bp+4]
mov di, [ghost4_pos]

mov ah, [ghost4_col] 

uploop4:
sub di, 164
mov al, 0x0a
stosw
stosw
add di, 156
mov al, '.'
stosw
stosw
call delay
call delay
call delay
sub di, 160
loop uploop4
mov [ghost4_pos], di

pop bp
ret 2

move_left4:

push bp
mov bp, sp

mov bx, 0xb800
mov es, bx

mov cx, [bp+4]
mov di, [ghost4_pos]

mov ah, [ghost4_col] 

leftloop4: 

sub di, 10
mov al, 0x0a
stosw
stosw
mov al, '.'
stosw
add di, 2
stosw
sub di, 2
call delay
call delay

loop leftloop4

mov [ghost4_pos], di
pop bp
ret 2


;---------------------------------------------------------
left:

push bp
mov bp, sp

mov bx, 0xb800
mov es, bx

mov cx, [bp+4]
mov di, [pacman_position]

mov ah, 00001110b 

leftloop: 

sub di, 10
mov al, 0x08
stosw
stosw
mov al, ' '
stosw
add di, 2
stosw
sub di, 2
call delay
call delay

loop leftloop

mov [pacman_position], di
pop bp
ret 2

down:

push bp
mov bp, sp

mov cx, [bp+4]
mov di, [pacman_position]

mov ah, 00001110b 

downloop:
sub di, 4
mov al, ' '
stosw
stosw
add di, 156

mov al, 0x08
stosw
stosw
call delay
call delay
call delay

loop downloop

mov [pacman_position], di

pop bp
ret 2

right:

push bp
mov bp, sp

mov cx, [bp+4]
mov di, [pacman_position]

mov ah, 00001110b 

rightloop: 

sub di, 4
mov al, ' '
stosw
stosw
mov al, 0x08
stosw
stosw
call delay
call delay

loop rightloop

mov [pacman_position], di

pop bp
ret 2

up:

push bp
mov bp, sp

mov cx, [bp+4]
mov di, [pacman_position]

mov ah, 00001110b 

uploop:
sub di, 164
mov al, 0x08
stosw
stosw
add di, 156
mov al, ' '
stosw
stosw
call delay
call delay
call delay
sub di, 160
loop uploop
mov [pacman_position], di

pop bp
ret 2


move_pacman:

push bp
mov bp, sp
mov di, [pacman_position]

mov ah, 0
int 16h

check1:

cmp ah, 4Bh ;left
jne check2

mov si, di
sub si, 1

mov ah, [es:si]
cmp ah, 0x0C       
je finish
cmp ah, 0x04
je finish

; mov al, [es:si]
; cmp al, '.'       
; je m_left
; cmp al, ' '       
; jne finish

m_left:
mov cx, 1
push cx
call left


sub di, 8
mov ah, 0x07
mov al, ' '
stosw
stosw

jmp finish

check2:
cmp ah, 4Dh ;right
jne check3

mov si, di
add si, 1

mov ah, [es:si]
cmp ah, 0x0C       
je finish
cmp ah, 0x04
je finish

m_right:
mov cx, 1
push cx
call right

jmp finish

check3:
cmp ah, 48h ; up
jne check4

mov si, di
sub si, 159

mov ah, [es:si]
cmp ah, 0x0C       
je finish
cmp ah, 0x04
je finish

; mov al, [es:si]
; cmp al, '.'       
; je m_up
; cmp al, ' '       
; je m_up
; add di, 160
; jmp finish

m_up:
mov cx, 1
push cx
call up

jmp finish

check4:
cmp ah, 50h ; down
jne finish

mov si, di
add si, 159

mov ah, [es:si]
cmp ah, 0x0C       
je finish
cmp ah, 0x04
je finish

; mov al, [es:si]
; cmp al, '.'       
; je m_down
; cmp al, ' '       
; je m_down
; jmp finish

m_down:

mov cx, 1
push cx
call down



finish:

pop bp
ret



intro:

mov ah, 0x13
mov al, 1
mov bh, 0
mov bl, 0x0c
mov cx, 53
mov dh, 8
mov dl, 16
push ds
pop es
mov bp, line1
int 10h

mov cx, 54
mov dh, 9
mov bp, line2
int 10h

mov cx, 54
mov dh, 10
mov bp, line3
int 10h

mov cx, 54
mov dh, 11
mov bp, line4
int 10h

mov cx, 54
mov dh, 12
mov bp, line5
int 10h

mov cx, 19
mov dh, 13
mov bp, line6
int 10h

mov cx, 25
mov dh, 14
mov dl, 30
mov bp, line8
int 10h

mov cx, 25
mov dh, 15
mov dl, 30
mov bp, line9
int 10h

mov cx, 16
mov dh, 16
mov dl, 36
mov bp, line10
int 10h

mov cx, 20
mov dh, 17
mov dl, 34
mov bl, 0xd0
mov bp, line6
int 10h

mov cx, 20
mov dh, 17
mov dl, 34
mov bp, line7
int 10h

mov ah, 0
int 16h
cmp ah, 0x1c
jne intro

ret

clear:
mov ax, 0xb800
mov es, ax
xor di, di

mov cx, 2000
mov ah, 0x07
mov al, ' '
rep stosw 

ret

display:

;starting half
mov di, 14
mov ah, 0x07
mov al, '.'
mov cx, 68
mov dx, 24

l6:
rep stosw
mov cx, 68
add di, 24
dec dx
jnz l6


mov di, 10
mov cx, 70
mov ah, 00001100b

stosw

mov al, 0xdc

rep stosw

mov dx, 2

l1:

add di, 20
mov al, 0xdd
stosw

add di, 136
mov al, 0xdb

stosw
dec dx

jnz l1

;swirly on top

add di, 20
mov al, 0xdf
stosw
stosw
stosw
stosw
mov al, 0xb2
stosw


add di, 120
mov al, 0xb2
stosw
mov al, 0xdf
stosw
stosw
stosw
stosw

add di, 20
stosw
stosw
stosw
stosw
stosw


add di, 120
stosw
stosw
stosw
stosw
stosw

; top middle rectangle hurdle


;middle swirly

mov al, 0xdf
add di, 20
stosw
stosw
stosw
mov al, 0xb2
stosw


add di, 126
mov al, 0xdc
stosw
stosw
stosw
 

add di, 26
mov al, 0xb2
stosw


add di, 126
stosw

add di, 30
stosw

add di, 126
stosw

add di, 30
stosw

add di, 126
stosw

add di, 30
stosw

add di, 126
stosw

add di, 30
stosw

add di, 126
stosw

add di, 30
stosw

add di, 126
stosw

add di, 24
mov al, 0xdf
stosw
stosw
stosw
stosw

add di, 126
stosw
stosw
stosw

; swirly pattern on bottom half

add di, 20
mov al, 0xdf
stosw
stosw
stosw
stosw
mov al, 0xb2
stosw


add di, 120
mov al, 0xdb
stosw
mov al, 0xdf
stosw
stosw
stosw
stosw

add di, 20
mov al, 0xb2
stosw

mov al, 0xdf
stosw
stosw
stosw
stosw

add di, 120
stosw
stosw
stosw
stosw
mov al, 0xb2
stosw

; add di, 320
mov al, 0xdc
mov dx, 9


l2:

add di, 20
mov al, 0xdb
stosw

add di, 136
mov al, 0xdb

stosw
dec dx

jnz l2

add di, 20
mov al, 0xdf
mov cx, 70
rep stosw


;left most hurdle 1, rectangle

mov di, 2906
mov al, 0xb1

stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw   
stosw
stosw

add di, 74
mov al, 0xb1
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw

mov cx, 2
l4:
add di, 46
mov al, 0xb1
stosw
mov al, 0xdb
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw
mov al, 0xb1
stosw

add di, 74
mov al, 0xb1
stosw
mov al, 0xdb
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw
mov al, 0xb1
stosw
dec cx
jnz l4

add di, 46
mov al, 0xb1
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw

add di, 74
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw

;top big rectangle hurdles

mov di, 1008 
mov al, 0xb1

stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw   
stosw
stosw

add di, 34
mov al, 0xb1
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw

mov cx, 1
l5:
add di, 86
mov al, 0xb1
stosw
mov al, 0xdb
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw
mov al, 0xb1
stosw

add di, 34
mov al, 0xb1
stosw
mov al, 0xdb
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw
mov al, 0xb1
stosw
dec cx
jnz l5

add di, 86
mov al, 0xb1
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw

add di, 34
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw

; mini rectangle hurdles on the top

mov di, 210
mov al, 0xb1
stosw
stosw
stosw

mov al, 0xb1
stosw
stosw
stosw

add di, 150
mov al, 0xb0
stosw
mov al, 0xb1
stosw
stosw
mov al, 0xb0
stosw

add di, 152
stosw
stosw
stosw
stosw

add di, 154
stosw
stosw

mov di, 260
mov al, 0xb1
stosw
stosw
stosw

mov al, 0xb1
stosw
stosw
stosw

add di, 150
mov al, 0xb0
stosw
mov al, 0xb1
stosw
stosw
mov al, 0xb0
stosw

add di, 152
stosw
stosw
stosw
stosw

add di, 154
stosw
stosw

;top skinny rectangle hurdles

mov di, 510
stosw
mov al, 0xb1
stosw
stosw
stosw
mov al, 0xb0
stosw

add di, 30
stosw
stosw
mov al, 0xb1
stosw
stosw
stosw
stosw
stosw
stosw
stosw
stosw
mov al, 0xb0
stosw
stosw

add di, 30
stosw
mov al, 0xb1
stosw
stosw
stosw
mov al, 0xb0
stosw


mov di, 2592
stosw
stosw
mov al, 0xb1
stosw
stosw
stosw
stosw
mov al, 0xb0
stosw
stosw

add di, 70
stosw
stosw
mov al, 0xb1
stosw
stosw
stosw
stosw
mov al, 0xb0
stosw
stosw

; ghost's hideout

mov di, 1670
mov al, 0xb2
stosw

mov al, 0xdf
stosw
stosw
stosw
mov ah, 00001110b
stosw
stosw
stosw
stosw
stosw
stosw
mov ah, 00001100b
stosw
stosw
stosw
mov al, 0xb2
stosw

add di, 132
stosw
add di, 24
stosw

add di, 132
stosw
add di, 24
stosw


add di, 132
stosw
add di, 24
stosw


add di, 132
mov cx, 14
mov al, 0xdf
rep stosw

;t-shapes at the bottom

mov di, 2644
mov al, 0xdb
mov ah, 0x04
stosw
add di, 158
mov ah, 0xC
stosw
add di, 150
mov al, 0xdf
mov ah, 0x04
stosw

mov ah, 0xC
mov cx, 7
rep stosw
mov ah, 0x04
stosw

add di, 310
mov al, 0xdb
mov ah, 0x04
stosw
add di, 158
mov ah, 0xC
stosw
add di, 150
mov al, 0xdf
mov ah, 0x04
stosw

mov ah, 0xC
mov cx, 7
rep stosw
mov ah, 0x04
stosw

; T SHAPES ON THE top


mov di, 1044
mov al, 0xdb
mov ah, 0x04
stosw
add di, 158
mov ah, 0xC
stosw
add di, 150
mov al, 0xdf
mov ah, 0x04
stosw

mov ah, 0xC
mov cx, 7
rep stosw
mov ah, 0x04
stosw

; t shapes on the sides

mov di, 1814
mov al, 0xdb
mov ah, 0x04
stosw
add di, 158
mov ah, 0xC
stosw
add di, 150
mov al, 0xdf
mov ah, 0x04
stosw

mov ah, 0xC
mov cx, 7
rep stosw
mov ah, 0x04
stosw

mov di, 1874
mov al, 0xdb
mov ah, 0x04
stosw
add di, 158
mov ah, 0xC
stosw
add di, 150
mov al, 0xdf
mov ah, 0x04
stosw

mov ah, 0xC
mov cx, 7
rep stosw
mov ah, 0x04
stosw

; l shapes on the bottom

mov al, 0xb1
mov di, 2774
stosw
add di, 158
stosw
add di, 158
stosw
add di, 158
stosw
add di, 158
mov al, 0xdf
stosw
stosw
stosw
stosw
stosw
stosw


mov al, 0xb1
mov di, 2830
stosw
add di, 158
stosw
add di, 158
stosw
add di, 158
stosw
add di, 148
mov al, 0xdf
stosw
stosw
stosw
stosw
stosw
stosw

; l shapes in the middle

mov di, 940
mov al, 0xb1
stosw
add di, 158
stosw
add di, 158
stosw
add di, 158
stosw
add di, 148
mov al, 0xdf
stosw
stosw
stosw
stosw
stosw
stosw

mov di, 1792
mov al, 0xb1
stosw
mov al, 0xdf
stosw
stosw
stosw
stosw
add di, 150
mov al, 0xb1
stosw
add di, 158
stosw

mov al, 0xb1
mov di, 826
stosw
add di, 158
stosw
add di, 158
stosw
add di, 158
stosw
add di, 158
mov al, 0xdf
stosw
stosw
stosw
stosw
stosw
stosw

mov di, 1884
stosw
stosw
stosw
stosw
stosw
mov al, 0xb1
stosw
add di, 158
stosw
add di, 158
stosw


;strategically clearing out spaces
mov di, 974
mov al, ' '
mov dx, 6
l7:
stosw 
stosw
add di, 156
dec dx
jnz l7

mov di, 1108
mov dx, 6
l8:
stosw 
add di, 158
dec dx
jnz l8

;cleaning the ghosts' lair

mov di, 1832
mov dx, 3
mov cx, 12

l9:
rep stosw
mov cx, 12
add di, 136
dec dx
jnz l9


;making pacman

mov al, 0x08
mov ah, 00001110b
mov di, 3718
stosw
stosw

;making ghosts

mov di, 1838
mov al, 0x0A
mov ah, 00001110b
stosw
stosw
add di, 156
mov al, 0xdb
stosw
stosw

mov di, 1992
mov al, 0x0A
mov ah, 00001111b
stosw
stosw
add di, 156
mov al, 0xdb
stosw
stosw

mov di, 2004
mov al, 0x0A
mov ah, 00001010b
stosw
stosw
add di, 156
mov al, 0xdb
stosw
stosw

mov di, 1850
mov al, 0x0A
mov ah, 00001100b
stosw
stosw
add di, 156
mov al, 0xdb
stosw
stosw


ret

start:

mov ax, 1100
out 0x40, al
mov al, ah
out 0x40, al

call clear
call intro
call clear
call delay
call delay
call delay
call exit_screen
call delay
call delay
call delay
call delay
call delay
call delay
call clear
call display
call move_ghost1
call move_ghost2
call move_ghost3
call move_ghost4

xor ax, ax
mov es, ax ; point es to IVT base

mov ax, [es:9*4]
mov [oldkb], ax ; save offset of old routine
mov ax, [es:9*4+2]
mov [oldkb+2], ax ; save segment of old routine

; cli ; disable interrupts
; mov word [es:9*4], kbisr ; store offset at n*4
; mov [es:9*4+2], cs ; store segment at n*4+2
; mov word [es:8*4], timer ; store offset at n*4
; mov [es:8*4+2], cs ; store segment at n*4+
; sti ; enable interrupts

;call display_score

mov ah, 0x13
mov al, 1
mov bh, 0
mov bl, 0x0c
mov cx, 15
mov dh, 20
mov dl, 30
push ds
pop es
mov bp, exiting

play:
call move_pacman
call display_score
mov ah, 0
int 16h
cmp ah, 0x12
jne play
;call display_score


end_of_game:
call clear
call exit_final
dec word[score]
call display_score

mov dx, start ; end of resident portion
add dx, 15 ; round up to next para
mov cl, 4
shr dx, cl ; number of paras
mov ax, 0x3100 ; terminate and stay resident
int 0x21 
