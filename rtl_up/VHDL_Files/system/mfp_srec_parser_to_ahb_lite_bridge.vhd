-- mfp_srec_parser_to_ahb_lite_bridge.vhd
-- Translated from mfp_srec_parser_to_ahb_lite_bridge.v for MIPSfpga v2
-- 
-- 15 Jan 2017

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.mipsfpga_const.all;


entity mfp_srec_parser_to_ahb_lite_bridge is     
    port (
        clock           : in    std_logic;
        reset_n         : in    std_logic;
        big_endian      : in    std_logic;
        write_address   : in    std_logic_vector(31 downto 0);
        write_byte      : in    std_logic_vector(7 downto 0);
        write_enable    : in    std_logic;
        HADDR           : out   std_logic_vector(31 downto 0);
        HBURST          : out   std_Logic_vector(2 downto 0);
        HMASTLOCK       : out   std_logic;
        HPROT           : out   std_logic_vector(3 downto 0);
        HSIZE           : out   std_logic_vector(2 downto 0);
        HTRANS          : out   std_logic_vector(1 downto 0);
        HWDATA          : out   std_logic_vector(31 downto 0);
        HWRITE          : out   std_logic
    );
end mfp_srec_parser_to_ahb_lite_bridge;



architecture rtl of mfp_srec_parser_to_ahb_lite_bridge is

    --------------------------------------------------------------------
    -- signal declarations
    --------------------------------------------------------------------
    signal padded_write_byte : std_logic_vector(31 downto 0);
    signal write_byte_shift : std_logic_vector(4 downto 0);
    signal HWDATA_next : std_logic_vector(31 downto 0);

begin
    
    HADDR(31 downto 29) <= (others => '0');
    HADDR(28 downto 0) <= write_address(28 downto 0);
    HBURST <= std_logic_vector(to_unsigned(HBURST_SINGLE, HBURST'length));
    HMASTLOCK <= '0';
    HPROT <= (others => '0');
    HSIZE <= std_logic_vector(to_unsigned(HSIZE_1, HSIZE'length));
    HTRANS <= std_logic_vector(to_unsigned(HTRANS_NONSEQ, HTRANS'length)) when write_enable = '1' else 
              std_logic_vector(to_unsigned(HTRANS_IDLE, HTRANS'length));
    HWRITE <= write_enable;


    padded_write_byte(31 downto 8) <= (others => '0');
    padded_write_byte(7 downto 0) <= write_byte;
    
    write_byte_shift(4 downto 3) <= write_address(1 downto 0);
    write_byte_shift(2 downto 0) <= (others => '0'); 


    with to_integer(unsigned(write_byte_shift)) select
        HWDATA_next <=  padded_write_byte(31 downto 0) when 0,
                        padded_write_byte(30 downto 0) & (0 downto 0 => '0') when 1,
                        padded_write_byte(29 downto 0) & (1 downto 0 => '0') when 2,
                        padded_write_byte(28 downto 0) & (2 downto 0 => '0') when 3,
                        padded_write_byte(27 downto 0) & (3 downto 0 => '0') when 4, 
                        padded_write_byte(26 downto 0) & (4 downto 0 => '0') when 5, 
                        padded_write_byte(25 downto 0) & (5 downto 0 => '0') when 6, 
                        padded_write_byte(24 downto 0) & (6 downto 0 => '0') when 7, 
                        padded_write_byte(23 downto 0) & (7 downto 0 => '0') when 8, 
                        padded_write_byte(22 downto 0) & (8 downto 0 => '0') when 9, 
                        padded_write_byte(21 downto 0) & (9 downto 0 => '0') when 10, 
                        padded_write_byte(20 downto 0) & (10 downto 0 => '0') when 11, 
                        padded_write_byte(19 downto 0) & (11 downto 0 => '0') when 12, 
                        padded_write_byte(18 downto 0) & (12 downto 0 => '0') when 13, 
                        padded_write_byte(17 downto 0) & (13 downto 0 => '0') when 14, 
                        padded_write_byte(16 downto 0) & (14 downto 0 => '0') when 15, 
                        padded_write_byte(15 downto 0) & (15 downto 0 => '0') when 16, 
                        padded_write_byte(14 downto 0) & (16 downto 0 => '0') when 17, 
                        padded_write_byte(13 downto 0) & (17 downto 0 => '0') when 18, 
                        padded_write_byte(12 downto 0) & (18 downto 0 => '0') when 19, 
                        padded_write_byte(11 downto 0) & (19 downto 0 => '0') when 20, 
                        padded_write_byte(10 downto 0) & (20 downto 0 => '0') when 21, 
                        padded_write_byte(9 downto 0) & (21 downto 0 => '0') when 22,
                        padded_write_byte(8 downto 0) & (22 downto 0 => '0') when 23, 
                        padded_write_byte(7 downto 0) & (23 downto 0 => '0') when 24, 
                        padded_write_byte(6 downto 0) & (24 downto 0 => '0') when 25, 
                        padded_write_byte(5 downto 0) & (25 downto 0 => '0') when 26, 
                        padded_write_byte(4 downto 0) & (26 downto 0 => '0') when 27, 
                        padded_write_byte(3 downto 0) & (27 downto 0 => '0') when 28, 
                        padded_write_byte(2 downto 0) & (28 downto 0 => '0') when 29, 
                        padded_write_byte(1 downto 0) & (29 downto 0 => '0') when 30,
                        padded_write_byte(0 downto 0) & (30 downto 0 => '0') when 31,
                        (others => '0') when others;
    

    p_next : process(clock)
    begin
        if rising_edge(clock) then
            HWDATA <= HWDATA_next;
        end if;
    end process p_next;

end rtl;
