library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ksa is
    port(
        CLOCK_50            : in  std_logic;  -- Clock pin
        KEY                 : in  STD_LOGIC_VECTOR(3 downto 0);  -- Push button switches
        SW                  : in  STD_LOGIC_VECTOR(9 downto 0);  -- Slider switches
        LEDR                : out STD_LOGIC_VECTOR(9 downto 0);  -- Red lights
        HEX0                : out STD_LOGIC_VECTOR(6 downto 0);
        HEX1                : out STD_LOGIC_VECTOR(6 downto 0);
        HEX2                : out STD_LOGIC_VECTOR(6 downto 0);
        HEX3                : out STD_LOGIC_VECTOR(6 downto 0);
        HEX4                : out STD_LOGIC_VECTOR(6 downto 0);
        HEX5                : out STD_LOGIC_VECTOR(6 downto 0)
    );
end ksa;

architecture rtl of ksa is
    -- Component Declaration for SevenSegmentDisplayDecoder
    COMPONENT SevenSegmentDisplayDecoder
    PORT (
        ssOut : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        nIn : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
    END COMPONENT;

    -- Component Declaration for s_memory
    COMPONENT s_memory
    PORT (
        address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        clock   : IN STD_LOGIC;
        data    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        wren    : IN STD_LOGIC;
        q       : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
    END COMPONENT;

    -- Component Declaration for s_array_init
    COMPONENT s_array_init
    PORT (
        clk          : IN  STD_LOGIC;
        reset        : IN  STD_LOGIC;
        start_count  : IN  STD_LOGIC;
        array_address: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        data         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        write_enable : OUT STD_LOGIC;
        finish       : OUT STD_LOGIC
    );
    END COMPONENT;
	 
    -- Component Declaration for s_array_shuffle
    COMPONENT s_array_shuffle
        PORT (
            clk             : IN  STD_LOGIC;
				reset           : IN  STD_LOGIC;
            start_shuffle   : IN  STD_LOGIC;
            secret_key      : IN  STD_LOGIC_VECTOR(23 DOWNTO 0);
            q               : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            memory_address  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            data            : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            write_enable    : OUT STD_LOGIC;
            finish          : OUT STD_LOGIC
        );
    END COMPONENT;
	 
    -- Signals Declaration
    signal clk, reset_n : STD_LOGIC;
    signal address, memory_address, data, q : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal wren : STD_LOGIC;
    signal start_count, start_shuffle, write_enable, finish : STD_LOGIC;
    signal array_address : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal secret_key : STD_LOGIC_VECTOR(23 DOWNTO 0);
	 signal zeros : std_logic_vector(13 downto 0);  -- 14 zeros
	 
begin
	 zeros <= (others => '0');
	 
    -- Clock and Reset Signals
    clk <= CLOCK_50;
    reset_n <= not KEY(3);
	 
	 --start_count <= not KEY(0);
	 start_shuffle <= not KEY(0);
	 secret_key <= zeros & SW;

    -- Instantiation of s_memory
    memory_instance: s_memory
    PORT MAP (
        address => array_address,
        clock   => CLOCK_50,
        data    => data,
        wren    => write_enable,
        q       => q
    );

    -- Instantiation of s_array_init
    array_init_instance: s_array_init
    PORT MAP (
        clk          => CLOCK_50,
        reset        => reset_n,
        start_count  => start_count,
        array_address=> array_address,
        data         => data,
        write_enable => write_enable,
        finish       => finish
    );

    -- Instantiation of s_array_shuffle
    shuffle_instance : s_array_shuffle
        PORT MAP (
            clk             => CLOCK_50,
				reset           => reset_n,
            start_shuffle   => start_shuffle,
            secret_key      => secret_key,
            q               => q,
            memory_address  => memory_address,
            data            => data,
            write_enable    => write_enable,
            finish          => finish
        );
 
end rtl;