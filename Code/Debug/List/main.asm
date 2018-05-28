
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 2.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _state=R4
	.DEF _state_msb=R5
	.DEF _cursor=R6
	.DEF _cursor_msb=R7
	.DEF _access=R8
	.DEF _access_msb=R9
	.DEF _user=R10
	.DEF _user_msb=R11
	.DEF _password=R12
	.DEF _password_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x5,0x0,0x0,0x0
	.DB  0x1,0x0

_0x0:
	.DB  0x75,0x73,0x65,0x72,0x20,0x69,0x64,0x3A
	.DB  0x20,0x0,0x70,0x61,0x73,0x73,0x77,0x6F
	.DB  0x72,0x64,0x3A,0x20,0x0,0x30,0x20,0x6F
	.DB  0x70,0x65,0x6E,0x0,0x31,0x20,0x61,0x64
	.DB  0x64,0x20,0x75,0x73,0x65,0x72,0x0,0x32
	.DB  0x20,0x64,0x65,0x6C,0x20,0x75,0x73,0x65
	.DB  0x72,0x0,0x33,0x20,0x61,0x63,0x63,0x65
	.DB  0x73,0x73,0x0,0x65,0x6E,0x74,0x65,0x72
	.DB  0x20,0x75,0x73,0x65,0x72,0x20,0x69,0x64
	.DB  0x3A,0x0,0x30,0x20,0x70,0x75,0x62,0x6C
	.DB  0x69,0x63,0x0,0x31,0x20,0x75,0x73,0x65
	.DB  0x72,0x73,0x20,0x6F,0x6E,0x6C,0x79,0x0
	.DB  0x32,0x20,0x6E,0x6F,0x6F,0x6E,0x65,0x0
	.DB  0x2A,0x20,0x62,0x61,0x63,0x6B,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0A
	.DW  _0x5D
	.DW  _0x0*2

	.DW  0x0B
	.DW  _0x5D+10
	.DW  _0x0*2+10

	.DW  0x07
	.DW  _0x5D+21
	.DW  _0x0*2+21

	.DW  0x0B
	.DW  _0x5D+28
	.DW  _0x0*2+28

	.DW  0x0B
	.DW  _0x5D+39
	.DW  _0x0*2+39

	.DW  0x09
	.DW  _0x5D+50
	.DW  _0x0*2+50

	.DW  0x0F
	.DW  _0x5D+59
	.DW  _0x0*2+59

	.DW  0x0F
	.DW  _0x5D+74
	.DW  _0x0*2+59

	.DW  0x09
	.DW  _0x5D+89
	.DW  _0x0*2+74

	.DW  0x0D
	.DW  _0x5D+98
	.DW  _0x0*2+83

	.DW  0x08
	.DW  _0x5D+111
	.DW  _0x0*2+96

	.DW  0x07
	.DW  _0x5D+119
	.DW  _0x0*2+104

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;// types
;typedef char* User;
;typedef char* Password;
;
;// states
;#define IDLE -1
;#define INIT 0
;#define LOGIN_USER 1
;#define LOGIN_PASS_INIT 2
;#define LOGIN_PASS 3
;#define LOGIN_CHECK 4
;#define ADMIN_MENU 5
;#define ADMIN_CHECK 6
;#define ADMIN_ADD 7
;#define ADMIN_ADD_CHECK 8
;#define ADMIN_DEL 9
;#define ADMIN_DEL_CHECK 10
;#define ADMIN_CNT 11
;#define ADMIN_CNT_CHECK 12
;#define DOOR_OPEN 20
;
;
;// Declare your global variables here
;int state = ADMIN_MENU;
;int cursor = 0;
;int access = 1;
;
;User user;
;Password password;
;
;
;// functions
;char getKey();
;
;void print(char c) {
; 0000 0028 void print(char c) {

	.CSEG
_print:
; .FSTART _print
; 0000 0029     lcd_gotoxy(cursor, 1);
	ST   -Y,R26
;	c -> Y+0
	ST   -Y,R6
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 002A     lcd_putchar(c);
	LD   R26,Y
	CALL _lcd_putchar
; 0000 002B     cursor++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 002C }
	JMP  _0x2020001
; .FEND
;
;void prints(char* s) {
; 0000 002E void prints(char* s) {
; 0000 002F     lcd_puts(s);
;	*s -> Y+0
; 0000 0030 }
;
;void clear() {
; 0000 0032 void clear() {
_clear:
; .FSTART _clear
; 0000 0033     cursor = cursor > 0 ? cursor-1 : 0;
	CLR  R0
	CP   R0,R6
	CPC  R0,R7
	BRGE _0x3
	MOVW R30,R6
	SBIW R30,1
	RJMP _0x4
_0x3:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x4:
	MOVW R6,R30
; 0000 0034     lcd_gotoxy(cursor, 1);
	ST   -Y,R6
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0035     lcd_putchar('');
	LDI  R26,LOW(0)
	CALL _lcd_putchar
; 0000 0036 }
	RET
; .FEND
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void) {
; 0000 0039 interrupt [2] void ext_int0_isr(void) {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 003A     char pressedKey = '';
; 0000 003B     switch (state) {
	ST   -Y,R17
;	pressedKey -> R17
	LDI  R17,0
	MOVW R30,R4
; 0000 003C         case LOGIN_USER:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x9
; 0000 003D             pressedKey = getKey();
	RCALL _getKey
	MOV  R17,R30
; 0000 003E 
; 0000 003F             if (pressedKey == '#') {
	CPI  R17,35
	BRNE _0xA
; 0000 0040                 state = LOGIN_PASS_INIT;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R4,R30
; 0000 0041             }else if (pressedKey == '*') {
	RJMP _0xB
_0xA:
	CPI  R17,42
	BRNE _0xC
; 0000 0042                 clear();
	RCALL _clear
; 0000 0043             }else{
	RJMP _0xD
_0xC:
; 0000 0044                 user[cursor] = pressedKey;
	MOVW R30,R6
	ADD  R30,R10
	ADC  R31,R11
	ST   Z,R17
; 0000 0045                 print(pressedKey);
	MOV  R26,R17
	RCALL _print
; 0000 0046             }
_0xD:
_0xB:
; 0000 0047             break;
	RJMP _0x8
; 0000 0048 
; 0000 0049         case LOGIN_PASS:
_0x9:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xE
; 0000 004A             pressedKey = getKey();
	RCALL _getKey
	MOV  R17,R30
; 0000 004B 
; 0000 004C             if (pressedKey == '#') {
	CPI  R17,35
	BRNE _0xF
; 0000 004D                 state = LOGIN_CHECK;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R4,R30
; 0000 004E             }else if (pressedKey == '*') {
	RJMP _0x10
_0xF:
	CPI  R17,42
	BRNE _0x11
; 0000 004F                 clear();
	RCALL _clear
; 0000 0050             }else{
	RJMP _0x12
_0x11:
; 0000 0051                 password[cursor] = pressedKey;
	MOVW R30,R6
	ADD  R30,R12
	ADC  R31,R13
	ST   Z,R17
; 0000 0052                 print('*');
	LDI  R26,LOW(42)
	RCALL _print
; 0000 0053             }
_0x12:
_0x10:
; 0000 0054             break;
	RJMP _0x8
; 0000 0055         case ADMIN_CHECK:
_0xE:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x13
; 0000 0056             pressedKey = getKey();
	RCALL _getKey
	MOV  R17,R30
; 0000 0057 
; 0000 0058             if (pressedKey == '0') {
	CPI  R17,48
	BRNE _0x14
; 0000 0059                 state = DOOR_OPEN;
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RJMP _0x67
; 0000 005A             }else if (pressedKey == '1') {
_0x14:
	CPI  R17,49
	BRNE _0x16
; 0000 005B                 state = ADMIN_ADD;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RJMP _0x67
; 0000 005C             }else if (pressedKey == '2'){
_0x16:
	CPI  R17,50
	BRNE _0x18
; 0000 005D                 state = ADMIN_DEL;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RJMP _0x67
; 0000 005E             }else if (pressedKey == '3'){
_0x18:
	CPI  R17,51
	BRNE _0x1A
; 0000 005F                 state = ADMIN_CNT;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	RJMP _0x67
; 0000 0060             }else{
_0x1A:
; 0000 0061               // possible error message
; 0000 0062               // delay library needs to be added
; 0000 0063               state = ADMIN_MENU;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x67:
	MOVW R4,R30
; 0000 0064             }
; 0000 0065             break;
	RJMP _0x8
; 0000 0066         case ADMIN_CNT_CHECK:
_0x13:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x8
; 0000 0067             pressedKey = getKey();
	RCALL _getKey
	MOV  R17,R30
; 0000 0068 
; 0000 0069             if (pressedKey == '0') {
	CPI  R17,48
	BRNE _0x1D
; 0000 006A                 access = 0;
	CLR  R8
	CLR  R9
; 0000 006B                 // possible acknowledge message
; 0000 006C                 state = ADMIN_MENU;
	RJMP _0x68
; 0000 006D             }else if (pressedKey == '1'){
_0x1D:
	CPI  R17,49
	BRNE _0x1F
; 0000 006E                 access = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
; 0000 006F                 // possible acknowledge message
; 0000 0070                 state = ADMIN_MENU;
	RJMP _0x68
; 0000 0071             }else if (pressedKey == '2') {
_0x1F:
	CPI  R17,50
	BRNE _0x21
; 0000 0072                 access = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R8,R30
; 0000 0073                 // possible acknowledge message
; 0000 0074                 state = ADMIN_MENU;
; 0000 0075             }else{
_0x21:
; 0000 0076               // possible error message
; 0000 0077               // delay library needs to be added
; 0000 0078               state = ADMIN_MENU;
_0x68:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	MOVW R4,R30
; 0000 0079             }
; 0000 007A             break;
; 0000 007B     }
_0x8:
; 0000 007C 
; 0000 007D }
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;char getKey() {
; 0000 007F char getKey() {
_getKey:
; .FSTART _getKey
; 0000 0080     char pressedKey = '';
; 0000 0081 
; 0000 0082     PORTC.0 = 0;
	ST   -Y,R17
;	pressedKey -> R17
	LDI  R17,0
	CBI  0x15,0
; 0000 0083     PORTC.1 = 1;
	SBI  0x15,1
; 0000 0084     PORTC.2 = 1;
	SBI  0x15,2
; 0000 0085 
; 0000 0086     if (PINC.0 == 0) {
	SBIC 0x13,0
	RJMP _0x29
; 0000 0087         if (PINC.3 == 0) {
	SBIC 0x13,3
	RJMP _0x2A
; 0000 0088             pressedKey = '1';
	LDI  R17,LOW(49)
; 0000 0089         }else if (PINC.4 == 0) {
	RJMP _0x2B
_0x2A:
	SBIC 0x13,4
	RJMP _0x2C
; 0000 008A             pressedKey = '4';
	LDI  R17,LOW(52)
; 0000 008B         }else if (PINC.5 == 0) {
	RJMP _0x2D
_0x2C:
	SBIC 0x13,5
	RJMP _0x2E
; 0000 008C             pressedKey = '7';
	LDI  R17,LOW(55)
; 0000 008D         }else if (PINC.6 == 0) {
	RJMP _0x2F
_0x2E:
	SBIS 0x13,6
; 0000 008E             pressedKey = '*';
	LDI  R17,LOW(42)
; 0000 008F         }
; 0000 0090     }
_0x2F:
_0x2D:
_0x2B:
; 0000 0091 
; 0000 0092     PORTC.0 = 1;
_0x29:
	SBI  0x15,0
; 0000 0093     PORTC.1 = 0;
	CBI  0x15,1
; 0000 0094     PORTC.2 = 1;
	SBI  0x15,2
; 0000 0095 
; 0000 0096     if (PINC.1 == 0) {
	SBIC 0x13,1
	RJMP _0x37
; 0000 0097         if (PINC.3 == 0) {
	SBIC 0x13,3
	RJMP _0x38
; 0000 0098             pressedKey = '2';
	LDI  R17,LOW(50)
; 0000 0099         }else if (PINC.4 == 0) {
	RJMP _0x39
_0x38:
	SBIC 0x13,4
	RJMP _0x3A
; 0000 009A             pressedKey = '5';
	LDI  R17,LOW(53)
; 0000 009B         }else if (PINC.5 == 0) {
	RJMP _0x3B
_0x3A:
	SBIC 0x13,5
	RJMP _0x3C
; 0000 009C             pressedKey = '8';
	LDI  R17,LOW(56)
; 0000 009D         }else if (PINC.6 == 0) {
	RJMP _0x3D
_0x3C:
	SBIS 0x13,6
; 0000 009E             pressedKey = '0';
	LDI  R17,LOW(48)
; 0000 009F         }
; 0000 00A0     }
_0x3D:
_0x3B:
_0x39:
; 0000 00A1 
; 0000 00A2     PORTC.0 = 1;
_0x37:
	SBI  0x15,0
; 0000 00A3     PORTC.1 = 1;
	SBI  0x15,1
; 0000 00A4     PORTC.2 = 0;
	CBI  0x15,2
; 0000 00A5 
; 0000 00A6     if (PINC.2 == 0) {
	SBIC 0x13,2
	RJMP _0x45
; 0000 00A7         if (PINC.3 == 0) {
	SBIC 0x13,3
	RJMP _0x46
; 0000 00A8             pressedKey = '3';
	LDI  R17,LOW(51)
; 0000 00A9         }else if (PINC.4 == 0) {
	RJMP _0x47
_0x46:
	SBIC 0x13,4
	RJMP _0x48
; 0000 00AA             pressedKey = '6';
	LDI  R17,LOW(54)
; 0000 00AB         }else if (PINC.5 == 0) {
	RJMP _0x49
_0x48:
	SBIC 0x13,5
	RJMP _0x4A
; 0000 00AC             pressedKey = '9';
	LDI  R17,LOW(57)
; 0000 00AD         }else if (PINC.6 == 0) {
	RJMP _0x4B
_0x4A:
	SBIS 0x13,6
; 0000 00AE             pressedKey = '#';
	LDI  R17,LOW(35)
; 0000 00AF         }
; 0000 00B0     }
_0x4B:
_0x49:
_0x47:
; 0000 00B1 
; 0000 00B2     PORTC.0 = 0;
_0x45:
	CBI  0x15,0
; 0000 00B3     PORTC.1 = 0;
	CBI  0x15,1
; 0000 00B4     PORTC.2 = 0;
	CBI  0x15,2
; 0000 00B5 
; 0000 00B6     return pressedKey;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 00B7 }
; .FEND
;
;void main(void)
; 0000 00BA {
_main:
; .FSTART _main
; 0000 00BB     // Declare your local variables here
; 0000 00BC 
; 0000 00BD     // Input/Output Ports initialization
; 0000 00BE     // Port A initialization
; 0000 00BF     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00C0     DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 00C1     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00C2     PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 00C3 
; 0000 00C4     // Port B initialization
; 0000 00C5     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00C6     DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 00C7     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00C8     PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 00C9 
; 0000 00CA     // Port C initialization
; 0000 00CB     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00CC     DDRC=(1<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(135)
	OUT  0x14,R30
; 0000 00CD     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00CE     PORTC=(0<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(120)
	OUT  0x15,R30
; 0000 00CF 
; 0000 00D0     // Port D initialization
; 0000 00D1     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00D2     DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 00D3     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00D4     PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 00D5 
; 0000 00D6     // Timer/Counter 0 initialization
; 0000 00D7     // Clock source: System Clock
; 0000 00D8     // Clock value: Timer 0 Stopped
; 0000 00D9     // Mode: Normal top=0xFF
; 0000 00DA     // OC0 output: Disconnected
; 0000 00DB     TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 00DC     TCNT0=0x00;
	OUT  0x32,R30
; 0000 00DD     OCR0=0x00;
	OUT  0x3C,R30
; 0000 00DE 
; 0000 00DF     // Timer/Counter 1 initialization
; 0000 00E0     // Clock source: System Clock
; 0000 00E1     // Clock value: Timer1 Stopped
; 0000 00E2     // Mode: Normal top=0xFFFF
; 0000 00E3     // OC1A output: Disconnected
; 0000 00E4     // OC1B output: Disconnected
; 0000 00E5     // Noise Canceler: Off
; 0000 00E6     // Input Capture on Falling Edge
; 0000 00E7     // Timer1 Overflow Interrupt: Off
; 0000 00E8     // Input Capture Interrupt: Off
; 0000 00E9     // Compare A Match Interrupt: Off
; 0000 00EA     // Compare B Match Interrupt: Off
; 0000 00EB     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 00EC     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 00ED     TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00EE     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00EF     ICR1H=0x00;
	OUT  0x27,R30
; 0000 00F0     ICR1L=0x00;
	OUT  0x26,R30
; 0000 00F1     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00F2     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00F3     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00F4     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00F5 
; 0000 00F6     // Timer/Counter 2 initialization
; 0000 00F7     // Clock source: System Clock
; 0000 00F8     // Clock value: Timer2 Stopped
; 0000 00F9     // Mode: Normal top=0xFF
; 0000 00FA     // OC2 output: Disconnected
; 0000 00FB     ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00FC     TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00FD     TCNT2=0x00;
	OUT  0x24,R30
; 0000 00FE     OCR2=0x00;
	OUT  0x23,R30
; 0000 00FF 
; 0000 0100     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0101     TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0102 
; 0000 0103     // External Interrupt(s) initialization
; 0000 0104     // INT0: On
; 0000 0105     // INT0 Mode: Rising Edge
; 0000 0106     // INT1: Off
; 0000 0107     // INT2: Off
; 0000 0108     GICR|=(0<<INT1) | (1<<INT0) | (0<<INT2);
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 0109     MCUCR=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (1<<ISC00);
	LDI  R30,LOW(3)
	OUT  0x35,R30
; 0000 010A     MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 010B     GIFR=(0<<INTF1) | (1<<INTF0) | (0<<INTF2);
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 010C 
; 0000 010D     // USART initialization
; 0000 010E     // USART disabled
; 0000 010F     UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 0110 
; 0000 0111     // Analog Comparator initialization
; 0000 0112     // Analog Comparator: Off
; 0000 0113     // The Analog Comparator's positive input is
; 0000 0114     // connected to the AIN0 pin
; 0000 0115     // The Analog Comparator's negative input is
; 0000 0116     // connected to the AIN1 pin
; 0000 0117     ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0118     SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0119 
; 0000 011A     // ADC initialization
; 0000 011B     // ADC disabled
; 0000 011C     ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 011D 
; 0000 011E     // SPI initialization
; 0000 011F     // SPI disabled
; 0000 0120     SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0121 
; 0000 0122     // TWI initialization
; 0000 0123     // TWI disabled
; 0000 0124     TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0125 
; 0000 0126     // Alphanumeric LCD initialization
; 0000 0127     // Connections are specified in the
; 0000 0128     // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0129     // RS - PORTA Bit 1
; 0000 012A     // RD - PORTA Bit 2
; 0000 012B     // EN - PORTA Bit 3
; 0000 012C     // D4 - PORTA Bit 4
; 0000 012D     // D5 - PORTA Bit 5
; 0000 012E     // D6 - PORTA Bit 6
; 0000 012F     // D7 - PORTA Bit 7
; 0000 0130     // Characters/line: 16
; 0000 0131     lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0132 
; 0000 0133     // Global enable interrupts
; 0000 0134     #asm("sei")
	sei
; 0000 0135 
; 0000 0136     while (1) {
_0x53:
; 0000 0137 
; 0000 0138         switch (state) {
	MOVW R30,R4
; 0000 0139             case IDLE:
	CPI  R30,LOW(0xFFFFFFFF)
	LDI  R26,HIGH(0xFFFFFFFF)
	CPC  R31,R26
	BRNE _0x59
; 0000 013A                 break;
	RJMP _0x58
; 0000 013B             case INIT:
_0x59:
	SBIW R30,0
	BRNE _0x5A
; 0000 013C                 PORTC.7 = 0;
	CBI  0x15,7
; 0000 013D                 lcd_clear();
	RCALL _lcd_clear
; 0000 013E                 lcd_puts("user id: ");
	__POINTW2MN _0x5D,0
	RCALL SUBOPT_0x0
; 0000 013F                 lcd_gotoxy(0, 1);
; 0000 0140                 state = LOGIN_USER;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x69
; 0000 0141                 break;
; 0000 0142 
; 0000 0143             case LOGIN_PASS_INIT:
_0x5A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x5E
; 0000 0144                 lcd_clear();
	RCALL _lcd_clear
; 0000 0145                 lcd_puts("password: ");
	__POINTW2MN _0x5D,10
	RCALL SUBOPT_0x0
; 0000 0146                 lcd_gotoxy(0, 1);
; 0000 0147                 state = LOGIN_PASS;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R4,R30
; 0000 0148                 cursor = 0;
	CLR  R6
	CLR  R7
; 0000 0149                 break;
	RJMP _0x58
; 0000 014A             case ADMIN_MENU:
_0x5E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x5F
; 0000 014B                 lcd_clear();
	RCALL _lcd_clear
; 0000 014C                 lcd_puts("0 open");
	__POINTW2MN _0x5D,21
	RCALL _lcd_puts
; 0000 014D                 lcd_gotoxy(6,0);
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x1
; 0000 014E                 lcd_puts("1 add user");
	__POINTW2MN _0x5D,28
	RCALL SUBOPT_0x0
; 0000 014F                 lcd_gotoxy(0,1);
; 0000 0150                 lcd_puts("2 del user");
	__POINTW2MN _0x5D,39
	RCALL SUBOPT_0x2
; 0000 0151                 lcd_gotoxy(8,1);
; 0000 0152                 lcd_puts("3 access");
	__POINTW2MN _0x5D,50
	RCALL _lcd_puts
; 0000 0153                 state = ADMIN_CHECK;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RJMP _0x69
; 0000 0154                 break;
; 0000 0155             case ADMIN_ADD:
_0x5F:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x60
; 0000 0156                 lcd_clear();
	RCALL _lcd_clear
; 0000 0157                 lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x1
; 0000 0158                 lcd_puts("enter user id:");
	__POINTW2MN _0x5D,59
	RCALL _lcd_puts
; 0000 0159                 state = ADMIN_ADD_CHECK;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RJMP _0x69
; 0000 015A                 break;
; 0000 015B             case ADMIN_DEL:
_0x60:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x61
; 0000 015C                 lcd_clear();
	RCALL _lcd_clear
; 0000 015D                 lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x1
; 0000 015E                 lcd_puts("enter user id:");
	__POINTW2MN _0x5D,74
	RCALL _lcd_puts
; 0000 015F                 state = ADMIN_DEL_CHECK;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP _0x69
; 0000 0160                 break;
; 0000 0161             case ADMIN_CNT:
_0x61:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x62
; 0000 0162                 lcd_clear();
	RCALL _lcd_clear
; 0000 0163                 lcd_puts("0 public");
	__POINTW2MN _0x5D,89
	RCALL _lcd_puts
; 0000 0164                 lcd_gotoxy(8,0);
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x1
; 0000 0165                 lcd_puts("1 users only");
	__POINTW2MN _0x5D,98
	RCALL SUBOPT_0x0
; 0000 0166                 lcd_gotoxy(0,1);
; 0000 0167                 lcd_puts("2 noone");
	__POINTW2MN _0x5D,111
	RCALL SUBOPT_0x2
; 0000 0168                 lcd_gotoxy(8,1);
; 0000 0169                 lcd_puts("* back");
	__POINTW2MN _0x5D,119
	RCALL _lcd_puts
; 0000 016A                 state = ADMIN_CNT_CHECK;
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	RJMP _0x69
; 0000 016B                 break;
; 0000 016C             case DOOR_OPEN:
_0x62:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0x58
; 0000 016D                 PORTC.7 = 1;
	SBI  0x15,7
; 0000 016E                 state = IDLE;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x69:
	MOVW R4,R30
; 0000 016F                 break;
; 0000 0170         }
_0x58:
; 0000 0171     }
	RJMP _0x53
; 0000 0172 }
_0x66:
	RJMP _0x66
; .FEND

	.DSEG
_0x5D:
	.BYTE 0x7E
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 3
	SBI  0x1B,3
	__DELAY_USB 3
	CBI  0x1B,3
	__DELAY_USB 3
	RJMP _0x2020001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 33
	RJMP _0x2020001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x3
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x2020001
_0x2000007:
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x1B,1
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,1
	RJMP _0x2020001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,3
	SBI  0x1A,1
	SBI  0x1A,2
	CBI  0x1B,3
	CBI  0x1B,1
	CBI  0x1B,2
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x4
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 67
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2020001:
	ADIW R28,1
	RET
; .FEND

	.DSEG
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x0:
	RCALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	RCALL _lcd_puts
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 67
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x1F4
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
