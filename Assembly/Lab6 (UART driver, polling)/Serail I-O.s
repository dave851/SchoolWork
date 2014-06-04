         TTL Serail I-O
;***************************************************************
;Descriptive comment header goes here.
;(What does the program do?)
;Name:  David Desrochers
;Date:  3/4/2014
;Class:  CMPE-250
;Section:  Teuesday, 11am
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
			
;**************************************************************
;Application for terminal interaction, polls terminal and call
;calls subroutines accordingly
;**************************************************************	

Main		BL		PutPrompt
ReadChar	BL		GetChar
			BL		PutChar
			CMP		R0, #'a'
			BLO		CorrectCase
FixCase		SUBS	R0, R0, #0x20
CorrectCase	CMP		R0, #'D'
			BEQ	    Call_Dushkoff
			CMP		R0, #'M'
			BEQ	    Call_Dushkoff
			CMP		R0, #'F'
			BEQ	    Call_Petroski_Such
			CMP		R0, #'P'
			BEQ	    Call_Petroski_Such
			CMP		R0, #'J'
			BEQ	    Call_Lowden
			CMP		R0, #'L'
			BEQ	    Call_Lowden
			CMP 	R0, #0x0D
			BNE		ReadChar
			MOVS	R0, #0x0A
			BL		PutChar
			B		Main

			
Call_Dushkoff       BL Dushkoff
					B  Main
Call_Petroski_Such  BL Petroski_Such
					B  Main
Call_Lowden         BL Lowden
					B  Main
			
			
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
			
;**********************************************************************
;Begin machine code provided for Exercise Six
;Place at bottom of MyCode section before ";end program code"
;comment in provided template so that "ALIGN" directive and 
;"__EndMyCode" label follow this code block.
;**********************************************************************
            ALIGN
Dushkoff    DCI    0xB501
            DCI.W  0xF000F821
            DCI    0xA00F
            DCI    0x6800
            DCI.W  0xF000F825
            DCI.W  0xF000F81B
            DCI    0xBD01
Lowden      DCI    0xB501
            DCI.W  0xF000F817
            DCI    0xA009
            DCI    0x6800
            DCI.W  0xF000F81B
            DCI.W  0xF000F811
            DCI    0xBD01
Petroski_Such
            DCI    0xB501
            DCI.W  0xF000F80D
            DCI    0xA003
            DCI    0x6800
            DCI.W  0xF000F811
            DCI.W  0xF000F807
            DCI    0xBD01
            ALIGN
            DCD    fp_string
            DCD    jl_string
            DCD    md_string
            DCI    0xB503
            DCI    0xA119
            DCI    0x6809
            DCI    0x200D
            DCI    0x4788
            DCI    0x200A
            DCI    0x4788
            DCI    0xBD03
            DCI    0xB507
            DCI    0x4601
            DCI    0xA214
            DCI    0x6812
            DCI    0x7808
            DCI    0x2800
            DCI    0xD002
            DCI    0x4790
            DCI    0x1C49
            DCI    0xE7F9
            DCI    0xBD07
PutPrompt   DCI    0xB501
            DCI    0xA001
            DCI.W  0xF7FFFFF1
            DCI    0xBD01
            ALIGN
            DCQ    0x206E612065707954,0x206C616974696E69
            DCQ    0x45504D4320726F66,0x7269642030353220
            DCQ    0x6C2079726F746365,0x0A0D2E70756B6F6F
            DCW    0x003E
            ALIGN
            DCW    0x4F0A
            ALIGN
            DCD              PutChar
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
fp_string   DCB		"Felipe Petroski Such, Lab TA",0
jl_string	DCB     "Jason Lowden, Lab TA",0
md_string	DCB     "Michael Dushkoff, Homework Grader",0
;end constants here
            ALIGN           
__EndMyConst          
;**********************************************************************
;Variables
            AREA    MyData,DATA,READWRITE
;begin variables here
;end variables here
__EndMyData          
            END