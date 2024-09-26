### 1. **Cấu trúc cơ sở dữ liệu**:

Bảng MySQL:
```sql
CREATE TABLE urls (
    id INT AUTO_INCREMENT PRIMARY KEY,
    original_url TEXT NOT NULL,
    short_code VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 2. **(HTML + Form)**:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>URL Shortener</title>
</head>
<body>
    <h1>URL Shortener</h1>
    <form action="shorten.php" method="post">
        <label for="url">Enter URL to shorten:</label>
        <input type="text" name="url" id="url" required>
        <button type="submit">Shorten</button>
    </form>
</body>
</html>
```

### 3. **PHP xử lý rút gọn liên kết**:

#### (`shorten.php`):
```php
<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "url_shortener";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

function gscode($length = 6) {
    return substr(str_shuffle("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"), 0, $length);
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $original_url = trim($_POST['url']);
    if (!filter_var($original_url, FILTER_VALIDATE_URL)) {
        echo "Invalid URL!";
        exit;
    }

    $short_code = gscode();
    $stmt = $conn->prepare("SELECT id FROM urls WHERE short_code = ?");
    $stmt->bind_param("s", $short_code);
    $stmt->execute();
    $stmt->store_result();

    while ($stmt->num_rows > 0) { // Nếu mã đã tồn tại, tạo mã mới
        $short_code = gscode();
        $stmt->bind_param("s", $short_code);
        $stmt->execute();
        $stmt->store_result();
    }

    $stmt = $conn->prepare("INSERT INTO urls (original_url, short_code) VALUES (?, ?)");
    $stmt->bind_param("ss", $original_url, $short_code);
    if ($stmt->execute()) {
        echo "Shortened URL: <a href='http://yourdomain.com/" . $short_code . "'>http://yourdomain.com/" . $short_code . "</a>";
    } else {
        echo "Error: " . $conn->error;
    }

    $stmt->close();
}
$conn->close();
?>
```

### 4. **Chuyển hướng liên kết ngắn**:

#### Mã PHP (`redirect.php`):
```php
<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "url_shortener";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$short_code = trim($_GET['code']);
$stmt = $conn->prepare("SELECT original_url FROM urls WHERE short_code = ?");
$stmt->bind_param("s", $short_code);
$stmt->execute();
$stmt->bind_result($original_url);
$stmt->fetch();

if ($original_url) {
    header("Location: " . $original_url);
    exit;
} else {
    echo "URL not found!";
}

$stmt->close();
$conn->close();
?>
```

### 5. **Cấu hình `.htaccess`**:

#### file `.htaccess`:
```htaccess
RewriteEngine On
RewriteRule ^([a-zA-Z0-9]{6})$ redirect.php?code=$1 [L]
```
