
package config_pkg;

  typedef enum logic [4:0] {
    GET_OP_CODE,
    HANDLE_RES,
    GET_LENGTH_LSB,
    GET_LENGHT_MSB,
    GET_INITIAL_OPERAND,
    GET_OPERAND,
    ADD,
    MUL,
    // DIV,
    ECHO,
    TRANSMIT

  } state_t;

endpackage
