library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_multiplication_circuit is
end tb_multiplication_circuit;

architecture Behavioral of tb_multiplication_circuit is
    signal clk, clr, clr_res_mul, ld_res_mul, ld_m_mul, ld_d_mul, right_shift_m_mul, left_shift_d_mul: std_logic := '0';
    signal x1, x2: std_logic_vector(31 downto 0) := (others => '0');
    signal op_id_mul: std_logic_vector(3 downto 0) := (others => '0');
    signal y: std_logic_vector(63 downto 0);
    signal i0: std_logic;
    signal flags: std_logic_vector(6 downto 0);
    
    constant clk_period: time := 10 ns;

begin

    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    uut: entity work.multiplication_circuit
        port map (
            clk => clk,
            clr => clr,
            x1 => x1,
            x2 => x2,
            clr_res_mul => clr_res_mul,
            ld_res_mul => ld_res_mul,
            ld_m_mul => ld_m_mul,
            ld_d_mul => ld_d_mul,
            right_shift_m_mul => right_shift_m_mul,
            left_shift_d_mul => left_shift_d_mul,
            op_id_mul => op_id_mul,
            y => y,
            i0 => i0,
            flags => flags
        );

    stimulus_process: process
    begin        
      
        clr <= '1';
        clr_res_mul <= '1';
        wait for clk_period;
        clr <= '0';
        clr_res_mul <= '0';
        wait for clk_period;
        
        -- Test1: 65535 * 65535
        clr_res_mul <= '1';
        wait for clk_period;
        clr_res_mul <= '0'; 
         x1 <= x"075946D1";
         x2 <= x"0000FC27"; 
        ld_d_mul <= '1';
        ld_m_mul <= '1';
        wait for clk_period;
        ld_d_mul <= '0';
        ld_m_mul <= '0';
        
        for i in 0 to 31 loop
            if i0 = '1' then
                ld_res_mul <= '1';
                wait for clk_period;
                ld_res_mul <= '0';
            end if;
            left_shift_d_mul <= '1';
            right_shift_m_mul <= '1';
            wait for clk_period;
            left_shift_d_mul <= '0';
            right_shift_m_mul <= '0';
        end loop;
        wait for clk_period;
            
        -- Test  2: 15 * 10
        clr_res_mul <= '1';
        wait for clk_period;
        clr_res_mul <= '0';
        x1 <= x"000001c4";
        x2 <= x"00000354";
        ld_d_mul <= '1';
        ld_m_mul <= '1';
        wait for clk_period;
        ld_d_mul <= '0';
        ld_m_mul <= '0';
        
        for i in 0 to 31 loop
            if i0 = '1' then
                ld_res_mul <= '1';
                wait for clk_period;
                ld_res_mul <= '0';
            end if;
            left_shift_d_mul <= '1';
            right_shift_m_mul <= '1';
            wait for clk_period;
            left_shift_d_mul <= '0';
            right_shift_m_mul <= '0';
        end loop;
        wait for clk_period;

        -- Test 3: -5 * 4
        clr_res_mul <= '1';
        wait for clk_period;
        clr_res_mul <= '0';
        x1 <= x"FFFFFFFB";
        x2 <= x"00000004";
        ld_d_mul <= '1';
        ld_m_mul <= '1';
        wait for clk_period;
        ld_d_mul <= '0';
        ld_m_mul <= '0';
        
        for i in 0 to 31 loop
            if i0 = '1' then
                ld_res_mul <= '1';
                wait for clk_period;
                ld_res_mul <= '0';
            end if;
            left_shift_d_mul <= '1';
            right_shift_m_mul <= '1';
            wait for clk_period;
            left_shift_d_mul <= '0';
            right_shift_m_mul <= '0';
        end loop;
        wait for clk_period;

        -- Test 4: -8 * -7
        clr_res_mul <= '1';
        wait for clk_period;
        clr_res_mul <= '0';
        x1 <= x"FFFFFFF8";
        x2 <= x"FFFFFFF9";
        ld_d_mul <= '1';
        ld_m_mul <= '1';
        wait for clk_period;
        ld_d_mul <= '0';
        ld_m_mul <= '0';
        
        for i in 0 to 31 loop
            if i0 = '1' then
                ld_res_mul <= '1';
                wait for clk_period;
                ld_res_mul <= '0';
            end if;
            left_shift_d_mul <= '1';
            right_shift_m_mul <= '1';
            wait for clk_period;
            left_shift_d_mul <= '0';
            right_shift_m_mul <= '0';
        end loop;
        wait for clk_period;

        -- Test  5: 8 x 12
        clr_res_mul <= '1';
        wait for clk_period;
        clr_res_mul <= '0';
        x1 <= x"00000008";
        x2 <= x"0000000C";
        ld_d_mul <= '1';
        ld_m_mul <= '1';
        wait for clk_period;
        ld_d_mul <= '0';
        ld_m_mul <= '0';
        
        for i in 0 to 31 loop
            if i0 = '1' then
                ld_res_mul <= '1';
                wait for clk_period;
                ld_res_mul <= '0';
            end if;
            left_shift_d_mul <= '1';
            right_shift_m_mul <= '1';
            wait for clk_period;
            left_shift_d_mul <= '0';
            right_shift_m_mul <= '0';
        end loop;
        wait for clk_period;
        wait;
    end process;
end Behavioral;