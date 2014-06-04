            TTL Functions
;***************************************************************
;Assembly functions for C addition
;Name:  David Desrochers
;Date:  4/29/2014
;Class:  CMPE-250
;Section:  Tuesday 
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
MAX_STRING  EQU 25
	
;EQUates for queue record management
IN_PTR	 EQU 0
OUT_PTR  EQU 4
BUF_STRT EQU 8
BUF_PAST EQU 12
BUF_SIZE EQU 16
NUM_ENQD EQU 17	
	
;EQUated for stucture sizes
Q_REC_SZ EQU 18
Q_BUF_SZ EQU 80
	
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
			EXPORT  AddInt96U
			EXPORT  PutNumHex
			EXPORT  GetString
			EXPORT  PutString
			EXPORT  SerialDriverInit
			EXPORT  SetClock48MHz
			EXPORT  SystemInit	
			IMPORT  Reset_Handler
			
;Functions

;**************************************************************
;AddInt96U
;Adds a three word number stored in memory. 
;Input: R0: Sum address
;		R1: First numbers address
;		R2: Second numbers address
;Output: R0: 0 if valid, 1 otherwise
;Modify: R0-R3, PSR
;**************************************************************
;R0 : Sum pointer
;R1 : Number pointer
;R2 : Number pointer
;R3 : Index
;R4-5 : Temp number
;R6 : Temp for PSR storage
AddInt96U
		  ;Setup regesters
		  PUSH {R4-R6}
		  MOVS R3, #0
		  LSLS R3, #1
		  ;Push PSR
		  MRS  R6, APSR
		  PUSH {R6}
		  ;Loop for three words
Adding96  CMP  R3, #12
		  BEQ  AddintEnd
		  ;Load one word of the numbers
		  LDR  R4, [R1, R3]
		  LDR  R5, [R2, R3]
		  ;Restore PSR to get carry from last addition
		  POP  {R6}
		  MSR  APSR, R6
		  ;Add and store PSR
		  ADCS R4, R5
		  MRS  R6, APSR
		  PUSH {R6}
		  ;Write sum
		  STR  R4, [R0, R3]
		  ADDS R3, #4
		  B    Adding96
		  ;Restore and return status
AddintEnd POP {R6}
		  MSR  APSR, R6
		  POP {R4-R6}
		  BCC  AddintS
		  MOVS R0, #1
		  BX  LR
AddintS	  MOVS R0, #0
		  BX  LR

;**************************************************************
;SerialDriverInit
;Sets up all needed data structures and modules for UART 
;comminication
;**************************************************************
SerialDriverInit
            PUSH    {LR}
			LDR     R0,=TxRec
			LDR	    R1,=TxBuff
			BL      Q_init
			LDR     R0,=RxRec
			LDR	    R1,=RxBuff
			BL      Q_init
			BL      NVIC__Init
			BL      UART1__Init
			POP     {PC}

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
;PutNumHex writes the hex number in R0 onto the screen.
;Inputs R0: Number to write
;Outputs : None
;Modifies: PSR
;**************************************************************
;R0: working space
;R1: index
;R2: Byte ANDS mask
;R3: shift length
PutNumHex  PUSH  {R1-R3,LR}
		   ;Init registers
		   MOVS  R1, #0
		   MOVS  R2, #0xF
		   MOVS  R3, #0x1C
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
            DCD    UART1_ISR           ;29:UART1 (status; error)
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
;**********************************************************************
;Constants
            AREA    MyConst,DATA,READONLY
;begin constants here
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