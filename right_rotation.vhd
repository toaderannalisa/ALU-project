library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity right_rotation_circuit is
    Port (clk: in std_logic;
          x: in std_logic_vector(31 downto 0);
          right: in std_logic;                 
          y: out std_logic_vector(31 downto 0));
end right_rotation_circuit;

architecture Structural of right_rotation_circuit is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if right = '1' then
       
                y <= '0' & x(31 downto 1);
            else
                y <= x;
            end if;
        end if;
    end process;
end Structural;