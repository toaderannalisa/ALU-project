library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_logic_unit is
end tb_logic_unit;

architecture behavior of tb_logic_unit is
    component logic_unit
        Port (
            clk: in std_logic;
            x1, x2: in std_logic_vector(31 downto 0);
            id_op: in std_logic_vector(3 downto 0);
            left, right: in std_logic;
            y: out std_logic_vector(31 downto 0);
            flags: out std_logic_vector(6 downto 0)
        );
    end component;
    
    signal clk: std_logic := '0';
    signal x1, x2: std_logic_vector(31 downto 0) := (others => '0');
    signal id_op: std_logic_vector(3 downto 0) := (others => '0');
    signal left, right: std_logic := '0';
    signal y: std_logic_vector(31 downto 0);
    signal flags: std_logic_vector(6 downto 0);
    
    constant clk_period: time := 10 ns;
   
begin
    uut: logic_unit
        port map (
            clk => clk,
            x1 => x1,
            x2 => x2,
            id_op => id_op,
            left => left,
            right => right,
            y => y,
            flags => flags
        );

    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim_proc: process
    begin
  
        x1 <= (others => '0');
        x2 <= (others => '0');
        id_op <= (others => '0');
        left <= '0';
        right <= '0';
        wait for clk_period;

        -- Test AND  (0110)
        id_op <= "0110";  
        x1 <= x"7FFFFFFE";
        x2 <= x"7FFFFFFF";
        wait for clk_period;
        
        x1 <= x"00000007";
        x2 <= x"0000000F";
        wait for clk_period;
        
        x1 <= x"FFFFFFEF"; 
        x2 <= x"FFFFFFF7"; 
        wait for clk_period;
        
        x1 <= x"FFFFFF90"; 
        x2 <= x"00000014"; 
        wait for clk_period;
        
        x1 <= x"000005B3"; 
        x2 <= x"0000007F"; 
        wait for clk_period;

        -- Test OR  (0111)
        id_op <= "0111";   
        
        x1 <= x"7FFFFFFE";
        x2 <= x"7FFFFFFF";
        wait for clk_period;
        
        x1 <= x"0CF5FFDE";
        x2 <= x"7FFFFFFF";
        wait for clk_period;
        
        x1 <= x"00000004";
        x2 <= x"00000008";
        wait for clk_period;
        
        x1 <= x"FFFFFFE7";
        x2 <= x"FFFFFFF7";
        wait for clk_period;
        
        x1 <= x"0000046E";
        x2 <= x"00000220";
        wait for clk_period;

        -- Test NOT (1000)
        id_op <= "1000";   
        
        x1 <= x"7FFF8000"; 
        wait for clk_period;
        
        x1 <= x"00000005"; 
        wait for clk_period;
        
        x1 <= x"FFFFFB75"; 
        wait for clk_period;
        
        x1 <= x"0000306B"; 
        wait for clk_period;
        
        x1 <= x"FFFFF0BC"; 
        wait for clk_period;

        -- Test Left Rotation (1001)
        id_op <= "1001";
        left <= '1';
        
        x1 <= x"7FFF8000";
        wait for clk_period;
        
        x1 <= x"00000007"; 
        wait for clk_period;
        
        x1 <= x"00000102"; 
        wait for clk_period;
        
        x1 <= x"FFFFFF85"; 
        wait for clk_period;
        
        x1 <= x"FFFFD406"; 
        wait for clk_period;
        
        left <= '0';
        x1 <= x"7FFF8000"; 
        wait for clk_period;
        
        x1 <= x"00000007"; 
        wait for clk_period;
        
        x1 <= x"00000102"; 
        wait for clk_period;
        
        x1 <= x"FFFFFF85"; 
        wait for clk_period;
        
        x1 <= x"FFFFD406"; 
        wait for clk_period;

        -- Test Right Rotation (1010)
        id_op <= "1010";
        right <= '1';
        
        x1 <= x"7FFF8000";
        wait for clk_period;
        
        x1 <= x"00000007";
        wait for clk_period;
        
        x1 <= x"00000102";
        wait for clk_period;
        
        x1 <= x"FFFFFF85";
        wait for clk_period;
        
        x1 <= x"FFFFD406";
        wait for clk_period;
        
        right <= '0';
        x1 <= x"7FFF8000";
        wait for clk_period;
        
        x1 <= x"00000007";
        wait for clk_period;
        
        x1 <= x"00000102";
        wait for clk_period;
        
        x1 <= x"FFFFFF85";
        wait for clk_period;
        
        x1 <= x"FFFFD406";
        wait for clk_period;

        wait;
    end process;
end behavior;