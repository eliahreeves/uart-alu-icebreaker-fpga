
package config_pkg;

  typedef enum logic [4:0] {
    GET_OP_CODE,
    HANDLE_RES,
    GET_LENGTH_LSB,
    GET_LENGHT_MSB,
    ADD,
    // MUL,
    // DIV,
    ECHO,
    TRANSMIT

  } state_t;


  //used in message_len.sv
  //typedef enum logic {
  //  LSB,
  //  MSB
  //} message_len_state_t;

endpackage
