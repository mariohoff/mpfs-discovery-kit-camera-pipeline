library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity camera_control is
    Port (
        PCLK : in std_logic;
        PRESETN : in std_logic;


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
        CSI_LINE_START : in std_logic;
        CSI_LINE_VALID : in std_logic;
        CSI_ECC_ERROR : in std_logic;

        CAM_ENABLE : out std_logic;
        CAM_GPIO : out std_logic;
        
        DMA_RESETN : out std_logic;
        IOD_RESETN : out std_logic;
        
        BAYER_FORMAT : out std_logic_vector(1 downto 0)
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
begin
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
        BAYER_FORMAT => BAYER_FORMAT
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
