library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_adder_64bits is
-- No ports in the testbench entity
end tb_adder_64bits;

architecture Behavioral of tb_adder_64bits is

    component adder_64bits is
        Port (
            x1, x2: in std_logic_vector(63 downto 0);
            sub: in std_logic;
            cout: out std_logic;
            y: out std_logic_vector(63 downto 0)
        );
    end component;


    signal x1, x2: std_logic_vector(63 downto 0) := (others => '0');
    signal sub: std_logic := '0';
    signal cout: std_logic;
    signal y: std_logic_vector(63 downto 0);


    constant clk_period: time := 10 ns;

begin


    uut: adder_64bits port map (
        x1 => x1,
        x2 => x2,
        sub => sub,
        cout => cout,
        y => y
    );


    stimulus_process: process
    begin
     
        x1 <= std_logic_vector(to_unsigned(5, 64));
        x2 <= std_logic_vector(to_unsigned(3, 64));
        sub <= '0';  -- Add
        wait for clk_period;
     

        -- Test Case 2: Add max
        x1 <= std_logic_vector(to_unsigned(2**63 - 1, 64));
        x2 <= std_logic_vector(to_unsigned(1, 64));
        sub <= '0';  -- Add
        wait for clk_period;
       
        -- Test Case 3: Sub 10 - 7
        x1 <= std_logic_vector(to_unsigned(10, 64));
        x2 <= std_logic_vector(to_unsigned(7, 64));
        sub <= '1';  -- Sub
        wait for clk_period;
       
        wait;
    end process;

end Behavioral;
