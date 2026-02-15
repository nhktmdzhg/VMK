<a name="readme-top"></a>

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![License][license-shield]][license-url]
[![Facebook][facebook-shield]][facebook-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/nhktmdzhg/VMK">
    <img src="data/icons/scalable/apps/fcitx-vmk.svg" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Fcitx5 VMK (Nanoka)</h3>

  <p align="center">
    Bộ gõ tiếng Việt đơn giản, hiệu năng cao dành cho Fcitx5.
    <br />
    <a href="#-cài-đặt"><strong>Cài đặt »</strong></a>
    <br />
    <br />
    <a href="https://github.com/nhktmdzhg/VMK/issues/new?template=bug_report.yml">Báo lỗi</a>
    &middot;
    <a href="https://github.com/nhktmdzhg/VMK/issues/new?template=feature_request.yml">Yêu cầu tính năng</a>
    &middot;
    <a href="https://software.opensuse.org//download.html?project=home%3Aiamnanoka&package=fcitx5-vmk">Open Build Service</a>
  </p>
</div>

Dự án này là một bản fork được tối ưu hóa từ [bộ gõ VMK gốc](https://github.com/thanhpy2009/VMK). Chân thành cảm ơn tác giả Thành đã đặt nền móng cho bộ gõ này.

> **Lưu ý:** Phiên bản này đã loại bỏ công cụ cấu hình cũ viết bằng FLTK. Mọi cấu hình giờ đây được thực hiện trực tiếp qua giao diện chuẩn của Fcitx5 hoặc qua menu phím tắt mới.

---

## 📦 Cài đặt

<details>
<summary><b>Arch Linux / Arch-based distro (systemd) (AUR)</b></summary>
<br>

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

</details>

<details>
<summary><b>Các Distro khác (Ubuntu/Fedora/Debian/openSUSE) - Open Build Service</b></summary>
<br>

Bạn có thể cài đặt fcitx5-vmk thông qua Open Build Service (OBS), nơi cung cấp các package đã được biên dịch sẵn cho nhiều distro khác nhau.

#### Cài đặt qua Open Build Service (Khuyên dùng)

Truy cập trang [Open Build Service](https://software.opensuse.org//download.html?project=home%3Aiamnanoka&package=fcitx5-vmk) để xem hướng dẫn cài đặt chi tiết cho distro của bạn.

[![build result](https://build.opensuse.org/projects/home:iamnanoka/packages/fcitx5-vmk/badge.svg?type=percent)](https://build.opensuse.org/package/show/home:iamnanoka/fcitx5-vmk)
[![build result](https://build.opensuse.org/projects/home:iamnanoka/packages/fcitx5-vmk/badge.svg?type=default)](https://build.opensuse.org/package/show/home:iamnanoka/fcitx5-vmk)

Hoặc có thể xem cách cài của từng distro [tại đây](INSTALL.md).

> Lưu ý: Arch và Arch-based distro cũng có thể dùng cách cài này.

</details>

<details>
<summary><b>NixOS</b></summary>
<br>

Thêm input của fcitx5-vmk vào `flake.nix`:

```
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    fcitx5-vmk = {
      url = "github:nhktmdzhg/VMK";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
  ...
}
```

Bật fcitx5-vmk service trong `configuration.nix`:

```
{
  inputs,
  ...
}: {
  imports = [
    inputs.fcitx5-vmk.nixosModules.fcitx5-vmk
  ];

  services.fcitx5-vmk = {
    enable = true;
    user = "your_username"; # Sửa thành tên user của bạn
  };
}
```

Rebuild lại system để cài đặt.

</details>

<details>
<summary><b>Biên dịch từ nguồn (Build from source)</b></summary>
<br>

> **KHUYẾN CÁO QUAN TRỌNG:**
>
> Vui lòng **KHÔNG** sử dụng cách này nếu distro của bạn đã được hỗ trợ thông qua **OBS**.
>
> Việc biên dịch thủ công đòi hỏi bạn phải hiểu rõ về cấu trúc thư mục của hệ thống. Nếu bạn gặp lỗi "Not Available" hoặc thiếu thư viện khi cài theo cách này trên các distro phổ biến (Ubuntu/Fedora...), hãy quay lại dùng OBS để đảm bảo tính ổn định và tự động cập nhật.
>
> _Chỉ sử dụng cách này nếu distro của bạn thực sự không có trong danh sách hỗ trợ của OBS._

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
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=/usr/lib . # Tùy vào distro mà LIBDIR sẽ khác nhau
make

# Cài đặt (cần quyền root)
sudo make install

# Hoặc cài đặt vào thư mục tùy chỉnh
sudo make install PREFIX=/usr/local
```

</details>

---

## ⚙️ Bật bộ gõ

Sau khi cài đặt xong, bạn cần thực hiện các bước sau để bật bộ gõ VMK:

### 1. Bật VMK Server

Server giúp bộ gõ tương tác với hệ thống tốt hơn (đặc biệt là gửi phím xóa và sửa lỗi).

```bash
# Bật và khởi động service (tự động fix lỗi thiếu user systemd nếu có)
sudo systemctl enable --now fcitx5-vmk-server@$(whoami).service || \
(sudo systemd-sysusers && sudo systemctl enable --now fcitx5-vmk-server@$(whoami).service)
```

```bash
# Kiểm tra status (nếu thấy active (running) màu xanh là OK)
systemctl status fcitx5-vmk-server@$(whoami).service
```

### 2. Thiết lập biến môi trường

Bộ gõ sẽ không hoạt động nếu thiếu các biến này. Chạy lệnh dưới để thêm vào file cấu hình shell của bạn (`~/.bash_profile` hoặc `~/.zprofile`):

```bash
# Lệnh này sẽ thêm cấu hình vào ~/.bash_profile, với .zprofile làm tương tự
cat <<EOF >> ~/.bash_profile
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus
EOF
```

Log out và log in để áp dụng thay đổi.

<details>
<summary><b>Nếu bạn vẫn chưa gõ được sau khi Log out</b></summary>
<br>

Một số trường hợp file `~/.bash_profile` không được load, bạn có thể thử thêm vào `/etc/environment`. Cách này "mạnh tay" hơn và áp dụng cho toàn bộ hệ thống:

```bash
cat <<EOF | sudo tee -a /etc/environment
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus
EOF
```

> **Lưu ý:** Sau khi sửa file này cần khởi động lại máy.

</details>

### 3. Tắt bộ gõ cũ (IBus) và thêm Fcitx5 vào Autostart

Nếu máy bạn đang dùng IBus, hãy tắt nó đi trước khi chuyển sang Fcitx5 để tránh xung đột.

```bash
# Tắt IBus
killall ibus-daemon || ibus exit
```

Thêm `fcitx5` vào danh sách ứng dụng khởi động cùng hệ thống (Autostart).

<details>
<summary><b>Hướng dẫn Autostart cho từng môi trường (GNOME, KDE, i3...)</b></summary>
<br>

- **GNOME:** Mở _GNOME Tweaks_ → _Startup Applications_ → Add → `Fcitx 5`
- **KDE Plasma:** _System Settings_ → _Startup and Shutdown_ → _Autostart_ → Add... → Add Application... → `Fcitx 5`
- **Xfce:** _Settings_ → _Session and Startup_ → _Application Autostart_ → Add → `Fcitx 5`
- **i3/Sway:** Thêm `exec --no-startup-id fcitx5 -d` vào file config (`~/.config/i3/config` hoặc `~/.config/sway/config`)
- **Hyprland:** Thêm `exec-once = fcitx5 -d` vào `~/.config/hypr/hyprland.conf`

> **Lưu ý:** Hãy xóa autostart của IBus nếu có (thường là `ibus-daemon` hoặc `ibus`), hoặc tốt hơn là gỡ luôn ibus ra khỏi máy.

</details>

### 4. Cấu hình Fcitx5

Sau khi đã Log out và Log in lại:

1. Mở **Fcitx5 Configuration** (tìm trong menu ứng dụng hoặc chạy `fcitx5-configtool`).
2. Tìm **VMK** ở cột bên phải.
3. Nhấn mũi tên **<** để thêm nó sang cột bên trái.
4. Apply.

### 5. Cấu hình cho Wayland (KDE và Hyprland)

Nếu bạn sử dụng **Wayland**, Fcitx5 cần được cấp quyền để hoạt động như bàn phím ảo:

- **KDE Plasma (Wayland):** Vào _System Settings_ → _Keyboard_ → _Virtual Keyboard_ → Chọn **Fcitx 5**.
- **Hyprland:** Thêm dòng sau vào `~/.config/hypr/hyprland.conf`:
  ```ini
  permission = fcitx5-vmk-server, keyboard, allow
  ```
  _(Điều này cần thiết vì trên Wayland, Fcitx5 không thể hoạt động như X11)._

---

## 📖 Hướng dẫn sử dụng

### 1. Menu chuyển mode nhanh

Khi đang ở trong bất kỳ ứng dụng nào, nhấn phím **`** (dấu huyền) để mở menu chọn nhanh:

- 🚀 **Mode 1 (Uinput smooth):** Chế độ mặc định, tốc độ phản hồi cao. Sử dụng server để gửi phím xóa. _Hạn chế:_ Không tương thích với ứng dụng xử lý chậm (ví dụ: LibreOffice).
- 🐢 **Mode 2 (Uinput):** Tương tự Mode 1 nhưng tốc độ gửi phím chậm hơn. _Khuyên dùng:_ Cho các ứng dụng có tốc độ xử lý input thấp.
- 🍷 **Mode 3 (Uinput hardcore):** Biến thể của Mode 1. _Khuyên dùng:_ Chạy ứng dụng Windows qua Wine.
- ✨ **Mode 4 (Surrounding Text):** Sử dụng cơ chế Surrounding Text của ứng dụng (tối ưu cho Qt/GTK). Cho phép sửa dấu từ đã gõ và hoạt động mượt mà. _Lưu ý:_ Phụ thuộc vào sự hỗ trợ của ứng dụng (có thể không ổn định trên Firefox).
- 📝 **Mode 5 (Preedit):** Hiển thị gạch chân khi gõ. Độ tương thích cao nhất nhưng trải nghiệm không tự nhiên bằng các mode trên.
- 😃 **Emoji mode:** Chế độ tìm kiếm và nhập Emoji (nguồn EmojiOne, hỗ trợ Fuzzy Search). Xem danh sách [tại đây](data/emoji/EMOJI_GUIDE.md).
- 📴 **OFF:** Tắt bộ gõ cho ứng dụng hiện tại.
- 🔄 **Xóa thiết lập cho app:** Khôi phục cấu hình mặc định cho ứng dụng.
- 🚪 **Tắt menu và gõ phím `:** Đóng menu và nhập ký tự dấu huyền.

### 2. Cơ chế đặt lại thông minh

Khi bạn click chuột hoặc chạm vào touchpad để đổi vị trí nhập liệu, bộ gõ sẽ tự động đặt lại trạng thái ngay lập tức. Điều này giúp tránh lỗi dính chữ cũ vào từ mới (một lỗi rất phổ biến trên các bộ gõ Linux khác).

---

## 🗑️ Gỡ cài đặt

<details>
<summary><b>Arch Linux / Arch-based (AUR)</b></summary>
<br>

Dùng `pacman` để gỡ, các file config ở `$HOME` sẽ được giữ lại (đúng chuẩn Linux):

```bash
sudo pacman -Rns fcitx5-vmk
# Hoặc nếu cài bản bin/git
sudo pacman -Rns fcitx5-vmk-bin
sudo pacman -Rns fcitx5-vmk-git
```

</details>

<details>
<summary><b>Ubuntu / Fedora / openSUSE (OBS)</b></summary>
<br>

Gỡ package thông thường qua trình quản lý gói:

```bash
# Ubuntu/Debian
sudo apt remove fcitx5-vmk

# Fedora
sudo dnf remove fcitx5-vmk

# openSUSE
sudo zypper remove fcitx5-vmk
```

</details>

<details>
<summary><b>NixOS</b></summary>
<br>

Xóa (hoặc comment) dòng `services.fcitx5-vmk` và `inputs` trong file config, sau đó rebuild lại system. NixOS sẽ tự dọn dẹp.

</details>

<details>
<summary><b>Biên dịch từ nguồn (Source)</b></summary>
<br>

Vào lại thư mục source code đã build và chạy:

```bash
sudo make uninstall
```

</details>

---

## 🚀 Cải tiến nổi bật

<details>
<summary><b>Click để xem chi tiết kỹ thuật</b></summary>
<br>

Bản fork này thay đổi hoàn toàn kiến trúc của Server và Addon để đạt hiệu năng tốt nhất trên Linux hiện đại.

### 1. VMK Server (Backend)

Server (phần mềm chạy ngầm để giả lập phím và theo dõi chuột) đã được viết lại (Refactor) theo phong cách **System Programming**:

- **Kiến trúc Event-Driven (Sử dụng `poll`):**
  - **Cũ:** Dùng `usleep(5000)` để kiểm tra sự kiện liên tục (Polling 200Hz). Tốn CPU đánh thức hệ thống ngay cả khi không làm gì.
  - **Mới:** Chuyển sang cơ chế `poll()` với timeout `-1` ở mọi nơi có thể. Server sẽ "ngủ đông" hoàn toàn khi không có sự kiện. **Mức tiêu thụ CPU khi nhàn rỗi là 0.0%**.

- **Single-Threaded (Đơn luồng):** Loại bỏ hoàn toàn `std::thread`. Gộp chung việc lắng nghe Socket và theo dõi Chuột (Libinput) vào một vòng lặp sự kiện duy nhất. Giảm overhead và dung lượng binary.

- **Phản hồi Thời gian thực (Real-time I/O):**
  - **Cũ:** Ghi file log chuột vào ổ cứng (có delay 1s để tránh hỏng ổ).
  - **Mới:** Sử dụng socket để gửi tín hiệu chuột đến addon, không ghi gì vào file, nhận tín hiệu ngay lập tức.

- **Bảo mật socket:**
  - **Cũ:** File socket có quyền 666, và cả file socket và file mouse flag đều đặt ở thư mục `/home`, bất cứ ai cũng có thể gửi socket nếu biết tên file, cũng như bất cứ ai cũng có thể ghi vào file mouse flag, với phần mềm foss có file tường minh, đây là LỖ HỔNG BẢO MẬT NGHIÊM TRỌNG.
  - **Mới:**
    - Sử dụng `getsockopt` để kiểm tra tên tiến trình gửi socket, và chỉ khi nào đúng tiến trình mới xử lý tiếp, không thể giả mạo tên tiến trình.
    - Không sử dụng file socket như bình thường, mà sử dụng abstract socket, khởi tạo ngay trong kernel, không thể bị chiếm chỗ, không thể bị xóa.

### 2. VMK Addon (Frontend)

Cải thiện trải nghiệm người dùng để tiện lợi hơn khi làm việc đa nhiệm:

- **Per-App Configuration (Cấu hình theo từng App):**
  - Tự động ghi nhớ chế độ gõ (Mode) cho từng ứng dụng riêng biệt.
  - _Ví dụ:_ Tự động tắt bộ gõ khi vào Terminal/Vim, tự bật vmk2 khi vào Chrome.

- **Menu Phím Tắt Thông Minh ( ` ):**
  - Nhấn ` (dấu huyền) để mở menu chọn nhanh chế độ ngay tại con trỏ văn bản chuẩn UI Fcitx5.
  - Trạng thái hiện tại của App được đánh dấu rõ ràng trong danh sách chọn.

- **Surrounding Text có thể sửa dấu từ cũ**

- **Emoji mode**
</details>

---

## 🤝 Đóng góp

Đóng góp là điều làm cho cộng đồng mã nguồn mở trở thành một nơi tuyệt vời để học hỏi, truyền cảm hứng và sáng tạo. Mọi đóng góp của bạn đều được **đánh giá cao**.

Vui lòng xem hướng dẫn chi tiết tại [đây](CONTRIBUTING.md) để biết cách tham gia phát triển dự án, quy trình Pull Request và quy tắc code style.

Đừng quên tặng dự án một ⭐! Cảm ơn bạn rất nhiều!

### Những người đóng góp:

<a href="https://github.com/nhktmdzhg/VMK/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=nhktmdzhg/VMK" alt="contrib.rocks image" />
</a>

---

## 📃 Giấy phép

Dự án được phân phối dưới giấy phép GNU General Public License v3. Xem [`LICENSE`](LICENSE) để biết thêm chi tiết.

---

## ✨ Lịch sử sao

<a href="https://star-history.com/#nhktmdzhg/VMK&Date">
 <img src="https://api.star-history.com/svg?repos=nhktmdzhg/VMK&type=Date" alt="Star History Chart">
</a>

---

<!-- MARKDOWN LINKS & IMAGES -->

[contributors-shield]: https://img.shields.io/github/contributors/nhktmdzhg/VMK.svg?style=for-the-badge
[contributors-url]: https://github.com/nhktmdzhg/VMK/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/nhktmdzhg/VMK.svg?style=for-the-badge
[forks-url]: https://github.com/nhktmdzhg/VMK/network/members
[stars-shield]: https://img.shields.io/github/stars/nhktmdzhg/VMK.svg?style=for-the-badge
[stars-url]: https://github.com/nhktmdzhg/VMK/stargazers
[issues-shield]: https://img.shields.io/github/issues/nhktmdzhg/VMK.svg?style=for-the-badge
[issues-url]: https://github.com/nhktmdzhg/VMK/issues
[license-shield]: https://img.shields.io/github/license/nhktmdzhg/VMK.svg?style=for-the-badge
[license-url]: https://github.com/nhktmdzhg/VMK/blob/main/LICENSE
[facebook-shield]: https://img.shields.io/badge/Facebook-Group-0866FF?style=for-the-badge&logo=facebook&logoColor=white
[facebook-url]: https://www.facebook.com/groups/vietnamlinuxcommunity
