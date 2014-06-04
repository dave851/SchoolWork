            TTL Lab8 Queue
;***************************************************************
;This application shows a implementation of a queue data 
;structure for byte data
;Name:  David Desrochers
;Date:  3/18/2014
;Class:  CMPE-250
;Section:  Tuesday 11am
;---------------------------------------------------------------
;Template:  R. W. Melton, March 1, 2014
;***************************************************************
;Assembler directives
            THUMB
		    OPT    64  ;Turn on listing macro expansions
SSTACK_SIZE EQU    0x00000100  ;required for MKL25Z128xxx4.s
;***************************************************************
;Include files
;  MK25Z128xxx4.s
            GET  MKL25Z128xxx4.s
		    OPT  1   ;Turn on listing
;***************************************************************
;EQUates

;EQUates for queue record management
IN_PTR	 EQU 0
OUT_PTR  EQU 4
BUF_STRT EQU 8
BUF_PAST EQU 12
BUF_SIZE EQU 16
NUM_ENQD EQU 17	
	
;EQUated for stucture sizes
Q_REC_SZ EQU 18
Q_BUF_SZ EQU 4
	
;---------------------------------------------------------------
;EQUates to use UART1 for serial I/O
;PORTx_PCRn (Port x pin control register n [for pin n])
;___->10-08:Pin mux control (select 0 to 8)
PIN_MUX_SELECT_3  EQU  0x00000300
;---------------------------------------------------------------
;Port C
PTC3_MUX_UART1_RX EQU  PIN_MUX_SELECT_3
PTC4_MUX_UART1_TX EQU  PIN_MUX_SELECT_3
SET_PTC3_UART1_RX EQU  (PIN_ISF_MASK :OR: PTC3_MUX_UART1_RX)
SET_PTC4_UART1_TX EQU  (PIN_ISF_MASK :OR: PTC4_MUX_UART1_TX)
;---------------------------------------------------------------
;SIM_SCGC4
;1->11:UART1 clock gate control (enabled)
UART1CGC_MASK  EQU  SIM_SCGC4_UART1_MASK
;---------------------------------------------------------------
;SIM_SCGC5
;1->   11:Port C clock gate control (enabled)
PORTCCGC_MASK  EQU  SIM_SCGC5_PORTC_MASK
;---------------------------------------------------------------
;SIM_SOPT5
; 0->   17:UART1 open drain enable (disabled)
; 0->   06:UART1 receive data select (UART1_RX)
;00->05-04:UART1 transmit data select source (UART1_TX)
UART1_EXTERN_MASK_CLEAR EQU (UART1ODE_MASK :OR: UART1RXSRC_MASK :OR: UART1TXSRC_MASK)
;---------------------------------------------------------------
;UARTx_BDH
;    0->  7:LIN break detect IE (disabled)
;    0->  6:RxD input active edge IE (disabled)
;    0->  5:Stop bit number select (1)
;00000->4-0:SBR[12:0] (BUSCLK / (16 x 9600))
;BUSCLK = CORECLK / 2 = PLLCLK / 4
;PLLCLK is 96 MHz
;BUSCLK is 24 MHz
;SBR = 24 MHz / (16 x 9600) = 156.25 --> 156 = 0x009C
UART_9600H  EQU 0x00
;---------------------------------------------------------------
;UARTx_BDL
;26->7-0:SBR[7:0] (BUSCLK / 16 x 9600))
;BUSCLK = CORECLK / 2 = PLLCLK / 4
;PLLCLK is 96 MHz
;BUSCLK is 24 MHz
;SBR = 24 MHz / (16 x 9600) = 156.25 --> 0x9C
UART_9600L  EQU 0x9C
;---------------------------------------------------------------
;UARTx_C1
;0-->7:LOOPS=loops select (normal)
;0-->6:UARTSWAI=UART stop in wait mode (disabled)
;0-->5:RSRC=receiver source select (internal--no effect LOOPS=0)
;0-->4:M=9- or 8-bit mode select (1 start, 8 data [lsb first], 1 stop)
;0-->3:WAKE=receiver wakeup method select (idle)
;0-->2:IDLE=idle line type select (idle begins after start bit)
;0-->1:PE=parity enable (disabled)
;0-->0:PT=parity type (even parity--no effect PE=0)
UART_8N1 EQU 0x00
;---------------------------------------------------------------
;UARTx_C2
;0-->7:TIE=transmit IE for TDRE (disabled)
;0-->6:TCIE=trasmission complete IE for TC (disabled)
;0-->5:RIE=receiver IE for RDRF (disabled)
;0-->4:ILIE=idle line IE for IDLE (disabled)
;1-->3:TE=transmitter enable (enabled)
;1-->2:RE=receiver enable (enabled)
;0-->1:RWU=receiver wakeup control (normal)
;0-->0:SBK=send break (disabled, normal)
UART_T_R  EQU  (UART_TE_MASK :OR: UART_RE_MASK)
;---------------------------------------------------------------
;UARTx_C3
;0-->7:R8=9th data bit for receiver (not used M=0)
;0-->6:T8=9th data bit for transmitter (not used M=0)
;0-->5:TXDIR=TxD pin direction in single-wire mode (no effect LOOPS=0)
;0-->4:TXINV=transmit data inversion (not invereted)
;0-->3:ORIE=overrun IE for OR (disabled)
;0-->2:NEIE=noise error IE for NF (disabled)
;0-->1:FEIE=framing error IE for FE (disabled)
;0-->0:PEIE=parity error IE for PF (disabled)
UART_TX_NOT_INVERTED EQU  0x00
;---------------------------------------------------------------
;UARTx_C4
;0-->  7:TDMAS=transmitter DMA select (disabled)
;0-->  6:Reserved; read-only; always 0
;0-->  5:RDMAS=receiver full DMA select (disabled)
;0-->  4:Reserved; read-only; always 0
;0-->  3:Reserved; read-only; always 0
;0-->2-0:Reserved; read-only; always 0
UART_NO_DMA EQU  0x00
;**********************************************************************
;Program
;Linker requires Reset_Handler
            AREA    MyCode,CODE,READONLY
            ENTRY
            EXPORT  Reset_Handler
Reset_Handler            
main
;---------------------------------------------------------------
;begin program code
            BL      SystemInit
;Mask interrupts
            CPSID   I
;Configure 48-MHz system clock
            BL      SetClock48MHz
;---------------------------------------------------------------
;begin program code

			;Set-up application by loading base address for
			;Record structure and initalizing UART1
			BL   UART1__Init
			BL   Q_init
			LDR  R1, =QRecord
Main		LDR	 R0, =TypePrmp   ;Prompt user for command
			BL   PutString
NotRec		BL	 GetChar
			;Compair with known commands and call 
			;correct subroutine
			CMP	 R0, #'a'
			BLO	 CorrectCase
FixCase		SUBS R0, R0, #0x20
CorrectCase	CMP	 R0, #'D'
			BEQ	 TerDeq
			CMP	 R0, #'E'
			BEQ	 TerEnq
			CMP	 R0, #'H'
			BEQ	 TerHlp
			CMP	 R0, #'P'
			BEQ	 TerPrt
			CMP	 R0, #'S'
			BEQ	 TerSts
			B    NotRec
			
			;Echo's comand and dequeues character
			;Prints success or failure based on
			;return from dequeue
TerDeq		BL	 PutChar
			MOVS R0, #0x0D
			BL   PutChar
			MOVS R0, #0x0A
			BL   PutChar
			BL   Dequeue
			BCS  Failure
			BL	 PutChar
			MOVS R0, #0x0D
			BL   PutChar
			MOVS R0, #0x0A
			BL   PutChar
			B    Main
			
			;Echo's comand and prompts for
			;character to enqueue
			;Prints success or failure based on
			;return from enqueue
TerEnq		BL	 PutChar
			MOVS R0, #0x0D
			BL   PutChar
			MOVS R0, #0x0A
			BL   PutChar
			LDR  R0, =CharPrmp
			BL   PutString
			BL   GetChar
			BL   PutChar
			BL   Enqueue
			MOVS R0, #0x0D
			BL   PutChar
			MOVS R0, #0x0A
			BL	 PutChar
			BCS  Failure
			B    Success
			
			;Prints failure message
Failure		LDR  R0, =Fail
			BL   PutString
			B    Main
			
			;Prints success message
Success     LDR  R0, =Sec
			BL   PutString
			B    Main

			;Prints help string
TerHlp		BL	 PutChar
			MOVS R0, #0x0D
			BL   PutChar
			MOVS R0, #0x0A
			BL   PutChar
			LDR  R0, =help
			BL   PutString
			B    Main

			;Prints contents of queue
TerPrt		BL	 PutChar
			MOVS R0, #0x0D
			BL   PutChar
			MOVS R0, #0x0A
			BL   PutChar
			;Check if queue is empty
			LDRB R2, [R1, #NUM_ENQD]
			MOVS R3, #0
			CMP  R2, R3
			BEQ  EMPTY
			LDRB R3, [R1, #BUF_SIZE]
			CMP  R2, R3
			;Load needed pointers
			LDR  R2, [R1, #OUT_PTR]
			LDR  R3, [R1, #IN_PTR]
			LDR  R4, [R1, #BUF_PAST]
			;Branch for full condition
			BEQ  Full
			;Print until out pointer 
			;is at in pointer location
Printing    CMP  R2, R3
			BEQ  Main
Full		MOVS R0, #">"
			BL   PutChar
			LDRB R0, [R2, #0]
			BL   PutChar
			MOVS R0, #"<"
			BL   PutChar
			ADDS R2, #1
			;Check next address is in the bounds
			;of the queue, wrap if not
			CMP  R2, R4
			BLO  NoWrap
			LDR  R2, [R1, #BUF_STRT]
NoWrap		MOVS R0, #0x0D
			BL   PutChar
			MOVS R0, #0x0A
			BL   PutChar
     		B    Printing
EMPTY       MOVS R0, #">"
			BL   PutChar
			MOVS R0, #"<"
			BL   PutChar
			MOVS R0, #0x0D
			BL   PutChar
			MOVS R0, #0x0A
			BL   PutChar
			B    Main

			;Prints pointers locations
			;and number of elements in the queue
TerSts		BL	 PutChar
			MOVS R0, #0x0D
			BL   PutChar
			MOVS R0, #0x0A
			BL   PutChar
			LDR  R0, =Status
			BL   PutString
			LDR  R0, =In
			BL   PutString
			LDR  R1, =QRecord
			LDR	 R0, [R1, #IN_PTR]
			BL   PutNumHex
			LDR  R0, =Out
			BL   PutString
			LDR  R0, [R1, #OUT_PTR]
			BL   PutNumHex
			LDR  R0, =Num
			BL   PutString
			LDRB R0, [R1, #NUM_ENQD]
			BL   PutNumUB
			MOVS R0, #0x0D
			BL   PutChar
			MOVS R0, #0x0A
			BL   PutChar
			B    Main
			
;**************************************************************
;Init for queue record at QRecord space, QBuffer needs to also
;be defined. 
;Modify: R0, R1, PSR
;**************************************************************	

		;Retrive buffer location and instantiate all pointers/conters
Q_init  LDR  R0, =QRecord
		LDR  R1, =QBuffer
		STR  R1, [R0, #IN_PTR]
		STR  R1, [R0, #OUT_PTR]
		STR  R1, [R0, #BUF_STRT]
		ADDS R1, #Q_BUF_SZ
		STR  R1, [R0, #BUF_PAST]
		MOVS R1, #Q_BUF_SZ
		STRB R1, [R0, #BUF_SIZE]
		MOVS R1, #0
		STRB R1, [R0, #NUM_ENQD]
		BX   LR
		

;**************************************************************
;Dequeue attempts to get a charater from the ques whose record 
;structure is in R1, if empty operation fails and set C flag
;Input: R1: base memory of record 
;Output: R0: character from queue
;Modify: PSR, R0, RAM
;**************************************************************	
		
Dequeue PUSH{R2,R3}
		LDRB R2,[R1, #NUM_ENQD]
		CMP  R2, #0				;If queue empty
		BEQ  QEMP
		SUBS R2, #1
		STRB R2, [R1, #NUM_ENQD]
		LDR  R2, [R1, #OUT_PTR] ;Load out pointer
		LDRB R0, [R2, #0]       ;Get character 
		ADDS R2, #1
		LDR  R3, [R1, #BUF_PAST];Check boundry
		CMP  R2, R3
		BLO   NOTSTR
		LDR  R2, [R1, #BUF_STRT]
		;Update record data and clear C flag
NOTSTR	STR  R2, [R1, #OUT_PTR] 
		PUSH {R0}		
		PUSH {R1}		
		MRS	 R0, APSR   
		MOVS R1, #0x20  
		LSLS R1, R1, #24
		BICS R0, R1     
		MSR  APSR, R0
		POP  {R1}		
		POP  {R0}   
		POP  {R2,R3}
		BX   LR

		;Set C flag in failure case
QEMP	PUSH {R0}		
		PUSH {R1}		
		MRS	 R0, APSR   
		MOVS R1, #0x20  
		LSLS R1, R1, #24
		ORRS R0, R1     
		MSR  APSR, R0
		POP  {R1}		
		POP  {R0}       
		POP  {R2,R3}
		BX   LR

;**************************************************************
;Enqueue attempts to put a charater in the queue whose record 
;address is in R1, if not full enqueues character in R0 to queue
;C flag set is operation fails
;Input: R1: base memory of record 
;Output: R0: character to queue
;Modify: PSR, R0, RAM
;**************************************************************	

Enqueue PUSH{R2,R3}
		LDRB R2,[R1, #NUM_ENQD]
		LDRB R3, [R1, #BUF_SIZE]
		CMP  R2, R3      		;If queue Full
		BEQ  QFUL
		ADDS R2, #1
		STRB R2, [R1, #NUM_ENQD]
		LDR  R2, [R1, #IN_PTR]  ;Load in pointer
		STRB R0, [R2, #0]       ;Put character
		ADDS R2, #1
		LDR  R3, [R1, #BUF_PAST]
		CMP  R2, R3    		    ;Check boundry
		BLO  NOTEND
		LDR  R2, [R1, #BUF_STRT]
		;Update record data and clear C flag
NOTEND	STR  R2, [R1, #IN_PTR]
		PUSH {R0}		
		PUSH {R1}		
		MRS	 R0, APSR   
		MOVS R1, #0x20  
		LSLS R1, R1, #24
		BICS R0, R1     
		MSR  APSR, R0
		POP  {R1}		
		POP  {R0}   
		POP  {R2,R3}
		BX   LR
		
		;Set C flag in failure case
QFUL	PUSH {R0}		
		PUSH {R1}		
		MRS	 R0, APSR   
		MOVS R1, #0x20  
		LSLS R1, R1, #24
		ORRS R0, R1     
		MSR  APSR, R0
		POP  {R1}		
		POP  {R0}       
		POP  {R2,R3}
		BX   LR

;**************************************************************
;Polls UART1 untill character can be read, then
;places the character in R0
;Input: None
;Output: R0: charater read
;Modify: R0, PSR
;**************************************************************	
GetChar		;Wait for RDRF
			PUSH    {R1-R3}
			LDR		R1, =UART1_BASE
			MOVS	R2, #UART_RDRF_MASK
PollRx		LDRB	R3, [R1,#UART_S1_OFFSET]
			ANDS    R3,R3,R2
			BEQ		PollRx
			;Receive
			LDRB	R0, [R1,#UART_D_OFFSET]
			POP		{R1-R3}
			BX		LR

;**************************************************************
;Transmits a character using the UART1 module
;Input: R1: pointer to array of signed words
;       R2: word value of number of elements in array
;Output: R0: number of non-zero elements in array
;Modify: R0, PSR
;**************************************************************	
PutChar		;Wait for TDRE
			PUSH    {R1-R3}
			LDR		R1, =UART1_BASE
			MOVS	R2, #UART_TDRE_MASK
PollTx		LDRB	R3, [R1,#UART_S1_OFFSET]
			ANDS    R3,R3,R2
			BEQ		PollTx
			;Send
			STRB	R0, [R1,#UART_D_OFFSET]
			POP		{R1-R3}
			BX		LR

;**************************************************************
;Displays a null-terinated string from memory starting
;at the address in R0 to the terminal.
;Input: R0: base memory location
;Output: None
;Modify: PSR
;**************************************************************	
;R0: Char to put
;R1: Current memory address
PutString   PUSH {R0-R1,LR}
		    MOVS R1, R0
NextCharP	LDRB R0, [R1, #0]
		    ADDS R1, #0x01
		    CMP  R0, #0x00
		    BEQ  Terminate
			BL   PutChar
			B	 NextCharP
Terminate	POP  {R0-R1,PC}

;**************************************************************
;Division Subroutine
;Input: R0: divisor 
;       R1: dividend
;Output:R0: integer result
;		R1: Remainder
;Modify:R0,R1 PSR
;**************************************************************	
DIVU		CMP  R0, #0		;Check if dividing by zero
			BEQ	 DivByZero  ;Branch if dividing by zero
			
startDiv	PUSH {R2}	    ;Push register on stack to be restore it later
			MOVS  R2, #0 	;Set R2 to 0, will be used as integer result

Dividing	CMP  R1, R0		;Check if demoninator is bigger then numberator
			BLO  DoneDiv    ;Branch to finish if above is true
			SUBS  R1, R0     ;Subtract demoninator from numerator
			ADDS  R2, #1     ;Add one to result
			B    Dividing   ;Continue dividing if above is false

DoneDiv		MOV  R0, R2		;Move result in correct register
			POP {R2}		;Restore data in R2 from the stack
			BX   LR			;Return from call
			
DivByZero   PUSH {R0}		;Push register onto stack to restore later
			PUSH {R1}		;Push register onto stack to restore later
			MRS	 R0, APSR   ;Move the APSR into R0
			MOVS R1, #0x20  ;Change the flags 
			LSLS R1, R1, #24;Shift into correct position
			ORRS R0, R1     
			MSR  APSR, R0	;Write the representation of the flags into the APSR
			POP  {R1}		;Restore R1 from stack
			POP  {R0}       ;Restore R2 form stack
			BX   LR         ;Return from call

;**************************************************************
;Configure and initalize UART1 model for commincation
;**************************************************************	
UART1__Init	;External Comms
			LDR		R0, =SIM_SOPT5
			LDR		R1, =UART1_EXTERN_MASK_CLEAR
			LDR		R2,[R0,#0]
			BICS	R2,R2,R1
			STR		R2,[R0,#0]
			;Clock UART1 enable
			LDR		R0, =SIM_SCGC4
			LDR		R1, =UART1CGC_MASK
			LDR		R2,[R0,#0]
			ORRS	R2,R2,R1
			STR		R2,[R0,#0]
			;Clock PortC enable
			LDR		R0, =SIM_SCGC5
			LDR		R1, =PORTCCGC_MASK
			LDR		R2, [R0,#0]
			ORRS	R2,R2,R1
			STR		R2,[R0,#0]
			;UART1 Rx to PCT3
			LDR		R0, =PORTC_PCR3
			LDR		R1, =SET_PTC3_UART1_RX
			STR		R1, [R0,#0]
			;UART Tc to PCT4
			LDR     R0, =PORTC_PCR4
			LDR     R1, =SET_PTC4_UART1_TX
			STR		R1, [R0,#0]
			;Load buad rate
			LDR		R0, =UART1_BASE
			MOVS	R1, #UART_9600H
			STRB	R1, [R0, #UART_BDH_OFFSET]
			MOVS	R1, #UART_9600L
			STRB	R1, [R0, #UART_BDL_OFFSET]
			MOVS    R1, #UART_8N1
			;Set control registers
			STRB	R1, [R0, #UART_C1_OFFSET]
			MOVS	R1, #UART_TX_NOT_INVERTED
			STRB	R1, [R0, #UART_C3_OFFSET]
			MOVS	R1, #UART_NO_DMA
			STRB	R1, [R0, #UART_C4_OFFSET]
			;Turn on
			MOVS	R1, #UART_T_R
			STRB	R1, [R0, #UART_C2_OFFSET]
			BX		LR

;**********************************************************************
;Begin machine code provided for Lab Exercise Eight
;Place at bottom of MyCode section before ";end program code"
;comment in provided template so that "ALIGN" directive and 
;"__EndMyCode" label follow this code block.
;**********************************************************************
            ALIGN
PutNumHex   DCI     0xB53E
            DCI     0x4601
            DCI     0x4D17
            DCI     0x2030
            DCI     0x47A8
            DCI     0x2078
            DCI     0x47A8
            DCI     0x2208
            DCI     0x231C
            DCI     0x240F
            DCI     0x41D9
            DCI     0x4608
            DCI     0x4020
            DCI     0x3030
            DCI     0x2839
            DCI     0xD901
            DCI     0x3041
            DCI     0x383A
            DCI     0x47A8
            DCI     0x1E52
            DCI     0xD1F4
            DCI     0x4608
            DCI     0xBD3E
PutNumU     DCI     0xB507
            DCI     0x2100
            DCI     0xB402
            DCI     0x4A0A
            DCI     0x4B0B
            DCI     0x4601
            DCI     0x200A
            DCI     0x4790
            DCI     0x3130
            DCI     0xB402
            DCI     0x2800
            DCI     0xD1F8
            DCI     0xBC01
            DCI     0x2800
            DCI     0xD001
            DCI     0x4798
            DCI     0xE7FA
            DCI     0xBD07
PutNumUB    DCI     0xB503
            DCI     0x21FF
            DCI     0x4008
            DCI.W   0xF7FFFFE9
            DCI     0xBD03
            ALIGN
            DCD     DIVU
            DCD     PutChar
;**********************************************************************
;End machine code provided for Lab Exercise Eight
;";end program code" comment of provided template should now follow
;so that "ALIGN" directive and "__EndMyCode" are after.
;**********************************************************************
;end program code
            ALIGN
__EndMyCode
;**********************************************************************
;Constants
            AREA    MyConst,DATA,READONLY
;begin constants here
TypePrmp    DCB 	"Type a queue command (d,e,h,p,s);", 0x00
CharPrmp	DCB     "Character to enqueue:", 0x00
Sec			DCB		"Success:", 0x0D, 0x0A, 0x00
Fail		DCB		"Failure:", 0x0D, 0x0A, 0x00
Status		DCB		"Status:  ", 0x00
In			DCB     "In=", 0x00
Out			DCB     "  Out=", 0x00
Num			DCB     "  Num=", 0x00
help		DCB		"d (dequeue), e (enqueue), h (help), p (print), s (status)", 0x0D, 0x0A, 0x00
;end constants here
            ALIGN           
__EndMyConst          
;**********************************************************************
;Variables
            AREA    MyData,DATA,READWRITE
;begin variables here
QBuffer		SPACE   Q_BUF_SZ
QRecord		SPACE   Q_REC_SZ
;end variables here
__EndMyData          
            END