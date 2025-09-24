/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  September 21, 2025

Purpose: To produce the desired note frequencies by generating a PWM wave with TIM16 (timer 16).
*/


#include "TIM16_struct.h"


// initializes the PWM wave-generation function
void PWM_generation_initialization(void) 
{
  
  // divides the system clock input by a prescaler to generate a new clock signal for the timer's internal counter
  // (PSC[15:0] = PRESCALER_VALUE)
  TIM16 -> PSC = PRESCALER_VALUE_16;                                                                        // f_cnt_clk = f_psc_clk / (PSC[15:0] + 1)

  // allows the PWM wave to output properly
  // (OC1M[6:4] = 110, OC1PE = 1, CC1P = 0, CC1E = 1)
  TIM16 -> CCMR1_output |= ((1 << 6) | (1 << 5)); TIM16 -> CCMR1_output &= ~(1 << 4); // activates the output channel when CNT < CCR1
  TIM16 -> CCER &= ~(1 << 1); TIM16 -> CCER |= (1 << 0);                                                    // makes the output channel active high
  TIM16 -> CCMR1_output |= (1 << 3);                                                                        // enables preloading to CCR1
  
  // enables output
  // (MOE = 1)
  TIM16 -> BDTR |= (1 << 15);                                                                               // enables the main outputs if their respective enable bits are set
  
  // pushes the register updates
  // (UG = 1)
  TIM16 -> EGR |= (1 << 0);                                                                                 // reinitializes the counter and generates an update of the registers
  
  // enables the counter
  // (CEN = 1, UIFREMAP = 0)
  TIM16 -> CR1 |= (1 << 0); TIM16 -> CR1 &= ~(1 << 11);                                                     // doesn't allow UIF status bit remapping when counting
	
}


// generates the PWM wave
void PWM_generation(int note_frequency) 
{
  
  // calculates the counter clock frequency when given an 80 MHz system clock as input
  int counter_clock_frequency = 80000000 / (PRESCALER_VALUE_16 + 1);
  
  // sets the maximum counter value as appropriate
  // (ARR[15:0] = (counter_clock_frequency / note_frequency) - 1)
  TIM16 -> ARR = (note_frequency > 0) ? ((counter_clock_frequency / note_frequency) - 1) : 0;         // zeroes out ARR when the frequency is zero

  // sets the duty cycle as appropriate
  // (CCR1[15:0] = ((counter_clock_frequency / note_frequency) - 1) / 2)
  TIM16 -> CCR1 = (note_frequency > 0) ? (((counter_clock_frequency / note_frequency) - 1) / 2) : 0;  // zeroes out the duty cycle when the frequency is zero

  // pushes the register updates
  // (UG = 1)
  TIM16 -> EGR |= (1 << 0);                                                                           // reinitializes the counter and generates an update of the registers

  // resets the counter
  // (CNT[15:0] = 0)
  TIM16 -> CNT = 0;                                                                                   // manually forces CNT to zero

}