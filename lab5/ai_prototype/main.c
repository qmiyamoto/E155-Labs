#include "stm32l4xx_hal.h"

volatile int32_t encoder_count = 0;

void Encoder_Init(void) {
    __HAL_RCC_GPIOA_CLK_ENABLE();

    GPIO_InitTypeDef GPIO_InitStruct = {0};

    GPIO_InitStruct.Pin = GPIO_PIN_0 | GPIO_PIN_1;
    GPIO_InitStruct.Mode = GPIO_MODE_IT_RISING_FALLING;  // both edges
    GPIO_InitStruct.Pull = GPIO_PULLUP;                  // enable pull-ups
    HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

    // Enable and set EXTI interrupts priority
    HAL_NVIC_SetPriority(EXTI0_IRQn, 2, 0);
    HAL_NVIC_EnableIRQ(EXTI0_IRQn);

    HAL_NVIC_SetPriority(EXTI1_IRQn, 2, 0);
    HAL_NVIC_EnableIRQ(EXTI1_IRQn);
}

void EXTI0_IRQHandler(void) {
    if (EXTI->PR1 & EXTI_PR1_PIF0) {
        EXTI->PR1 = EXTI_PR1_PIF0; // clear interrupt flag

        uint8_t A = (GPIOA->IDR & GPIO_IDR_ID0) ? 1 : 0;
        uint8_t B = (GPIOA->IDR & GPIO_IDR_ID1) ? 1 : 0;

        if (A == B)
            encoder_count++;
        else
            encoder_count--;
    }
}

void EXTI1_IRQHandler(void) {
    if (EXTI->PR1 & EXTI_PR1_PIF1) {
        EXTI->PR1 = EXTI_PR1_PIF1;

        uint8_t A = (GPIOA->IDR & GPIO_IDR_ID0) ? 1 : 0;
        uint8_t B = (GPIOA->IDR & GPIO_IDR_ID1) ? 1 : 0;

        if (A != B)
            encoder_count++;
        else
            encoder_count--;
    }
}

float angle_deg = (encoder_count * 360.0f) / (4.0f * pulses_per_rev);