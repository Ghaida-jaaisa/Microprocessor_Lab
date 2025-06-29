CODE SEGMENT
ASSUME CS : CODE , DS : CODE , ES  : CODE , SS : CODE

; FOR KEYPAD
KEY EQU 01H

; FOR ELEVATOR
PPI EQU 26H
CPORT EQU  24H
BPORT EQU 22H
APORT EQU 20H

ORG 1000H

         ; KEYPAD ON by Default
AGAIN : 
 
 CALL SCAN  ;;   VALUE IS IN K_BUF
 
 
       ;;  ELEVATOR ON
         MOV AL , 90H
         OUT PPI , AL
         
        MOV DL , BYTE PTR K_BUF
        ; IF KEY A PRESSED
         CMP DL , 0AH
         JNE  AGAIN
         IN AL , APORT
         AND AL , 0F0H
         CMP AL , 20H
         JNE AGAIN
         ;; NOW WE IN FLOOR2
         
         MOV AL , 0F6H
         OUT CPORT , AL
          REPEAT :
IN AL , APORT
AND AL , 0F0H
CMP AL , 40H
JE IN_3
CONT1 :
IN AL , APORT
AND AL , 0F0H
CMP AL , 80H
JE STOP
JMP REPEAT

         
         
;;;
JMP EXIT



SCAN: IN AL,KEY
 TEST AL,10000000B
 JNZ SCAN
 TEST AL,00010000B
 JNZ SCAN
 ;
 AND AL,00001111B
 MOV BYTE PTR K_BUF,AL
 ; key clear
 OUT KEY,AL
 RET
 ;
 
IN_3 :
      MOV AL , 0B6H
      OUT CPORT , AL
      MOV AL , 0B0H
      OUT BPORT , AL
      JMP CONT1

IN_4 :
      MOV AL , 076H
      OUT CPORT , AL
      MOV AL , 099H
      OUT BPORT , AL
      ;JMP CONT2
 
STOP :
      MOV AL , 07FH
      OUT CPORT , AL
      MOV AL , 099H
      OUT BPORT , AL
      JMP EXIT
       
K_BUF: DB 1
      EXIT :

      INT 3;
      CODE ENDS
      END