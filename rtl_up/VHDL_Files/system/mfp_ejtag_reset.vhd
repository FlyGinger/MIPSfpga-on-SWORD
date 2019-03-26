-- mfp_ejtag_reset.vhd
-- Translated from mfp_ejtag_reset.v for MIPSfpga v2
-- 
-- 14 Jan 2017

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mipsfpga_const.all;


entity mfp_ejtag_reset is
    port (
        clk     : in    std_logic;
        trst_n  : out   std_logic
    );
end mfp_ejtag_reset;
    

    
architecture rtl of mfp_ejtag_reset is

    --------------------------------------------------------------------
    -- signal declarations
    --------------------------------------------------------------------
    signal trst_delay : std_logic_vector(3 downto 0);

begin 

    p_count : process (clk)
    begin
        if rising_edge(clk) then
            if (trst_delay = "1111") then
                trst_n <= '1';
            else
                trst_n <= '0';
                trst_delay <= std_logic_vector(unsigned(trst_delay) + 1);
            end if;
        end if;
    end process p_count;

end rtl;
