/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  October 3, 2025

Purpose: To set up the MCU as desired.
*/


#include "STM32L432KC.h"


// enables all basic MCU peripherals
void MCU_configuration(void)
{

  // configures the system clock
  configureFlash();
  configureClock();

  // enables GPIO port A
  gpioEnable(GPIO_PORT_A);
  
  // instructs the MCU to take PA9 and PA10 as inputs
  pinMode(PA9,  GPIO_INPUT);
  pinMode(PA10, GPIO_INPUT);

  // configures PA6 as an output to perform manual polling
  pinMode(PA6, GPIO_OUTPUT);

  // provides PA9 and PA10 with internal pull-down resistors
  GPIOA -> PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD9,  0b10);
  GPIOA -> PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD10, 0b10);

  // enables TIM16
  RCC -> APB2ENR |= RCC_APB2ENR_TIM16EN;

}