import serial
import struct
connection = None
def open_conection(port: str) -> None:
    global connection 
    connection = serial.Serial(
        port=port,
        baudrate=115200,
        bytesize=serial.EIGHTBITS,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE
    )

def close_conection() -> None:
    global connection
    if connection is not None:
        connection.close()
        connection = None
    

def echo(data: str) -> None:
    global connection
    if connection is not None:
        message_len = len(data) + 4
        connection.write(bytes([0xEC, 0x00])) 
        connection.write(bytes([message_len & 0xFF, (message_len >> 8) & 0xFF]))
        connection.write(data.encode())

def add(args: list[int]) -> None:
    global connection
    if connection is not None:
        message_len = (len(args) * 4) + 4
        connection.write(bytes([0xAD, 0x00]))
        connection.write(bytes([message_len & 0xFF, (message_len >> 8) & 0xFF]))
        data = b''.join(struct.pack('<i', x) for x in args)
        connection.write(data)

def mul(args: list[int]) -> None:
    global connection
    if connection is not None:
        message_len = (len(args) * 4) + 4
        connection.write(bytes([0xAF, 0x00]))
        connection.write(bytes([message_len & 0xFF, (message_len >> 8) & 0xFF]))
        data = b''.join(struct.pack('<i', x) for x in args)
        connection.write(data)

def div(n: int, d: int) -> None:
    global connection
    if connection is not None:
        message_len = 12
        connection.write(bytes([0xF6, 0x00]))
        connection.write(bytes([message_len & 0xFF, (message_len >> 8) & 0xFF]))
        connection.write(struct.pack('<ii', n, d))

if __name__ == '__main__':
    raise ImportError("This is a library module and should not be run directly.")
