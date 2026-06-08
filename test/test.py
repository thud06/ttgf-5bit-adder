import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def test_5bit_adder_exhaustive(dut):
    """Exhaustively test the 5-bit combinational adder."""

    dut.ena.value = 1

    for a in range(32):
        for b in range(32):
            for cin in range(2):
                dut.ui_in.value = (cin << 5) | a
                dut.uio_in.value = b

                await Timer(1, units="ns")

                expected_sum = a + b + cin
                expected_low = expected_sum & 0x1F
                expected_carry = (expected_sum >> 5) & 0x1

                a_sign = (a >> 4) & 1
                b_sign = (b >> 4) & 1
                result_sign = (expected_low >> 4) & 1
                expected_overflow = int((a_sign == b_sign) and (result_sign != a_sign))

                expected_zero = int(expected_low == 0)

                expected_uo = (
                    expected_low
                    | (expected_carry << 5)
                    | (expected_overflow << 6)
                    | (expected_zero << 7)
                )

                actual_uo = int(dut.uo_out.value)

                assert actual_uo == expected_uo, (
                    f"A={a:02d} B={b:02d} cin={cin} "
                    f"expected uo_out=0x{expected_uo:02x}, got 0x{actual_uo:02x}"
                )
