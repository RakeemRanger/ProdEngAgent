def check_user(pin: str) -> bool:
    get_pin_len = len(pin)
    if get_pin_len != 10:
        return False
    return True


def test_pin_check():
    sample_pin_len = check_user('4095949495')
    assert sample_pin_len == True