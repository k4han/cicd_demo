# 1. Sử dụng Python 3.9 bản slim để image nhẹ nhất có thể (giống version trong workflow)
FROM python:3.9-slim

# 2. Thiết lập biến môi trường
# PYTHONDONTWRITEBYTECODE: Ngăn Python tạo file .pyc (không cần thiết trong docker)
# PYTHONUNBUFFERED: Log sẽ được in ra console ngay lập tức (dễ debug trên VPS)
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 3. Tạo thư mục làm việc trong container
WORKDIR /app

# 4. Copy file requirements trước để tận dụng Docker Cache
# (Nếu code đổi nhưng thư viện không đổi, Docker sẽ bỏ qua bước cài lại thư viện -> Build siêu nhanh)
COPY requirements.txt .

# 5. Cài đặt các thư viện
RUN pip install --no-cache-dir -r requirements.txt

# 6. Copy toàn bộ code còn lại vào container
COPY . .

# 7. Khai báo port mà container sẽ lắng nghe (để khớp với -p 80:80 của bạn)
EXPOSE 3000

# 8. Lệnh chạy ứng dụng
# main:app -> file main.py, biến app
# --host 0.0.0.0 -> Bắt buộc để truy cập được từ bên ngoài container
# --port 80 -> Chạy ở cổng 80
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "3000"]
