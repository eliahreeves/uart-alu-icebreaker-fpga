import serial
import struct

def open_conection(port: str) -> serial.Serial:
    return serial.Serial(
        port=port,
        baudrate=115200,
        bytesize=serial.EIGHTBITS,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE
    )

def close_conection(ser: serial.Serial) -> None:
    ser.close()

def echo(ser: serial.Serial, data: str) -> None:
    message_len = len(data) + 4
    ser.write(bytes([0xEC, 0x00])) 
    ser.write(bytes([message_len & 0xFF, (message_len >> 8) & 0xFF]))
    ser.write(data.encode())

def add(ser: serial.Serial, args: list[int]) -> None:
    message_len = (len(args) * 4) + 4
    ser.write(bytes([0xAD, 0x00]))
    ser.write(bytes([message_len & 0xFF, (message_len >> 8) & 0xFF]))
    data = b''.join(struct.pack('<i', x) for x in args)
    ser.write(data)

def mul(ser: serial.Serial, args: list[int]) -> None:
    message_len = (len(args) * 4) + 4
    ser.write(bytes([0xAF, 0x00]))
    ser.write(bytes([message_len & 0xFF, (message_len >> 8) & 0xFF]))
    data = b''.join(struct.pack('<i', x) for x in args)
    ser.write(data)


if __name__ == '__main__':
    raise ImportError("This is a library module and should not be run directly.")