library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity genImm32 is
    port (
        instr: in std_logic_vector(31 downto 0);
        imm32: out signed(31 downto 0)
    );
end entity genImm32;

architecture arch of genImm32 is
    signal opcode: std_logic_vector(7 downto 0);
begin
    opcode <= '0' & instr(6 downto 0);

    process(instr)
    begin
        case opcode is
            when x"33" =>  -- R-type
                imm32 <= (others => '0');
            when x"03" | x"13" | x"67" =>  -- I-type
                imm32 <= resize(signed(instr(31 downto 20)), 32);
            when x"23" =>  -- S-type
                imm32 <= resize(signed(instr(31 downto 25) & instr(11 downto 7)), 32);
            when x"63" =>  -- SB-type
                imm32 <= resize(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0'), 32);
            when x"37" =>  -- U-type
                imm32 <= resize(signed(instr(31 downto 12) & "000000000000"), 32); -- Correção aqui
            when x"6F" =>  -- UJ-type
                imm32 <= resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0'), 32);
            when others =>
                imm32 <= (others => '0');
        end case;
    end process;
end architecture arch;

