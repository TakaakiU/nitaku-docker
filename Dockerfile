FROM ubuntu:22.04

# 必要なパッケージのインストール
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    libglu1-mesa \
    cmake \
    clang \
    make \
    pkg-config \
    libgtk-3-dev \
    liblzma-dev \
    ninja-build \
    g++

# Flutter SDKの最新安定版（例: 3.13.0）をダウンロード＆解凍
RUN curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.29.0-stable.tar.xz -o flutter.tar.xz \
    && tar xf flutter.tar.xz -C /opt \
    && rm flutter.tar.xz

# PATHにFlutterコマンドおよびDart SDKを追加
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

# 作業ディレクトリの設定
WORKDIR /app

# pubspecファイルから依存パッケージを取得（キャッシュ活用）
COPY pubspec.* ./
# 安全なフォルダーであることを設定
RUN git config --global --add safe.directory /opt/flutter
RUN flutter pub get

# プロジェクト全体をコピー
COPY . .

# 必要に応じFlutter Webのためのポート（例: 8080）を公開
EXPOSE 8080

# デフォルトのコマンド（初期検証としてflutter doctorを実行）
CMD ["flutter", "doctor"]