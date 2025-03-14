library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity division_circuit_tb is
end division_circuit_tb;

architecture Behavioral of division_circuit_tb is
    component division_circuit is
        Port (clk: in std_logic;
              clr: in std_logic;
              x1, x2: in std_logic_vector(31 downto 0);
              op_id_div: in std_logic_vector(3 downto 0); 
              clr_c_div: in std_logic;    
              ld_d_div: in std_logic;     
              sub_div: in std_logic;      
              ld_d2_div: in std_logic;    
              right_shift_d2_div: in std_logic;
              left_shift_q_div: in std_logic;
              y: out std_logic_vector(63 downto 0); 
              flags: out std_logic_vector(6 downto 0);
              dn: out std_logic);
    end component;
    
    signal clk_tb: std_logic := '0';
    signal clr_tb, clr_c_div_tb, ld_d_div_tb, sub_div_tb: std_logic := '0';
    signal ld_d2_div_tb, right_shift_d2_div_tb, left_shift_q_div_tb: std_logic := '0';
    signal x1_tb, x2_tb: std_logic_vector(31 downto 0) := (others => '0');
    signal op_id_div_tb: std_logic_vector(3 downto 0) := "0000";  
    signal y_tb: std_logic_vector(63 downto 0);
    signal flags_tb: std_logic_vector(6 downto 0);
    signal dn_tb: std_logic;
    
    constant CLK_PERIOD: time := 10 ns;
    
begin
    DUT: division_circuit port map (
        clk => clk_tb,
        clr => clr_tb,
        x1 => x1_tb,
        x2 => x2_tb,
        op_id_div => op_id_div_tb, 
        clr_c_div => clr_c_div_tb,
        ld_d_div => ld_d_div_tb,
        sub_div => sub_div_tb,
        ld_d2_div => ld_d2_div_tb,
        right_shift_d2_div => right_shift_d2_div_tb,
        left_shift_q_div => left_shift_q_div_tb,
        y => y_tb,
        flags => flags_tb,
        dn => dn_tb
    );
    

    clk_proc: process
    begin
        while now < 1000 ns loop
            clk_tb <= '0';
            wait for CLK_PERIOD/2;
            clk_tb <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;
    
   
    stim_proc: process
    begin
        
        clr_tb <= '1';
        clr_c_div_tb <= '1';
        op_id_div_tb <= "1011";  
        wait for CLK_PERIOD * 2;
        
        
        clr_tb <= '0';
        clr_c_div_tb <= '0';
        wait for CLK_PERIOD;
        
       
        x1_tb <= x"00000035";  
        x2_tb <= x"00000005";  
        
        

        ld_d2_div_tb <= '1';
        wait for CLK_PERIOD;
        ld_d2_div_tb <= '0';
        wait for CLK_PERIOD;
        
       
        ld_d_div_tb <= '1';
        wait for CLK_PERIOD;
        ld_d_div_tb <= '0';
        wait for CLK_PERIOD;
        
      
        for i in 0 to 31 loop
            sub_div_tb <= '1';
            wait for CLK_PERIOD;
            
          
            
            
            if dn_tb = '0' then
                ld_d_div_tb <= '1';  
                left_shift_q_div_tb <= '1';  
                wait for CLK_PERIOD;
                ld_d_div_tb <= '0';
                left_shift_q_div_tb <= '0';
            else
                left_shift_q_div_tb <= '1';  
                wait for CLK_PERIOD;
                left_shift_q_div_tb <= '0';
            end if;
            
            sub_div_tb <= '0';
            wait for CLK_PERIOD;
            
           
            if i /= 31 then
                right_shift_d2_div_tb <= '1';
                wait for CLK_PERIOD;
                right_shift_d2_div_tb <= '0';
                wait for CLK_PERIOD;
            end if;
         
        end loop;
        
      
        wait for CLK_PERIOD * 2;
       
        
        wait;
    end process;
    
end Behavioral;