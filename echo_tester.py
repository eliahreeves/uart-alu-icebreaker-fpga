import serial
import time

def test_uart_binary():
    # Configure the serial port
    ser = serial.Serial(
        port='/dev/ttyUSB1',      # Change this to match your port
        baudrate=115200,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
        bytesize=serial.EIGHTBITS,
        timeout=1                  # Read timeout in seconds
    )

    try:
        if not ser.is_open:
            ser.open()
        
        print("Serial port opened successfully")
        
        test_byte = 0
        count = 0
        while (test_byte < 256):
            ser.write(bytes([test_byte]))

            while(ser.in_waiting == 0):
                pass
            
            # Read response (expecting 1 byte)
            if ser.in_waiting >= 1:
                received_byte = int.from_bytes(ser.read(1), byteorder='big')
            if(test_byte == received_byte):
                count = count + 1
                print(f"Sent: {test_byte} Received: {received_byte}")
            test_byte = (test_byte + 1)
        print(f"{count}/256 PASSED")    
    except KeyboardInterrupt:
        print("\nExiting...")
    except serial.SerialException as e:
        print(f"Error: {e}")
    finally:
        ser.close()
        print("Serial port closed")

if __name__ == "__main__":
    test_uart_binary()