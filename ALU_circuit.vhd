library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_circuit is
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
end alu_circuit;

architecture Structural of alu_circuit is

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

    
    component arithmetic_unit is
        Port (
            x1, x2: in std_logic_vector(31 downto 0);
            op_id_arithm: in std_logic_vector(3 downto 0);
            y: out std_logic_vector(31 downto 0);
            flags: out std_logic_vector(6 downto 0)
        );
    end component;

    component logic_unit is
        Port (
            clk: in std_logic;
            x1, x2: in std_logic_vector(31 downto 0);
            id_op: in std_logic_vector(3 downto 0);
            left, right: in std_logic;
            y: out std_logic_vector(31 downto 0);
            flags: out std_logic_vector(6 downto 0)
        );
    end component;

    component multiplication_circuit is
        Port (
            clk: in std_logic;
            clr: in std_logic;
            x1, x2: in std_logic_vector(31 downto 0);
            clr_res_mul: in std_logic;
            ld_res_mul: in std_logic;
            ld_m_mul: in std_logic;
            ld_d_mul: in std_logic;
            right_shift_m_mul: in std_logic;
            left_shift_d_mul: in std_logic;
            op_id_mul: in std_logic_vector(3 downto 0);
            y: out std_logic_vector(63 downto 0);
            i0: out std_logic;
            flags: out std_logic_vector(6 downto 0)
        );
    end component;

    component division_circuit is
        Port (
            clk: in std_logic;
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
            dn: out std_logic
        );
    end component;


    signal arith_result: std_logic_vector(31 downto 0);
    signal logic_result: std_logic_vector(31 downto 0);
    signal mul_result: std_logic_vector(63 downto 0);
    signal div_result: std_logic_vector(63 downto 0);
    
    signal arith_flags: std_logic_vector(6 downto 0);
    signal logic_flags: std_logic_vector(6 downto 0);
    signal mul_flags: std_logic_vector(6 downto 0);
    signal div_flags: std_logic_vector(6 downto 0);
    
    signal left_rotate, right_rotate: std_logic;
    signal i0_mul: std_logic;
    signal dn_div: std_logic;

begin
  
    left_rotate <= '1' when op_id = OP_ROL else '0';
    right_rotate <= '1' when op_id = OP_ROR else '0';


    arithmetic_unit_inst: arithmetic_unit
        port map (
            x1 => x1,
            x2 => x2,
            op_id_arithm => op_id,
            y => arith_result,
            flags => arith_flags
        );


    logic_unit_inst: logic_unit
        port map (
            clk => clk,
            x1 => x1,
            x2 => x2,
            id_op => op_id,
            left => left_rotate,
            right => right_rotate,
            y => logic_result,
            flags => logic_flags
        );


    multiplication_unit_inst: multiplication_circuit
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
            op_id_mul => op_id,
            y => mul_result,
            i0 => i0_mul,
            flags => mul_flags
        );


    division_unit_inst: division_circuit
        port map (
            clk => clk,
            clr => clr,
            x1 => x1,
            x2 => x2,
            op_id_div => op_id,
            clr_c_div => clr_c_div,
            ld_d_div => ld_d_div,
            sub_div => sub_div,
            ld_d2_div => ld_d2_div,
            right_shift_d2_div => right_shift_d2_div,
            left_shift_q_div => left_shift_q_div,
            y => div_result,
            flags => div_flags,
            dn => dn_div
        );

  
    output_mux: process(op_id, arith_result, logic_result, mul_result, div_result,
                       arith_flags, logic_flags, mul_flags, div_flags)
    begin
        case op_id is
        
            when OP_ADD | OP_SUB | OP_INC | OP_DEC | OP_NEG =>
                result <= std_logic_vector(resize(signed(arith_result), 64));
                flags <= arith_flags;
            
        
            when OP_AND | OP_OR | OP_NOT =>
                result <= std_logic_vector(resize(unsigned(logic_result), 64));
                flags <= logic_flags;
            
         
            when OP_ROL | OP_ROR =>
                result <= std_logic_vector(resize(unsigned(logic_result), 64));
                flags <= logic_flags;
            
       
            when OP_MUL =>
                result <= mul_result;
                flags <= mul_flags;
            
          
            when OP_DIV =>
                result <= div_result;
                flags <= div_flags;
            
           
            when others =>
                result <= (others => '0');
                flags <= (others => '0');
        end case;
    end process output_mux;

end Structural;