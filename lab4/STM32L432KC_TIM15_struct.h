// STM32L432KC_TIM15_struct.h
// Header for TIM15 functions

/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  September 21, 2025

Purpose: 
*/

#ifndef TIM15_STRUCT_H
#define TIM15_STRUCT_H

#include <stdint.h>

///////////////////////////////////////////////////////////////////////////////
// Definitions
///////////////////////////////////////////////////////////////////////////////

#define __IO volatile
#define PRESCALER_VALUE_3000 3000

// Base addresses
#define TIM15_BASE (0x40014000UL) // base address of TIM15

typedef struct
{
  __IO uint32_t CR1;          /*!< TIM15 control register 1,                    Address offset: 0x00 */
  __IO uint32_t CR2;          /*!< TIM15 control register 2,                    Address offset: 0x04 */
  __IO uint32_t SMCR;         /*!< TIM15 sl*ve mode control register,           Address offset: 0x08 */
  __IO uint32_t DIER;         /*!< TIM15 DMA/interrupt enable register,         Address offset: 0x0C */
  __IO uint32_t SR;           /*!< TIM15 status register,                       Address offset: 0x10 */
  __IO uint32_t EGR;          /*!< TIM15 event generation register,             Address offset: 0x14 */
  __IO uint32_t CCMR1_output; /*!< TIM15 capture/compare mode register 1,       Address offset: 0x18 */
  __IO uint32_t CCMR1_input;  /*!< TIM15 capture/compare mode register 1,       Address offset: 0x1C */
  __IO uint32_t CCER;         /*!< TIM15 capture/compare enable register,       Address offset: 0x20 */
  __IO uint32_t CNT;          /*!< TIM15 counter,                               Address offset: 0x24 */
  __IO uint32_t PSC;          /*!< TIM15 prescaler,                             Address offset: 0x28 */
  __IO uint32_t ARR;          /*!< TIM15 auto-reload register,                  Address offset: 0x2C */
  __IO uint32_t RCR;          /*!< TIM15 repetition counter register,           Address offset: 0x30 */
  __IO uint32_t CCR1;         /*!< TIM15 capture/compare register 1,            Address offset: 0x34 */
  __IO uint32_t CCR2;         /*!< TIM15 capture/compare register 2,            Address offset: 0x38 */
       uint32_t RESERVED0;    /*!< Reserved,                                    Address offset: 0x3C */
       uint32_t RESERVED1;    /*!< Reserved,                                    Address offset: 0x40 */
  __IO uint32_t BDTR;         /*!< TIM15 break and dead-time register,          Address offset: 0x44 */
  __IO uint32_t DCR;          /*!< TIM15 DMA control register,                  Address offset: 0x48 */
  __IO uint32_t DMAR;         /*!< TIM15 DMA address for full transfer,         Address offset: 0x4C */
  __IO uint32_t OR1_1;        /*!< TIM15 option register 1,                     Address offset: 0x50 */
       uint32_t RESERVED2;    /*!< Reserved,                                    Address offset: 0x54 */
       uint32_t RESERVED3;    /*!< Reserved,                                    Address offset: 0x58 */
       uint32_t RESERVED4;    /*!< Reserved,                                    Address offset: 0x5C */
  __IO uint32_t OR2_1;        /*!< TIM15 option register 2,                     Address offset: 0x60 */
} TIM15_TypeDef;

#define TIM15 ((TIM15_TypeDef *) TIM15_BASE)

///////////////////////////////////////////////////////////////////////////////
// Function prototypes
///////////////////////////////////////////////////////////////////////////////

void PWM_duration_initialization(void);
void PWM_duration(const int note_duration);

#endif

