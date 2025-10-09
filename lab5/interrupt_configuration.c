/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  October 4, 2025

Purpose: To enable interrupts for the MCU and tell it how to handle them.
*/


#include "STM32L432KC.h"
#include <stdio.h>


#define CLOCKWISE             1
#define COUNTERCLOCKWISE     -1
#define PULSE_PER_REVOLUTION  408


volatile float direction        = 0;
volatile float pulse_per_second = 0;
volatile float angular_velocity = 0;


// initializes all interrupts
void interrupt_configuration(void)
{

  // enables the system configuration controller
  RCC -> APB2ENR |= RCC_APB2ENR_SYSCFGEN;

  // selects pins PA9 and PA10 as source inputs for external interrupts
  SYSCFG -> EXTICR[2] |= _VAL2FLD(SYSCFG_EXTICR3_EXTI9,  0b000);
  SYSCFG -> EXTICR[2] |= _VAL2FLD(SYSCFG_EXTICR3_EXTI10, 0b000);

  // enables global interrupts
  __enable_irq();

  // unmasks interrupt requests from lines 9 and 10
  EXTI -> IMR1 |= _VAL2FLD(EXTI_IMR1_IM9,  1);
  EXTI -> IMR1 |= _VAL2FLD(EXTI_IMR1_IM10, 1);

  // configures the external interrupts to trigger on a pulse's rising edge
  EXTI -> RTSR1 |= _VAL2FLD(EXTI_RTSR1_RT9,  1);
  EXTI -> RTSR1 |= _VAL2FLD(EXTI_RTSR1_RT10, 1);

  // configures the external interrupts to trigger on a pulse's falling edge
  EXTI -> FTSR1 |= _VAL2FLD(EXTI_FTSR1_FT9,  1);
  EXTI -> FTSR1 |= _VAL2FLD(EXTI_FTSR1_FT10, 1);

  // allows TIM16 to also traffic in interrupts
  TIM16 -> DIER |= _VAL2FLD(TIM_DIER_UIE, 1);
  TIM16 -> SR   &= ~(1 << 0);

  // enables interrupt generation in the desired peripherals (PA9, PA10, and TIM16) with the NVIC
  __NVIC_EnableIRQ(EXTI9_5_IRQn);
  __NVIC_EnableIRQ(EXTI15_10_IRQn);
  __NVIC_EnableIRQ(TIM1_UP_TIM16_IRQn);

  // sets the priority level for each interrupt
  __NVIC_SetPriority(EXTI9_5_IRQn,       1);
  __NVIC_SetPriority(EXTI15_10_IRQn,     2);
  __NVIC_SetPriority(TIM1_UP_TIM16_IRQn, 3);

}


// handles any interrupts from PA9
// triggers on every rising and falling edge
// increments the pulse_per_second counter and sets direction
void EXTI9_5_IRQHandler(void)
{

  // checks if there is an interrupt pending
  if ((EXTI -> PR1) & (1 << 9))
  {
    // clears the pending status
    EXTI -> PR1 |= _VAL2FLD(EXTI_PR1_PIF9, 1);

    // determines which edge of A the interrupt was triggered on and the current state of B
    int posedge_A_high_B = (digitalRead(PA9)  & digitalRead(PA10));   // signifies counterclockwise rotation
    int negedge_A_low_B  = (~digitalRead(PA9) & ~digitalRead(PA10));  // signifies counterclockwise rotation
    int posedge_A_low_B  = (digitalRead(PA9)  & ~digitalRead(PA10));  // signifies clockwise rotation
    int negedge_A_high_B = (~digitalRead(PA9) & digitalRead(PA10));   // signifies clockwise rotation

    // determines the current direction of rotation based on the values of the above
    direction = ((posedge_A_low_B | negedge_A_high_B) ? CLOCKWISE : ((posedge_A_high_B | negedge_A_low_B) ? COUNTERCLOCKWISE : 0));

    // keeps a running total of how many times an interrupt has been triggered during the sampling period
    pulse_per_second += direction;

    // toggles PA6 to perform manual polling
    // if (posedge_A_high_B | posedge_A_low_B) {togglePin(PA6);}

  }

}


// handles any interrupts from PA10
// triggers on every rising and falling edge
// increments the pulse_per_second counter and sets direction
void EXTI15_10_IRQHandler(void)
{

  // checks if there is an interrupt pending
  if ((EXTI -> PR1) & (1 << 10))
  {
    // clears the pending status 
    EXTI -> PR1 |= _VAL2FLD(EXTI_PR1_PIF10, 1);

     // determines which edge of B the interrupt was triggered on and the current state of A
    int posedge_A_high_B = (digitalRead(PA9)  & digitalRead(PA10));   // signifies clockwise rotation
    int negedge_A_low_B  = (~digitalRead(PA9) & ~digitalRead(PA10));  // signifies clockwise rotation
    int posedge_A_low_B  = (digitalRead(PA9)  & ~digitalRead(PA10));  // signifies counterclockwise rotation
    int negedge_A_high_B = (~digitalRead(PA9) & digitalRead(PA10));   // signifies counterclockwise rotation

    // determines the current direction of rotation based on the values of the above
    direction = ((posedge_A_low_B | negedge_A_high_B) ? COUNTERCLOCKWISE : ((posedge_A_high_B | negedge_A_low_B) ? CLOCKWISE : 0));

    // keeps a running total of how many times an interrupt has been triggered during the sampling period
    pulse_per_second += direction;
  }

}


// handles any interrupts from TIM16
// triggers when the timer is done counting
// computes and prints the average angular velocity and direction of rotation
void TIM1_UP_TIM16_IRQHandler(void)
{

  // checks if UIF has been set
  if ((TIM16 -> SR) & (1 << 0))
  {
    // resets UIF
    TIM16 -> SR &= ~(1 << 0);

    // computes a running average of the angular velocity
    // (note: this takes into account the fact that pulse_per_second is increased every time *any* edge is detected)
    // (in other words: pulse_per_second is artifically increased by a factor of four, which must then be dealt with accordingly)
    angular_velocity = (pulse_per_second / 4) / PULSE_PER_REVOLUTION;

    // prints out the overall angular velocity in the debug terminal
    printf("Angular Velocity: %.1f revolutions/second\n", angular_velocity);

    // prints out the direction of rotation
    if      (angular_velocity == 0) {printf("Direction: N/A\n");}
    else if (angular_velocity > 0)  {printf("Direction: Clockwise\n");}
    else if (angular_velocity < 0)  {printf("Direction: Counterclockwise\n");}
    else                            {printf("Direction: N/A\n");}

    // resets the pulse-per-second count
    pulse_per_second = 0;

    // resets the timer count
    TIM16 -> CNT = 0;
  }

}