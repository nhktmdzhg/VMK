PREFIX ?= /usr
BINDIR = $(PREFIX)/bin
LIBDIR = $(PREFIX)/lib
DATADIR = $(PREFIX)/share
FCITX5_DATADIR = $(DATADIR)/fcitx5
ICONDIR = $(DATADIR)/icons/hicolor/scalable/apps
METAINFODIR = $(DATADIR)/metainfo
LICENSEDIR = $(DATADIR)/licenses/fcitx5-vmk
SYSTEMDDIR = $(PREFIX)/lib/systemd/system
UDEVDIR = $(PREFIX)/lib/udev/rules.d
MODULESLOADDIR = $(PREFIX)/lib/modules-load.d
SYSUSERSDIR = $(PREFIX)/lib/sysusers.d

BUILD_DIR = addon/build
SERVER_BINARY = server/fcitx5-vmk-server

CXXFLAGS += -O3 -Wall -Wextra -std=c++17 $(shell pkg-config --cflags libinput libudev)
LDFLAGS  += $(shell pkg-config --libs libinput libudev) -Wl,-z,relro -Wl,-z,now

BLUE = \033[0;34m
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
NC = \033[0m

.PHONY: all build install uninstall clean help

help:
	@echo "$(BLUE)Fcitx5 VMK - Makefile$(NC)"
	@echo ""
	@echo "$(GREEN)Các lệnh có sẵn:$(NC)"
	@echo "  make all        - Biên dịch toàn bộ dự án (mặc định)"
	@echo "  make build      - Biên dịch toàn bộ dự án"
	@echo "  make install    - Cài đặt vào hệ thống (cần sudo)"
	@echo "  make uninstall  - Gỡ cài đặt khỏi hệ thống (cần sudo)"
	@echo "  make clean      - Xóa các file build"
	@echo "  make help       - Hiển thị thông tin này"
	@echo ""
	@echo "$(YELLOW)Biến cấu hình:$(NC)"
	@echo "  PREFIX=/usr/local make install  - Cài đặt vào /usr/local thay vì /usr"
	@echo ""
	@echo "$(BLUE)Ví dụ:$(NC)"
	@echo "  sudo make install PREFIX=/usr/local"

all: build

build:
	@echo "$(BLUE)Đang compile Fcitx5 VMK Addon...$(NC)"
	@mkdir -p $(BUILD_DIR)
	@cd $(BUILD_DIR) && \
		export LDFLAGS="$(LDFLAGS)" && \
		cmake -DCMAKE_INSTALL_PREFIX=$(PREFIX) \
		-DCMAKE_BUILD_TYPE=Release \
		-DFCITX_INSTALL_PKGDATADIR=$(FCITX5_DATADIR) \
		..
	@$(MAKE) -C $(BUILD_DIR)
	@echo "$(GREEN)✓ Biên dịch Addon thành công!$(NC)"
	@echo "$(BLUE)Đang biên dịch Fcitx5 VMK Server...$(NC)"
	@g++ $(CXXFLAGS) server/src/fcitx5-vmk-server.cpp -o $(SERVER_BINARY) $(LDFLAGS)
	@echo "$(GREEN)✓ Biên dịch Server thành công!$(NC)"
	@echo "$(GREEN)✓ Biên dịch hoàn tất!$(NC)"

install: build
	@echo "$(BLUE)Đang cài đặt Fcitx5 VMK vào $(PREFIX)...$(NC)"
	
	@# Cài đặt thư viện addon
	@echo "$(YELLOW)  - Cài đặt thư viện addon...$(NC)"
	@install -Dm755 $(BUILD_DIR)/src/libvmk.so $(DESTDIR)$(LIBDIR)/fcitx5/libvmk.so
	
	@# Cài đặt cấu hình input method
	@echo "$(YELLOW)  - Cài đặt cấu hình input method...$(NC)"
	@install -Dm644 addon/config/inputmethod/vmk.conf.in $(DESTDIR)$(FCITX5_DATADIR)/inputmethod/vmk.conf
	
	@# Cài đặt cấu hình addon
	@echo "$(YELLOW)  - Cài đặt cấu hình addon...$(NC)"
	@install -Dm644 addon/config/inputmethod/vmk-addon.conf.in.in $(DESTDIR)$(FCITX5_DATADIR)/addon/vmk.conf
	
	@# Cài đặt metainfo
	@echo "$(YELLOW)  - Cài đặt metainfo...$(NC)"
	@install -Dm644 addon/config/metainfo/org.fcitx.Fcitx5.Addon.VMK.metainfo.xml.in \
		$(DESTDIR)$(METAINFODIR)/org.fcitx.Fcitx5.Addon.VMK.metainfo.xml
	
	@# Cài đặt systemd service
	@echo "$(YELLOW)  - Cài đặt systemd service...$(NC)"
	@install -Dm644 docs/fcitx5-vmk-server@.service \
		$(DESTDIR)$(SYSTEMDDIR)/fcitx5-vmk-server@.service
	
	@# Cài đặt udev rules
	@echo "$(YELLOW)  - Cài đặt udev rules...$(NC)"
	@install -Dm644 docs/99-vmk.rules $(DESTDIR)$(UDEVDIR)/99-vmk.rules
	
	@# Cài đặt modules-load config
	@echo "$(YELLOW)  - Cài đặt modules-load config...$(NC)"
	@install -Dm644 docs/module-fcitx5-vmk.conf $(DESTDIR)$(MODULESLOADDIR)/fcitx5-vmk.conf
	
	@# Cài đặt sysusers config
	@echo "$(YELLOW)  - Cài đặt sysusers config...$(NC)"
	@install -Dm644 docs/user-vmk.conf $(DESTDIR)$(SYSUSERSDIR)/vmk.conf
	
	@# Cài đặt binary server
	@echo "$(YELLOW)  - Cài đặt binary server...$(NC)"
	@install -Dm755 $(SERVER_BINARY) $(DESTDIR)$(BINDIR)/fcitx5-vmk-server
	
	@# Cài đặt icon
	@echo "$(YELLOW)  - Cài đặt icon...$(NC)"
	@install -Dm644 addon/data/icons/scalable/apps/fcitx-vmk.svg \
		$(DESTDIR)$(ICONDIR)/fcitx-vmk.svg
	@install -Dm644 addon/data/icons/scalable/apps/org.fcitx.Fcitx5.fcitx-vmk.svg \
		$(DESTDIR)$(ICONDIR)/org.fcitx.Fcitx5.fcitx-vmk.svg
	
	@# Cài đặt từ điển
	@echo "$(YELLOW)  - Cài đặt từ điển...$(NC)"
	@install -Dm644 addon/data/dictionaries/vietnamese.cm.dict \
		$(DESTDIR)$(FCITX5_DATADIR)/vmk/vietnamese.cm.dict
	
	@# Cài đặt license
	@echo "$(YELLOW)  - Cài đặt license...$(NC)"
	@install -Dm444 LICENSE $(DESTDIR)$(LICENSEDIR)/LICENSE

uninstall:
	@echo "$(BLUE)Đang gỡ cài đặt Fcitx5 VMK...$(NC)"
	
	@# Xóa thư viện addon
	@echo "$(YELLOW)  - Xóa thư viện addon...$(NC)"
	@rm -f $(DESTDIR)$(LIBDIR)/fcitx5/libvmk.so
	
	@# Xóa cấu hình input method
	@echo "$(YELLOW)  - Xóa cấu hình input method...$(NC)"
	@rm -f $(DESTDIR)$(FCITX5_DATADIR)/inputmethod/vmk.conf
	
	@# Xóa cấu hình addon
	@echo "$(YELLOW)  - Xóa cấu hình addon...$(NC)"
	@rm -f $(DESTDIR)$(FCITX5_DATADIR)/addon/vmk.conf
	
	@# Xóa metainfo
	@echo "$(YELLOW)  - Xóa metainfo...$(NC)"
	@rm -f $(DESTDIR)$(METAINFODIR)/org.fcitx.Fcitx5.Addon.VMK.metainfo.xml
	
	@# Xóa systemd service
	@echo "$(YELLOW)  - Xóa systemd service...$(NC)"
	@rm -f $(DESTDIR)$(SYSTEMDDIR)/fcitx5-vmk-server@.service
	
	@# Xóa udev rules
	@echo "$(YELLOW)  - Xóa udev rules...$(NC)"
	@rm -f $(DESTDIR)$(UDEVDIR)/99-vmk.rules
	
	@# Xóa modules-load config
	@echo "$(YELLOW)  - Xóa modules-load config...$(NC)"
	@rm -f $(DESTDIR)$(MODULESLOADDIR)/fcitx5-vmk.conf
	
	@# Xóa sysusers config
	@echo "$(YELLOW)  - Xóa sysusers config...$(NC)"
	@rm -f $(DESTDIR)$(SYSUSERSDIR)/vmk.conf
	
	@# Xóa binary server
	@echo "$(YELLOW)  - Xóa binary server...$(NC)"
	@rm -f $(DESTDIR)$(BINDIR)/fcitx5-vmk-server
	
	@# Xóa icon
	@echo "$(YELLOW)  - Xóa icon...$(NC)"
	@rm -f $(DESTDIR)$(ICONDIR)/fcitx-vmk.svg
	@rm -f $(DESTDIR)$(ICONDIR)/org.fcitx.Fcitx5.fcitx-vmk.svg

	@# Xóa từ điển
	@echo "$(YELLOW)  - Xóa từ điển...$(NC)"
	@rm -f $(DESTDIR)$(FCITX5_DATADIR)/vmk/vietnamese.cm.dict
	
	@# Xóa license
	@echo "$(YELLOW)  - Xóa license...$(NC)"
	@rm -f $(DESTDIR)$(LICENSEDIR)/LICENSE
	@rmdir $(DESTDIR)$(LICENSEDIR) 2>/dev/null || true
	
	@echo "$(GREEN)✓ Gỡ cài đặt hoàn tất!$(NC)"
	@echo "$(BLUE)Hãy khởi động lại Fcitx5 để áp dụng thay đổi:$(NC)"
	@echo "  pkill fcitx5 && fcitx5 -d"

clean:
	@echo "$(BLUE)Đang dọn dẹp các file build...$(NC)"
	@rm -rf $(BUILD_DIR)
	@rm -f $(SERVER_BINARY)
	@echo "$(GREEN)✓ Dọn dẹp hoàn tất!$(NC)"
