/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  October 3, 2025

Purpose: To determine the angular velocity of a given motor (with a quadrature encoder).
*/


#include "STM32L432KC.h"
#include "MCU_configuration.h"
#include "timer_delay.h"
#include "interrupt_configuration.h"
#include <stdio.h>


// determines the angular velocity of a given motor (with a quadrature encoder)
int main(void)
{

  // sets up the MCU with all basic functionalities
  MCU_configuration();

  // initializes TIM16
  timer_initialization();

  // sets the sampling period to be 1 s
  // (note: this function only takes inputs in ms)
  sampling_period(1000);

  // configures both the desired interrupts and their respective handler functions
  interrupt_configuration();

  // loops infinitely through all of the above
  while(1);
    // {togglePin(PA6); printf("Angular Velocity: %f revolutions/second\n", angular_velocity);}; // toggles PA6 to perform manual polling

}


// provides the means to use the "printf" function in TIM1_UP_TIM16_IRQHandler 
int _write(int file, char *ptr, int len)
{
  
  for (int i = 0; i < len; i++)
  {
    ITM_SendChar((*ptr++));
  }

  return len;

}