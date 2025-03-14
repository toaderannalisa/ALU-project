library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_arithmetic_unit is
end tb_arithmetic_unit;

architecture behavior of tb_arithmetic_unit is
    component arithmetic_unit
        Port (
            x1, x2: in std_logic_vector(31 downto 0);
            op_id_arithm: in std_logic_vector(3 downto 0);
            y: out std_logic_vector(31 downto 0);
            flags: out std_logic_vector(6 downto 0)
        );
    end component;

    signal x1, x2: std_logic_vector(31 downto 0) := (others => '0');
    signal op_id_arithm: std_logic_vector(3 downto 0) := "0000";
    signal y: std_logic_vector(31 downto 0);
    signal flags: std_logic_vector(6 downto 0);
    
    constant clk_period: time := 10 ns;
   
begin

    uut: arithmetic_unit
        port map (
            x1 => x1,
            x2 => x2,
            op_id_arithm => op_id_arithm,
            y => y,
            flags => flags
        );

   
    stim_proc: process
    begin
      
        x1 <= (others => '0');
        x2 <= (others => '0');
        op_id_arithm <= "0000";
        wait for clk_period;

        
         op_id_arithm <= "0101";  -- ADD
        
        -- 4 + 5
        x1 <= x"075946D1";
         x2 <= x"0000FC27"; 
        wait for clk_period;
        
        
        op_id_arithm <= "0110";  -- SUB
        
        -- 9 - 6
        x1 <= x"075946D1";
        x2 <= x"0000FC27"; 
        wait for clk_period;
        

      
        op_id_arithm <= "0111";  -- INC
        
        -- 2147437904
         x1 <= x"075946D1";
         
        wait for clk_period;
       
       
        op_id_arithm <= "1000";  -- DEC
        -- 2147437904
         x1 <= x"075946D1";
              x2 <= x"0000FC27"; 
        wait for clk_period;
        
      
        op_id_arithm <= "1001";  -- NEG
        -- 3 -> -3
        x1 <= x"075946D1";
           
        wait for clk_period;
        
      

 
        wait;
    end process;

end behavior;