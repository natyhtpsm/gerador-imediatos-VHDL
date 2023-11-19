library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity genImm32_tb is
end entity genImm32_tb;

architecture tb of genImm32_tb is
    component genImm32 is
        port (
            instr: in std_logic_vector(31 downto 0);
            imm32: out signed(31 downto 0)
        );
    end component genImm32;

    signal instr_in: std_logic_vector(31 downto 0);
    signal imm32_out: signed(31 downto 0);

begin
    DUT: genImm32 port map(instr_in, imm32_out);

    process
    begin
        -- Teste para instrução R-type
        instr_in <= x"000002b3"; -- add t0, zero, zero
        wait for 1 ns;
        assert (imm32_out = X"00000000") report "R-type instruction failed" severity error;

        -- Teste para instrução I-type0
        instr_in <= x"01002283"; -- lw t0, 16(zero)
        wait for 1 ns;
        assert (imm32_out = X"00000010") report "I-type instruction failed" severity error;
       -- Teste para instrução I-type1
       instr_in <= x"f9c00313";
        wait for 1 ns;
        assert (imm32_out = X"FFFFFF9C") report "I-type1 (addi, negative immediate) instruction failed" severity error;
        -- Teste para instrução I-type1
        instr_in <= x"fff2c293";
        wait for 1 ns;
        assert (imm32_out = X"FFFFFFFF") report "I-type1 (xori) instruction failed" severity error;
        -- Teste para instrução I-type1
        instr_in <= x"16200313";
        wait for 1 ns;
        assert (imm32_out = X"00000162") report "I-type1 (addi) instruction failed" severity error;
        -- Teste para instrução I-type2
        instr_in <= x"01800067";
        wait for 1 ns;
        assert (imm32_out = X"00000018") report "I-type2 instruction failed" severity error;
        --Teste I-type*
        instr_in <= x "40a3d313";
        wait for 1 ns;
        assert (imm32_out = X"0000000A") report "I-type* failed" severity error;
        
        -- Teste para U-type
        instr_in <= x"00002437";
        wait for 1 ns;
        assert (imm32_out = X"00002000") report "U-type instruction failed" severity error;
        
        -- Teste para instrução S-type
        instr_in <= x"02542e23"; -- sw t0, 60(s0)
        wait for 1 ns;
        assert (imm32_out = X"0000003C") report "S-type instruction failed" severity error;

        -- Teste para instrução SB-type
        instr_in <= x"fe5290e3"; -- bne t0, t0, main
        wait for 1 ns;
        assert (imm32_out = X"FFFFFFE0") report "SB-type instruction failed" severity error;

        -- Teste para instrução UJ-type
        instr_in <= x"00c000ef"; -- jal rot
        wait for 1 ns;
        assert (imm32_out = X"0000000C") report "UJ-type instruction failed" severity error;

        -- Teste para instrução U-type
        instr_in <= x"00002437"; -- lui s0, 2
        wait for 1 ns;
        assert (imm32_out = X"00002000") report "U-type instruction failed" severity error;

        -- Encerrar o processo
        assert false report "Test done." severity note;
        wait;
    end process;
end architecture tb;

