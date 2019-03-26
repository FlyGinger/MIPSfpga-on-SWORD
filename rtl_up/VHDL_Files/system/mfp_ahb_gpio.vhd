-- mfp_ahb_gpio.vhd
-- Translated from mfp_ahb_gpio.v for MIPSfpga v2
-- 
-- 15 Jan 2017
--
-- General-purpose I/O module for Digilent's (Xilinx) Nexys4-DDR board
--
-- Digilent's (Xilinx) Nexys4-DDR board:
-- Outputs:
-- 15 LEDs (IO_LED[14:0]) 
-- Inputs:
-- 15 slide switches (IO_Switch[14:0]), 
-- 5 pushbutton switches (IO_PB)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mipsfpga_const.all;



entity mipsfpga_ahb_gpio is
    port (
        HCLK        : in    std_logic;
        HRESETn     : in    std_logic;
        HADDR       : in    std_logic_vector(3 downto 0);
        HTRANS      : in    std_logic_vector(1 downto 0);
        HWDATA      : in    std_logic_vector(31 downto 0);
        HWRITE      : in    std_logic;
        HSEL        : in    std_logic;
        HRDATA      : out   std_logic_vector(31 downto 0);
        
        IO_Switch   : in    std_logic_vector(MFP_N_SW-1 downto 0);
        IO_PB       : in    std_logic_vector(MFP_N_PB-1 downto 0);
        IO_LED      : out   std_logic_vector(MFP_N_LED-1 downto 0)
    );
end mipsfpga_ahb_gpio;





architecture rtl of mipsfpga_ahb_gpio is

    --------------------------------------------------------------------
    -- signal declarations
    --------------------------------------------------------------------
    signal HADDR_d : std_logic_vector(3 downto 0);
    signal HWRITE_d : std_logic;
    signal HSEL_d : std_logic;
    signal HTRANS_d : std_logic_vector(1 downto 0);
    signal we : std_logic;

begin

    -- delay HADDR, HWRITE, HSEL, and HTRANS to align with HWDATA for writing
    p_delay : process(HCLK)
    begin
        if rising_edge(HCLK) then
            HADDR_d <= HADDR;
            HWRITE_d <= HWRITE;
            HSEL_d <= HSEL;
            HTRANS_d <= HTRANS;
        end if;
    end process p_delay;

    -- overall write enable signal
    we <= '1' when (unsigned(HTRANS_d) /= HTRANS_IDLE) and (HSEL_d = '1') and (HWRITE_d = '1') else '0';

    p_ioleds : process(HCLK, HRESETn)
    begin
        if (HRESETn = '0') then
            IO_LED <= (others => '0');
        elsif rising_edge(HCLK) then
            if (we = '1') then
                case to_integer(unsigned(HADDR_d)) is
                    when H_LED_IONUM   =>  IO_LED <= HWDATA(MFP_N_LED-1 downto 0);
                    when others =>
                end case;
            end if;
        end if;
    end process p_ioleds;


    p_hrdata : process(HCLK, HRESETn)
    begin
        if (HRESETn = '0') then
            HRDATA <= (others => '0');
        elsif rising_edge(HCLK) then
            case to_integer(unsigned(HADDR)) is
                when H_SW_IONUM  => HRDATA <= (31 downto MFP_N_SW => '0') & IO_Switch;
                when H_PB_IONUM  => HRDATA <= (31 downto MFP_N_PB => '0') & IO_PB;
                when others      => HRDATA <= (others => '0');
            end case;
        end if;
    end process p_hrdata;

end rtl;
