            TTL Program Title for Listing Header Goes Here
;***************************************************************
;Controls a servo using the PWM and also uses DAC / ADC to restore
;and print value.
;Name:  David Desrochers
;Date:  4/15/2014
;Class:  CMPE-250
;Section:  Tuesday 11am
;---------------------------------------------------------------
;Template:  R. W. Melton
;           March 1, 2014
;           April 4, 2014
;***************************************************************
;Assembler directives
            THUMB
		    OPT    64  ;Turn on listing macro expansions
SSTACK_SIZE EQU    0x00000100  ;Used by MKL25Z128xxx4.s
;**********************************************************************
;Include files
;  MK25Z128xxx4.s
            GET  MKL25Z128xxx4.s
		    OPT  1   ;Turn on listing
;***************************************************************
;EQUates

;Max String length
MAX_STRING  EQU 79

;EQUates for queue record management
IN_PTR	 EQU 0
OUT_PTR  EQU 4
BUF_STRT EQU 8
BUF_PAST EQU 12
BUF_SIZE EQU 16
NUM_ENQD EQU 17	
	
;EQUates for stucture sizes
Q_REC_SZ EQU 18
Q_BUF_SZ EQU 80

;Step info
DAC0_STEPS EQU 4096
SERVO_POSITIONS EQU 5

;EQUates for TPM
PWM_PERIOD_20ms EQU  60000
PWM_DUTY_5 EQU 2000
PWM_DUTY_10 EQU 6000
TPM_EPWM_DIV16  EQU  0x0C
TPM_PWMH EQU 0x28

;EQUates for DAC
DAC0_BUFFER_DISABLED EQU 0x00
DAC0_ENABLE EQU 0xC0
DAC0_0v EQU 0x00
	
;Equates for ADC
ADC0_LP_LONG_SGL10_3MHZ EQU 0xD9
ADC0_CHAN_A_NORMAL_LONG EQU 0x00
ADC0_SWTRIG_VDDA EQU 0x01
ADC0_SC3_CAL EQU 0x87
ADC0_SINGLE  EQU 0x00
ADC0_SGL_DAC EQU 0x17
	
;EQUates for SIM
PTE30_MUX_DAC0_OUT EQU PIN_MUX_SELECT_0_MASK
SET_PTE30_DAC0_OUT EQU (PIN_ISF_MASK :OR: PTE30_MUX_DAC0_OUT)
PTE22_MUX_TMP2_CH0_OUT EQU PIN_MUX_SELECT_3
SET_PTE22_TMP_2_CH0 EQU (PIN_ISF_MASK :OR: PTE22_MUX_TMP2_CH0_OUT :OR: PIN_DSE_MASK)
TPM_MCGPLLCLK_SEL EQU 0x01000000
TPM_MCGPLLCLK_DIV2 EQU (TPM_MCGPLLCLK_SEL :OR: SIM_SOPT2_PLLFLLSEL_MASK)

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
UART_T_RI     EQU  (UART_TE_MASK :OR: UART_RE_MASK :OR: UART_RIE_MASK)
UART_TI_RI    EQU  (UART_TE_MASK :OR: UART_RE_MASK :OR: UART_RIE_MASK :OR: UART_TIE_MASK)	
UART1_IRQ_PRI EQU  3
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
;Init DAC0
		BL      DAC0__Init
;Init ADC0
		BL	  ADC0__Init
;Init TPM
		BL      TPM0__Init
;Init UART1
		BL      UART1__Init
;Init NVIC for UART1 IRQ's
		BL      NVIC__Init 
;Init queues for UART Tx,Rx
		LDR     R0,=TxRec
		LDR	  R1,=TxBuff
		BL      Q_init
		LDR     R0,=RxRec
		LDR	  R1,=RxBuff
		BL      Q_init
;UnMask interrupts
		CPSIE   I
;---------------------------------------------------------------
;begin program code
;Stay here
            ;Main prompt
Main		LDR  R0, =UserPrmp
			BL   PutString
Invalid		BL   GetChar
			;Check range
			CMP  R0, #'0'
			BLO  Invalid
			CMP  R0, #'5'
			BHI  Invalid
			;Echo and print next line
			PUSH {R0}
			BL   PutChar
			LDR  R0, =NewLineP
			BL   PutString
			LDR  R0, =OrgnPrmp
			BL   PutString
			;Convert ascii value into integer index
			POP  {R0}
			SUBS R0, #'1'
            MOVS R1, #2
            MULS R0, R1, R0
			;Retrvive digital value from table and print
GetDAC0Val  LDR  R1, =DAC0_TABLE
			LDRH R1, [R1, R0] 
			MOVS R0, R1
PrintDAC	BL   PutNumHex
            PUSH {R0}
			LDR  R0, =NewLineP
			BL   PutString
            LDR  R0, =NewPrmp
			BL   PutString
			POP  {R0}
			;Write value into DAC to convert
PutVal		LDR  R1, =DAC0_BASE
			STRB R0, [R1, #DAC0_DAT0L_OFFSET]
			LSRS R0, #8
			STRB R0, [R1, #DAC0_DAT0H_OFFSET]
			;Start ADC conversion
GetVal		LDR  R0, =ADC0_BASE
			MOVS R1, #ADC0_SGL_DAC
			STR  R1, [R0, #ADC0_SC1A_OFFSET]
			MOVS R2, #ADC_COCO_MASK
			;Wait for conversion complete flag
NotDone     LDR  R1, [R0, #ADC0_SC1A_OFFSET]
			ANDS R1, R2
			BEQ  NotDone
			;Retrive conversion result and print
			LDR  R0, [R0, #ADC0_RA_OFFSET]
PrintADC	BL   PutNumHex
            PUSH {R0}
            LDR  R0, =NewLineP
			BL   PutString
			POP  {R0}
			;Find index in PWM table with division
			;by repeated division
            MOVS R1, #0
GetPWMI		CMP  R0, #204
			BLO  GotI
			SUBS R0, #204
			ADDS R1, #1
			B    GetPWMI
			;Print position integer on screen
GotI		LDR  R0, =SerPPrmp
			BL   PutString
			MOVS R0, R1
			ADDS R0, #1
			BL   PutNumU
            LDR  R0, =NewLineP
			BL   PutString
			;Load PWM value from table
			LDR  R0, =PWM_DUTY_TABLE
            MOVS R2, #2
            MULS R1, R2, R1
			LDRH R1, [R0, R1]
			LDR  R0, =TPM2_BASE
			;Write value to the TMP module to change pulse width
			STR  R1, [R0, #TPM_C0V_OFFSET]
			B    Main
		
;Subroutines
;**************************************************************
;Dequeues a character from the recive queue and returns it in R0
;if operation fails C flag will be set on return
;recive queue record should be named RxRec
;Input: None
;Output: R0: charater read
;Modify: R0, PSR
;**************************************************************
GetChar		PUSH  {R1,LR}
			LDR   R1, =RxRec
			;Disable interupts for critical section
WaitForC	CPSID I
			BL    Dequeue
			CPSIE I
			BCS   WaitForC
			POP   {R1,PC}
			
;**************************************************************
;Enqueues the character from R0 to the transmit queue
;if operation fails C flag will be set on return
;transmit queue record should be named TxRec
;Input: R0: Character to enqueue
;Output: None
;Modify: PSR
;**************************************************************	
PutChar	PUSH  {R1-R2,LR}
		LDR   R1, =TxRec
		;Disable interupts for critical section
QNotRDY	CPSID I
		BL    Enqueue
		CPSIE I
		;Turns on UART tranmit interupts because there is
		;now data to send
		BCS   QNotRDY
		LDR   R1, =UART1_BASE
		MOVS  R2, #UART_TI_RI
		STRB  R2, [R1, #UART_C2_OFFSET]
		POP   {R1-R2,PC}

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
			;Get character
NextCharP	LDRB R0, [R1, #0]
			ADDS R1, #0x01
			;While not null add character to queue
			CMP  R0, #0x00
			BEQ  Terminate
			BL   PutChar
			B	 NextCharP
Terminate	POP  {R0-R1,PC}

;**************************************************************
;PutNumHex writes the hex number in R0 onto the screen.
;Inputs R0: Number to write
;Outputs : None
;Modifies: PSR
;**************************************************************
;R0: working space
;R1: index
;R2: Byte ANDS mask
;R3: shift length
PutNumHex  PUSH  {R0-R3,LR}
		   ;Init registers
		   MOVS  R1, #0
		   MOVS  R2, #0xF
		   MOVS  R3, #0x1C
		   ;Print the 0x prefix
		   MOVS  R0, #"0"
		   BL    PutChar
		   MOVS  R0, #"x"
		   BL    PutChar
		   POP   {R0}
		   ;Loop eight times
PrintingH  CMP   R1, #8
	       BHS   EndHex
	       ;Rotate to get most significant byte
	       RORS  R0, R3
	       ADDS  R1, #1
    	   PUSH  {R0}
	       ;Mask register to only contain first byte
   	       ANDS  R0, R2
	       ;Compare to determine the ascii value then print
	       CMP   R0, #0xA
	       BHS   Letter
Number     ADDS  R0, #0x30
	       BL    PutChar
   	       POP   {R0}
	       B     PrintingH
Letter     ADDS  R0, #0x37
	       BL    PutChar
	       POP   {R0}
	       B     PrintingH
EndHex     POP   {R1-R3, PC}

;**************************************************************
;PutNumU writes the hex number in R0 in decimal onto the screen.
;Inputs R0: Number to write
;Outputs : None
;Modifies: PSR
;**************************************************************
;R0 : number to convert / dividend
;R1 : remainder / divisor
;R2 : number of chacaters on stack
PutNumU    PUSH   {R0-R2, LR}
	       ;Zero check
	       CMP    R0, #0
	       BEQ    PZero
	       MOVS   R2, #0
	       ;Loop until quotient is zero
Conv	   CMP    R0, #0
		   BEQ    PrintingNU
		   ;Divide by 10
		   MOVS   R1, #10
		   BL     DIVU
		   ;Push reaminder onto stack
		   PUSH   {R1}
		   ADDS   R2, #1		   
		   B      Conv
           ;Loop until stack has no more characters
PrintingNU CMP    R2, #0
           BEQ    doneNU
           POP    {R0}
           SUBS   R2, #1
           ;Add acsii offset for numbers then print
           ADDS   R0, #0x30
           BL     PutChar
           B      PrintingNU
PZero	   MOVS   R0, #0x30
	       BL     PutChar
doneNU     POP    {R0-R2, PC}

;**************************************************************
;Division Subroutine
;Input: R0: divisor 
;       R1: dividend
;Output:R0: integer result
;		R1: Remainder
;Modify:R0,R1 PSR
;**************************************************************	
DIVU		CMP  R1, #0		;Check if dividing by zero
		    BEQ	 DivByZero  ;Branch if dividing by zero
			
startDiv	PUSH {R2}	    ;Push register on stack to be restore it later
		    MOVS R2, #0 	;Set R2 to 0, will be used as integer result

Dividing	CMP  R0, R1		;Check if demoninator is bigger then numberator
		    BLO  DoneDiv    ;Branch to finish if above is true
			SUBS R0, R1     ;Subtract demoninator from numerator
			ADDS R2, #1     ;Add one to result
			B    Dividing   ;Continue dividing if above is false

DoneDiv		MOVS R1, R0
			MOV  R0, R2		;Move result in correct register
			POP  {R2}		;Restore data in R2 from the stack
			BX   LR			;Return from call
			
DivByZero   PUSH {R1}		;Push register onto stack to restore later
			PUSH {R0}		;Push register onto stack to restore later
			MRS	 R1, APSR   ;Move the APSR into R0
			MOVS R0, #0x20  ;Change the flags 
			LSLS R0, R0, #24;Shift into correct position
			ORRS R1, R0     
			MSR  APSR, R1	;Write the representation of the flags into the APSR
			POP  {R0}		;Restore R1 from stack
			POP  {R1}       ;Restore R2 form stack
			BX   LR         ;Return from call

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
;Init for queue record at QRecord space, QBuffer needs to also
;be defined. 
;Input: R0: Memory location for new record
;		R1: Memory location for new buffer
;Modify: PSR
;**************************************************************	

		;Instantiate all pointers/conters
Q_init  PUSH {R1}
		STR  R1, [R0, #IN_PTR]
		STR  R1, [R0, #OUT_PTR]
		STR  R1, [R0, #BUF_STRT]
		ADDS R1, #Q_BUF_SZ
		STR  R1, [R0, #BUF_PAST]
		MOVS R1, #Q_BUF_SZ
		STRB R1, [R0, #BUF_SIZE]
		MOVS R1, #0
		STRB R1, [R0, #NUM_ENQD]
		POP  {R1}
		BX   LR

;**************************************************************
;DAC init
;**************************************************************
DAC0__Init
		;SIM setup
		;Setup DAC0 clk
		LDR  R0, =SIM_SCGC6
		LDR  R1, =SIM_SCGC6_DAC0_MASK
		LDR  R2, [R0, #0]
		ORRS R2, R1
		STR  R2, [R0, #0]
		;Setup PortE clk
		LDR  R0, =SIM_SCGC5
		LDR  R1, =SIM_SCGC5_PORTE_MASK
		LDR  R2, [R0, #0]
		ORRS R2, R1
		STR  R2, [R0, #0]
		;DAC0 pin select
		LDR  R0, =PORTE_PCR30
		LDR  R1, =SET_PTE30_DAC0_OUT
		STR  R1, [R0, #0]
		;DAC config
		LDR  R0, =DAC0_BASE
		;Disable buffering
		MOVS R1, #DAC0_BUFFER_DISABLED
		MOVS R2, #DAC0_C1_OFFSET
		STRB R1, [R0, R2]
		;Enable Module
		MOVS R1, #DAC0_ENABLE
		MOVS R2, #DAC0_C0_OFFSET
		STRB R1, [R0, R2]
		;Set init V to min
		MOVS R1, #DAC0_0v
		STRB R1, [R0, #DAC0_DAT0L_OFFSET]
		STRB R1, [R0, #DAC0_DAT0H_OFFSET]
		BX   LR
		
;**************************************************************
;ADC init
;**************************************************************
ADC0__Init
		;SIM setup
		;Enable Clk
		LDR  R0, =SIM_SCGC6
		LDR  R1, [R0, #0]
		LDR  R2, =SIM_SCGC6_ADC0_MASK
		ORRS R2, R1
		STR  R2, [R0, #0]
		;ADC Config
		;Config Reg1
		LDR  R0, =ADC0_BASE
		MOVS R1, #ADC0_LP_LONG_SGL10_3MHZ
		STR  R1, [R0, #ADC0_CFG1_OFFSET]
		;Config Reg2
		MOVS R1, #ADC0_CHAN_A_NORMAL_LONG
		STR  R1, [R0,#ADC0_CFG2_OFFSET]
		;Control/status Reg2
		MOVS R1, #ADC0_SC2_OFFSET
		MOVS R2, #ADC0_SWTRIG_VDDA
		STR  R2, [R0, R1]
		;Control/status Reg3, Calibration
		MOVS R1, #ADC0_SC3_OFFSET
Calb	      MOVS R2, #ADC0_SC3_CAL
		STR  R2, [R0, R1]
		MOVS R2, #ADC_CAL_MASK
		;Wait for Calibration complete, reapeat if fail
CalIP       LDR  R3, [R0, R1]
		ANDS R3, R2
		BNE  CalIP
		MOVS R2, #ADC_CALF_MASK
		LDR  R3, [R0, R1]
		ANDS R3, R2
		BNE  Calb
		;Save calibration values
		;Plus Side
		MOVS R1, #0
		LDR  R2, [R0, #ADC0_CLP0_OFFSET]
		ADDS R1, R2
		LDR  R2, [R0, #ADC0_CLP1_OFFSET]
		ADDS R1, R2
		LDR  R2, [R0, #ADC0_CLP2_OFFSET]
		ADDS R1, R2
		LDR  R2, [R0, #ADC0_CLP3_OFFSET]
		ADDS R1, R2
		LDR  R2, [R0, #ADC0_CLP4_OFFSET]
		ADDS R1, R2
		LDR  R2, [R0, #ADC0_CLPS_OFFSET]
		ADDS R1, R2
		LSRS R1, #1
		MOVS R3, #0x8
		LSLS R3, #12
		ORRS R1, R3
		STR  R1, [R0, #ADC0_PG_OFFSET]
		;Minus Side
		MOVS R1, #0
		LDR  R2, [R0, #ADC0_CLM0_OFFSET]
		ADDS R1, R2
		LDR  R2, [R0, #ADC0_CLM1_OFFSET]
		ADDS R1, R2
		LDR  R2, [R0, #ADC0_CLM2_OFFSET]
		ADDS R1, R2
		LDR  R2, [R0, #ADC0_CLM3_OFFSET]
		ADDS R1, R2
		LDR  R2, [R0, #ADC0_CLM4_OFFSET]
		ADDS R1, R2
		LDR  R2, [R0, #ADC0_CLMS_OFFSET]
		ADDS R1, R2
		LSRS R1, #1
		MOVS R3, #0x8
		LSLS R3, #12
		ORRS R1, R3
		STR  R1, [R0, #ADC0_MG_OFFSET]
		;Select single end conversion
CalSuc  MOVS R1, #ADC0_SC3_OFFSET
		MOVS R2, #ADC0_SINGLE
		STR  R2, [R0,R1]
		;Channel A S/C reg
		MOVS R1, #ADC0_SGL_DAC
		STR  R1, [R0, #ADC0_SC1A_OFFSET]
		;Wait for COCO flag
		MOVS R2, #ADC_COCO_MASK
ADCCon  LDR  R1, [R0, #ADC0_SC1A_OFFSET]
		ANDS R1, R2
		BEQ  ADCCon  
		BX   LR

;**************************************************************
;TPM init
;**************************************************************
TPM0__Init
		;SIM setup
		;Enable Clk
		LDR  R0, =SIM_SCGC6
		LDR  R1, =SIM_SCGC6_TPM2_MASK
		LDR  R2, [R0, #0]
		ORRS R2, R1
		STR  R2, [R0, #0]
		;Clock PortE enable
		LDR	R0, =SIM_SCGC5
		LDR	R1, =SIM_SCGC5_PORTE_MASK
		LDR	R2, [R0,#0]
		ORRS	R2,R2,R1
		STR	R2,[R0,#0]
		;Output Pin select
		LDR  R0, =PORTE_PCR22
		LDR  R1, =SET_PTE22_TMP_2_CH0
		STR  R1, [R0, #0]
		;Clk select
		LDR  R0, =SIM_SOPT2
		LDR  R1, =TPM_MCGPLLCLK_DIV2
		LDR  R2, =SIM_SOPT2_TPMSRC_MASK
		LDR  R3, [R0, #0]
		BICS R3, R2
		ORRS R3, R1
		STR  R3, [R0, #0]
		;Set Counter
		LDR  R0, =TPM2_BASE
		MOVS R1, #0
		STR  R1, [R0, #TPM_CNT_OFFSET]
		;Set mod
		LDR  R1, =PWM_PERIOD_20ms
		STR  R1, [R0, #TPM_MOD_OFFSET]
		;Status / Control config
		MOVS R1, #TPM_EPWM_DIV16
		STR  R1, [R0, #TPM_SC_OFFSET]
		MOVS R1, #TPM_PWMH
		STR  R1, [R0, #TPM_C0SC_OFFSET]
		LDR  R1, =PWM_DUTY_5
		STR  R1, [R0, #TPM_C0V_OFFSET]
		BX   LR
		
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
			;Turn on and enable interupts
			MOVS	R1, #UART_T_RI
			STRB	R1, [R0, #UART_C2_OFFSET]
			BX		LR

;**************************************************************
;Inits NVIC for UART1 interupts
;**************************************************************
NVIC__Init LDR   R0, =NVIC_ISER
		   LDR   R1, =UART1_IRQ_MASK
		   ;Unmask UART1 interupts
		   STR   R1, [R0, #0]
		   ;Set prority
		   LDR   R0, =UART1_IPR
		   LDR   R1, =(UART1_IRQ_PRI << UART1_PRI_POS)
		   STR   R1, [R0, #0]
		   BX    LR

;**************************************************************
;UART1_ISR handles interupts produced by the UART device
;enqueues or dequeues to the recive or transmitt queues
;If revice queue is full, characters will be lost
;Disables transmit interrupts if tranmit queue is empty
;**************************************************************
UART1_ISR PUSH  {LR}
		  ;Check for recive flag, otherwise perform transmit operation
		  LDR   R3, =UART1_BASE
		  LDRB	R1, [R3,#UART_S1_OFFSET]
		  MOVS	R2, #UART_RDRF_MASK
		  ANDS  R1,R1,R2
		  BNE   RxInter
		  ;Dequeue from transmit queue
TxInter	  LDR   R1, =TxRec
		  BL    Dequeue
		  ;If dequeue fails, disable transmit interupts 
		  BCS   TxFail
		  STRB	R0, [R3,#UART_D_OFFSET]
		  BCC   EndU1ISR
TxFail	  MOVS  R1, #UART_T_RI
		  STRB  R1, [R3, #UART_C2_OFFSET]
		  POP   {PC}
		  ;Enqueue data to reviced data queue
RxInter   LDR   R1, =RxRec
		  LDRB	R0, [R3,#UART_D_OFFSET]
		  BL    Enqueue
EndU1ISR  POP   {PC}

;end program code
		  ALIGN
__EndMyCode
;***************************************************************
;Vector Table Mapped to Address 0 at Reset
;Linker requires __Vectors to be exported
            AREA    RESET, DATA, READONLY
            EXPORT  __Vectors
__Vectors 
                                      ;ARM core vectors
            DCD    SP_INIT            ;00:end of stack
            DCD    Reset_Handler      ;01:reset vector
            DCD    Dummy_Handler      ;02:NMI
            DCD    Dummy_Handler      ;03:hard fault
            DCD    Dummy_Handler      ;04:(reserved)
            DCD    Dummy_Handler      ;05:(reserved)
            DCD    Dummy_Handler      ;06:(reserved)
            DCD    Dummy_Handler      ;07:(reserved)
            DCD    Dummy_Handler      ;08:(reserved)
            DCD    Dummy_Handler      ;09:(reserved)
            DCD    Dummy_Handler      ;10:(reserved)
            DCD    Dummy_Handler      ;11:SVCall (supervisor call)
            DCD    Dummy_Handler      ;12:(reserved)
            DCD    Dummy_Handler      ;13:(reserved)
            DCD    Dummy_Handler      ;14:PendableSrvReq (pendable request 
			                          ;   for system service)
            DCD    Dummy_Handler      ;15:SysTick (system tick timer)
            DCD    Dummy_Handler      ;16:DMA channel 0 xfer complete/error
            DCD    Dummy_Handler      ;17:DMA channel 1 xfer complete/error
            DCD    Dummy_Handler      ;18:DMA channel 2 xfer complete/error
            DCD    Dummy_Handler      ;19:DMA channel 3 xfer complete/error
            DCD    Dummy_Handler      ;20:(reserved)
            DCD    Dummy_Handler      ;21:command complete; read collision
            DCD    Dummy_Handler      ;22:low-voltage detect;
			                          ;   low-voltage warning
            DCD    Dummy_Handler      ;23:low leakage wakeup
            DCD    Dummy_Handler      ;24:I2C0
            DCD    Dummy_Handler      ;25:I2C1
            DCD    Dummy_Handler      ;26:SPI0 (all IRQ sources)
            DCD    Dummy_Handler      ;27:SPI1 (all IRQ sources)
            DCD    Dummy_Handler      ;28:UART0 (status; error)
            DCD    UART1_ISR          ;29:UART1 (status; error)
            DCD    Dummy_Handler      ;30:UART2 (status; error)
            DCD    Dummy_Handler      ;31:ADC0
            DCD    Dummy_Handler      ;32:CMP0
            DCD    Dummy_Handler      ;33:TPM0
            DCD    Dummy_Handler      ;34:TPM1
            DCD    Dummy_Handler      ;35:TPM2
            DCD    Dummy_Handler      ;36:RTC (alarm)
            DCD    Dummy_Handler      ;37:RTC (seconds)
            DCD    Dummy_Handler      ;38:PIT (all IRQ sources)
            DCD    Dummy_Handler      ;39:(reserved)
            DCD    Dummy_Handler      ;40:USB OTG
            DCD    Dummy_Handler      ;41:DAC0
            DCD    Dummy_Handler      ;42:TSI0
            DCD    Dummy_Handler      ;43:MCG
            DCD    Dummy_Handler      ;44:LPTMR0
            DCD    Dummy_Handler      ;45:(reserved)
            DCD    Dummy_Handler      ;46:PORTA pin detect
            DCD    Dummy_Handler      ;47:PORTD pin detect
			ALIGN
;**********************************************************************
;Constants
            AREA    MyConst,DATA,READONLY
;begin constants here

;Prompts for terminal
NewLineP	DCB		0x0A, 0x0D, 0x00
UserPrmp    DCB		"Type a number from 1 to 5: ", 0x00
OrgnPrmp	DCB		"Original digital value: ", 0x00
NewPrmp		DCB		"New digital value: ", 0x00
SerPPrmp	DCB     "Servo Position: ", 0x00
			ALIGN

;DAC value table
DAC0_TABLE
			DCW		(DAC0_STEPS / (SERVO_POSITIONS*2))
			DCW		((DAC0_STEPS*3) / (SERVO_POSITIONS*2))
			DCW		((DAC0_STEPS*5) / (SERVO_POSITIONS*2))
			DCW		((DAC0_STEPS*7) / (SERVO_POSITIONS*2))
			DCW		((DAC0_STEPS*9) / (SERVO_POSITIONS*2))

;Servo Positions
PWM_DUTY_TABLE
			DCW		PWM_DUTY_10									
			DCW		((3*(PWM_DUTY_10-PWM_DUTY_5)/4)+PWM_DUTY_5)
                  DCW		(((PWM_DUTY_10-PWM_DUTY_5)/2)+PWM_DUTY_5)
                  DCW		(((PWM_DUTY_10-PWM_DUTY_5)/4)+PWM_DUTY_5)
			DCW     PWM_DUTY_5												
			ALIGN

;end constants here
;**********************************************************************
;Variables
            AREA    MyData,DATA,READWRITE
;begin variables here
TxRec		SPACE Q_REC_SZ 
			ALIGN
TxBuff		SPACE Q_BUF_SZ
			ALIGN
RxRec		SPACE Q_REC_SZ
			ALIGN
RxBuff		SPACE Q_BUF_SZ
			ALIGN
;end variables here
            END