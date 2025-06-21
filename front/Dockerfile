FROM node:12.5.0-alpine

ENV HOME="/app" \
  LANG=C.UTF-8 \
  TZ=Asia/Tokyo

WORKDIR ${HOME}

# Vue CLI & npm バージョン指定（オプション）
RUN apk update && \
  apk upgrade && \
  npm install -g npm@6.14.16 && \
  npm install -g @vue/cli@4.5.19

# プロジェクトの依存ファイルを先にコピー
COPY package*.json ./

# fibersなどのビルドに必要なツールを追加
RUN apk add --no-cache python3 make g++ \
  && npm install \
  && apk del python3 make g++

# プロジェクト全体をコピー（scripts含める）
COPY . .

# ポートと起動設定
ENV HOST 0.0.0.0
EXPOSE 3000

# npm script 経由で起動（npm run dev を使う）
CMD ["npm", "run", "dev"]
