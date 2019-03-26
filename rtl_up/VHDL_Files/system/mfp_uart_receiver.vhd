-- mfp_uart_receiver.vhd
-- Translated from mfp_uart_receiver.v for MIPSfpga v2
-- 
-- 17 Feb 2017

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mipsfpga_const.all;


entity mfp_uart_receiver is
    generic (
        clock_frequency : natural := 50000000;
        baud_rate : natural := 115200
    );
    port (
        clock       : in    std_logic;
        reset_n     : in    std_logic;
        rx          : in    std_logic;
        byte_data   : out   std_logic_vector(7 downto 0);
        byte_ready  : out   std_logic
    );
end mfp_uart_receiver;



architecture rtl of mfp_uart_receiver is

    --------------------------------------------------------------------
    -- constant value definitions
    --------------------------------------------------------------------
    constant clock_cycles_in_symbol : natural := clock_frequency / baud_rate;
    
    
    --------------------------------------------------------------------
    -- signal declarations
    --------------------------------------------------------------------
    signal rx_sync, rx_sync1 : std_logic;

    signal prev_rx_sync : std_logic;
    signal start_bit_edge : std_logic;
    
    signal counter : std_logic_vector(31 downto 0);
    signal load_counter : std_logic;
    signal load_counter_value : std_logic_vector(31 downto 0);
    signal counter_done : std_logic;
    
    signal shift : std_logic;
    signal shifted_1 : std_logic_vector(7 downto 0);
    
    signal idle, idle_r : std_logic;
    signal byte_data_internal : std_logic_vector(7 downto 0);
    signal byte_ready_internal : std_logic;
    
begin

    -- Syncronize rx input to clock
    p_sync_clock : process(clock, reset_n)
    begin
        if reset_n = '0' then
            rx_sync1 <= '1';
            rx_sync  <= '1';
        elsif rising_edge(clock) then
            rx_sync1 <= rx;
            rx_sync  <= rx_sync1;
        end if;
    end process p_sync_clock;


    -- Finding edge for start bit
    p_find_edge : process(clock, reset_n)
    begin
        if reset_n = '0' then
            prev_rx_sync <= '1';
        elsif rising_edge(clock) then
            prev_rx_sync <= rx_sync;
        end if;
    end process p_find_edge;

    start_bit_edge <= prev_rx_sync AND (NOT rx_sync);


    -- Counter to measure distance between symbols
    p_measure_distance : process(clock, reset_n)
    begin
        if reset_n = '0' then
            counter <= (others => '0');
        elsif rising_edge(clock) then
            if load_counter = '1' then
                counter <= load_counter_value;
            elsif (unsigned(counter) /= 0) then
                counter <= std_logic_vector(unsigned(counter) - 1);
            end if;
        end if;
    end process p_measure_distance; 
    counter_done <= '1' when unsigned(counter) = 1 else '0';
    
    
    -- Shift register to accumulate data
    p_acumulate_data : process(clock, reset_n)
    begin
        if reset_n = '0' then
            shifted_1 <= (others => '0');
            byte_data_internal <= (others => '0');
        elsif rising_edge(clock) then
            if shift = '1' then
                if unsigned(shifted_1) = 0 then
                    shifted_1 <= "10000000";
                else
                    shifted_1 <= std_logic_vector(SHIFT_RIGHT(unsigned(shifted_1), 1));
                end if;
                
                byte_data_internal <= rx & byte_data_internal(7 downto 1);
            
            elsif byte_ready_internal = '1' then
                shifted_1 <= (others => '0');
            end if;
        end if;
    end process p_acumulate_data; 

    byte_ready_internal <= shifted_1(0);
    
    byte_ready <= byte_ready_internal;
    byte_data <= byte_data_internal;


    p_control : process(idle_r, start_bit_edge, counter_done, byte_ready_internal)
    begin
        idle <= idle_r;
        shift <= '0';
        load_counter <= '0';
        load_counter_value <= (others => '0');
    
        if idle_r = '1' then
                if start_bit_edge = '1' then
                    load_counter <= '1';
                    load_counter_value <= std_logic_vector(to_unsigned(  clock_cycles_in_symbol * 3 / 2  , load_counter_value'length));
                    idle <= '0';
                end if;
        elsif counter_done = '1' then
            shift <= '1';
            load_counter <= '1';
            load_counter_value <= std_logic_vector(to_unsigned(clock_cycles_in_symbol, load_counter_value'length));
        elsif byte_ready_internal = '1' then
            idle <= '1';
        end if;
    end process p_control;
    

    p_idle : process(clock, reset_n)
    begin
        if reset_n = '0' then
            idle_r <= '1';
        elsif rising_edge(clock) then
            idle_r <= idle;
        end if;
    end process p_idle; 

end rtl;
