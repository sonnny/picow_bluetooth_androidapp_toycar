

#include "pico/stdlib.h"
#include "pico/multicore.h"
#include "hardware/gpio.h"
#include "ble.h"
#include "motor.h"
#include "servo.h"

// front and rear motor pin assignment
#define FRONT_PWM  4
#define FRONT_DIR  5
#define REAR_PWM   2
#define REAR_DIR   3

#define STEERING   0x73
#define MOTOR      0x64
#define STOP       0x68
#define BACK       0x72
#define LED        0x6c
#define CENTER_STEERING 58   // adjusted for my servo, ymmv

struct bt_type data;
struct motor_type front;
struct motor_type rear;
struct servo_type servo;

uint position; // steering position
uint dir;

int main(void) {
  stdio_init_all();
  sleep_ms(1000);
  multicore_launch_core1(bt_main);
  sleep_ms(1000);
  
  position = CENTER_STEERING;
  
  servoInit(&servo, 15, false);
  servoOn(&servo);
  servoPosition(&servo, position);        //center servo
  motorInit(&front, FRONT_PWM, FRONT_DIR, 2000); // 2khz frequency
  motorInit(&rear,  REAR_PWM,  REAR_DIR,  2000);
  motorOn(&rear);
  motorOn(&front);
  motorMove(&front, 0, 1); // stop motor zero speed
  motorMove(&rear, 0, 1);  // stop motor zero speed
  
  for(;;){ // loop
	  
	sleep_ms(100);
	bt_get_latest(&data);
	
	switch(data.code){
	
	  case STEERING: switch(data.data){
		           case 0x00: position = 20; break;
		           case 0x01: position = 40; break;
		           case 0x02: position = CENTER_STEERING; break;
		           case 0x03: position = 80; break;
		           case 0x04: position = 95; break;	  
	                 }
	                 servoPosition(&servo, position);
	                 break;
	                 
	  case MOTOR: motorMove(&front, data.data * 10, 0);
	              motorMove(&rear,  data.data * 10, 0);
	              break;
	              
	  case STOP: motorMove(&front, 0, 0);
	             motorMove(&rear,  0, 0);
	             break;
	             
	  case BACK: motorMove(&front, 10, 1);
	             motorMove(&rear,  10, 1);
	             break;
	             
	  case LED: switch(data.data){
	              case 0x6f: hal_led_on();  break;
	              case 0x66: hal_led_off(); break;
	            }
	            break;
	}} return 0;}

