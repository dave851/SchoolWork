           TTL String-I/O
;***************************************************************
;Reads/Writes string to terminal and calculated length
;Name:  David Desrochers
;Date:  3/11/2014
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
MAX_STRING	EQU		78
	
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
;Register use:
;R0: location to strore strings
;R1: charaters to write
			BL	 UART1__Init
			LDR	 R0, =String
			
Main        BL	 PutPrompt
			BL	 GetString
			PUSH {R0}
			MOVS R0, #0x0D
			BL   PutChar
			MOVS R0, #0x0A
			BL   PutChar
			MOVS R0, #"\\"
			BL   PutChar
			POP  {R0}
			BL	 PutString
			PUSH {R0}
			MOVS R0, #"/"
			BL   PutChar
			MOVS R0, #0x0D
			BL   PutChar
			MOVS R0, #0x0A
			BL   PutChar
			LDR  R0, =LenString
			BL	 PutString
			POP  {R0}
			BL	 StringLen
			PUSH {R0}
			MOVS R0, R1
			BL   PutNumU
			POP  {R0}
			PUSH {R0}
			MOVS R0, #0x0D
			BL   PutChar
			MOVS R0, #0x0A
			BL   PutChar
			POP  {R0}
			B    Main


;Subroutines

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

;**************************************************************
;Reads a string from the terminal keyboard to to memory
;starting at the adress in R0 and adds null termination
;Accepts charaters typed in terminal until carrige return is 
;found, or until MAX_STRING-1
;Input: R0: base memory location to store string
;Output: String stored to adress in R0
;Modify: PSR, RAM
;**************************************************************	
;Regester contents
;R0: getChar output
;R1: Current memory address
;R2: Counter to restrict string lenght to MAX_STRING
GetString	PUSH {R0-R2,LR}
			MOVS R1, R0
			MOVS R2, #0
NextCharS	CMP  R2, #MAX_STRING-1
			BEQ  Max_Len
			BL   GetChar
			BL   PutChar
			CMP  R0, #0x0D
			BEQ  CarReturn
			STRB R0,[R1,R2]
			ADDS R2, #1
			B	 NextCharS
			
Max_Len		BL   GetChar
			CMP  R0, #0x0D
			BNE  Max_Len

CarReturn	MOVS R0, #0x00
			STRB R0,[R1,R2]
			POP  {R0-R2,PC}
			

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
;Determines how many characters are in the null terminated 
;string in memory starting at the address in R0, and returns 
;that number in R1
;Input: R0: base memory location
;Output: R1: Number of charaters in string
;Modify: R1
;**************************************************************	
StringLen	PUSH {R0,R2}
			MOVS R1, #0
Count		LDRB R2, [R0, R1]
		    CMP  R2, #0x00
			BEQ	 endString
			ADDS R1, #1
			B	 Count
endString   POP {R0,R2}
			BX   LR

;**************************************************************
;Displays Prompt to user
;Input: Defined Prompt in Constants
;Output: None
;Modify: PSR
;**************************************************************	
PutPrompt	PUSH {R0,LR}
			LDR  R0, =Prompt
			BL	 PutString
			MOVS R0, #0x0D
			BL	 PutChar
			MOVS R0, #0x0A
			BL	 PutChar
			MOVS R0, #">"
			BL	 PutChar
			POP  {R0,PC}

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
;**********************************************************************
;Begin machine code provided for Lab Exercise Seven
;Place at bottom of MyCode section before ";end program code"
;comment in provided template so that "ALIGN" directive and 
;"__EndMyCode" label follow this code block.
;**********************************************************************
            ALIGN
PutNumU     DCI   0xB507
            DCI   0x2100
            DCI   0xB402
            DCI   0x4A07
            DCI   0x4B07
            DCI   0x4601
            DCI   0x200A
            DCI   0x4790
            DCI   0x3130
            DCI   0xB402
            DCI   0x2800
            DCI   0xD1F8
            DCI   0xBC01
            DCI   0x2800
            DCI   0xD001
            DCI   0x4798
            DCI   0xE7FA
            DCI   0xBD07
            ALIGN
            DCD   DIVU
            DCD   PutChar
;**********************************************************************
;End machine code provided for Exercise 6
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
Prompt		DCB		"Enter a string:", 0x00
LenString	DCB		"Length:", 0x00
;end constants here
            ALIGN           
__EndMyConst          
;**********************************************************************
;Variables
            AREA    MyData,DATA,READWRITE
;begin variables here
String		SPACE	MAX_STRING
			ALIGN
;end variables here
__EndMyData          
            END