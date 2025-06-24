`timescale 1ns/1ps


module bt_uart (
  input            clk_pin,      // Clock input (from pin)
  input            rst_pin,        // Active HIGH reset (from pin)

  // RS232 signals
  input            rxd_pin,        // RS232 RXD pin
  output           txd_pin,        // RS232 RXD pin

  // Loopback selector
  input            lb_sel_pin,     // Loopback selector 
  

  
  output [31:0] bt_data32
);


//***************************************************************************
// Parameter definitions
//***************************************************************************

  parameter BAUD_RATE           = 9600;   

  parameter CLOCK_RATE_RX       = 100_000_000;
  parameter CLOCK_RATE_TX       = 100_000_000; 


  wire        rst_i;          
  wire        rxd_i;         
  wire        txd_o;
  wire        lb_sel_i;
  wire        spi_clk_o;
  wire        spi_mosi_o;
  wire        dac_cs_n_o;
  wire [15:0]  led_o;

  // From Clock Generator
  wire        clk_rx;         // Receive clock
  wire        clk_tx;         // Transmit clock
  wire        clk_samp;       // Sample clock
  wire        en_clk_samp;    // Enable for clk_samp, syncronous to clk_tx
  wire        clock_locked;   // Locked signal from clk_core

  // From Reset Generator
  wire        rst_clk_rx;     // Reset, synchronized to clk_rx
  wire        rst_clk_tx;     // Reset, synchronized to clk_tx
  wire        rst_clk_samp;   // Reset, synchronized to clk_samp

  // From the RS232 receiver
  wire        rxd_clk_rx;     // RXD signal synchronized to clk_rx
  wire        rx_data_rdy;    // New character is ready
  wire [7:0]  rx_data;        // New character

  // From the command parser to the response generator
  wire        send_char_val;  // A character is ready to be sent
  wire [7:0]  send_char;      // Character to be sent

  wire        send_resp_val;  // A response is requested
  wire [1:0]  send_resp_type; // Type of response - see localparams
  wire [15:0] send_resp_data; // Data to be output


  // From the response generator back to the command parser
  wire        send_resp_done;   // The response generation is complete

  // From the response generator to character FIFO
  wire [7:0]  char_fifo_din;    // Character to push into the FIFO
  wire        char_fifo_wr_en;  // Write enable (push) for the FIFO

  // From the character FIFO
  wire [7:0]  char_fifo_dout;   // Character to be popped from the FIFO
  wire        char_fifo_full;   // The character FIFO is full
  wire        char_fifo_empty;  // The character FIFO is full


  // From the UART transmitter
  wire        char_fifo_rd_en;  // Pop signal to the char FIFO
  wire        txd_tx;           // The transmit serial signal

//***************************************************************************
// Code
//***************************************************************************

  // Instantiate input/output buffers
  IBUF IBUF_rst_i0      (.I (rst_pin),      .O (rst_i));
  IBUF IBUF_rxd_i0      (.I (rxd_pin),      .O (rxd_i));
  IBUF IBUF_lb_sel_i0   (.I (lb_sel_pin),   .O (lb_sel_i));
  OBUF OBUF_txd         (.I(txd_o),         .O(txd_pin));

  // Instantiate the clock generator
  clk_gen clk_gen_i0 (
    .clk_pin         (clk_pin),         // Input clock pin - IBUFG is in core
    .rst_i           (rst_i),           // Asynchronous input from IBUF

    .rst_clk_tx      (rst_clk_tx),      // For clock divider

    .pre_clk_tx      ( ),      // Current divider

    .clk_rx          (clk_rx),          // Receive clock
    .clk_tx          (clk_tx),          // Transmit clock
    .clk_samp        ( ),        // Sample clock

    .en_clk_samp     ( ),     // Enable for clk_samp
    .clock_locked    (clock_locked)     // Locked signal from clk_core
  );

  // Instantiate the reset generator
  rst_gen rst_gen_i0 (
    .clk_rx          (clk_rx),          // Receive clock
    .clk_tx          (clk_tx),          // Transmit clock
    .clk_samp        ( ),        // Sample clock

    .rst_i           (rst_i),           // Asynchronous input - from IBUF
    .clock_locked    (clock_locked),    // Locked signal from clk_core

    .rst_clk_rx      (rst_clk_rx),      // Reset, synchronized to clk_rx
    .rst_clk_tx      (rst_clk_tx),      // Reset, synchronized to clk_tx
    .rst_clk_samp    ( )     // Reset, synchronized to clk_samp
  );

  // Instantiate the UART receiver
  uart_rx #(
    .BAUD_RATE   (BAUD_RATE),
    .CLOCK_RATE  (CLOCK_RATE_RX)
  ) uart_rx_i0 (
    .clk_rx      (clk_rx),              // Receive clock
    .rst_clk_rx  (rst_clk_rx),          // Reset, synchronized to clk_rx 

    .rxd_i       (rxd_i),               // RS232 receive pin
    .rxd_clk_rx  (rxd_clk_rx),          // RXD pin after sync to clk_rx
    
    .rx_data_rdy (rx_data_rdy),         // New character is ready
    .rx_data     (rx_data),             // New character
    .frm_err     ()                     // Framing error (unused)
  );

  // Instantiate the command parser
  cmd_parse cmd_parse_i0 (
    .clk_rx            (clk_rx),         // Clock input
    .rst_clk_rx        (rst_clk_rx),     // Reset - synchronous to clk_rx

    .rx_data           (rx_data),        // Character to be parsed
    .rx_data_rdy       (rx_data_rdy),    // Ready signal for rx_data

    // From Character FIFO
    .char_fifo_full    (char_fifo_full), // The char_fifo is full

    // To/From Response generator
    .send_char_val     (send_char_val),  // A character is ready to be sent
    .send_char         (send_char),      // Character to be sent

    .send_resp_val     (send_resp_val),  // A response is requested
    .send_resp_type    (send_resp_type), // Type of response - see localparams
    .send_resp_data    (send_resp_data), // Data to be output

    .send_resp_done    (send_resp_done), // The response generation is complete
    .bt_data16                (led_o),
	.bt_data32                (bt_data32)
  );

  // Instantiate the Response Generator
  resp_gen resp_gen_i0 (
    .clk_rx             (clk_rx),         // Clock input
    .rst_clk_rx         (rst_clk_rx),     // Reset - synchronous to clk_rx

    // From Character FIFO
    .char_fifo_full     (char_fifo_full), // The char_fifo is full

    // To/From the Command Parser
    .send_char_val      (send_char_val),  // A character is ready to be sent
    .send_char          (send_char),      // Character to be sent

    .send_resp_val      (send_resp_val),  // A response is requested
    .send_resp_type     (send_resp_type), // Type of response - see localparams
    .send_resp_data     (send_resp_data), // Data to be output

    .send_resp_done     (send_resp_done), // The response generation is complete

    // To character FIFO
    .char_fifo_din      (char_fifo_din),  // Character to push into the FIFO
    .char_fifo_wr_en    (char_fifo_wr_en) // Write enable (push) for the FIFO
  );


  // Instantiate the Character FIFO - Core generator module

  char_fifo char_fifo_i0 (
    .din        (char_fifo_din), // Bus [7 : 0] 
    .rd_clk     (clk_tx),
    .rd_en      (char_fifo_rd_en),
    .rst        (rst_i),          // ASYNCHRONOUS reset - to both sides
    .wr_clk     (clk_rx),
    .wr_en      (char_fifo_wr_en),
    .dout       (char_fifo_dout), // Bus [7 : 0] 
    .empty      (char_fifo_empty),
    .full       (char_fifo_full)
  );

  // Instantiate the UART transmitter
  uart_tx #(
    .BAUD_RATE    (BAUD_RATE),
    .CLOCK_RATE   (CLOCK_RATE_TX)
  ) uart_tx_i0 (
    .clk_tx             (clk_tx),          // Clock input
    .rst_clk_tx         (rst_clk_tx),      // Reset - synchronous to clk_tx

    .char_fifo_empty    (char_fifo_empty), // Empty signal from char FIFO (FWFT)
    .char_fifo_dout     (char_fifo_dout),  // Data from the char FIFO
    .char_fifo_rd_en    (char_fifo_rd_en), // Pop signal to the char FIFO

    .txd_tx             (txd_tx)           // The transmit serial signal
  );

  // Instantiate the loopback controller
  lb_ctl lb_ctl_i0 (
    .clk_tx     (clk_tx),          // Clock input
    .rst_clk_tx (rst_clk_tx),      // Active HIGH reset - synchronous to clk_tx

    .lb_sel_i   (lb_sel_i),        // Undebounced slide switch input

    .txd_tx     (txd_tx),          // Normal transmit data
    .rxd_clk_rx (rxd_clk_rx),      // RXD signal

    .txd_o      (txd_o)            // Transmit data to pin
  );



endmodule
