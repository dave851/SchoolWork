/*********************************************************************/
/* Arithmetic                                        								 */
/* 96-bit addiotn with mixed C and ASM                               */
/* Name: David Desrochers                                            */
/* Date:   4/29/2014                                                 */
/* Class:  CMPE 250                                                  */
/* Section:  Teusday 11am													                   */
/* ----------------------------------------------------------------- */
/* Template:  R. W. Melton                                           */
/*            April 22, 2014                                         */
/*********************************************************************/
#include "CmixedASMArith.h"  



/* C functions go here */

//Gets three word number from terminal
int GetHexInt96U(Int96 *number){
	char string[25];
	char tophalf;
	int i;
	int j = 0;
	GetString(string);
	//For ever charater in string
	for( i = 23; i >= 0; i--){
		//Check range to determine value
	  if ((string[i] >= '0') && (string[i] <= '9')) {
			//Every other loop, store to top half of byte and increment byte index
			if (i%2 != 0){
				number -> Byte[j] = string[i] - '0';
			}
			else{
				tophalf = ((string[i] - '0') << 4);
				number -> Byte[j] = tophalf | (number -> Byte[j]);
				j++;
			}
		}
		else if ((string[i] >= 'a') && (string[i] <= 'f')){
			if (i%2 != 0){
				number -> Byte[j] = string[i] - 'a' + 10;
			}
			else{
				tophalf = ((string[i] - 'a' + 10) << 4);
				number -> Byte[j] = tophalf | (number -> Byte[j]);
				j++;
			}
		}
		else if ((string[i] >= 'A') && (string[i] <= 'F')){
			if (i%2 != 0){
				number -> Byte[j] = string[i] - 'A' + 10;
			}
			else{
				tophalf = ((string[i] - 'A' + 10) << 4);
				number -> Byte[j] = tophalf | (number -> Byte[j]);
				j++;
			}
		}
		//If not in range, invalid number
		else {
			return 1;
		}
	}
	return 0;
}

//Writes three word number to screen
void PutHexInt96U(Int96 *number){
	int i;
	PutString("0x");
	for( i = 2; i >= 0; i--){
		PutNumHex(number -> Word[i]);
	}
}


//Prompts user for two hex numbers to add, and prints sum
//if valid, otherwise prints error and reprompts for
//first number
int main (void) {
	Int96 number1;
	Int96 number2;
	Int96 sum;
	int valid;
  
  SystemInit ();
  __asm("CPSID   I");  /* mask interrupts */
  SetClock48MHz ();
  SerialDriverInit ();
  __asm("CPSIE   I");  /* unmask interrupts */

  /* main program code goes here */
	for(;;){
		PutString(" Enter First Hex number: 0x");
		valid = GetHexInt96U(&number1);
		PutString("\n\r");
		//If not valid restart loop
		if (valid != 0){
			PutString("Invalid Number--try again: 0xvvvvvvvvvvvvvvvvvvvvvvvv\n\r");
			continue;
		}
		PutString("Enter Hex number to Add: 0x");
		valid = GetHexInt96U(&number2);
		PutString("\n\r");
		//If not valid restart loop
		if (valid != 0){
			PutString("Invalid Number--try again: 0xvvvvvvvvvvvvvvvvvvvvvvvv\n\r");
			continue;
		}
		valid = AddInt96U(&sum, &number1, &number2);
		//If result not valid restart loop
		if (valid != 0){
			PutString("                    Sum: OVERFLOW\n\r");
			continue;
		}
		PutString("                    Sum: ");
		PutHexInt96U(&sum);
		PutString("\n\r");
	}
  return (0);
} /* main */