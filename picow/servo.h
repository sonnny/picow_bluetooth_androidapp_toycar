// servo.h

#include "pico/stdlib.h"

struct servo_type{
  uint gpio;
  uint slice;
  uint chan;
  uint speed;
  uint resolution;
  bool on;
  bool invert;};

void servoInit(struct servo_type *s, uint, bool);
void servoOn(struct servo_type *s);
void servoPosition(struct servo_type *s, uint); 
