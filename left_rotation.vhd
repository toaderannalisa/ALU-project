library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity left_rotation_circuit is
    Port (clk: in std_logic;
          x: in std_logic_vector(31 downto 0);
          left: in std_logic;                 
          y: out std_logic_vector(31 downto 0));
end left_rotation_circuit;

architecture Structural of left_rotation_circuit is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if left = '1' then
              
                y <= x(30 downto 0) & '0';
            else
                y <= x;
            end if;
        end if;
    end process;
end Structural;