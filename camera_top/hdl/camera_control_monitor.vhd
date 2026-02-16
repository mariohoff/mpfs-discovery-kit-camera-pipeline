library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity camera_control_monitor is
    Generic (
        PCLK_FREQ_HZ : natural := 50_000_000
    );
    Port (
        PCLK : in std_logic;
        PRESETN : in std_logic;
        PARALLEL_CLK : in std_logic;
        PARALLEL_RESETN : in std_logic;
        COUNT_RESETN : in std_logic;

        CSI_FRAME_START : in std_logic;
        CSI_LINE_START : in std_logic;
        CSI_LINE_VALID : in std_logic;
        CSI_ECC_ERROR : in std_logic;
        -- outputs are synchronous with PCLK
        FRAME_COUNT     : out std_logic_vector(31 downto 0);
        LINES_PER_FRAME : out std_logic_vector(31 downto 0);
        PIXEL_PER_LINE  : out std_logic_vector(31 downto 0);
        PIXEL_PER_FRAME : out std_logic_vector(31 downto 0);
        FRAMES_PER_S    : out std_logic_vector(31 downto 0);
        ERROR_COUNT     : out std_logic_vector(31 downto 0)
    );
end entity camera_control_monitor;

architecture behave of camera_control_monitor is
    constant CLOCK_DIV_MAX : natural := PCLK_FREQ_HZ;
    signal frame_count_reg : unsigned(31 downto 0);
    signal line_count_reg : unsigned(31 downto 0);
    signal pixel_count_reg : unsigned(31 downto 0);
    signal pixel_line_count_reg : unsigned(31 downto 0);
    signal error_count_reg : unsigned(31 downto 0);

    signal frame_cnt_ff1, frame_cnt_ff2           : std_logic_vector(31 downto 0);
    signal lines_cnt_ff1, lines_cnt_ff2           : std_logic_vector(31 downto 0);
    signal error_cnt_ff1, error_cnt_ff2           : std_logic_vector(31 downto 0);
    signal pixel_cnt_ff1, pixel_cnt_ff2           : std_logic_vector(31 downto 0);
    signal pixel_line_cnt_ff1, pixel_line_cnt_ff2 : std_logic_vector(31 downto 0);
    
    signal time_counter : unsigned(31 downto 0);
    signal prev_frame_cnt : unsigned(31 downto 0);
    signal fps_reg : unsigned(31 downto 0);
    signal fps_ff1 : std_logic_vector(31 downto 0);
begin
    FRAME_COUNT <= frame_cnt_ff2;
    LINES_PER_FRAME <= lines_cnt_ff2;
    PIXEL_PER_LINE <= pixel_line_cnt_ff2;
    PIXEL_PER_FRAME <= pixel_cnt_ff2;
    FRAMES_PER_S <= fps_ff1;
    ERROR_COUNT <= error_cnt_ff2;
    
    fps_p : process(PCLK, PRESETN)
    begin
        if PRESETN = '0' then
            time_counter <= (others => '0');
            fps_reg <= (others => '0');
            prev_frame_cnt <= (others => '0');
        elsif rising_edge(PCLK) then
            if time_counter = 0 then
                time_counter <= to_unsigned(CLOCK_DIV_MAX-2, time_counter'length);
                
                if unsigned(frame_cnt_ff2) > prev_frame_cnt then
                    fps_reg <= (unsigned(frame_cnt_ff2) - prev_frame_cnt);
                else
                    fps_reg <= (others => '0');  -- Handle wraparound/no new frames
                end if;               
                prev_frame_cnt <= unsigned(frame_cnt_ff2);
            else
                time_counter <= time_counter - 1;
            end if;
        end if;
    end process;
    
    sync_p: process(PCLK, PRESETN)
    begin
        if PRESETN = '0' then
            frame_cnt_ff1 <= (others => '0');
            frame_cnt_ff2 <= (others => '0');
            lines_cnt_ff1 <= (others => '0');
            lines_cnt_ff2 <= (others => '0');
            error_cnt_ff1 <= (others => '0');
            error_cnt_ff2 <= (others => '0');
            pixel_cnt_ff1 <= (others => '0');
            pixel_cnt_ff2 <= (others => '0');
            pixel_line_cnt_ff1 <= (others => '0');
            pixel_line_cnt_ff2 <= (others => '0');
            fps_ff1 <= (others => '0');
        elsif rising_edge(PCLK) then
            frame_cnt_ff1 <= std_logic_vector(frame_count_reg);
            frame_cnt_ff2 <= frame_cnt_ff1;

            lines_cnt_ff1 <= std_logic_vector(line_count_reg);
            lines_cnt_ff2 <= lines_cnt_ff1;

            error_cnt_ff1 <= std_logic_vector(error_count_reg);
            error_cnt_ff2 <= error_cnt_ff1;
            
            pixel_cnt_ff1 <= std_logic_vector(pixel_count_reg);
            pixel_cnt_ff2 <= pixel_cnt_ff1;
            
            pixel_line_cnt_ff1 <= std_logic_vector(pixel_line_count_reg);
            pixel_line_cnt_ff2 <= pixel_line_cnt_ff1;
            
            fps_ff1 <= std_logic_vector(fps_reg);
        end if;
    end process;

    mon_p: process(PARALLEL_CLK, PARALLEL_RESETN)
        variable prev_frame_start, prev_line_start, prev_line_valid : std_logic;
        variable line_count_tmp  : unsigned(31 downto 0);
        variable pixel_count_tmp : unsigned(31 downto 0);
        variable pixel_line_count_tmp : unsigned(31 downto 0);
    begin
        if PARALLEL_RESETN = '0' then
            frame_count_reg         <= (others => '0');
            line_count_reg          <= (others => '0');
            pixel_count_reg         <= (others => '0');
            pixel_line_count_reg    <= (others => '0');
            error_count_reg         <= (others => '0');
            prev_frame_start := '0';
            prev_line_start := '0';
            prev_line_valid := '0';
            -- temporary counters
            line_count_tmp  := (others => '0');
            pixel_count_tmp := (others => '0');
            pixel_line_count_tmp := (others => '0');
        elsif rising_edge(PARALLEL_CLK) then

            if CSI_FRAME_START = '1' and prev_frame_start = '0' then
               frame_count_reg <= frame_count_reg + 1;
               
               line_count_reg <= line_count_tmp;
               line_count_tmp := (others => '0');
               
               pixel_count_reg <= pixel_count_tmp;
               pixel_count_tmp := (others => '0');
            end if;

            if CSI_LINE_START = '1' and prev_line_start = '0' then
                line_count_tmp := line_count_tmp + 1;
            end if;
            
            if CSI_LINE_VALID = '1' then
                pixel_count_tmp := pixel_count_tmp + 1;
                pixel_line_count_tmp := pixel_line_count_tmp + 1;
            elsif CSI_LINE_VALID = '0' and prev_line_valid = '1' then
                pixel_line_count_reg <= pixel_line_count_tmp;
                pixel_line_count_tmp := (others => '0');
            end if;

            if CSI_ECC_ERROR = '1' then
                error_count_reg <= error_count_reg + 1;
            end if;

            prev_frame_start := CSI_FRAME_START;
            prev_line_start := CSI_LINE_START;
            prev_line_valid := CSI_LINE_VALID;
            
            if COUNT_RESETN = '0' then
                frame_count_reg <= (others => '0');
                line_count_reg <= (others => '0');
                pixel_count_reg <= (others => '0');
                pixel_line_count_reg <= (others => '0');
                error_count_reg <= (others => '0');
                
                line_count_tmp  := (others => '0');
                pixel_count_tmp := (others => '0');
                pixel_line_count_tmp := (others => '0');
                prev_frame_start := '0';
                prev_line_start := '0';
            end if;
        end if;
    end process;
end architecture behave;
