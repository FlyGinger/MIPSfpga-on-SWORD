-- mfp_ahb_p_ram.vhd
-- Translated from mfp_ahb_p_ram.v for MIPSfpga v2
-- 
-- 15 Jan 2017

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mipsfpga_const.all;


entity mfp_ahb_p_ram is
    port(
        HCLK        : in    std_logic;
        HRESETn     : in    std_logic;
        HADDR       : in    std_logic_vector(31 downto 0);
        HBURST      : in    std_logic_vector(2 downto 0);
        HMASTLOCK   : in    std_logic;
        HPROT       : in    std_logic_vector(3 downto 0);
        HSIZE       : in    std_logic_vector(2 downto 0);
        HTRANS      : in    std_logic_vector(1 downto 0);
        HWDATA      : in    std_logic_vector(31 downto 0);
        HWRITE      : in    std_logic;
        HRDATA      : out   std_logic_vector(31 downto 0);
        HSEL        : in    std_logic
    );
end mfp_ahb_p_ram;
    
    
    
architecture rtl of mfp_ahb_p_ram is
    
    --------------------------------------------------------------------
    -- component declarations
    --------------------------------------------------------------------
    component ram_p0 is
        generic (
            DATA_WIDTH : natural := 8;
            ADDR_WIDTH : natural := 6
        );
        port (
            data        : in    std_logic_vector(DATA_WIDTH-1 downto 0);
            read_addr   : in    std_logic_vector(ADDR_WIDTH-1 downto 0);
            write_addr  : in    std_logic_vector(ADDR_WIDTH-1 downto 0);
            we          : in    std_logic; 
            clk         : in    std_logic;
            q           : out   std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component ram_p0;
    
    component ram_p1 is
        generic (
            DATA_WIDTH : natural := 8;
            ADDR_WIDTH : natural := 6
        );
        port (
            data        : in    std_logic_vector(DATA_WIDTH-1 downto 0);
            read_addr   : in    std_logic_vector(ADDR_WIDTH-1 downto 0);
            write_addr  : in    std_logic_vector(ADDR_WIDTH-1 downto 0);
            we          : in    std_logic; 
            clk         : in    std_logic;
            q           : out   std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component ram_p1;
 
    component ram_p2 is
        generic (
            DATA_WIDTH : natural := 8;
            ADDR_WIDTH : natural := 6
        );
        port (
            data        : in    std_logic_vector(DATA_WIDTH-1 downto 0);
            read_addr   : in    std_logic_vector(ADDR_WIDTH-1 downto 0);
            write_addr  : in    std_logic_vector(ADDR_WIDTH-1 downto 0);
            we          : in    std_logic; 
            clk         : in    std_logic;
            q           : out   std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component ram_p2;
    
    component ram_p3 is
        generic (
            DATA_WIDTH : natural := 8;
            ADDR_WIDTH : natural := 6
        );
        port (
            data        : in    std_logic_vector(DATA_WIDTH-1 downto 0);
            read_addr   : in    std_logic_vector(ADDR_WIDTH-1 downto 0);
            write_addr  : in    std_logic_vector(ADDR_WIDTH-1 downto 0);
            we          : in    std_logic; 
            clk         : in    std_logic;
            q           : out   std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component ram_p3;
    
    
    --------------------------------------------------------------------
    -- signal declarations
    --------------------------------------------------------------------
    signal HADDR_d : std_logic_vector(31 downto 0);
    signal HWRITE_d : std_logic;
    signal HSEL_d : std_logic;
    signal HTRANS_d : std_logic_vector(1 downto 0);
    signal we : std_logic;                          -- write enable
    signal we_mask : std_logic_vector(3 downto 0);  -- sub-word write mask
    signal we_mask_1 : std_logic_vector(3 downto 0);
    signal we_mask_2 : std_logic_vector(3 downto 0);
    
begin

    p_delay : process(HCLK)
    begin
        if rising_edge(HCLK) then
            HADDR_d <= HADDR;
            HWRITE_d <= HWRITE;
            HSEL_d <= HSEL;
            HTRANS_d <= HTRANS;
        end if;
    end process p_delay;

    we <= '1' when (unsigned(HTRANS_d) /= HTRANS_IDLE) and (HSEL_d = '1') and (HWRITE_d = '1') else '0';


    -- write enable mask when hsize = hsize_1
    we_mask_1 <= "0001" when unsigned(HADDR(1 downto 0)) = 0 else
                 "0010" when unsigned(HADDR(1 downto 0)) = 1 else
                 "0100" when unsigned(HADDR(1 downto 0)) = 2 else
                 "1000" when unsigned(HADDR(1 downto 0)) = 3 else
                 "0000";

    -- write enable mask when hsize = hsize_2
    we_mask_2 <= "1100" when HADDR(1) = '1' else
                 "0011";
    

    we_mask <= "0000" when we = '0' else
               we_mask_1 when (unsigned(HBURST) = HBURST_SINGLE) and (unsigned(HSIZE) = HSIZE_1) else
               we_mask_2 when (unsigned(HBURST) = HBURST_SINGLE) and (unsigned(HSIZE) = HSIZE_2) else
               "1111";


    ram_p0_i : ram_p0
        generic map (
            DATA_WIDTH => 8,
            ADDR_WIDTH => H_RAM_ADDR_WIDTH
        ) 
        port map (
            data        => HWDATA(7 downto 0),
            read_addr   => HADDR(H_RAM_ADDR_WIDTH+1 downto 2),
            write_addr  => HADDR_d(H_RAM_ADDR_WIDTH+1 downto 2),
            we          => we_mask(0),
            clk         => HCLK,
            q           => HRDATA(7 downto 0)
        );

    ram_p1_i : ram_p1
        generic map (
            DATA_WIDTH => 8,
            ADDR_WIDTH => H_RAM_ADDR_WIDTH
        ) 
        port map (
            data        => HWDATA(15 downto 8),
            read_addr   => HADDR(H_RAM_ADDR_WIDTH+1 downto 2),
            write_addr  => HADDR_d(H_RAM_ADDR_WIDTH+1 downto 2),
            we          => we_mask(1),
            clk         => HCLK,
            q           => HRDATA(15 downto 8)
        );

    ram_p2_i : ram_p2
        generic map (
            DATA_WIDTH => 8,
            ADDR_WIDTH => H_RAM_ADDR_WIDTH
        ) 
        port map (
            data        => HWDATA(23 downto 16),
            read_addr   => HADDR(H_RAM_ADDR_WIDTH+1 downto 2),
            write_addr  => HADDR_d(H_RAM_ADDR_WIDTH+1 downto 2),
            we          => we_mask(2),
            clk         => HCLK,
            q           => HRDATA(23 downto 16)
        );

    ram_p3_i : ram_p3
        generic map (
            DATA_WIDTH => 8,
            ADDR_WIDTH => H_RAM_ADDR_WIDTH
        ) 
        port map (
            data        => HWDATA(31 downto 24),
            read_addr   => HADDR(H_RAM_ADDR_WIDTH+1 downto 2),
            write_addr  => HADDR_d(H_RAM_ADDR_WIDTH+1 downto 2),
            we          => we_mask(3),
            clk         => HCLK,
            q           => HRDATA(31 downto 24)
        );

end rtl;
