library ieee;
use ieee.std_logic_1164.all;

package tb_utils is
    type apb_master_out is record
        paddr   : std_logic_vector(31 downto 0);
        pwrite  : std_logic;
        psel    : std_logic;
        penable : std_logic;
        pwdata  : std_logic_vector(31 downto 0);
    end record;

    type apb_slave_out is record
        prdata  : std_logic_vector(31 downto 0);
        pready  : std_logic;
        pslverr : std_logic;
    end record;
    
    procedure apb_read (
        signal clk   : in  std_logic;
        address      : in  std_logic_vector(31 downto 0);
        data         : out std_logic_vector(31 downto 0);
        signal m_out : out apb_master_out;
        signal s_out : in  apb_slave_out
    );
    procedure apb_write (
        signal clk   : in  std_logic;
        address      : in  std_logic_vector(31 downto 0);
        data         : in  std_logic_vector(31 downto 0);
        signal m_out : out apb_master_out;
        signal s_out : in  apb_slave_out
    );
end package tb_utils;

package body tb_utils is    
    procedure apb_write (
        signal clk   : in  std_logic;
        address      : in  std_logic_vector(31 downto 0);
        data         : in  std_logic_vector(31 downto 0);
        signal m_out : out apb_master_out;
        signal s_out : in  apb_slave_out
    ) is
    begin
        wait until rising_edge(clk);
        m_out.paddr   <= address;
        m_out.pwrite  <= '1';
        m_out.psel    <= '1';
        m_out.pwdata  <= data;
        m_out.penable <= '0';
        m_out.penable <= '1';
        wait until rising_edge(clk);
        wait until s_out.pready = '1';
        m_out.psel    <= '0';
        m_out.penable <= '0';
    end procedure apb_write;
    
    procedure apb_read (
        signal clk   : in  std_logic;
        address      : in  std_logic_vector(31 downto 0);
        data         : out std_logic_vector(31 downto 0);
        signal m_out : out apb_master_out;
        signal s_out : in  apb_slave_out
    ) is
    begin
        wait until rising_edge(clk);
        m_out.paddr   <= address;
        m_out.pwrite  <= '0';
        m_out.psel    <= '1';
        m_out.penable <= '1';
        wait until rising_edge(clk);
        wait until s_out.pready = '1';
        data := s_out.prdata;
        m_out.psel    <= '0';
        m_out.penable <= '0';
    end procedure apb_read;
end package body tb_utils;