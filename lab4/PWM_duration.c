/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  September 21, 2025

Purpose: To prolong the notes for a desired duration using TIM15 (timer 15).
*/


#include "STM32L432KC_TIM15_struct.h"


// initializes the note-prolonging function
void PWM_duration_initialization(void)
{

  // divides the system clock input by a prescaler to generate a new clock signal for the timer's internal counter
  // (PSC[15:0] = PRESCALER_VALUE)
  TIM15 -> PSC = PRESCALER_VALUE_3000;                            // f_cnt_clk = f_psc_clk / (PSC[15:0] + 1)

  // sets the clock input to be the system clock (as opposed to another timer)
  // (SMS[3:0] = 0000)
  TIM15 -> SMCR &= ~((1 << 16) | (1 << 2) | (1 << 1) | (1 << 0)); // disables sl*ve mode
  
  // pushes the register updates
  // (UG = 1)
  TIM15 -> EGR |= (1 << 0);                                       // reinitializes the counter and generates an update of the registers

  // enables the counter
  // (CEN = 1, UIFREMAP = 0)
  TIM15 -> CR1 |= (1 << 0); TIM15 -> CR1 &= ~(1 << 11);           // doesn't allow UIF status bit remapping when counting	

  // resets the counter
  // (CNT[15:0] = 0)
  TIM15 -> CNT = 0;                                               // manually forces CNT to zero
  
}


// prolongs the note
void PWM_duration(int note_duration)
{
  
  // calculates the counter clock frequency when given an 80 MHz system clock as input
  int counter_clock_frequency = 80000000 / (PRESCALER_VALUE_3000 + 1);
  
  // sets the maximum counter value as appropriate
  // (ARR[15:0] = (note_duration / 1000) * counter_clock_frequency)
  TIM15 -> ARR = note_duration * (counter_clock_frequency / 1000);  // converts ms and Hz into an actual counter value

  // pushes the register updates
  // (UG = 1)
  TIM15 -> EGR |= (1 << 0);                                         // reinitializes the counter and generates an update of the registers

  // updates the counter
  // (UIF = 0)
  TIM15 -> SR &= ~(1 << 0);                                         // clears the Update flag

  // resets the counter
  // (CNT[15:0] = 0)
  TIM15 -> CNT = 0;                                                 // manually forces CNT to zero

  // waits until the Update flag goes high and signals that the counter has hit the maximum value
  while (!((TIM15 -> SR) & 1));
	
}