# mkdir build
# cd build
# cmake ..
# make

# sudo openocd
#   -f interface/cmsis-dap.cfg
#   -f target/rp2040.cfg
#   -c "adapter speed 5000"
#   -c "program jeep.elf verify reset exit"

cmake_minimum_required(VERSION 3.12)
set(PICO_SDK_PATH "/home/sonny/pico/pico-sdk")
set(PICO_SDK_POST_LIST_DIRS "/home/sonny/pico/pico-extras")
set(PICO_BOARD "pico_w")

include("${PICO_SDK_PATH}/external/pico_sdk_import.cmake")
include("${PICO_SDK_POST_LIST_DIRS}/external/pico_extras_import.cmake")

project(jeep C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
pico_sdk_init()

add_executable(jeep main.c motor.c servo.c ble.c)
target_link_libraries(jeep 
  pico_stdlib
  hardware_pwm
  hardware_gpio
  pico_btstack_ble
  pico_btstack_cyw43
  pico_btstack_classic
  pico_cyw43_arch_none
  pico_multicore)

target_include_directories(jeep PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}
    )
pico_btstack_make_gatt_header(jeep PRIVATE "${CMAKE_CURRENT_LIST_DIR}/mygatt.gatt")
  
pico_add_extra_outputs(jeep)
