--[[
        SSEG register definiton for Duinotech display.
        See MAX7219/MAX7221 "Serially Interfaced, 8-Digit
        LED Display Drivers" document.

        https://www.analog.com/media/en/technical-documentation/
        data-sheets/MAX7219-MAX7221.pdf.

        NOTE: variables are declared as 'local' to ensure they
        do not consume memory after the program exits...
--]]

-- SSEG registers

local digit_regs = {}
digit_regs[1] = 0x01
digit_regs[2] = 0x02
digit_regs[3] = 0x03
digit_regs[4] = 0x04
digit_regs[5] = 0x05
digit_regs[6] = 0x06
digit_regs[7] = 0x07
digit_regs[8] = 0x08

local mode_regs = {}
mode_regs["REG_DECODE_MODE_CTRL"]       = 0x09
mode_regs["REG_INTENSITY_CTRL"]         = 0x0A
mode_regs["REG_SCAN_LIMIT_CTRL"]        = 0x0B
mode_regs["REG_OPERATION_MODE_CTRL"]    = 0x0C
mode_regs["REG_DISPLAY_TEST_MODE_CTRL"] = 0x0F

return digit_regs, mode_regs