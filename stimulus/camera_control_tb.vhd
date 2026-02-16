library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.env.finish;

use work.tb_utils.all;

entity camera_control_tb is
end camera_control_tb;

architecture behavioral of camera_control_tb is

    constant SYSCLK_PERIOD : time := 100 ns; -- 10MHZ

    signal apb_m : apb_master_out;
    signal apb_s : apb_slave_out;
    
    signal PARALLEL_CLK : std_logic := '0';
    signal PARALLEL_RESETN : std_logic := '0';
    signal PCLK, PRESETN : std_logic := '0';
    
    signal csi_frame_start, csi_line_start : std_logic := '0';
    signal csi_line_valid, csi_ecc_error : std_logic := '0';
    signal cam_enable, cam_gpio : std_logic;
    signal dma_resetn, iod_resetn : std_logic;
    
    constant FS_COUNT_MAX : natural := 50;
    signal fs_count : unsigned(31 downto 0);
begin
    PCLK <= not PCLK after (SYSCLK_PERIOD / 2.0 );
    PRESETN <= '0', '1' after (SYSCLK_PERIOD * 10);
    PARALLEL_CLK <= not PARALLEL_CLK after (SYSCLK_PERIOD / 1.5);
    PARALLEL_RESETN <= '0', '1' after (SYSCLK_PERIOD * 10);
    
    csi_line_start <= '0';
    csi_line_valid <= '0';
    csi_ecc_error <= '0';
    
    frame_p: process(PARALLEL_CLK)
    begin
        if rising_edge(PARALLEL_CLK) then
            if PARALLEL_RESETN = '0' then
                csi_frame_start <= '0';
                fs_count <= (others => '0');
            else
                csi_frame_start <= '0';
            
                if fs_count > 0 then
                    fs_count <= fs_count - 1;
                else
                    fs_count <= to_unsigned(FS_COUNT_MAX - 2, fs_count'length);
                    csi_frame_start <= '1';
                end if;
            end if;
        end if;
    end process;
    
    stim: process
        variable apb_dout : std_logic_vector(31 downto 0);
    begin
        apb_m.PSEL <= '0';
        apb_m.PENABLE <= '0';
        apb_m.PWRITE <= '0';
        apb_m.PADDR <= (others => '0');
        apb_m.PWDATA <= (others => '0');
        wait until PRESETN = '1';
        wait until rising_edge(PCLK);
        
        report "enabling camera";
        apb_write(PCLK, x"0000_0004", x"0000_0001", apb_m, apb_s);
        wait until rising_edge(PCLK);
        wait until rising_edge(PCLK);
        wait until rising_edge(PCLK);
        report "enabling gpio";
        apb_write(PCLK, x"0000_0004", x"0000_0003", apb_m, apb_s);
        
        wait until rising_edge(PCLK);
        wait until rising_edge(PCLK);
        wait until rising_edge(PCLK);
        wait for 80 us;
        finish;
    end process;
    
    cam_ctrl_inst: entity work.camera_control
    port map (
        PCLK => PCLK,
        PRESETN => PRESETN,
        PSEL => apb_m.PSEL,
        PENABLE => apb_m.PENABLE,
        PWRITE => apb_m.PWRITE,
        PADDR => apb_m.PADDR,
        PWDATA => apb_m.PWDATA,
        PREADY => apb_s.PREADY,
        PSLVERR => apb_s.PSLVERR,
        PRDATA => apb_s.PRDATA,
        
        PARALLEL_CLK => PARALLEL_CLK,
        PARALLEL_RESETN => PARALLEL_RESETN,
        CSI_FRAME_START => csi_frame_start,
        CSI_LINE_START => csi_line_start,
        CSI_LINE_VALID => csi_line_valid,
        CSI_ECC_ERROR => csi_ecc_error,
        
        CAM_ENABLE => cam_enable,
        CAM_GPIO => cam_gpio,
        DMA_RESETN => dma_resetn,
        IOD_RESETN => iod_resetn
    );
end behavioral;

