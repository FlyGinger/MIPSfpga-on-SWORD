-- mfp_srec_parser.vhd
-- Translated from mfp_srec_parser.v for MIPSfpga v2
-- 
-- 17 Feb 2017

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mipsfpga_const.all;


entity mfp_srec_parser is
    port (
        clock           : in    std_logic;
        reset_n         : in    std_logic;
        char_data       : in    std_logic_vector(7 downto 0);
        char_ready      : in    std_logic;
        in_progress     : out   std_logic;
        format_error    : out   std_logic;
        checksum_error  : out   std_logic;
        error_location  : out   std_logic_vector(7 downto 0);
        write_address   : out   std_logic_vector(31 downto 0);
        write_byte      : out   std_logic_vector(7 downto 0);
        write_enable    : out   std_Logic
    );
end mfp_srec_parser;



architecture rtl of mfp_srec_parser is

    --------------------------------------------------------------------
    -- FSM state definitions
    --------------------------------------------------------------------
    subtype state_type is std_logic_vector(4 downto 0);
 
    constant WAITING_S          : state_type :=  "00000";
    constant GET_TYPE           : state_type :=  "00001";
    constant GET_COUNT_7_4      : state_type :=  "00010";
    constant GET_COUNT_3_0      : state_type :=  "00011";
    constant GET_ADDRESS_31_28  : state_type :=  "00100";
    constant GET_ADDRESS_27_24  : state_type :=  "00101";
    constant GET_ADDRESS_23_20  : state_type :=  "00110";
    constant GET_ADDRESS_19_16  : state_type :=  "00111";
    constant GET_ADDRESS_15_12  : state_type :=  "01000";
    constant GET_ADDRESS_11_08  : state_type :=  "01001";
    constant GET_ADDRESS_07_04  : state_type :=  "01010";
    constant GET_ADDRESS_03_00  : state_type :=  "01011";
    constant GET_BYTE_7_4       : state_type :=  "01100";
    constant GET_BYTE_3_0       : state_type :=  "01101";
    constant CHECK_SUM_7_4      : state_type :=  "01110";
    constant CHECK_SUM_3_0      : state_type :=  "01111";
    constant CR                 : state_type :=  "10000";
    constant LF                 : state_type :=  "10001";
    

    --------------------------------------------------------------------
    -- constant value definitions
    --------------------------------------------------------------------
    constant CHAR_LF : integer := 16#0A#;
    constant CHAR_CR : integer := 16#0D#;
    constant CHAR_0  : integer := 16#30#;
    constant CHAR_3  : integer := 16#33#;
    constant CHAR_7  : integer := 16#37#;
    constant CHAR_9  : integer := 16#39#;
    constant CHAR_A  : integer := 16#41#;
    constant CHAR_F  : integer := 16#46#;
    constant CHAR_S  : integer := 16#53#;
    
    
    --------------------------------------------------------------------
    -- signal declarations
    --------------------------------------------------------------------
    signal state,       reg_state       : state_type;
    
    signal rec_type,    reg_rec_type    : std_logic_vector(7 downto 0);   
    signal count,       reg_count       : std_logic_vector(7 downto 0);
    signal address,     reg_address     : std_logic_vector(31 downto 0);
    signal byte_data,   reg_byte_data   : std_logic_vector(7 downto 0);
    signal write_data,  reg_write_data  : std_logic;
    
    signal count_nibble     : std_logic_vector(7 downto 0);
    signal address_nibble   : std_logic_vector(31 downto 0);
    signal byte_data_nibble : std_logic_vector(7 downto 0);
    
    signal nibble       : std_logic_vector(3 downto 0);
    signal nibble_error : std_logic;
    signal nibble_0     : std_logic_vector(3 downto 0);
    signal nibble_A     : std_logic_vector(3 downto 0);
    
    signal checksum : std_logic_vector(7 downto 0); 
    signal error    : std_logic;

    signal format_error_internal    : std_logic;
    signal checksum_error_internal  : std_logic;
    signal error_location_internal  : std_logic_vector(7 downto 0);
    
begin

    nibble_0 <= std_logic_vector(resize(unsigned(char_data) - CHAR_0, nibble'length));
    nibble_A <= std_logic_vector(resize(unsigned(char_data) - CHAR_A + 10, nibble'length));

    nibble <= nibble_0 when (unsigned(char_data) >= CHAR_0) and (unsigned(char_data) <= CHAR_9) else
              nibble_A when (unsigned(char_data) >= CHAR_A) and (unsigned(char_data) <= CHAR_F) else
              (others => '0');

    nibble_error <= '0' when ((unsigned(char_data) >= CHAR_0) and (unsigned(char_data) <= CHAR_9)) or
                             ((unsigned(char_data) >= CHAR_A) and (unsigned(char_data) <= CHAR_F)) else
                    '1';


    write_address <= reg_address;
    write_byte <= reg_byte_data;
    write_enable <= reg_write_data;


    count_nibble(7 downto 4) <= reg_count(3 downto 0);
    count_nibble(3 downto 0) <= nibble;

    address_nibble(31 downto 4) <= reg_address(27 downto 0);
    address_nibble(3 downto 0) <= nibble;

    byte_data_nibble(7 downto 4) <= reg_byte_data(3 downto 0);
    byte_data_nibble(3 downto 0) <= nibble;


    -- compute FSM's next state and control signals
    p_fsm : process(reg_state, reg_rec_type, reg_count, reg_address, reg_byte_data, char_ready, char_data, count, nibble, address_nibble, count_nibble, rec_type, byte_data_nibble)
    begin
        state <= reg_state;
        rec_type <= reg_rec_type;
        count <= reg_count;
        address <= reg_address;
        byte_data <= reg_byte_data;
        write_data <= '0';
        
        if char_ready = '1' then
            state <= std_logic_vector( unsigned(reg_state) + 1 );
            case reg_state is     
                when WAITING_S => 
                    -- Nothing
                    
                when GET_TYPE =>
                    rec_type <= char_data;
                    
                when GET_COUNT_7_4 | GET_COUNT_3_0 =>
                    count <= count_nibble;

                when GET_ADDRESS_31_28 | GET_ADDRESS_27_24 |
                    GET_ADDRESS_23_20 | GET_ADDRESS_19_16 |
                    GET_ADDRESS_15_12 | GET_ADDRESS_11_08 |
                    GET_ADDRESS_07_04 =>
                    address <= address_nibble;
                    
                when GET_ADDRESS_03_00 =>
                    address <= std_logic_vector(unsigned(address_nibble) - 1);
                    
                    if unsigned(reg_count) = 5 then
                        state <= CHECK_SUM_7_4;
                    end if;
                    
                when GET_BYTE_7_4 =>
                
                    byte_data(7 downto 4) <= nibble;
                
                when GET_BYTE_3_0 =>
                
                    address <= std_logic_vector(unsigned(reg_address) + 1);
                    byte_data(3 downto 0) <= nibble;
                    count <= std_logic_vector(unsigned(reg_count) - 1);
                    
                    if unsigned(rec_type) = CHAR_3 then
                        write_data <= '1';
                    end if;
                    
                    if unsigned(count) > 5 then
                        state <= GET_BYTE_7_4;
                    end if;
                
                when CHECK_SUM_7_4 | CHECK_SUM_3_0 =>
                    byte_data <= byte_data_nibble;
                
                when CR =>
                    if unsigned(char_data) = CHAR_LF then
                        state <= WAITING_S;
                    end if;
                
                when LF =>
                    state <= WAITING_S;
                
                when others =>
                    -- Nothing
                    
            end case; 
        end if;
    end process p_fsm;


    p_data_registers : process(clock)
    begin
        if rising_edge(clock) then
            reg_count <= count;
            reg_address <= address;
            reg_byte_data <= byte_data;
        end if;
    end process p_data_registers;


    p_state : process(clock, reset_n)
    begin
        if reset_n = '0' then
            reg_state <= WAITING_S;
            reg_rec_type <= (others => '0');
            reg_write_data <= '0';
        elsif rising_edge(clock) then
            reg_state <= state; 
            reg_rec_type <= rec_type;
            reg_write_data <= write_data;
        end if;
    end process p_state;


    p_progress_register : process(clock, reset_n)
    begin
        if reset_n = '0' then
            in_progress <= '0';
        elsif rising_edge(clock) then
            if unsigned(rec_type) = CHAR_3 then
                in_progress <= '1';
            elsif unsigned(rec_type) = CHAR_7 then
                in_progress <= '0';
            end if;
        end if;
    end process p_progress_register;

    
    p_format_error : process(clock, reset_n)
    begin
        if reset_n = '0' then
            format_error_internal <= '0';
        elsif rising_edge(clock) then
            if (char_ready = '1') and (format_error_internal = '0') then
                case reg_state is
                    when WAITING_S =>
                        if unsigned(char_data) /= CHAR_S then
                            format_error_internal <= '1';
                        end if;
                    when CR =>
                        if (unsigned(char_data) /= CHAR_CR) and (unsigned(char_data) /= CHAR_LF) then
                            format_error_internal <= '1';
                        end if;
                    when LF =>
                        if unsigned(char_data) /= CHAR_LF then
                            format_error_internal <= '1';
                        end if;
                    when others =>
                        if nibble_error = '1' then
                            format_error_internal <= '1';
                        end if;
                end case;
                
            end if;
        end if;
    end process p_format_error;
    format_error <= format_error_internal;


    p_checksum : process(clock, reset_n)
    begin
        if reset_n = '0' then
            checksum_error_internal <= '0';
        elsif rising_edge(clock) then
            if (char_ready = '1') and (checksum_error_internal = '0') then
                case reg_state is
                    when WAITING_S =>
                        checksum <= (others => '0');
                        
                    when GET_COUNT_7_4 | GET_ADDRESS_31_28 | GET_ADDRESS_23_20 | 
                         GET_ADDRESS_15_12 | GET_ADDRESS_07_04 | GET_BYTE_7_4 =>
                        checksum <= std_logic_vector(unsigned(checksum) + SHIFT_LEFT(resize(unsigned(nibble), checksum'length), 4));

                    when GET_COUNT_3_0 | GET_ADDRESS_27_24 | GET_ADDRESS_19_16 |
                         GET_ADDRESS_11_08 | GET_ADDRESS_03_00 | GET_BYTE_3_0 =>
                        checksum <= std_logic_vector(unsigned(checksum) + unsigned(nibble));

                    when CHECK_SUM_3_0 =>
                        if ((not checksum) /= byte_data) then
                            checksum_error_internal <= '1';
                        end if;

                    when others =>
                        -- Nothing
                        
                end case;
            end if;
        end if;    
    end process p_checksum;
    checksum_error <= checksum_error_internal;


    error <= format_error_internal or checksum_error_internal;


    p_error_location : process(clock, reset_n)
    begin
        if reset_n = '0' then
            error_location_internal <= (others => '0');
        elsif rising_edge(clock) then
            if (char_ready = '1') and (error = '0') then
                error_location_internal <= std_logic_vector(unsigned(error_location_internal) + 1);
            end if;
        end if;
    end process p_error_location;
    error_location <= error_location_internal;

end rtl;
