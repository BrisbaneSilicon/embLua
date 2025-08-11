--[[
        Demonstrate SPI output by counting on a
        SSEG display (Duinotech display).

        NOTE: stray, beginning of line '--' comments improve
        code readability while still allowing user to copy-paste
        the entire program into the REPL.

        NOTE: Depending upon 'sseg_regs_uploaded', this program
        requires the program 'sseg_regs.lua' to be present on Lumorphix.
--]]


main_program_name = "SPI OUT Example"

sseg_regs_uploaded = false
    -- NOTE: change to 'true' if 'sseg_regs.lua' has been
    -- uploaded to Lumorphix


-- Dependencies

import("reset_all_io_type_cfg")
import("set_io_type_cfg")
import("spi_tx_int")
import("msleep")

import("string", "format")

if sseg_regs_uploaded then
    digit_regs, mode_regs = run_program("sseg_regs.lua")
else
    digit_regs = {}
    digit_regs[1] = 0x01
    digit_regs[2] = 0x02
    digit_regs[3] = 0x03
    digit_regs[4] = 0x04
    digit_regs[5] = 0x05
    digit_regs[6] = 0x06
    digit_regs[7] = 0x07
    digit_regs[8] = 0x08

    mode_regs = {}
    mode_regs["REG_DECODE_MODE_CTRL"]       = 0x09
    mode_regs["REG_INTENSITY_CTRL"]         = 0x0A
    mode_regs["REG_SCAN_LIMIT_CTRL"]        = 0x0B
    mode_regs["REG_OPERATION_MODE_CTRL"]    = 0x0C
    mode_regs["REG_DISPLAY_TEST_MODE_CTRL"] = 0x0F
end



-- SSEG register values

DISPLAY_TEST_MODE_OFF           = 0x00
DISPLAY_NORMAL_OPERATION_MODE   = 0x01
DISPLAY_DECODE_MODE_CODE_B      = 0xFF
DISPLAY_SCAN_ALL_DIGITS         = 0x07
DISPLAY_INTENSITY_LOW           = 0x03


-- Program configuration

SPI_OUT_PIN = 1

LOOP_COUNT = 100
LOOP_DURATION_MS = 50


-- Helper functions

function spi_cmnd (register, value)
    return (register << 8) | value
end


-- Main program begin

print("Program begin: "..main_program_name)


-- Initialise PINS

print("Initialise PINs")

reset_all_io_type_cfg()
set_io_type_cfg(SPI_OUT_PIN, SPI_OUT)

msleep(500)


-- Initialise SSEG

print("Initialise SSEG")

cmnds = {}
cmnds[1] = spi_cmnd(mode_regs["REG_DISPLAY_TEST_MODE_CTRL"], DISPLAY_TEST_MODE_OFF)
cmnds[2] = spi_cmnd(mode_regs["REG_OPERATION_MODE_CTRL"], DISPLAY_NORMAL_OPERATION_MODE)
cmnds[3] = spi_cmnd(mode_regs["REG_DECODE_MODE_CTRL"], DISPLAY_DECODE_MODE_CODE_B)
cmnds[4] = spi_cmnd(mode_regs["REG_SCAN_LIMIT_CTRL"], DISPLAY_SCAN_ALL_DIGITS)
cmnds[5] = spi_cmnd(mode_regs["REG_INTENSITY_CTRL"], DISPLAY_INTENSITY_LOW)

for i=1,#cmnds do
    print("SPI CMD "..i..": 0x"..string.format("%.4x", cmnds[i]))
--
    spi_tx_int(SPI_OUT_PIN, cmnds[i])
    msleep(50)
end

msleep(500)


-- Perform counting loop

print("Perform counting loop")

target_digit = 1
target_digit_value = 0
for i = 1, LOOP_COUNT do
    spi_tx_int(SPI_OUT_PIN, spi_cmnd(digit_regs[target_digit], target_digit_value))
--
    msleep(LOOP_DURATION_MS);
--
    target_digit = target_digit + 1
    if target_digit > #digit_regs then
        target_digit = 1
    end
--
    target_digit_value = target_digit_value + 1
    if target_digit_value > 9 then
        target_digit_value = 0
    end
end


print("Program end: "..main_program_name)