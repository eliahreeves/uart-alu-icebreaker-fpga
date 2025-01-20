import ctypes

# Convert hexadecimal strings to integers
dividend = int("cdffffff", 16)
divisor = int("ade6bffc", 16)

# Interpret the integers as signed 32-bit integers
dividend_signed = ctypes.c_int32(dividend).value
divisor_signed = ctypes.c_int32(divisor).value

# Perform signed integer division
result = dividend_signed // divisor_signed

# Print the result in hexadecimal format
print(hex(result))
