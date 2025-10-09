/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  October 4, 2025

Purpose: To configure the timer to delay for variable periods of time.
*/


#include "STM32L432KC.h"


// initializes the timer
void timer_initialization(void)
{

  // divides the system clock input by a prescaler to generate a new clock signal for the timer's internal counter
  // (f_cnt_clk = f_psc_clk / (PSC[15:0] + 1))
  TIM16 -> PSC = 3000;

  // pushes the register updates
  // additionally, reinitializes the counter and generates an update of the registers
  TIM16 -> EGR |= (1 << 0);

  // enables the counter
  TIM16 -> CR1 |= (1 << 0);

  // resets the counter
  TIM16 -> CNT = 0;
  
}


// provides a sampling period of variable duration
// (note: this function only takes inputs in ms)
void sampling_period(int duration)
{
  
  // calculates the counter clock frequency when given an 80 MHz system clock as input
  int counter_clock_frequency = 80000000 / (3000 + 1);
  
  // sets the maximum counter value as appropriate
  // (ARR[15:0] = (duration / 1000) * counter_clock_frequency)
  TIM16 -> ARR = duration * (counter_clock_frequency / 1000);

  // pushes the register updates
  // additionally, reinitializes the counter and generates an update of the registers
  TIM16 -> EGR |= (1 << 0);

  // clears the Update flag and updates the counter
  TIM16 -> SR &= ~(1 << 0);

  // resets the counter
  TIM16 -> CNT = 0;

  // waits until the Update flag goes high and signals that the counter has hit the maximum value
  while (!((TIM16 -> SR) & 1));
	
}