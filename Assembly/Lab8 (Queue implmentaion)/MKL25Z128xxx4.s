           OPT  2   ;Turn off listing
;**********************************************************************
;Freescale MKL25Z128xxx4 device values and configuration code
;* Various EQUATES for memory map
;* Flash configuration image for area at 0x400-0x40F(+)
;* SystemInit subroutine (++)
;* SetClock48MHz subroutine (+++)
;+:Following Freescale startup_MKL25Z4.s
;     CMSIS Cortex-M0plus Core Device Startup File for the MKL25Z4
;     v1.4, 11/22/2012
;++:Following [1].1.1.4.2 Startup routines
;+++:Following [1].4.1 Clocking
;[1] Freescale Semiconductor, <B>Kinetis L Peripheral Module Quick
;    Reference</B>, KLQRUG, Rev. 0, 9/2012.
;---------------------------------------------------------------
;Author:  R. W. Melton
;Date:  February 22, 2014
;***************************************************************
;EQUates
;Data sizes
WORD_SIZE         EQU  4  ;Cortex-M0+
HALFWORD_SIZE     EQU  2  ;Cortex-M0+
;Return                 
RET_ADDR_T_MASK   EQU  1  ;Bit 0 of ret. addr. must be
                          ;set for BX, BLX, or POP
                          ;mask in thumb
;---------------------------------------------------------------
;Vectors
VECTOR_TABLE_SIZE EQU 0x000000C0  ;KL25Z
VECTOR_SIZE       EQU 4           ;Bytes per vector
;---------------------------------------------------------------
;Fast (zero wait state) GPIO (FGPIO) or (IOPORT)
;FGPIOx_PDD: Port x Data Direction Register
;Bit n:  0=Port x pin n configured as input
;        1=Port x pin n configured as output
FGPIO_BASE         EQU  0xF80FF000
;offsets for PDOR, PSOR, PCOR, PTOR, PDIR, and PDDR defined
;  with GPIO EQUates
;offsets for Ports A-E defined with GPIO EQUates
;Port A
FGPIOA_BASE        EQU  0xF80FF000
FGPIOA_PDOR        EQU  (FGPIOA_BASE + GPIO_PDOR_OFFSET)
FGPIOA_PSOR        EQU  (FGPIOA_BASE + GPIO_PSOR_OFFSET)
FGPIOA_PCOR        EQU  (FGPIOA_BASE + GPIO_PCOR_OFFSET)
FGPIOA_PTOR        EQU  (FGPIOA_BASE + GPIO_PTOR_OFFSET)
FGPIOA_PDIR        EQU  (FGPIOA_BASE + GPIO_PDIR_OFFSET)
FGPIOA_PDDR        EQU  (FGPIOA_BASE + GPIO_PDDR_OFFSET)
;Port B
FGPIOB_BASE        EQU  0xF80FF040
FGPIOB_PDOR        EQU  (FGPIOB_BASE + GPIO_PDOR_OFFSET)
FGPIOB_PSOR        EQU  (FGPIOB_BASE + GPIO_PSOR_OFFSET)
FGPIOB_PCOR        EQU  (FGPIOB_BASE + GPIO_PCOR_OFFSET)
FGPIOB_PTOR        EQU  (FGPIOB_BASE + GPIO_PTOR_OFFSET)
FGPIOB_PDIR        EQU  (FGPIOB_BASE + GPIO_PDIR_OFFSET)
FGPIOB_PDDR        EQU  (FGPIOB_BASE + GPIO_PDDR_OFFSET)
;Port C
FGPIOC_BASE        EQU  0xF80FF080
FGPIOC_PDOR        EQU  (FGPIOC_BASE + GPIO_PDOR_OFFSET)
FGPIOC_PSOR        EQU  (FGPIOC_BASE + GPIO_PSOR_OFFSET)
FGPIOC_PCOR        EQU  (FGPIOC_BASE + GPIO_PCOR_OFFSET)
FGPIOC_PTOR        EQU  (FGPIOC_BASE + GPIO_PTOR_OFFSET)
FGPIOC_PDIR        EQU  (FGPIOC_BASE + GPIO_PDIR_OFFSET)
FGPIOC_PDDR        EQU  (FGPIOC_BASE + GPIO_PDDR_OFFSET)
;Port D
FGPIOD_BASE        EQU  0xF80FF0C0
FGPIOD_PDOR        EQU  (FGPIOD_BASE + GPIO_PDOR_OFFSET)
FGPIOD_PSOR        EQU  (FGPIOD_BASE + GPIO_PSOR_OFFSET)
FGPIOD_PCOR        EQU  (FGPIOD_BASE + GPIO_PCOR_OFFSET)
FGPIOD_PTOR        EQU  (FGPIOD_BASE + GPIO_PTOR_OFFSET)
FGPIOD_PDIR        EQU  (FGPIOD_BASE + GPIO_PDIR_OFFSET)
FGPIOD_PDDR        EQU  (FGPIOD_BASE + GPIO_PDDR_OFFSET)
;Port E
FGPIOE_BASE        EQU  0xF80FF100
FGPIOE_PDOR        EQU  (FGPIOE_BASE + GPIO_PDOR_OFFSET)
FGPIOE_PSOR        EQU  (FGPIOE_BASE + GPIO_PSOR_OFFSET)
FGPIOE_PCOR        EQU  (FGPIOE_BASE + GPIO_PCOR_OFFSET)
FGPIOE_PTOR        EQU  (FGPIOE_BASE + GPIO_PTOR_OFFSET)
FGPIOE_PDIR        EQU  (FGPIOE_BASE + GPIO_PDIR_OFFSET)
FGPIOE_PDDR        EQU  (FGPIOE_BASE + GPIO_PDDR_OFFSET)
;---------------------------------------------------------------
;Flash Configuration Field (FCF) 0x400-0x40F
;Following Freescale startup_MKL25Z4.s
;     CMSIS Cortex-M0plus Core Device Startup File for the MKL25Z4
;     v1.4, 11/22/2012
;16-byte flash configuration field that stores default protection settings
;(loaded on reset) and security information that allows the MCU to 
;restrict acces to the FTFL module.
;FCF Backdoor Comparison Key
;8 bytes from 0x400-0x407
;-----------------------------------------------------
;FCF Backdoor Comparison Key 0
;7-0:Backdoor Key 0
FCF_BACKDOOR_KEY0  EQU  0xFF
;-----------------------------------------------------
;FCF Backdoor Comparison Key 1
;7-0:Backdoor Key 1
FCF_BACKDOOR_KEY1  EQU  0xFF
;-----------------------------------------------------
;FCF Backdoor Comparison Key 2
;7-0:Backdoor Key 2
FCF_BACKDOOR_KEY2  EQU  0xFF
;-----------------------------------------------------
;FCF Backdoor Comparison Key 3
;7-0:Backdoor Key 3
FCF_BACKDOOR_KEY3  EQU  0xFF
;-----------------------------------------------------
;FCF Backdoor Comparison Key 4
;7-0:Backdoor Key 4
FCF_BACKDOOR_KEY4  EQU  0xFF
;-----------------------------------------------------
;FCF Backdoor Comparison Key 5
;7-0:Backdoor Key 5
FCF_BACKDOOR_KEY5  EQU  0xFF
;-----------------------------------------------------
;FCF Backdoor Comparison Key 6
;7-0:Backdoor Key 6
FCF_BACKDOOR_KEY6  EQU  0xFF
;-----------------------------------------------------
;FCF Backdoor Comparison Key 7
;7-0:Backdoor Key 7
FCF_BACKDOOR_KEY7  EQU  0xFF
;-----------------------------------------------------
;FCF Flash nonvolatile option byte (FCF_FOPT)
;Allows user to customize operation of the MCU at boot time.
;7-6:11:(reserved)
;  5: 1:FAST_INIT=fast initialization
;4,0:11:LPBOOT=core and system clock divider:  2^(3-LPBOOT)
;  3: 1:RESET_PIN_CFG=enable reset pin following POR
;  2: 1:NMI_DIS=Enable NMI
;  1: 1:(reserved)
;  0:(see bit 4 above)
FCF_FOPT  EQU  0xFF
;-----------------------------------------------------
;FCF Program flash protection bytes (FCF_FPROT)
;Each program flash region can be protected from program and erase 
;operation by setting the associated PROT bit.  Each bit protects a 
;1/32 region of the program flash memory.
;FCF FPROT0
;7:1:FCF_PROT7=Program flash region 7/32 not protected
;6:1:FCF_PROT6=Program flash region 6/32 not protected
;5:1:FCF_PROT5=Program flash region 5/32 not protected
;4:1:FCF_PROT4=Program flash region 4/32 not protected
;3:1:FCF_PROT3=Program flash region 3/32 not protected
;2:1:FCF_PROT2=Program flash region 2/32 not protected
;1:1:FCF_PROT1=Program flash region 1/32 not protected
;0:1:FCF_PROT0=Program flash region 0/32 not protected
FCF_FPROT0  EQU  0xFF
;-----------------------------------------------------
;FCF FPROT1
;7:1:FCF_PROT15=Program flash region 15/32 not protected
;6:1:FCF_PROT14=Program flash region 14/32 not protected
;5:1:FCF_PROT13=Program flash region 13/32 not protected
;4:1:FCF_PROT12=Program flash region 12/32 not protected
;3:1:FCF_PROT11=Program flash region 11/32 not protected
;2:1:FCF_PROT10=Program flash region 10/32 not protected
;1:1:FCF_PROT9=Program flash region 9/32 not protected
;0:1:FCF_PROT8=Program flash region 8/32 not protected
FCF_FPROT1  EQU  0xFF
;-----------------------------------------------------
;FCF FPROT2
;7:1:FCF_PROT23=Program flash region 23/32 not protected
;6:1:FCF_PROT22=Program flash region 22/32 not protected
;5:1:FCF_PROT21=Program flash region 21/32 not protected
;4:1:FCF_PROT20=Program flash region 20/32 not protected
;3:1:FCF_PROT19=Program flash region 19/32 not protected
;2:1:FCF_PROT18=Program flash region 18/32 not protected
;1:1:FCF_PROT17=Program flash region 17/32 not protected
;0:1:FCF_PROT16=Program flash region 16/32 not protected
FCF_FPROT2  EQU  0xFF
;-----------------------------------------------------
;FCF FPROT3
;7:1:FCF_PROT31=Program flash region 31/32 not protected
;6:1:FCF_PROT30=Program flash region 30/32 not protected
;5:1:FCF_PROT29=Program flash region 29/32 not protected
;4:1:FCF_PROT28=Program flash region 28/32 not protected
;3:1:FCF_PROT27=Program flash region 27/32 not protected
;2:1:FCF_PROT26=Program flash region 26/32 not protected
;1:1:FCF_PROT25=Program flash region 25/32 not protected
;0:1:FCF_PROT24=Program flash region 24/32 not protected
FCF_FPROT3  EQU  0xFF
;-----------------------------------------------------
;FCF Flash security byte (FCF_FSEC)
;WARNING: If SEC field is configured as "MCU security status is 
;secure" and MEEN field is configured as "Mass erase is disabled",
;MCU's security status cannot be set back to unsecure state since 
;mass erase via the debugger is blocked !!!
;7-6:01:KEYEN=backdoor key security enable
;            :00=Backdoor key access disabled
;            :01=Backdoor key access disabled (preferred value)
;            :10=Backdoor key access enabled
;            :11=Backdoor key access disabled
;5-4:11:MEEN=mass erase enable bits
;           (does not matter if SEC unsecure)
;           :00=mass erase enabled
;           :01=mass erase enabled
;           :10=mass erase disabled
;           :11=mass erase enabled
;3-2:11:FSLACC=Freescale failure analysis access code
;             (does not matter if SEC unsecure)
;             :00=Freescale factory access granted
;             :01=Freescale factory access denied
;             :10=Freescale factory access denied
;             :01=Freescale factory access granted
;1-0:10:SEC=flash security
;          :00=MCU secure
;          :01=MCU secure
;          :10=MCU unsecure (standard value)
;          :11=MCU secure
FCF_FSEC  EQU  0x7E
;---------------------------------------------------------------
                IF      :LNOT::DEF:RAM_TARGET
                AREA    |.ARM.__at_0x400|,CODE,READONLY
                DCB     FCF_BACKDOOR_KEY0,FCF_BACKDOOR_KEY1
                DCB     FCF_BACKDOOR_KEY2,FCF_BACKDOOR_KEY3
                DCB     FCF_BACKDOOR_KEY4,FCF_BACKDOOR_KEY5
                DCB     FCF_BACKDOOR_KEY6,FCF_BACKDOOR_KEY7
                DCB     FCF_FPROT0,FCF_FPROT1,FCF_FPROT2,FCF_FPROT3
                DCB     FCF_FSEC,FCF_FOPT,0xFF,0xFF
__END_FCF				
                ENDIF
;---------------------------------------------------------------
;General-purpose input and output (GPIO)
;GPIOx_PDD: Port x Data Direction Register
;Bit n:  0=Port x pin n configured as input
;        1=Port x pin n configured as output
GPIO_BASE         EQU  0x400FF000
GPIO_PDOR_OFFSET  EQU  0x00
GPIO_PSOR_OFFSET  EQU  0x04
GPIO_PCOR_OFFSET  EQU  0x08
GPIO_PTOR_OFFSET  EQU  0x0C
GPIO_PDIR_OFFSET  EQU  0x10
GPIO_PDDR_OFFSET  EQU  0x14
GPIOA_OFFSET      EQU  0x00
GPIOB_OFFSET      EQU  0x40
GPIOC_OFFSET      EQU  0x80
GPIOD_OFFSET      EQU  0xC0
GPIOE_OFFSET      EQU  0x0100
;Port A
GPIOA_BASE        EQU  0x400FF000
GPIOA_PDOR        EQU  (GPIOA_BASE + GPIO_PDOR_OFFSET)
GPIOA_PSOR        EQU  (GPIOA_BASE + GPIO_PSOR_OFFSET)
GPIOA_PCOR        EQU  (GPIOA_BASE + GPIO_PCOR_OFFSET)
GPIOA_PTOR        EQU  (GPIOA_BASE + GPIO_PTOR_OFFSET)
GPIOA_PDIR        EQU  (GPIOA_BASE + GPIO_PDIR_OFFSET)
GPIOA_PDDR        EQU  (GPIOA_BASE + GPIO_PDDR_OFFSET)
;Port B
GPIOB_BASE         EQU  0x400FF040
GPIOB_PDOR         EQU  (GPIOB_BASE + GPIO_PDOR_OFFSET)
GPIOB_PSOR         EQU  (GPIOB_BASE + GPIO_PSOR_OFFSET)
GPIOB_PCOR         EQU  (GPIOB_BASE + GPIO_PCOR_OFFSET)
GPIOB_PTOR         EQU  (GPIOB_BASE + GPIO_PTOR_OFFSET)
GPIOB_PDIR         EQU  (GPIOB_BASE + GPIO_PDIR_OFFSET)
GPIOB_PDDR         EQU  (GPIOB_BASE + GPIO_PDDR_OFFSET)
;Port C
GPIOC_BASE         EQU  0x400FF080
GPIOC_PDOR         EQU  (GPIOC_BASE + GPIO_PDOR_OFFSET)
GPIOC_PSOR         EQU  (GPIOC_BASE + GPIO_PSOR_OFFSET)
GPIOC_PCOR         EQU  (GPIOC_BASE + GPIO_PCOR_OFFSET)
GPIOC_PTOR         EQU  (GPIOC_BASE + GPIO_PTOR_OFFSET)
GPIOC_PDIR         EQU  (GPIOC_BASE + GPIO_PDIR_OFFSET)
GPIOC_PDDR         EQU  (GPIOC_BASE + GPIO_PDDR_OFFSET)
;Port D
GPIOD_BASE         EQU  0x400FF0C0
GPIOD_PDOR         EQU  (GPIOD_BASE + GPIO_PDOR_OFFSET)
GPIOD_PSOR         EQU  (GPIOD_BASE + GPIO_PSOR_OFFSET)
GPIOD_PCOR         EQU  (GPIOD_BASE + GPIO_PCOR_OFFSET)
GPIOD_PTOR         EQU  (GPIOD_BASE + GPIO_PTOR_OFFSET)
GPIOD_PDIR         EQU  (GPIOD_BASE + GPIO_PDIR_OFFSET)
GPIOD_PDDR         EQU  (GPIOD_BASE + GPIO_PDDR_OFFSET)
;Port E
GPIOE_BASE         EQU  0x400FF100
GPIOE_PDOR         EQU  (GPIOE_BASE + GPIO_PDOR_OFFSET)
GPIOE_PSOR         EQU  (GPIOE_BASE + GPIO_PSOR_OFFSET)
GPIOE_PCOR         EQU  (GPIOE_BASE + GPIO_PCOR_OFFSET)
GPIOE_PTOR         EQU  (GPIOE_BASE + GPIO_PTOR_OFFSET)
GPIOE_PDIR         EQU  (GPIOE_BASE + GPIO_PDIR_OFFSET)
GPIOE_PDDR         EQU  (GPIOE_BASE + GPIO_PDDR_OFFSET)
;---------------------------------------------------------------
;IOPORT:  GPIO alias for zero wait state access to GPIO
;See FGPIO
;---------------------------------------------------------------
;Multipurpose clock generator (MCG)
MCG_BASE          EQU  0x40064000
MCG_C1_OFFSET     EQU  0x00
MCG_C2_OFFSET     EQU  0x01
MCG_C4_OFFSET     EQU  0x03
MCG_C5_OFFSET     EQU  0x04
MCG_C6_OFFSET     EQU  0x05
MCG_S_OFFSET      EQU  0x06
MCG_C1            EQU  (MCG_BASE + MCG_C1_OFFSET)
MCG_C2            EQU  (MCG_BASE + MCG_C2_OFFSET)
MCG_C4            EQU  (MCG_BASE + MCG_C4_OFFSET)
MCG_C5            EQU  (MCG_BASE + MCG_C5_OFFSET)
MCG_C6            EQU  (MCG_BASE + MCG_C6_OFFSET)
MCG_S             EQU  (MCG_BASE + MCG_S_OFFSET)
;---------------------------------------------------------------
;MCG_C1
;7-6:CLKS=clock source select
;        :00=ouput of FLL of PLL (depends on MCG_C6.PLLS)
;        :01=internal reference clock
;        :10=external reference clock
;        :11=(reserved)
;5-3:FRDIV=FLL external reference divider (depends on MCG_C2.RANGE0)
;         :first divider is for RANGE0=0
;         :second divider is for all other RANGE0 values
;         :000=  1 or   32
;         :001=  2 or   64
;         :010=  4 or  128
;         :011=  8 or  256
;         :100= 16 or  512
;         :101= 32 or 1024
;         :110= 64 or 1280
;         :111=128 or 1536
;  2:IREFS=internal reference select (for FLL)
;         :0=external reference clock
;         :1=slow internal reference clock
;  1:IRCLKEN=internal reference clock (MCGIRCLK) enable
;  0:IREFSTEN=internal reference stop enable
MCG_C1_CLKS_MASK      EQU 0xC0
MCG_C1_FRDIV_MASK     EQU 0x38
MCG_C1_IREFS_MASK     EQU 0x04
MCG_C1_IRCLKEN_MASK   EQU 0x02
MCG_C1_IREFSTEN_MASK  EQU 0x01
MCG_C1_CLKS_EXT_MASK  EQU 0x80
MCG_C1_CLKS_PLL_MASK  EQU 0x00
MCG_C1_FRDIV_256_MASK EQU 0x18
MCG_C1_EXT_DIV256     EQU (MCG_C1_CLKS_EXT_MASK :OR: MCG_C1_FRDIV_256_MASK)
;---------------------------------------------------------------
;MCG_C2
;  7:LOCRE0=loss of clock reset enable
;          :0=interrupt request on loss of OCS0 external reference clock
;          :1=reset request on loss of OCS0 external reference clock
;  6:Reserved; read-only; always 0
;5-4:RANGE0=frequency range select
;          :00=low frequency range for crystal oscillator
;          :01=high frequency range for crystal oscillator
;          :1X=very high frequency range for crystal oscillator
;  3:HGO0=high gain oscillator select
;        :0=low-power operation
;        :1=high-gain operation
;  2:EREFS0=external reference select
;          :0=external reference clock
;          :1=oscillator
;  1:LP=low power select
;      :0=FLL or PLL not disabled in bypass modes
;      :1=FLL or PLL disabled in bypass modes (lower power)
;  0:IRCS=internal reference clock select
;        :0=slow internal reference clock
;        :1=fast internal reference clock
MCG_C2_LOCRE0_MASK EQU 0x80
MCG_C2_RANGE0_MASK EQU 0x30
MCG_C2_HGO0_MASK   EQU 0x08
MCG_C2_EREFS0_MASK EQU 0x04
MCG_C2_LP_MASK     EQU 0x02
MCG_C2_IRCS_MASK   EQU 0x01
MCG_C2_RANGE0_HIGH_MASK EQU 0x10
MCG_C2_HF_LP_OSC        EQU (MCG_C2_RANGE0_HIGH_MASK :OR: MCG_C2_EREFS0_MASK)
;---------------------------------------------------------------
;MCG_C5
;  7:Reserved: read-only; always 0
;  6:PLLCLKEN0=PLL clock (MCGPLLCLK) enable
;  5:PLLSTEN0=PLL stop enable (in normal stop mode)
;4-0:PRDIV0=PLL external reference divider
;          :00000-11000=1-25 (PRDIV0 + 1)
;          :others=(reserved)
MCG_C5_PLLCLKEN0_MASK EQU 0x40
MCG_C5_PLLSTEN0_MASK  EQU 0x20
MCG_C5_PRDIV0_MASK    EQU 0x1F
MCG_C5_PRDIV0_DIV2  EQU 0x01
;---------------------------------------------------------------
;MCG_C6
;  7:LOLIE0=loss of lock interrupt enable
;  6:PLLS=PLL select
;        :0=FLL
;        :1=PLL
;  5:CME0=clock monitor enable
;4-0:VDIV0=VCO 0 divider
;         :24 + VDIV0
MCG_C6_LOLIE0_MASK EQU 0x80
MCG_C6_PLLS_MASK   EQU 0x40
MCG_C6_CME0_MASK   EQU 0x20
MCG_C6_VDIV0_MASK  EQU 0x1F
MCG_C6_VDIV0_MUL24   EQU 0x00
MCG_C6_PLLS_PLL_MASK EQU MCG_C6_PLLS_MASK
MCG_C6_PLL_MUL24     EQU (MCG_C6_PLLS_PLL_MASK :OR: MCG_C6_VDIV0_MUL24)
;---------------------------------------------------------------
;MCG_S
;  7:LOLS=loss of lock status
;  6:LOCK0=lock status
;  5:PLLST=PLL select status
;         :0=FLL
;         :1=PLL
;  4:IREFST=internal reference status
;          :0=FLL source external
;          :1=FLL source internal
;3-2:CLKST=clock mode status
;         :00=FLL
;         :01=internal reference
;         :10=external reference
;         :11=PLL
;  1:OSCINIT0=OSC initialization (complete)
;  0:IRCST=internal reference clock status
;         :0=slow (32 kHz)
;         :1=fast (4 MHz)
MCG_S_LOLS_MASK      EQU 0x80
MCG_S_LOCK0_MASK     EQU 0x40
MCG_S_PLLST_MASK     EQU 0x20
MCG_S_IREFST_MASK    EQU 0x10
MCG_S_CLKST_MASK     EQU 0x0C
MCG_S_OSCINIT0_MASK  EQU 0x02
MCG_S_IRCST_MASK     EQU 0x01
MCG_S_CLKST_EXT_MASK EQU 0x08
MCG_S_CLKST_PLL_MASK EQU 0x0C
;---------------------------------------------------------------
;PORTx_PCRn (Port x pin control register n [for pin n])
;31-25:Reserved; read-only; always 0
;   24:ISF=interrupt status flag; write 1 clears
;23-20:Reserved; read-only; always 0
;23-20:IRCQ=interrupt configuration
;          :0000=interrupt/DMA request disabled
;          :0001=DMA request on rising edge
;          :0010=DMA request on falling edge
;          :0011=DMA request on either edge
;          :1000=interrupt when logic zero
;          :1001=interrupt on rising edge
;          :1010=interrupt on falling edge
;          :1011=interrupt on either edge
;          :1100=interrupt when logic one
;          :others=reserved
;15-11:Reserved; read-only; always 0
;10-08:MUX=Pin mux control
;         :000=pin disabled (analog)
;         :001=alternative 1 (GPIO)
;         :010-111=alternatives 2-7 (chip-specific)
;    7:Reserved; read-only; always 0
;    6:DSE=Drive strength enable
;         :0=low
;         :1=high
;    5:Reserved; read-only; always 0
;    4:PFE=Passive filter enable
;    3:Reserved; read-only; always 0
;    2:SRE=Slew rate enable
;         :0=fast
;         :1=slow
;    1:PE=Pull enable
;    0:PS=Pull select (if PE=1)
;        :0=internal pulldown
;        :1=internal pullup
PIN_MUX_MASK           EQU  0x00000700
PIN_ISF_MASK           EQU  0x01000000
PIN_MUX_SELECT_0_MASK  EQU  0x00000000 ;analog
PIN_MUX_SELECT_1_MASK  EQU  0x00000100 ;GPIO
PIN_MUX_SELECT_2_MASK  EQU  0x00000200
PIN_MUX_SELECT_3_MASK  EQU  0x00000300
PIN_MUX_SELECT_4_MASK  EQU  0x00000400
PIN_MUX_SELECT_5_MASK  EQU  0x00000500
PIN_MUX_SELECT_6_MASK  EQU  0x00000600
PIN_MUX_SELECT_7_MASK  EQU  0x00000700
;---------------------------------------------------------------
;Port A
PORTA_BASE         EQU  0x40049000
PORTA_PCR0_OFFSET  EQU  0x00
PORTA_PCR1_OFFSET  EQU  0x04
PORTA_PCR2_OFFSET  EQU  0x08
PORTA_PCR3_OFFSET  EQU  0x0C
PORTA_PCR4_OFFSET  EQU  0x10
PORTA_PCR5_OFFSET  EQU  0x14
PORTA_PCR6_OFFSET  EQU  0x18
PORTA_PCR7_OFFSET  EQU  0x1C
PORTA_PCR8_OFFSET  EQU  0x20
PORTA_PCR9_OFFSET  EQU  0x24
PORTA_PCR10_OFFSET EQU  0x28
PORTA_PCR11_OFFSET EQU  0x2C
PORTA_PCR12_OFFSET EQU  0x30
PORTA_PCR13_OFFSET EQU  0x34
PORTA_PCR14_OFFSET EQU  0x38
PORTA_PCR15_OFFSET EQU  0x3C
PORTA_PCR16_OFFSET EQU  0x40
PORTA_PCR17_OFFSET EQU  0x44
PORTA_PCR18_OFFSET EQU  0x48
PORTA_PCR19_OFFSET EQU  0x4C
PORTA_PCR20_OFFSET EQU  0x50
PORTA_PCR21_OFFSET EQU  0x54
PORTA_PCR22_OFFSET EQU  0x58
PORTA_PCR23_OFFSET EQU  0x5C
PORTA_PCR24_OFFSET EQU  0x60
PORTA_PCR25_OFFSET EQU  0x64
PORTA_PCR26_OFFSET EQU  0x68
PORTA_PCR27_OFFSET EQU  0x6C
PORTA_PCR28_OFFSET EQU  0x70
PORTA_PCR29_OFFSET EQU  0x74
PORTA_PCR30_OFFSET EQU  0x78
PORTA_PCR31_OFFSET EQU  0x7C
PORTA_GPCLR_OFFSET EQU  0x80
PORTA_GPCHR_OFFSET EQU  0x84
PORTA_ISFR_OFFSET  EQU  0xA0
PORTA_PCR0         EQU  (PORTA_BASE + PORTA_PCR0_OFFSET)
PORTA_PCR1         EQU  (PORTA_BASE + PORTA_PCR1_OFFSET)
PORTA_PCR2         EQU  (PORTA_BASE + PORTA_PCR2_OFFSET)
PORTA_PCR3         EQU  (PORTA_BASE + PORTA_PCR3_OFFSET)
PORTA_PCR4         EQU  (PORTA_BASE + PORTA_PCR4_OFFSET)
PORTA_PCR5         EQU  (PORTA_BASE + PORTA_PCR5_OFFSET)
PORTA_PCR6         EQU  (PORTA_BASE + PORTA_PCR6_OFFSET)
PORTA_PCR7         EQU  (PORTA_BASE + PORTA_PCR7_OFFSET)
PORTA_PCR8         EQU  (PORTA_BASE + PORTA_PCR8_OFFSET)
PORTA_PCR9         EQU  (PORTA_BASE + PORTA_PCR9_OFFSET)
PORTA_PCR10        EQU  (PORTA_BASE + PORTA_PCR10_OFFSET)
PORTA_PCR11        EQU  (PORTA_BASE + PORTA_PCR11_OFFSET)
PORTA_PCR12        EQU  (PORTA_BASE + PORTA_PCR12_OFFSET)
PORTA_PCR13        EQU  (PORTA_BASE + PORTA_PCR13_OFFSET)
PORTA_PCR14        EQU  (PORTA_BASE + PORTA_PCR14_OFFSET)
PORTA_PCR15        EQU  (PORTA_BASE + PORTA_PCR15_OFFSET)
PORTA_PCR16        EQU  (PORTA_BASE + PORTA_PCR16_OFFSET)
PORTA_PCR17        EQU  (PORTA_BASE + PORTA_PCR17_OFFSET)
PORTA_PCR18        EQU  (PORTA_BASE + PORTA_PCR18_OFFSET)
PORTA_PCR19        EQU  (PORTA_BASE + PORTA_PCR19_OFFSET)
PORTA_PCR20        EQU  (PORTA_BASE + PORTA_PCR20_OFFSET)
PORTA_PCR21        EQU  (PORTA_BASE + PORTA_PCR21_OFFSET)
PORTA_PCR22        EQU  (PORTA_BASE + PORTA_PCR22_OFFSET)
PORTA_PCR23        EQU  (PORTA_BASE + PORTA_PCR23_OFFSET)
PORTA_PCR24        EQU  (PORTA_BASE + PORTA_PCR24_OFFSET)
PORTA_PCR25        EQU  (PORTA_BASE + PORTA_PCR25_OFFSET)
PORTA_PCR26        EQU  (PORTA_BASE + PORTA_PCR26_OFFSET)
PORTA_PCR27        EQU  (PORTA_BASE + PORTA_PCR27_OFFSET)
PORTA_PCR28        EQU  (PORTA_BASE + PORTA_PCR28_OFFSET)
PORTA_PCR29        EQU  (PORTA_BASE + PORTA_PCR29_OFFSET)
PORTA_PCR30        EQU  (PORTA_BASE + PORTA_PCR30_OFFSET)
PORTA_PCR31        EQU  (PORTA_BASE + PORTA_PCR31_OFFSET)
PORTA_GPCLR        EQU  (PORTA_BASE + PORTA_GPCLR_OFFSET)
PORTA_GPCHR        EQU  (PORTA_BASE + PORTA_GPCHR_OFFSET)
PORTA_ISFR         EQU  (PORTA_BASE + PORTA_ISFR_OFFSET)
;---------------------------------------------------------------
;Port B
PORTB_BASE         EQU  0x4004A000
PORTB_PCR0_OFFSET  EQU  0x00
PORTB_PCR1_OFFSET  EQU  0x04
PORTB_PCR2_OFFSET  EQU  0x08
PORTB_PCR3_OFFSET  EQU  0x0C
PORTB_PCR4_OFFSET  EQU  0x10
PORTB_PCR5_OFFSET  EQU  0x14
PORTB_PCR6_OFFSET  EQU  0x18
PORTB_PCR7_OFFSET  EQU  0x1C
PORTB_PCR8_OFFSET  EQU  0x20
PORTB_PCR9_OFFSET  EQU  0x24
PORTB_PCR10_OFFSET EQU  0x28
PORTB_PCR11_OFFSET EQU  0x2C
PORTB_PCR12_OFFSET EQU  0x30
PORTB_PCR13_OFFSET EQU  0x34
PORTB_PCR14_OFFSET EQU  0x38
PORTB_PCR15_OFFSET EQU  0x3C
PORTB_PCR16_OFFSET EQU  0x40
PORTB_PCR17_OFFSET EQU  0x44
PORTB_PCR18_OFFSET EQU  0x48
PORTB_PCR19_OFFSET EQU  0x4C
PORTB_PCR20_OFFSET EQU  0x50
PORTB_PCR21_OFFSET EQU  0x54
PORTB_PCR22_OFFSET EQU  0x58
PORTB_PCR23_OFFSET EQU  0x5C
PORTB_PCR24_OFFSET EQU  0x60
PORTB_PCR25_OFFSET EQU  0x64
PORTB_PCR26_OFFSET EQU  0x68
PORTB_PCR27_OFFSET EQU  0x6C
PORTB_PCR28_OFFSET EQU  0x70
PORTB_PCR29_OFFSET EQU  0x74
PORTB_PCR30_OFFSET EQU  0x78
PORTB_PCR31_OFFSET EQU  0x7C
PORTB_GPCLR_OFFSET EQU  0x80
PORTB_GPCHR_OFFSET EQU  0x84
PORTB_ISFR_OFFSET  EQU  0xA0
PORTB_PCR0         EQU  (PORTB_BASE + PORTB_PCR0_OFFSET)
PORTB_PCR1         EQU  (PORTB_BASE + PORTB_PCR1_OFFSET)
PORTB_PCR2         EQU  (PORTB_BASE + PORTB_PCR2_OFFSET)
PORTB_PCR3         EQU  (PORTB_BASE + PORTB_PCR3_OFFSET)
PORTB_PCR4         EQU  (PORTB_BASE + PORTB_PCR4_OFFSET)
PORTB_PCR5         EQU  (PORTB_BASE + PORTB_PCR5_OFFSET)
PORTB_PCR6         EQU  (PORTB_BASE + PORTB_PCR6_OFFSET)
PORTB_PCR7         EQU  (PORTB_BASE + PORTB_PCR7_OFFSET)
PORTB_PCR8         EQU  (PORTB_BASE + PORTB_PCR8_OFFSET)
PORTB_PCR9         EQU  (PORTB_BASE + PORTB_PCR9_OFFSET)
PORTB_PCR10        EQU  (PORTB_BASE + PORTB_PCR10_OFFSET)
PORTB_PCR11        EQU  (PORTB_BASE + PORTB_PCR11_OFFSET)
PORTB_PCR12        EQU  (PORTB_BASE + PORTB_PCR12_OFFSET)
PORTB_PCR13        EQU  (PORTB_BASE + PORTB_PCR13_OFFSET)
PORTB_PCR14        EQU  (PORTB_BASE + PORTB_PCR14_OFFSET)
PORTB_PCR15        EQU  (PORTB_BASE + PORTB_PCR15_OFFSET)
PORTB_PCR16        EQU  (PORTB_BASE + PORTB_PCR16_OFFSET)
PORTB_PCR17        EQU  (PORTB_BASE + PORTB_PCR17_OFFSET)
PORTB_PCR18        EQU  (PORTB_BASE + PORTB_PCR18_OFFSET)
PORTB_PCR19        EQU  (PORTB_BASE + PORTB_PCR19_OFFSET)
PORTB_PCR20        EQU  (PORTB_BASE + PORTB_PCR20_OFFSET)
PORTB_PCR21        EQU  (PORTB_BASE + PORTB_PCR21_OFFSET)
PORTB_PCR22        EQU  (PORTB_BASE + PORTB_PCR22_OFFSET)
PORTB_PCR23        EQU  (PORTB_BASE + PORTB_PCR23_OFFSET)
PORTB_PCR24        EQU  (PORTB_BASE + PORTB_PCR24_OFFSET)
PORTB_PCR25        EQU  (PORTB_BASE + PORTB_PCR25_OFFSET)
PORTB_PCR26        EQU  (PORTB_BASE + PORTB_PCR26_OFFSET)
PORTB_PCR27        EQU  (PORTB_BASE + PORTB_PCR27_OFFSET)
PORTB_PCR28        EQU  (PORTB_BASE + PORTB_PCR28_OFFSET)
PORTB_PCR29        EQU  (PORTB_BASE + PORTB_PCR29_OFFSET)
PORTB_PCR30        EQU  (PORTB_BASE + PORTB_PCR30_OFFSET)
PORTB_PCR31        EQU  (PORTB_BASE + PORTB_PCR31_OFFSET)
PORTB_GPCLR        EQU  (PORTB_BASE + PORTB_GPCLR_OFFSET)
PORTB_GPCHR        EQU  (PORTB_BASE + PORTB_GPCHR_OFFSET)
PORTB_ISFR         EQU  (PORTB_BASE + PORTB_ISFR_OFFSET)
;---------------------------------------------------------------
;Port C
PORTC_BASE         EQU  0x4004B000
PORTC_PCR0_OFFSET  EQU  0x00
PORTC_PCR1_OFFSET  EQU  0x04
PORTC_PCR2_OFFSET  EQU  0x08
PORTC_PCR3_OFFSET  EQU  0x0C
PORTC_PCR4_OFFSET  EQU  0x10
PORTC_PCR5_OFFSET  EQU  0x14
PORTC_PCR6_OFFSET  EQU  0x18
PORTC_PCR7_OFFSET  EQU  0x1C
PORTC_PCR8_OFFSET  EQU  0x20
PORTC_PCR9_OFFSET  EQU  0x24
PORTC_PCR10_OFFSET EQU  0x28
PORTC_PCR11_OFFSET EQU  0x2C
PORTC_PCR12_OFFSET EQU  0x30
PORTC_PCR13_OFFSET EQU  0x34
PORTC_PCR14_OFFSET EQU  0x38
PORTC_PCR15_OFFSET EQU  0x3C
PORTC_PCR16_OFFSET EQU  0x40
PORTC_PCR17_OFFSET EQU  0x44
PORTC_PCR18_OFFSET EQU  0x48
PORTC_PCR19_OFFSET EQU  0x4C
PORTC_PCR20_OFFSET EQU  0x50
PORTC_PCR21_OFFSET EQU  0x54
PORTC_PCR22_OFFSET EQU  0x58
PORTC_PCR23_OFFSET EQU  0x5C
PORTC_PCR24_OFFSET EQU  0x60
PORTC_PCR25_OFFSET EQU  0x64
PORTC_PCR26_OFFSET EQU  0x68
PORTC_PCR27_OFFSET EQU  0x6C
PORTC_PCR28_OFFSET EQU  0x70
PORTC_PCR29_OFFSET EQU  0x74
PORTC_PCR30_OFFSET EQU  0x78
PORTC_PCR31_OFFSET EQU  0x7C
PORTC_GPCLR_OFFSET EQU  0x80
PORTC_GPCHR_OFFSET EQU  0x84
PORTC_ISFR_OFFSET  EQU  0xA0
PORTC_PCR0         EQU  (PORTC_BASE + PORTC_PCR0_OFFSET)
PORTC_PCR1         EQU  (PORTC_BASE + PORTC_PCR1_OFFSET)
PORTC_PCR2         EQU  (PORTC_BASE + PORTC_PCR2_OFFSET)
PORTC_PCR3         EQU  (PORTC_BASE + PORTC_PCR3_OFFSET)
PORTC_PCR4         EQU  (PORTC_BASE + PORTC_PCR4_OFFSET)
PORTC_PCR5         EQU  (PORTC_BASE + PORTC_PCR5_OFFSET)
PORTC_PCR6         EQU  (PORTC_BASE + PORTC_PCR6_OFFSET)
PORTC_PCR7         EQU  (PORTC_BASE + PORTC_PCR7_OFFSET)
PORTC_PCR8         EQU  (PORTC_BASE + PORTC_PCR8_OFFSET)
PORTC_PCR9         EQU  (PORTC_BASE + PORTC_PCR9_OFFSET)
PORTC_PCR10        EQU  (PORTC_BASE + PORTC_PCR10_OFFSET)
PORTC_PCR11        EQU  (PORTC_BASE + PORTC_PCR11_OFFSET)
PORTC_PCR12        EQU  (PORTC_BASE + PORTC_PCR12_OFFSET)
PORTC_PCR13        EQU  (PORTC_BASE + PORTC_PCR13_OFFSET)
PORTC_PCR14        EQU  (PORTC_BASE + PORTC_PCR14_OFFSET)
PORTC_PCR15        EQU  (PORTC_BASE + PORTC_PCR15_OFFSET)
PORTC_PCR16        EQU  (PORTC_BASE + PORTC_PCR16_OFFSET)
PORTC_PCR17        EQU  (PORTC_BASE + PORTC_PCR17_OFFSET)
PORTC_PCR18        EQU  (PORTC_BASE + PORTC_PCR18_OFFSET)
PORTC_PCR19        EQU  (PORTC_BASE + PORTC_PCR19_OFFSET)
PORTC_PCR20        EQU  (PORTC_BASE + PORTC_PCR20_OFFSET)
PORTC_PCR21        EQU  (PORTC_BASE + PORTC_PCR21_OFFSET)
PORTC_PCR22        EQU  (PORTC_BASE + PORTC_PCR22_OFFSET)
PORTC_PCR23        EQU  (PORTC_BASE + PORTC_PCR23_OFFSET)
PORTC_PCR24        EQU  (PORTC_BASE + PORTC_PCR24_OFFSET)
PORTC_PCR25        EQU  (PORTC_BASE + PORTC_PCR25_OFFSET)
PORTC_PCR26        EQU  (PORTC_BASE + PORTC_PCR26_OFFSET)
PORTC_PCR27        EQU  (PORTC_BASE + PORTC_PCR27_OFFSET)
PORTC_PCR28        EQU  (PORTC_BASE + PORTC_PCR28_OFFSET)
PORTC_PCR29        EQU  (PORTC_BASE + PORTC_PCR29_OFFSET)
PORTC_PCR30        EQU  (PORTC_BASE + PORTC_PCR30_OFFSET)
PORTC_PCR31        EQU  (PORTC_BASE + PORTC_PCR31_OFFSET)
PORTC_GPCLR        EQU  (PORTC_BASE + PORTC_GPCLR_OFFSET)
PORTC_GPCHR        EQU  (PORTC_BASE + PORTC_GPCHR_OFFSET)
PORTC_ISFR         EQU  (PORTC_BASE + PORTC_ISFR_OFFSET)
;---------------------------------------------------------------
;Port D
PORTD_BASE         EQU  0x4004C000
PORTD_PCR0_OFFSET  EQU  0x00
PORTD_PCR1_OFFSET  EQU  0x04
PORTD_PCR2_OFFSET  EQU  0x08
PORTD_PCR3_OFFSET  EQU  0x0C
PORTD_PCR4_OFFSET  EQU  0x10
PORTD_PCR5_OFFSET  EQU  0x14
PORTD_PCR6_OFFSET  EQU  0x18
PORTD_PCR7_OFFSET  EQU  0x1C
PORTD_PCR8_OFFSET  EQU  0x20
PORTD_PCR9_OFFSET  EQU  0x24
PORTD_PCR10_OFFSET EQU  0x28
PORTD_PCR11_OFFSET EQU  0x2C
PORTD_PCR12_OFFSET EQU  0x30
PORTD_PCR13_OFFSET EQU  0x34
PORTD_PCR14_OFFSET EQU  0x38
PORTD_PCR15_OFFSET EQU  0x3C
PORTD_PCR16_OFFSET EQU  0x40
PORTD_PCR17_OFFSET EQU  0x44
PORTD_PCR18_OFFSET EQU  0x48
PORTD_PCR19_OFFSET EQU  0x4C
PORTD_PCR20_OFFSET EQU  0x50
PORTD_PCR21_OFFSET EQU  0x54
PORTD_PCR22_OFFSET EQU  0x58
PORTD_PCR23_OFFSET EQU  0x5C
PORTD_PCR24_OFFSET EQU  0x60
PORTD_PCR25_OFFSET EQU  0x64
PORTD_PCR26_OFFSET EQU  0x68
PORTD_PCR27_OFFSET EQU  0x6C
PORTD_PCR28_OFFSET EQU  0x70
PORTD_PCR29_OFFSET EQU  0x74
PORTD_PCR30_OFFSET EQU  0x78
PORTD_PCR31_OFFSET EQU  0x7C
PORTD_GPCLR_OFFSET EQU  0x80
PORTD_GPCHR_OFFSET EQU  0x84
PORTD_ISFR_OFFSET  EQU  0xA0
PORTD_PCR0         EQU  (PORTD_BASE + PORTD_PCR0_OFFSET)
PORTD_PCR1         EQU  (PORTD_BASE + PORTD_PCR1_OFFSET)
PORTD_PCR2         EQU  (PORTD_BASE + PORTD_PCR2_OFFSET)
PORTD_PCR3         EQU  (PORTD_BASE + PORTD_PCR3_OFFSET)
PORTD_PCR4         EQU  (PORTD_BASE + PORTD_PCR4_OFFSET)
PORTD_PCR5         EQU  (PORTD_BASE + PORTD_PCR5_OFFSET)
PORTD_PCR6         EQU  (PORTD_BASE + PORTD_PCR6_OFFSET)
PORTD_PCR7         EQU  (PORTD_BASE + PORTD_PCR7_OFFSET)
PORTD_PCR8         EQU  (PORTD_BASE + PORTD_PCR8_OFFSET)
PORTD_PCR9         EQU  (PORTD_BASE + PORTD_PCR9_OFFSET)
PORTD_PCR10        EQU  (PORTD_BASE + PORTD_PCR10_OFFSET)
PORTD_PCR11        EQU  (PORTD_BASE + PORTD_PCR11_OFFSET)
PORTD_PCR12        EQU  (PORTD_BASE + PORTD_PCR12_OFFSET)
PORTD_PCR13        EQU  (PORTD_BASE + PORTD_PCR13_OFFSET)
PORTD_PCR14        EQU  (PORTD_BASE + PORTD_PCR14_OFFSET)
PORTD_PCR15        EQU  (PORTD_BASE + PORTD_PCR15_OFFSET)
PORTD_PCR16        EQU  (PORTD_BASE + PORTD_PCR16_OFFSET)
PORTD_PCR17        EQU  (PORTD_BASE + PORTD_PCR17_OFFSET)
PORTD_PCR18        EQU  (PORTD_BASE + PORTD_PCR18_OFFSET)
PORTD_PCR19        EQU  (PORTD_BASE + PORTD_PCR19_OFFSET)
PORTD_PCR20        EQU  (PORTD_BASE + PORTD_PCR20_OFFSET)
PORTD_PCR21        EQU  (PORTD_BASE + PORTD_PCR21_OFFSET)
PORTD_PCR22        EQU  (PORTD_BASE + PORTD_PCR22_OFFSET)
PORTD_PCR23        EQU  (PORTD_BASE + PORTD_PCR23_OFFSET)
PORTD_PCR24        EQU  (PORTD_BASE + PORTD_PCR24_OFFSET)
PORTD_PCR25        EQU  (PORTD_BASE + PORTD_PCR25_OFFSET)
PORTD_PCR26        EQU  (PORTD_BASE + PORTD_PCR26_OFFSET)
PORTD_PCR27        EQU  (PORTD_BASE + PORTD_PCR27_OFFSET)
PORTD_PCR28        EQU  (PORTD_BASE + PORTD_PCR28_OFFSET)
PORTD_PCR29        EQU  (PORTD_BASE + PORTD_PCR29_OFFSET)
PORTD_PCR30        EQU  (PORTD_BASE + PORTD_PCR30_OFFSET)
PORTD_PCR31        EQU  (PORTD_BASE + PORTD_PCR31_OFFSET)
PORTD_GPCLR        EQU  (PORTD_BASE + PORTD_GPCLR_OFFSET)
PORTD_GPCHR        EQU  (PORTD_BASE + PORTD_GPCHR_OFFSET)
PORTD_ISFR         EQU  (PORTD_BASE + PORTD_ISFR_OFFSET)
;---------------------------------------------------------------
;Port E
PORTE_BASE         EQU  0x4004D000
PORTE_PCR0_OFFSET  EQU  0x00
PORTE_PCR1_OFFSET  EQU  0x04
PORTE_PCR2_OFFSET  EQU  0x08
PORTE_PCR3_OFFSET  EQU  0x0C
PORTE_PCR4_OFFSET  EQU  0x10
PORTE_PCR5_OFFSET  EQU  0x14
PORTE_PCR6_OFFSET  EQU  0x18
PORTE_PCR7_OFFSET  EQU  0x1C
PORTE_PCR8_OFFSET  EQU  0x20
PORTE_PCR9_OFFSET  EQU  0x24
PORTE_PCR10_OFFSET EQU  0x28
PORTE_PCR11_OFFSET EQU  0x2C
PORTE_PCR12_OFFSET EQU  0x30
PORTE_PCR13_OFFSET EQU  0x34
PORTE_PCR14_OFFSET EQU  0x38
PORTE_PCR15_OFFSET EQU  0x3C
PORTE_PCR16_OFFSET EQU  0x40
PORTE_PCR17_OFFSET EQU  0x44
PORTE_PCR18_OFFSET EQU  0x48
PORTE_PCR19_OFFSET EQU  0x4C
PORTE_PCR20_OFFSET EQU  0x50
PORTE_PCR21_OFFSET EQU  0x54
PORTE_PCR22_OFFSET EQU  0x58
PORTE_PCR23_OFFSET EQU  0x5C
PORTE_PCR24_OFFSET EQU  0x60
PORTE_PCR25_OFFSET EQU  0x64
PORTE_PCR26_OFFSET EQU  0x68
PORTE_PCR27_OFFSET EQU  0x6C
PORTE_PCR28_OFFSET EQU  0x70
PORTE_PCR29_OFFSET EQU  0x74
PORTE_PCR30_OFFSET EQU  0x78
PORTE_PCR31_OFFSET EQU  0x7C
PORTE_GPCLR_OFFSET EQU  0x80
PORTE_GPCHR_OFFSET EQU  0x84
PORTE_ISFR_OFFSET  EQU  0xA0
PORTE_PCR0         EQU  (PORTE_BASE + PORTE_PCR0_OFFSET)
PORTE_PCR1         EQU  (PORTE_BASE + PORTE_PCR1_OFFSET)
PORTE_PCR2         EQU  (PORTE_BASE + PORTE_PCR2_OFFSET)
PORTE_PCR3         EQU  (PORTE_BASE + PORTE_PCR3_OFFSET)
PORTE_PCR4         EQU  (PORTE_BASE + PORTE_PCR4_OFFSET)
PORTE_PCR5         EQU  (PORTE_BASE + PORTE_PCR5_OFFSET)
PORTE_PCR6         EQU  (PORTE_BASE + PORTE_PCR6_OFFSET)
PORTE_PCR7         EQU  (PORTE_BASE + PORTE_PCR7_OFFSET)
PORTE_PCR8         EQU  (PORTE_BASE + PORTE_PCR8_OFFSET)
PORTE_PCR9         EQU  (PORTE_BASE + PORTE_PCR9_OFFSET)
PORTE_PCR10        EQU  (PORTE_BASE + PORTE_PCR10_OFFSET)
PORTE_PCR11        EQU  (PORTE_BASE + PORTE_PCR11_OFFSET)
PORTE_PCR12        EQU  (PORTE_BASE + PORTE_PCR12_OFFSET)
PORTE_PCR13        EQU  (PORTE_BASE + PORTE_PCR13_OFFSET)
PORTE_PCR14        EQU  (PORTE_BASE + PORTE_PCR14_OFFSET)
PORTE_PCR15        EQU  (PORTE_BASE + PORTE_PCR15_OFFSET)
PORTE_PCR16        EQU  (PORTE_BASE + PORTE_PCR16_OFFSET)
PORTE_PCR17        EQU  (PORTE_BASE + PORTE_PCR17_OFFSET)
PORTE_PCR18        EQU  (PORTE_BASE + PORTE_PCR18_OFFSET)
PORTE_PCR19        EQU  (PORTE_BASE + PORTE_PCR19_OFFSET)
PORTE_PCR20        EQU  (PORTE_BASE + PORTE_PCR20_OFFSET)
PORTE_PCR21        EQU  (PORTE_BASE + PORTE_PCR21_OFFSET)
PORTE_PCR22        EQU  (PORTE_BASE + PORTE_PCR22_OFFSET)
PORTE_PCR23        EQU  (PORTE_BASE + PORTE_PCR23_OFFSET)
PORTE_PCR24        EQU  (PORTE_BASE + PORTE_PCR24_OFFSET)
PORTE_PCR25        EQU  (PORTE_BASE + PORTE_PCR25_OFFSET)
PORTE_PCR26        EQU  (PORTE_BASE + PORTE_PCR26_OFFSET)
PORTE_PCR27        EQU  (PORTE_BASE + PORTE_PCR27_OFFSET)
PORTE_PCR28        EQU  (PORTE_BASE + PORTE_PCR28_OFFSET)
PORTE_PCR29        EQU  (PORTE_BASE + PORTE_PCR29_OFFSET)
PORTE_PCR30        EQU  (PORTE_BASE + PORTE_PCR30_OFFSET)
PORTE_PCR31        EQU  (PORTE_BASE + PORTE_PCR31_OFFSET)
PORTE_GPCLR        EQU  (PORTE_BASE + PORTE_GPCLR_OFFSET)
PORTE_GPCHR        EQU  (PORTE_BASE + PORTE_GPCHR_OFFSET)
PORTE_ISFR         EQU  (PORTE_BASE + PORTE_ISFR_OFFSET)
;---------------------------------------------------------------
;System integration module (SIM)
SIM_BASE            EQU  0x40047000
SIM_SOPT5_OFFSET    EQU  0x1010
SIM_SCGC4_OFFSET    EQU  0x1034
SIM_SCGC5_OFFSET    EQU  0x1038
SIM_CLKDIV1_OFFSET  EQU  0x1044
SIM_COPC_OFFSET     EQU  0x1100
SIM_CLKDIV1         EQU  (SIM_BASE + SIM_CLKDIV1_OFFSET)
SIM_COPC            EQU  (SIM_BASE + SIM_COPC_OFFSET)
SIM_SCGC4           EQU  (SIM_BASE + SIM_SCGC4_OFFSET) 
SIM_SCGC5           EQU  (SIM_BASE + SIM_SCGC5_OFFSET)
SIM_SOPT5           EQU  (SIM_BASE + SIM_SOPT5_OFFSET)
;---------------------------------------------------------------
;SIM_CLKDIV1
;31-28:OUTDIV1=clock 1 output divider value
;             :set divider for core/system clock,
;             :from which bus/flash clocks are derived
;             :divide by OUTDIV1 + 1
;27-19:Reserved; read-only; always 0
;18-16:OUTDIV4=clock 4 output divider value
;             :sets divider for bus and flash clocks,
;             :relative to core/system clock
;             :divide by OUTDIV4 + 1
;15-00:Reserved; read-only; always 0
SIM_CLKDIV1_OUTDIV1_MASK EQU 0xF0000000
SIM_CLKDIV1_OUTDIV4_MASK EQU 0x00070000
SIM_CLKDIV1_OUTDIV1_DIV2_MASK EQU 0x10000000
SIM_CLKDIV1_OUTDIV4_DIV2_MASK EQU 0x00010000
SIM_CORE_DIV2_BUS_DIV2        EQU (SIM_CLKDIV1_OUTDIV1_DIV2_MASK :OR: SIM_CLKDIV1_OUTDIV4_DIV2_MASK)
;---------------------------------------------------------------
;SIM_COPC
;31-04:Reserved; read-only; always 0
;03-02:COPT=COP watchdog timeout
;          :00=disabled
;          :01=timeout after 2^5 LPO cycles or 2^13 bus cycles
;          :10=timeout after 2^8 LPO cycles or 2^16 bus cycles
;          :11=timeout after 2^10 LPO cycles or 2^18 bus cycles
;   01:COPCLKS=COP clock select
;             :0=internal 1 kHz
;             :1=bus clock
;   00:COPW=COP windowed mode
COP_COPT_MASK     EQU  0x0000000C
COP_COPCLKS_MASK  EQU  0x00000002
COP_COPW_MASK     EQU  0x00000001
COP_DISABLE       EQU  0x00000000
;---------------------------------------------------------------
;SIM_SCGC4
;1->31-28:Reserved; read-only; always 1
;0->27-24:Reserved; read-only; always 0
;0->   23:SPI1=SPI1 clock gate control (disabled)
;0->   22:SPI0=SPI0 clock gate control (disabled)
;0->21-20:Reserved; read-only; always 0
;0->   19:CMP=comparator clock gate control (disabled)
;0->   18:USBOTG=USB clock gate control (disabled)
;0->17-14:Reserved; read-only; always 0
;0->   13:Reserved; read-only; always 0
;0->   12:UART2=UART2 clock gate control (disabled)
;1->   11:UART1=UART1 clock gate control (disabled)
;0->   10:UART0=UART0 clock gate control (disabled)
;0->09-08:Reserved; read-only; always 0
;0->   07:I2C1=I2C1 clock gate control (disabled)
;0->   06:I2C0=I2C0 clock gate control (disabled)
;1->05-04:Reserved; read-only; always 1
;0->03-00:Reserved; read-only; always 0
SIM_SCGC4_SPI1_MASK    EQU  0x00800000
SIM_SCGC4_SPI0_MASK    EQU  0x00400000
SIM_SCGC4_CMP_MASK     EQU  0x00080000
SIM_SCGC4_USBOTG_MASK  EQU  0x00040000
SIM_SCGC4_UART2_MASK   EQU  0x00001000
SIM_SCGC4_UART1_MASK   EQU  0x00000800
SIM_SCGC4_UART0_MASK   EQU  0x00000400
SIM_SCGC4_I2C1_MASK    EQU  0x00000080
SIM_SCGC4_I2C0_MASK    EQU  0x00000040
;---------------------------------------------------------------
;SIM_SCGC5
;31-20:Reserved; read-only; always 0
;   19:Reserved; read-only; always 0
;18-14:Reserved; read-only; always 0
;   13:PORTE=Port E clock gate control
;   12:PORTD=Port D clock gate control
;   11:PORTC=Port C clock gate control
;   10:PORTB=Port B clock gate control
;    9:PORTA=Port A clock gate control
;08-07:Reserved; read-only; always 1
;    6:Reserved; read-only; always 0
;    5:TSI=TSI access control
;04-02:Reserved; read-only; always 0
;    1:Reserved; read-only; always 0
;    0:LPTMR=Low power timer access control
SIM_SCGC5_PORTE_MASK  EQU  0x00002000
SIM_SCGC5_PORTD_MASK  EQU  0x00001000
SIM_SCGC5_PORTC_MASK  EQU  0x00000800
SIM_SCGC5_PORTB_MASK  EQU  0x00000400
SIM_SCGC5_PORTA_MASK  EQU  0x00000200
SIM_SCGC5_TSI_MASK    EQU  0x00000020
SIM_SCGC5_LPTMR_MASK  EQU  0x00000001
;---------------------------------------------------------------
;SIM_SOPT5
;31-20:Reserved; read-only; always 0
;   19:Reserved; read-only; always 0
;   18:UART2ODE=UART2 open drain enable
;   17:UART1ODE=UART1 open drain enable
;   16:UART0ODE=UART0 open drain enable
;15-07:Reserved; read-only; always 0
;   06:UART1TXSRC=UART1 receive data select
;                :0=UART1_RX pin
;                :1=CMP0 output
;05-04:UART1TXSRC=UART1 transmit data select source
;                :00=UART1_TX pin
;                :01=UART1_TX pin modulated with TPM1 channel 0 output
;                :10=UART1_TX pin modulated with TPM2 channel 0 output
;                :11=(reserved)
;   03:Reserved; read-only; always 0
;   02:UART0RXSRC=UART0 receive data select
;                :0=UART0_RX pin
;                :1=CMP0 output
;01-00:UART0TXSRC=UART0 transmit data select source
;                :00=UART0_TX pin
;                :01=UART0_TX pin modulated with TPM1 channel 0 output
;                :10=UART0_TX pin modulated with TPM2 channel 0 output
;                :11=(reserved)
UART2ODE_MASK     EQU  0x00040000
UART1ODE_MASK     EQU  0x00020000
UART0ODE_MASK     EQU  0x00010000
UART1RXSRC_MASK   EQU  0x00000040
UART1TXSRC_MASK   EQU  0x00000030
UART0RXSRC_MASK   EQU  0x00000004
UART0TXSRC_MASK   EQU  0x00000003
;---------------------------------------------------------------
;UART 1
UART1_BASE  EQU  0x4006B000
UART_BDH_OFFSET  EQU  0x00
UART_BDL_OFFSET  EQU  0x01
UART_C1_OFFSET   EQU  0x02
UART_C2_OFFSET   EQU  0x03
UART_S1_OFFSET   EQU  0x04
UART_S2_OFFSET   EQU  0x05
UART_C3_OFFSET   EQU  0x06
UART_D_OFFSET    EQU  0x07
UART_C4_OFFSET   EQU  0x08
UART1_BDH        EQU  (UART1_BASE + UART_BDH_OFFSET)
UART1_BDL        EQU  (UART1_BASE + UART_BDL_OFFSET)
UART1_C1         EQU  (UART1_BASE + UART_C1_OFFSET)
UART1_C2         EQU  (UART1_BASE + UART_C2_OFFSET)
UART1_S1         EQU  (UART1_BASE + UART_S1_OFFSET)
UART1_S2         EQU  (UART1_BASE + UART_S2_OFFSET)
UART1_C3         EQU  (UART1_BASE + UART_C3_OFFSET)
UART1_D          EQU  (UART1_BASE + UART_D_OFFSET)
UART1_C4         EQU  (UART1_BASE + UART_C4_OFFSET)
;---------------------------------------------------------------
;UARTx_BDH
;  7:LBKDIE=LIN break detect IE
;  6:RXEDGIE=RxD input active edge IE
;  5:SBNS=Stop bit number select
;4-0:SBR[12:0] (BUSCLK / (16 x 9600))
UART_LBKDIE_MASK    EQU  0x80
UART_RXEDGIE_MASK   EQU  0x40
UART_SBNS_MASK      EQU  0x20
UART_SBR_12_0_MASK  EQU  0x1F
;---------------------------------------------------------------
;UARTx_BDL
;7-0:SBR[7:0] (BUSCLK / 16 x 9600))
;---------------------------------------------------------------
;UARTx_C1
;7:LOOPS=loops select (normal)
;6:UARTSWAI=UART stop in wait mode (disabled)
;5:RSRC=receiver source select (internal--no effect LOOPS=0)
;4:M=9- or 8-bit mode select (1 start, 8 data [lsb first], 1 stop)
;3:WAKE=receiver wakeup method select (idle)
;2:IDLE=idle line type select (idle begins after start bit)
;1:PE=parity enable (disabled)
;0:PT=parity type (even parity--no effect PE=0)
UART_LOOPS_MASK     EQU  0x80
UART_UARTSWAI_MASK  EQU  0x40
UART_RSRC_MASK      EQU  0x20
UART_M_MASK         EQU  0x10
UART_WAKE_MASK      EQU  0x08
UART_ILT_MASK       EQU  0x04
UART_PE_MASK        EQU  0x02
UART_PT_MASK        EQU  0x01
;---------------------------------------------------------------
;UARTx_C2
;7:TIE=transmit IE for TDRE (disabled)
;6:TCIE=trasmission complete IE for TC (disabled)
;5:RIE=receiver IE for RDRF (disabled)
;4:ILIE=idle line IE for IDLE (disabled)
;3:TE=transmitter enable (enabled)
;2:RE=receiver enable (enabled)
;1:RWU=receiver wakeup control (normal)
;0:SBK=send break (disabled, normal)
UART_TIE_MASK   EQU  0x80
UART_TCIE_MASK  EQU  0x40
UART_RIE_MASK   EQU  0x20
UART_ILIE_MASK  EQU  0x10
UART_TE_MASK    EQU  0x08
UART_RE_MASK    EQU  0x04
UART_RWU_MASK   EQU  0x02
UART_SBK_MASK   EQU  0x01
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
UART_R8_MASK     EQU  0x80
UART_T8_MASK     EQU  0x40
UART_TXDIR_MASK  EQU  0x20
UART_TXINV_MASK  EQU  0x10
UART_ORIE_MASK   EQU  0x08
UART_NEIE_MASK   EQU  0x04
UART_FEIE_MASK   EQU  0x02
UART_PEIE_MASK   EQU  0x01
;---------------------------------------------------------------
;UARTx_C4
;  7:TDMAS=transmitter DMA select (disabled)
;  6:Reserved; read-only; always 0
;  5:RDMAS=receiver full DMA select (disabled)
;  4:Reserved; read-only; always 0
;  3:Reserved; read-only; always 0
;2-0:Reserved; read-only; always 0
UART_TDMAS_MASK  EQU  0x80
UART_RDMAS_MASK  EQU  0x20
;---------------------------------------------------------------
;UARTx_S1
;7:TDRE=transmit data register empty flag
;6:TC=transmission complete flag
;5:RDRF=receive data register full flag
;4:IDLE=idle line flag
;3:OR=receiver overrun flag
;2:NF=noise flag
;1:FE=framing error flag
;0:PF=parity error flag
UART_TDRE_MASK EQU 0x80
UART_TC_MASK   EQU 0x40
UART_RDRF_MASK EQU 0x20
UART_IDLE_MASK EQU 0x10
UART_OR_MASK   EQU 0x08
UART_NF_MASK   EQU 0x04
UART_FE_MASK   EQU 0x02
UART_PF_MASK   EQU 0x01
;**********************************************************************
;Vector Table Mapped to Address 0 at Reset
;Linker requires __Vectors to be exported
            AREA    RESET, DATA, READONLY
            EXPORT  __Vectors
__Vectors 
            DCD    SP_INIT        ;stack pointer value when stack is empty
            DCD    Reset_Handler  ;reset vector
            SPACE  (VECTOR_TABLE_SIZE - (2 * VECTOR_SIZE))
            ALIGN
;**********************************************************************
            AREA    Start,CODE,READONLY
SystemInit
;**********************************************************************
;Performs the following system initialization tasks.
;* Mask interrupts
;* Disable watchdog timer (+)
;* Load initial RAM image from end of loaded flash image (++)
;* Initialize registers to known state for debugger
;+:Following [1].1.1.4.2 Startup routines: 1 Disable watchdog
;++:Step suggested [1].1.1.4.2 Startup routtines: 2 Initialize RAM
;[1] Freescale Semiconductor, <B>Kinetis L Peripheral Module Quick
;    Reference</B>, KLQRUG, Rev. 0, 9/2012.
;**********************************************************************
;Mask interrupts
            CPSID   I
;Disable watchdog timer
            LDR     R0,=SIM_COPC
            MOVS    R1,#COP_DISABLE
            STR     R1,[R0,#0]
;Put return on stack
            PUSH    {LR}
;Initialize RAM                       ;Find start of RAM image
            LDR     R0,=__EndMyConst  ;R0 = max(__EndMyConst,
			LDR     R1,=__END_FCF     ;         __END_FCF,
			CMP     R0,R1             ;         __ENDMyCode
			BHI     __RAMImage
			MOV     R0,R1
__RAMImage  LDR     R1,=__EndMyCode
            CMP     R0,R1
			BHI     __RAMInit
			MOV     R0,R1
__RAMInit	                          ;Copy from RAM image in
            LDR     R1,=MyData        ;ROM to RAM
            LDR     R2,=__EndMyData
            CMP     R1,R2
            BHS     __RAMInitDone
__RAMInitLoop
            LDR     R3,[R0,#0]
            STR     R3,[R1,#0]
            ADDS    R0,R0,#4
            ADDS    R1,R1,#4
            CMP     R1,R2    
            BLO     __RAMInitLoop
__RAMInitDone
;Initialize registers
            LDR     R1,=0x11111111
            ADDS    R2,R1,R1
            ADDS    R3,R2,R1
            ADDS    R4,R3,R1
            ADDS    R5,R4,R1
            ADDS    R6,R5,R1
            ADDS    R7,R6,R1
            ADDS    R0,R7,R1
            MOV     R8,R0
            ADDS    R0,R0,R1
            MOV     R9,R0
            ADDS    R0,R0,R1
            MOV     R10,R0
            ADDS    R0,R0,R1
            MOV     R11,R0
            ADDS    R0,R0,R1
            MOV     R12,R0
            ADDS    R0,R0,R1
            ADDS    R0,R0,R1
            MOV     R14,R0
            MOVS    R0,#0
            POP     {PC}
SetClock48MHz
;**********************************************************************
;Establishes 96-MHz PLL clock from 8-MHz external oscillator.
;Follows [1].4.1 Clocking 3: Configuration examples
;[1] Freescale Semiconductor, <B>Kinetis L Peripheral Module Quick
;    Reference</B>, KLQRUG, Rev. 0, 9/2012.
;Modifies:  condition flags
;**********************************************************************
            PUSH    {R0-R3}
  ;Establish FLL bypassed external mode (FBE)
    ;First configure oscillator settings in MCG_C2
    ;RANGE is determined from external frequency
    ;Since RANGE affects FRDIV, it must be set
    ;correctly even with an external clock
            LDR     R0,=MCG_BASE
            MOVS    R1,#MCG_C2_HF_LP_OSC
            STRB    R1,[R0,#MCG_C2_OFFSET]
    ;FRDIV set to keep FLL ref clock within
    ;  correct range, determined by ref clock.
    ;For 8-MHz ref, need divide by 256
    ;CLKS must be set to 2_10 to select
    ;  external referenc clock
    ;Clearing IREFS selects and enables
    ;  external oscillator
            MOVS    R1,#MCG_C1_EXT_DIV256
            STRB    R1,[R0,#MCG_C1_OFFSET]
    ;Wait for OSCINIT to set after switching
    ;  to external oscillator, or time out
            MOVS    R1,#MCG_S_OSCINIT0_MASK
            LDR     R3,=20000
__MCG_Wait_OSCINIT0
            LDRB    R2,[R0,#MCG_S_OFFSET]
            TST     R1,R2
            BNE     __MCG_OSCINIT0
            SUBS    R3,R3,#1
            BNE     __MCG_Wait_OSCINIT0
__MCG_OSCINIT0
    ;Wait for reference clock status to clear,
    ;  or time out
            MOVS    R1,#MCG_S_IREFST_MASK
            LDR     R3,=2000
__MCG_Wait_IREFST_Clear
            LDRB    R2,[R0,#MCG_S_OFFSET]
            TST     R1,R2
            BEQ     __MCG_IREFST_Clear
            SUBS    R3,R3,#1
            BNE     __MCG_Wait_IREFST_Clear
__MCG_IREFST_Clear
    ;Wait for clock status to show
    ;  external reference clock source,
    ;  or time out
            MOVS    R1,#MCG_S_CLKST_MASK
            LDR     R3,=2000
__MCG_Wait_CLKST_EXT
            LDRB    R2,[R0,#MCG_S_OFFSET]
            ANDS    R2,R2,R1
            CMP     R2,#MCG_S_CLKST_EXT_MASK
            BEQ     __MCG_CLKST_EXT
            SUBS    R3,R3,#1
            BNE     __MCG_Wait_CLKST_EXT
__MCG_CLKST_EXT
  ;Enable clock monitor when using external clock
            MOVS    R1,#MCG_C6_CME0_MASK
            LDRB    R2,[R0,#MCG_C6_OFFSET]
            ORRS    R2,R2,R1
            STRB    R2,[R0,#MCG_C6_OFFSET]
  ;Enable PLL and move to PLL bypassed external mode
  ;  to allow PLL lock while still clocking from
  ;  external reference clock (PBE mode)
    ;Set PLL reference clock to right frequency
            MOVS    R1,#MCG_C5_PRDIV0_MASK
            MVNS    R1,R1
            MOVS    R3,#MCG_C5_PRDIV0_DIV2
            LDRB    R2,[R0,#MCG_C5_OFFSET]
            ANDS    R2,R2,R1
            ORRS    R2,R2,R3
            STRB    R2,[R0,#MCG_C5_OFFSET]
    ;Set PLL multiplier and enable PLL
            MOVS    R1,#MCG_C6_VDIV0_MASK
            MVNS    R1,R1
            MOVS    R3,#MCG_C6_PLL_MUL24
            LDRB    R2,[R0,#MCG_C6_OFFSET]
            ANDS    R2,R2,R1
            ORRS    R2,R2,R3
            STRB    R2,[R0,#MCG_C6_OFFSET]
    ;Wait for PLLST status bit to set,
    ;  or time out
            MOVS    R1,#MCG_S_PLLST_MASK
            LDR     R3,=2000
__MCG_Wait_PLLST
            LDRB    R2,[R0,#MCG_S_OFFSET]
            TST     R1,R2
            BNE     __MCG_PLLST
            SUBS    R3,R3,#1
            BNE     __MCG_Wait_PLLST
__MCG_PLLST
    ;Wait for LOCK0 status bit to set,
    ;  or time out
            MOVS    R1,#MCG_S_LOCK0_MASK
            LDR     R3,=4000
__MCG_Wait_LOCK0
            LDRB    R2,[R0,#MCG_S_OFFSET]
            TST     R1,R2
            BNE     __MCG_LOCK0
            SUBS    R3,R3,#1
            BNE     __MCG_Wait_LOCK0
__MCG_LOCK0
  ;With PLL now enabled and locked,
  ;  MCGOUTCLK can be switched to PLL output
  ;Before switching to this higher frequency clock,
  ;  system clock dividers must be set to keep 
  ;  frequencies withing specifications
            LDR     R1,=SIM_CLKDIV1
            LDR     R2,=SIM_CORE_DIV2_BUS_DIV2
            STR     R2,[R1,#0]
  ;Switch to PLL (PEE mode)
    ;Clear CLKS to select PLL as MCGCLKOUT
            MOVS    R1,#MCG_C1_CLKS_MASK
            MVNS    R1,R1
            LDRB    R2,[R0,#MCG_C1_OFFSET]
            ANDS    R2,R2,R1
            STRB    R2,[R0,#MCG_C1_OFFSET]
    ;Wait for clock status to show
    ;  external reference clock source,
    ;  or time out
            MOVS    R1,#MCG_S_CLKST_MASK
            LDR     R3,=2000
__MCG_Wait_CLKST_PLL
            LDRB    R2,[R0,#MCG_S_OFFSET]
            ANDS    R2,R2,R1
            CMP     R2,#MCG_S_CLKST_PLL_MASK
            BEQ     __MCG_CLKST_PLL
            SUBS    R3,R3,#1
            BNE     __MCG_Wait_CLKST_PLL
__MCG_CLKST_PLL            
            POP     {R0-R3}
            BX      LR
;**********************************************************************
            AREA    SSTACK,DATA,READWRITE
;Allocate system stack
            ALIGN
            SPACE   SSTACK_SIZE
SP_INIT
            END