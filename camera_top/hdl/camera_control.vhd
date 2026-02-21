library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity camera_control is
    Port (
        PCLK : in std_logic;
        PRESETN : in std_logic;

        ACLK : in std_logic;
        ARESETN : in std_logic;
        VDMA_INT : in std_logic;

        PSEL : in std_logic;
        PENABLE : in std_logic;
        PWRITE : in std_logic;
        PADDR : in std_logic_vector(31 downto 0);
        PWDATA : in std_logic_vector(31 downto 0);
        PREADY : out std_logic;
        PSLVERR : out std_logic;
        PRDATA : out std_logic_vector(31 downto 0);
        
        PARALLEL_CLK : in std_logic;
        PARALLEL_RESETN : in std_logic;

        CSI_FRAME_START : in std_logic;
        CSI_FRAME_END : in std_logic;
        CSI_LINE_START : in std_logic;
        CSI_LINE_VALID : in std_logic;
        CSI_ECC_ERROR : in std_logic;

        CAM_ENABLE : out std_logic;
        CAM_GPIO : out std_logic;
        
        DMA_RESETN : out std_logic;
        IOD_RESETN : out std_logic;
        
        BAYER_FORMAT : out std_logic_vector(1 downto 0);
        
        HRES_IN_O : out std_logic_vector(12 downto 0);
        VRES_IN_O : out std_logic_vector(12 downto 0);
        HRES_OUT_O : out std_logic_vector(12 downto 0);
        VRES_OUT_O : out std_logic_vector(12 downto 0);
        SCALER_H_FACTOR_O : out std_logic_vector(15 downto 0);
        SCALER_V_FACTOR_O : out std_logic_vector(15 downto 0)
    );
end camera_control;

architecture architecture_camera_control of camera_control is
    signal count_resetn_internal : std_logic;
    signal frame_count : std_logic_vector(31 downto 0);
    signal lines_per_frame : std_logic_vector(31 downto 0);
    signal pixel_per_line : std_logic_vector(31 downto 0);
    signal pixel_per_frame : std_logic_vector(31 downto 0);
    signal frames_per_s : std_logic_vector(31 downto 0);
    signal error_count : std_logic_vector(31 downto 0);
    
    signal int_count : unsigned(31 downto 0);
    signal int_per_s : unsigned(31 downto 0);
    signal aclk_cnt : unsigned(31 downto 0);
    signal prev_int : std_logic;
    signal prev_int_cnt : unsigned(31 downto 0);
    constant ACLK_HZ : natural := 125_000_000;
    
    signal int_count_ff, int_count_ff2 : std_logic_vector(31 downto 0);
    signal int_per_s_ff, int_per_s_ff2 : std_logic_vector(31 downto 0);
begin
    process(PCLK, PRESETN)
    begin
        if PRESETN = '0' then
            int_count_ff <= (others => '0');
            int_count_ff2 <= (others => '0');
            int_per_s_ff <= (others => '0');
            int_per_s_ff2 <= (others => '0');
        elsif rising_edge(PCLK) then
            int_count_ff <= std_logic_vector(int_count);
            int_count_ff2 <= int_count_ff;
            
            int_per_s_ff <= std_logic_vector(int_per_s);
            int_per_s_ff2 <= int_per_s_ff;
        end if;
    end process;
    
    process(ACLK, ARESETN)
    begin
        if ARESETN = '0' then
            int_count <= (others => '0');
            int_per_s <= (others => '0');
            prev_int_cnt <= (others => '0');
            prev_int <= '0';
        elsif rising_edge(ACLK) then
            if aclk_cnt = 0 then
                aclk_cnt <= to_unsigned(ACLK_HZ-2, aclk_cnt'length);
                if unsigned(int_count) > prev_int_cnt then
                    int_per_s <= (int_count - prev_int_cnt);
                else
                    int_per_s <= (others => '0');
                end if;               
                prev_int_cnt <= int_count;
            else
                aclk_cnt <= aclk_cnt - 1;
            end if;
            
            
            if prev_int = '0' and VDMA_INT = '1' then
                int_count <= int_count + 1;
            end if;
            prev_int <= VDMA_INT;
        end if;
    end process;
    
    cam_ctrl_apb_inst: entity work.camera_control_apb
    port map (
        PCLK => PCLK,
        PRESETN => PRESETN,
        PARALLEL_CLK => PARALLEL_CLK,
        PARALLEL_RESETN => PARALLEL_RESETN,

        PSEL => PSEL,
        PENABLE => PENABLE,
        PWRITE => PWRITE,
        PADDR => PADDR,
        PWDATA => PWDATA,
        PREADY => PREADY,
        PSLVERR => PSLVERR,
        PRDATA => PRDATA,
        
        INT_COUNT => int_count_ff2,
        INT_PER_S => int_per_s_ff2,
        
        CSI_FRAME_END => CSI_FRAME_END,

        FRAME_COUNT => frame_count,
        LINES_PER_FRAME => lines_per_frame,
        PIXEL_PER_LINE => pixel_per_line,
        PIXEL_PER_FRAME => pixel_per_frame,
        FRAMES_PER_S => frames_per_s,
        ERROR_COUNT => error_count,
        
        CAM_ENABLE => CAM_ENABLE,
        CAM_GPIO => CAM_GPIO,
        IOD_RESETN => IOD_RESETN,
        DMA_RESETN => DMA_RESETN,
        COUNT_RESETN => count_resetn_internal,
        BAYER_FORMAT => BAYER_FORMAT,
        
        SCALER_HRES_IN => HRES_IN_O,
        SCALER_VRES_IN => VRES_IN_O,
        SCALER_HRES_OUT => HRES_OUT_O,
        SCALER_VRES_OUT => VRES_OUT_O,
        SCALER_HFACT => SCALER_H_FACTOR_O,
        SCALER_VFACT => SCALER_V_FACTOR_O
    );

    cam_mon_inst: entity work.camera_control_monitor
    port map (
        PCLK => PCLK,
        PRESETN => PRESETN,
        PARALLEL_CLK => PARALLEL_CLK,
        PARALLEL_RESETN => PARALLEL_RESETN,
        COUNT_RESETN => count_resetn_internal,
        CSI_FRAME_START => CSI_FRAME_START,
        CSI_LINE_START => CSI_LINE_START,
        CSI_LINE_VALID => CSI_LINE_VALID,
        CSI_ECC_ERROR => CSI_ECC_ERROR,
        
        FRAME_COUNT => frame_count,
        LINES_PER_FRAME => lines_per_frame,
        PIXEL_PER_LINE => pixel_per_line,
        PIXEL_PER_FRAME => pixel_per_frame,
        FRAMES_PER_S => frames_per_s,
        ERROR_COUNT => error_count
    );
end architecture_camera_control;
