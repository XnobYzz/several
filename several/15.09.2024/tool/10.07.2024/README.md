## Mẫu mã về key 1 ngày

### Cách có dài dòng, phức tạp nên hãy tham khảo thôi nhé !!

```python
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes
from cryptography.fernet import Fernet
import base64, json, pytz, os, random, string
from datetime import datetime, timedelta

def generate_random(length=7):
    characters = string.ascii_letters + string.digits
    return ''.join(random.choice(characters) for _ in range(length))

key = f"XIE_{generate_random()}"
url_key = f"https://elvis.com.hr/getkey/xnobyzz&key={key}"

# hãy gắn api rút gọn link rồi sau đó in ra màn hình để người dùng vượt link ( Link ở đích là "url_key" ) -> xác minh

timezone = pytz.timezone('Asia/Ho_Chi_Minh')
current_time = datetime.now(timezone)
future_time = current_time + timedelta(hours=24)

def generate(password: str) -> bytes:
    salt = b'\x8d\x8cZ\x19\xbf\xe1\x8c\x03\xbb\x93X\xa9\xe3\x9b\x02\xd1'
    kdf = PBKDF2HMAC(
        algorithm=hashes.SHA256(),
        length=32,
        salt=salt,
        iterations=100000,
        backend=default_backend()
    )
    return base64.urlsafe_b64encode(kdf.derive(password.encode()))

def encrypt(message: str, password: str) -> str:
    key = generate(password)
    fernet = Fernet(key)
    return fernet.encrypt(message.encode('utf-8')).decode('utf-8')

def decrypt(encrypted: str, password: str) -> str:
    key = generate(password)
    fernet = Fernet(key)
    return fernet.decrypt(encrypted.encode('utf-8')).decode('utf-8')

password = "Ex_XIE1582"

def write_log(key: str, end_time: str):
    data = {
        "log": key,
        "time": end_time
    }
    with open('log.json', 'w') as json_file:
        json.dump(data, json_file, indent=4)

def read_log(file_log: str) -> dict:
    if not os.path.exists(file_log):
        return {}
    
    with open(file_log, 'r') as file:
        try:
            return json.load(file)
        except json.JSONDecodeError:
            return {}

def check_key(input_key: str) -> bool:
    data = read_log('log.json')
    now_time = current_time.strftime("%d:%m:%Y:%H:%M:%S")
    decrypted_k = decrypt(data.get("log", ''), password) if "log" in data else None
    decrypted_t = decrypt(data.get("time", ''), password) if "time" in data else None
    end_time = future_time.strftime("%d:%m:%Y:%H:%M:%S")
    if input_key == key:
        encrypted_k = encrypt(input_key, password)
        encrypted_t = encrypt(end_time, password)
        write_log(encrypted_k, encrypted_t)
        print("Key đúng.")
        return True
    elif input_key == decrypted_k:
        if decrypted_t is None:
            return False
        if now_time >= decrypted_t:
            print("Key đã hết hạn.")
            return False
        else:
            return True
    else:
        print("Key không đúng.")
        return False

def log_key():
    data = read_log('log.json')
    old_key = decrypt(data.get("log", ''), password) if "log" in data else None
    if check_key(old_key):
        print("Bạn đã nhập key.")
    else:
        check_key(input("Nhập key: "))
        exit()

if __name__ == "__main__":
    log_key()
```
