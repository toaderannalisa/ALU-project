library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_5_1 is
    Port (
        x0, x1, x2, x3, x4: in std_logic_vector(31 downto 0);
        sel: in std_logic_vector(3 downto 0);
        y: out std_logic_vector(31 downto 0)
    );
end mux_5_1;

architecture Behavioral of mux_5_1 is
begin
    process(sel, x0, x1, x2, x3, x4)
    begin
        case sel is
            when "0000" => y <= x0;
            when "0001" => y <= x1;
            when "0010" => y <= x2;
            when "0011" => y <= x3;
            when "0100" => y <= x4;
            when others => y <= (others => '0');
        end case;
    end process;
end Behavioral;
