library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU_TB is
end ALU_TB;

architecture Behavioral of ALU_TB is
 
    component alu_circuit is
        Port (
            clk: in std_logic;
            clr: in std_logic;
            x1, x2: in std_logic_vector(31 downto 0);
            op_id: in std_logic_vector(3 downto 0);
       
            clr_c_div: in std_logic;
            ld_d_div: in std_logic;
            sub_div: in std_logic;
            ld_d2_div: in std_logic;
            right_shift_d2_div: in std_logic;
            left_shift_q_div: in std_logic;
         
            clr_res_mul: in std_logic;
            ld_res_mul: in std_logic;
            ld_m_mul: in std_logic;
            ld_d_mul: in std_logic;
            right_shift_m_mul: in std_logic;
            left_shift_d_mul: in std_logic;
      
            result: out std_logic_vector(63 downto 0);
            flags: out std_logic_vector(6 downto 0)
        );
    end component;


    constant OP_ADD: std_logic_vector(3 downto 0) := "0001";
    constant OP_SUB: std_logic_vector(3 downto 0) := "0010";
    constant OP_INC: std_logic_vector(3 downto 0) := "0011";
    constant OP_DEC: std_logic_vector(3 downto 0) := "0100";
    constant OP_NEG: std_logic_vector(3 downto 0) := "0101";
    constant OP_AND: std_logic_vector(3 downto 0) := "0110";
    constant OP_OR:  std_logic_vector(3 downto 0) := "0111";
    constant OP_NOT: std_logic_vector(3 downto 0) := "1000";
    constant OP_ROL: std_logic_vector(3 downto 0) := "1001";
    constant OP_ROR: std_logic_vector(3 downto 0) := "1010";
    constant OP_DIV: std_logic_vector(3 downto 0) := "1011";
    constant OP_MUL: std_logic_vector(3 downto 0) := "1100";

  
    constant CLK_PERIOD : time := 10 ns;

  
    signal clk : std_logic := '0';
    signal clr : std_logic := '0';
    signal x1, x2 : std_logic_vector(31 downto 0) := (others => '0');
    signal op_id : std_logic_vector(3 downto 0) := (others => '0');
    

    signal clr_c_div : std_logic := '0';
    signal ld_d_div : std_logic := '0';
    signal sub_div : std_logic := '0';
    signal ld_d2_div : std_logic := '0';
    signal right_shift_d2_div : std_logic := '0';
    signal left_shift_q_div : std_logic := '0';
    

    signal clr_res_mul : std_logic := '0';
    signal ld_res_mul : std_logic := '0';
    signal ld_m_mul : std_logic := '0';
    signal ld_d_mul : std_logic := '0';
    signal right_shift_m_mul : std_logic := '0';
    signal left_shift_d_mul : std_logic := '0';
    

    signal result : std_logic_vector(63 downto 0);
    signal flags : std_logic_vector(6 downto 0);

begin

    UUT: alu_circuit port map (
        clk => clk,
        clr => clr,
        x1 => x1,
        x2 => x2,
        op_id => op_id,
        clr_c_div => clr_c_div,
        ld_d_div => ld_d_div,
        sub_div => sub_div,
        ld_d2_div => ld_d2_div,
        right_shift_d2_div => right_shift_d2_div,
        left_shift_q_div => left_shift_q_div,
        clr_res_mul => clr_res_mul,
        ld_res_mul => ld_res_mul,
        ld_m_mul => ld_m_mul,
        ld_d_mul => ld_d_mul,
        right_shift_m_mul => right_shift_m_mul,
        left_shift_d_mul => left_shift_d_mul,
        result => result,
        flags => flags
    );


    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

  
    stim_proc: process
    begin
     
        clr <= '1';
        wait for CLK_PERIOD;
        clr <= '0';
        wait for CLK_PERIOD;

     
        clr_res_mul <= '0';
        ld_res_mul <= '0';
        ld_m_mul <= '0';
        ld_d_mul <= '0';
        right_shift_m_mul <= '0';
        left_shift_d_mul <= '0';
        clr_c_div <= '0';
        ld_d_div <= '0';
        sub_div <= '0';
        ld_d2_div <= '0';
        right_shift_d2_div <= '0';
        left_shift_q_div <= '0';

        -- Test ADD  (15 + 10 = 25)
        x1 <= x"075946D1";
        x2 <= x"0000FC27"; 
        op_id <= OP_ADD;
        wait for CLK_PERIOD * 2;
        assert result(31 downto 0) = x"00000019" -- 25
            report "ADD test failed" severity error;

        -- Test SUB  (20 - 5 = 15)
          x1 <= x"075946D1";
           x2 <= x"0000FC27"; 
        op_id <= OP_SUB;
        wait for CLK_PERIOD * 2;
        assert result(31 downto 0) = x"0000000F" -- 15
            report "SUB test failed" severity error;

        -- Test INC  (25 + 1 = 26)
         x1 <= x"075946D1";
        op_id <= OP_INC;
        wait for CLK_PERIOD * 2;
        assert result(31 downto 0) = x"0000001A" -- 26
            report "INC test failed" severity error;

        -- Test DEC  (25 - 1 = 24)
            x1 <= x"075946D1";
        
        op_id <= OP_DEC;
        wait for CLK_PERIOD * 2;
        assert result(31 downto 0) = x"00000018" -- 24
            report "DEC test failed" severity error;

        -- Test NEG  (NEG 5 = -5)
            x1 <= x"075946D1";
       
        op_id <= OP_NEG;
        wait for CLK_PERIOD * 2;
        assert result(31 downto 0) = x"FFFFFFFB" -- -5
            report "NEG test failed" severity error;

        -- Test AND
            x1 <= x"075946D1";
           x2 <= x"0000FC27"; 
        op_id <= OP_AND;
        wait for CLK_PERIOD * 2;
        assert result(31 downto 0) = x"0000F000"
            report "AND test failed" severity error;

        -- Test OR 
           x1 <= x"075946D1";
           x2 <= x"0000FC27"; 
        op_id <= OP_OR;
        wait for CLK_PERIOD * 2;
        assert result(31 downto 0) = x"0000FFFF"
            report "OR test failed" severity error;

        -- Test NOT 
          x1 <= x"075946D1";
          
        op_id <= OP_NOT;
        wait for CLK_PERIOD * 2;
        assert result(31 downto 0) = x"FFFF0000"
            report "NOT test failed" severity error;

        -- Test ROL 
           x1 <= x"075946D1";
          
        op_id <= OP_ROL;
        wait for CLK_PERIOD * 2;
        assert result(31 downto 0) = x"00000001"
            report "ROL test failed" severity error;

        -- Test ROR 
      x1 <= x"075946D1";
           
        op_id <= OP_ROR;
        wait for CLK_PERIOD * 2;
        assert result(31 downto 0) = x"80000000"
            report "ROR test failed" severity error;

        -- Test DIV  (20 / 5 = 4)
          x1 <= x"075946D1";
           x2 <= x"0000FC27"; 
        op_id <= OP_DIV;
        
  
        clr_c_div <= '1';
        wait for CLK_PERIOD;
        clr_c_div <= '0';
        ld_d_div <= '1';
        ld_d2_div <= '1';
        wait for CLK_PERIOD;
        ld_d_div <= '0';
        ld_d2_div <= '0';
        
        for i in 0 to 31 loop
            sub_div <= '1';
            right_shift_d2_div <= '1';
            left_shift_q_div <= '1';
            wait for CLK_PERIOD;
        end loop;
        
        wait for CLK_PERIOD;
      

        -- Test MUL (5 * 4 = 20)
          x1 <= x"075946D1";
           x2 <= x"0000FC27"; 
        op_id <= OP_MUL;
        

        clr_res_mul <= '1';
        wait for CLK_PERIOD;
        clr_res_mul <= '0';
        ld_m_mul <= '1';
        ld_d_mul <= '1';
        wait for CLK_PERIOD;
        ld_m_mul <= '0';
        ld_d_mul <= '0';
        
      
        for i in 0 to 31 loop
            right_shift_m_mul <= '1';
            left_shift_d_mul <= '1';
            ld_res_mul <= '1';
            wait for CLK_PERIOD;
        end loop;
        
        wait for CLK_PERIOD;
  
      
        wait for CLK_PERIOD * 5;
        wait;
    end process;

end Behavioral;