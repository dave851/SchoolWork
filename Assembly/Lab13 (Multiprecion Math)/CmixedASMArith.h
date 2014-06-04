/*********************************************************************/
/* Lab Exercise Thireen header file                                  */
/* Tests mixed C and assembly language programming to add 96-bit     */
/* unsigned numbers.  Prompts user to enter two numbers in hex       */
/* format to add, computes the result, and prints it.                */
/* Name:  R. W. Melton                                               */
/* Date:  April 22, 2014                                             */
/* Class:  CMPE 250                                                  */
/* Section:  All sections                                            */
/*********************************************************************/
typedef int Int32;
typedef char Int8;

typedef union {
  Int32 Word[3];
  Int8  Byte[12];
} Int96;

/* assembly language subroutines */
int AddInt96U (Int96 *Sum, Int96 *Augend, Int96 *Addend);
void PutNumHex(int number);
char *GetString ();
char *PutString (char String[]);
void SerialDriverInit (void);
void SetClock48MHz (void);
void SystemInit (void);

/* C subroutines */
int GetHexInt96U (Int96 *Number);
void PutHexInt96U (Int96 *Number);
int main (void);
int Reset_Handler (void) __attribute__((alias("main")));