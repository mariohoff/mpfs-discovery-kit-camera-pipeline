library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity camera_control_apb is
port (
    PCLK : in std_logic;
    PRESETN : in std_logic;

    PARALLEL_CLK : in std_logic;
    PARALLEL_RESETN : in std_logic;

    PSEL : in std_logic;
    PENABLE : in std_logic;
    PWRITE : in std_logic;
    PADDR : in std_logic_vector(31 downto 0);
    PWDATA : in std_logic_vector(31 downto 0);
    PREADY : out std_logic;
    PSLVERR : out std_logic;
    PRDATA : out std_logic_vector(31 downto 0);

    FRAME_COUNT : in std_logic_vector(31 downto 0);
    LINES_PER_FRAME : in std_logic_vector(31 downto 0);
    PIXEL_PER_LINE : in std_logic_vector(31 downto 0);
    PIXEL_PER_FRAME : in std_logic_vector(31 downto 0);
    FRAMES_PER_S : in std_logic_vector(31 downto 0);
    ERROR_COUNT : in std_logic_vector(31 downto 0);

    CAM_ENABLE : out std_logic;
    CAM_GPIO : out std_logic;
    IOD_RESETN : out std_logic;
    DMA_RESETN : out std_logic;
    COUNT_RESETN : out std_logic;
    BAYER_FORMAT : out std_logic_vector(1 downto 0)
);
end camera_control_apb;

architecture behave of camera_control_apb is
    constant C_REG_CAPTURE_REQ : std_logic_vector(7 downto 0)       := x"00";
    constant C_REG_CAM_CTRL : std_logic_vector(7 downto 0)          := x"04";
    constant C_REG_FRAME_COUNT : std_logic_vector(7 downto 0)       := x"08";
    constant C_REG_LINE_COUNT : std_logic_vector(7 downto 0)        := x"0c";
    constant C_REG_PIXEL_LINE_COUNT : std_logic_vector(7 downto 0)  := x"10";
    constant C_REG_PIXEL_COUNT : std_logic_vector(7 downto 0)       := x"14";
    constant C_REG_FRAMES_PER_S : std_logic_vector(7 downto 0)      := x"18";
    constant C_REG_ERROR_COUNT : std_logic_vector(7 downto 0)       := x"1c";
    constant C_REG_RESET_GEN : std_logic_vector(7 downto 0)         := x"20";
    constant C_REG_BAYER_FORMAT : std_logic_vector(7 downto 0)      := x"30";
    
    constant C_RESET_CYCLES : natural := 50; -- picked arbitrary
    signal cam_ctrl_reg : std_logic_vector(7 downto 0);
    signal bayer_format_reg : std_logic_vector(1 downto 0);
    
    signal iod_reset_gen : std_logic;
    signal iod_reset_done : std_logic;
    signal iod_reset_count : unsigned(7 downto 0);
    signal dma_reset_gen : std_logic;
    signal dma_reset_done : std_logic;
    signal dma_reset_count : unsigned(7 downto 0);
    signal count_reset_gen : std_logic;
    signal count_reset_ack : std_logic;
begin
    PSLVERR <= '0';
    COUNT_RESETN <= not count_reset_gen;
    IOD_RESETN <= not iod_reset_gen;
    DMA_RESETN <= not dma_reset_gen;
    CAM_ENABLE <= cam_ctrl_reg(0);
    CAM_GPIO <= cam_ctrl_reg(1);
    BAYER_FORMAT <= bayer_format_reg;

    PREADY <= PSEL and PENABLE when rising_edge(PCLK);
    
    wr_apb_p: process(PCLK, PRESETN)
        variable lower_addr: std_logic_vector(7 downto 0);
    begin
        if PRESETN = '0' then
            iod_reset_gen <= '0';
            dma_reset_gen <= '0';
            count_reset_gen <= '0';
            cam_ctrl_reg <= (others => '0');
        elsif rising_edge(PCLK) then
            lower_addr := PADDR(7 downto 0);
            
            if PENABLE = '1' and PSEL = '1' and PWRITE = '1' then
                report "[APB write] to address byte: 0x" & to_hstring(lower_addr);
                case lower_addr is
                    when C_REG_CAPTURE_REQ =>
                    when C_REG_CAM_CTRL =>
                        cam_ctrl_reg(1 downto 0) <= PWDATA(1 downto 0);
                    when C_REG_FRAME_COUNT =>
                    when C_REG_LINE_COUNT =>
                    when C_REG_PIXEL_LINE_COUNT =>
                    when C_REG_PIXEL_COUNT =>
                    when C_REG_FRAMES_PER_S =>
                    when C_REG_ERROR_COUNT =>
                    when C_REG_RESET_GEN =>
                        iod_reset_gen <= not PWDATA(0);
                        dma_reset_gen <= not PWDATA(1);
                        count_reset_gen <= not PWDATA(2);
                    when C_REG_BAYER_FORMAT =>
                        bayer_format_reg <= PWDATA(1 downto 0);
                    when others =>
                end case;
            end if;

            if iod_reset_done = '1' then
                iod_reset_gen <= '0';
            end if;
            if dma_reset_done = '1' then
                dma_reset_gen <= '0';
            end if;
            if count_reset_ack = '1' then
                count_reset_gen <= '0';
            end if;
        end if;
    end process;

    rd_apb_p: process(PCLK, PRESETN)
        variable lower_addr: std_logic_vector(7 downto 0);
        variable tmp_data : std_logic_vector(31 downto 0);
    begin
        if PRESETN = '0' then
            PRDATA <= (others => '0');
        elsif rising_edge(PCLK) then
            PRDATA <= (others => '0');
            lower_addr := PADDR(7 downto 0);
            tmp_data := (others => '0');
            
            if PENABLE = '1' and PSEL = '1' and PWRITE = '0' then
                report "[APB read] to address byte: 0x" & to_hstring(lower_addr);
                case lower_addr is
                    when C_REG_CAPTURE_REQ =>
                        tmp_data(0) := '0';
                        PRDATA <= tmp_data;
                    when C_REG_CAM_CTRL =>
                        tmp_data(1 downto 0) := cam_ctrl_reg(1 downto 0);
                        PRDATA <= tmp_data;
                    when C_REG_FRAME_COUNT =>
                        PRDATA <= FRAME_COUNT;
                    when C_REG_LINE_COUNT =>
                        PRDATA <= LINES_PER_FRAME;
                    when C_REG_PIXEL_LINE_COUNT =>
                        PRDATA <= PIXEL_PER_LINE;
                    when C_REG_PIXEL_COUNT =>
                        PRDATA <= PIXEL_PER_FRAME;
                    when C_REG_FRAMES_PER_S =>
                        PRDATA <= FRAMES_PER_S;
                    when C_REG_ERROR_COUNT =>
                        PRDATA <= ERROR_COUNT;
                    when C_REG_RESET_GEN =>
                    when C_REG_BAYER_FORMAT =>
                        tmp_data(1 downto 0) := bayer_format_reg;
                        PRDATA <= tmp_data;
                    when others =>
                        PRDATA <= (others => '0');
                end case;
                
            end if;
        end if;
    end process;

    cnt_rst_p: process(PARALLEL_CLK, PARALLEL_RESETN)
    begin
        if PARALLEL_RESETN = '0' then
            count_reset_ack <= '0';
        elsif rising_edge(PARALLEL_CLK) then
            if count_reset_gen = '1' then
                count_reset_ack <= '1';
            else
                count_reset_ack <= '0';
            end if;
        end if;
    end process;

    iod_rstn_p: process(PARALLEL_CLK, PARALLEL_RESETN)
        variable prev_reset_gen : std_logic;
    begin
        if PRESETN = '0' then
            iod_reset_done <= '0';
            iod_reset_count <= (others => '0');
            prev_reset_gen := '0';
        elsif rising_edge(PCLK) then
            iod_reset_done <= '0';

            if iod_reset_count > 0 then
                iod_reset_count <= iod_reset_count - 1;
            else
                iod_reset_done <= '1';
            end if;

            if prev_reset_gen = '0' and iod_reset_gen = '1' then
                iod_reset_count <= to_unsigned(C_RESET_CYCLES, iod_reset_count'length);
                iod_reset_done <= '0';
            end if;

            prev_reset_gen := iod_reset_gen;
        end if;
    end process;
    
    dma_rstn_p: process(PCLK, PRESETN)
        variable prev_reset_gen : std_logic;
    begin
        if PRESETN = '0' then
            dma_reset_done <= '0';
            dma_reset_count <= (others => '0');
        elsif rising_edge(PCLK) then
            dma_reset_done <= '0';

            if dma_reset_count > 0 then
                dma_reset_count <= dma_reset_count - 1;
            else
                dma_reset_done <= '1';
            end if;

            if prev_reset_gen = '0' and dma_reset_gen = '1' then
                dma_reset_count <= to_unsigned(C_RESET_CYCLES, dma_reset_count'length);
                dma_reset_done <= '0';
            end if;

            prev_reset_gen := dma_reset_gen;
        end if;
    end process;
end behave;
