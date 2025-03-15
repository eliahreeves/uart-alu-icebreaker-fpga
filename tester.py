import testing_library as test_lib
def test_echo():
    test_lib.open_conection('/dev/ttyUSB1')
    try:
        test_lib.echo("hello")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        test_lib.close_conection()

if __name__ == "__main__":
    test_echo()
