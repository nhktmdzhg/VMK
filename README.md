# Fcitx5 VMK (Optimized Fork)

**Bộ gõ tiếng Việt đơn giản, hiệu năng cao dành cho Fcitx5.**

Dự án này là một bản fork được tối ưu hóa từ bộ gõ VMK gốc.

> **Lưu ý:** Phiên bản này đã loại bỏ công cụ cấu hình cũ viết bằng FLTK. Mọi cấu hình giờ đây được thực hiện trực tiếp qua giao diện chuẩn của Fcitx5 hoặc qua Menu phím tắt mới.

---

## 🚀 Các Cải Tiến Nổi Bật (Changelog)

Bản fork này thay đổi hoàn toàn kiến trúc của Server và Addon để đạt hiệu năng tốt nhất trên Linux hiện đại.

### 1. VMK Server (Backend)

Server (phần mềm chạy ngầm để giả lập phím và theo dõi chuột) đã được viết lại (Refactor) theo phong cách **System Programming**:

- **Kiến trúc Event-Driven (Sử dụng `poll`):**
  - **Cũ:** Dùng `usleep(5000)` để kiểm tra sự kiện liên tục (Polling 200Hz). Tốn CPU đánh thức hệ thống ngay cả khi không làm gì.
  - **Mới:** Chuyển sang cơ chế `poll()` với timeout `-1`. Server sẽ "ngủ đông" hoàn toàn khi không có sự kiện. **Mức tiêu thụ CPU khi nhàn rỗi là 0.0%**.

- **Single-Threaded (Đơn luồng):** Loại bỏ hoàn toàn `std::thread`. Gộp chung việc lắng nghe Socket và theo dõi Chuột (Libinput) vào một vòng lặp sự kiện duy nhất. Giảm overhead và dung lượng binary.

- **Phản hồi Thời gian thực (Real-time I/O):**
  - **Cũ:** Ghi file log chuột vào ổ cứng (có delay 1s để tránh hỏng ổ).
  - **Mới:** Ghi trực tiếp tín hiệu vào `/run` (RAM/tmpfs). Loại bỏ hoàn toàn độ trễ, tín hiệu reset bộ gõ được gửi đi ngay lập tức khi bạn chạm vào chuột/touchpad.

### 2. VMK Addon (Frontend)

Cải thiện trải nghiệm người dùng để tiện lợi hơn khi làm việc đa nhiệm:

- **Per-App Configuration (Cấu hình theo từng App):**
  - Tự động ghi nhớ chế độ gõ (Mode) cho từng ứng dụng riêng biệt.
  - _Ví dụ:_ Tự động tắt bộ gõ khi vào Terminal/Vim, tự bật vmk2 khi vào Chrome.

- **Menu Phím Tắt Thông Minh (`` ` ``):**
  - Nhấn `` ` `` (dấu huyền) để mở menu chọn nhanh chế độ ngay tại con trỏ văn bản chuẩn UI Fcitx5.
  - Trạng thái hiện tại của App được đánh dấu rõ ràng trong danh sách chọn.

---

## 📦 Cài đặt

### Arch Linux / Arch-based distro (systemd) (AUR)

Hiện tại AUR đã có đầy đủ 3 gói cài đặt:

| Gói              | Mô tả                      |
| ---------------- | -------------------------- |
| `fcitx5-vmk`     | Build từ tag release       |
| `fcitx5-vmk-bin` | Prebuilt binary            |
| `fcitx5-vmk-git` | Build theo commit mới nhất |

```bash
# Sử dụng yay
yay -S fcitx5-vmk
yay -S fcitx5-vmk-bin
yay -S fcitx5-vmk-git

# Hoặc sử dụng paru
paru -S fcitx5-vmk
paru -S fcitx5-vmk-bin
paru -S fcitx5-vmk-git
```

### Các Distro khác (Ubuntu/Fedora/Debian/openSUSE) và Arch Linux/Arch-based distro (systemd)

Bạn có thể cài đặt fcitx5-vmk thông qua Open Build Service (OBS), nơi cung cấp các package đã được biên dịch sẵn cho nhiều distro khác nhau.

#### Cách 1: Cài đặt qua Open Build Service (Khuyên dùng)

Truy cập trang [Open Build Service](https://software.opensuse.org//download.html?project=home%3Aiamnanoka&package=fcitx5-vmk) để xem hướng dẫn cài đặt chi tiết cho distro của bạn.

[![build result](https://build.opensuse.org/projects/home:iamnanoka/packages/fcitx5-vmk/badge.svg?type=percent)](https://build.opensuse.org/package/show/home:iamnanoka/fcitx5-vmk)
[![build result](https://build.opensuse.org/projects/home:iamnanoka/packages/fcitx5-vmk/badge.svg?type=default)](https://build.opensuse.org/package/show/home:iamnanoka/fcitx5-vmk)

> Lưu ý: Arch và Arch-based distro cũng có thể dùng cách cài này.

#### Cách 2: Biên dịch từ mã nguồn (Build from source)

Nếu bạn muốn biên dịch từ mã nguồn, hãy làm theo các bước sau:

##### Yêu cầu hệ thống

```bash
# Ubuntu/Debian
sudo apt-get install cmake extra-cmake-modules libfcitx5core-dev libfcitx5config-dev libfcitx5utils-dev libinput-dev libudev-dev g++ golang hicolor-icon-theme pkg-config libx11-dev

# Fedora/RHEL
sudo dnf install cmake extra-cmake-modules fcitx5-devel libinput-devel libudev-devel gcc-c++ golang hicolor-icon-theme systemd-devel libX11-devel

# openSUSE
sudo zypper install cmake extra-cmake-modules fcitx5-devel libinput-devel systemd-devel gcc-c++ go hicolor-icon-theme systemd-devel libX11-devel udev
```

##### Biên dịch và cài đặt

```bash
# Clone repository
git clone https://github.com/nhktmdzhg/VMK.git
cd VMK

# Biên dịch
make build

# Cài đặt (cần quyền root)
sudo make install

# Hoặc cài đặt vào thư mục tùy chỉnh
sudo make install PREFIX=/usr/local
```

##### Gỡ cài đặt

```bash
# Gỡ cài đặt
sudo make uninstall

# Hoặc nếu đã cài đặt với PREFIX tùy chỉnh
sudo make uninstall PREFIX=/usr/local
```

---

## 📖 Hướng dẫn sử dụng

### 1. Menu Chuyển Mode Nhanh

Khi đang ở trong bất kỳ ứng dụng nào, nhấn phím:

```
` (Phím dấu huyền)
```

Menu sẽ hiện ra cho phép bạn chọn số từ 1-6 và `` ` ``:

- **Mode 1 (Uinput):** Chế độ mặc định, tương thích tốt nhất (dùng server gửi phím xóa).
- **Mode 2 (Surrounding Text):** Dùng cơ chế xóa ký tự của ứng dụng (Tương tự Unikey).
- **Mode 3 (Preedit):** Hiện gạch chân, an toàn nhưng không tự nhiên bằng Mode 1.
- **Mode 4 (Hardcore):** Tốc độ cao nhất.
- **OFF:** Tắt bộ gõ cho ứng dụng này.
- **Xóa thiết lập cho app:** Quay về dùng cấu hình mặc định.
- **Tắt menu và gõ phím `:** Thoát menu và in ký tự dấu huyền.

### 2. Cơ chế Reset thông minh

Khi bạn click chuột hoặc chạm vào touchpad để đổi vị trí nhập liệu, bộ gõ sẽ tự động Reset trạng thái ngay lập tức. Điều này giúp tránh lỗi dính chữ cũ vào từ mới (một lỗi rất phổ biến trên các bộ gõ Linux khác).

---

## 🙏 Lời cảm ơn (Credits)

Dự án này được phát triển dựa trên ý tưởng và mã nguồn gốc của tác giả Thành (tác giả gốc của VMK).

Chân thành cảm ơn tác giả đã đặt nền móng cho một bộ gõ tiếng Việt gọn nhẹ trên Linux.

---

## 📄 License

[GPL-3.0-or-later](LICENSE)

---

## 🔗 Liên kết

- **GitHub Repository:** https://github.com/nhktmdzhg/VMK
- **Báo lỗi:** https://github.com/nhktmdzhg/VMK/issues
- **Open Build Service:** https://software.opensuse.org//download.html?project=home%3Aiamnanoka&package=fcitx5-vmk
