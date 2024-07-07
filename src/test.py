import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

@cocotb.test()
async def test_puf_cipher(dut):
    clock = Clock(dut.clk, 10, units="us")
    cocotb.fork(clock.start())

    dut.rst.value = 1
    await ClockCycles(dut.clk, 10)
    dut.rst.value = 0

    for challenge in range(16):
        dut.challenge.value = challenge
        await ClockCycles(dut.clk, 100)
        print(f"Challenge: {challenge}, Encoded char: {dut.encoded_char.value}")
