# Minecraft Server (Docker for Windows)



## 概要

- 動作環境はDocker for Windows
- Dockerコンテナ内にマイクラサーバーを構築
- Switchからアクセスできる事
    - DNSの書き換えを行えばSwitchからでも自分で建てたサーバーへとアクセス可能
- DNSサーバーはdnsmasqを使う
- ワールドバックアップは毎日自動で行われる
    - backup.batをダブルクリックでもバックアップ可能
    - ワールドバックアップは30日間まで保持される(30日より古いデータは古い順から削除される)
        - zipファイルをバックアップ対象としてカウントしてるので、削除されたくないデータは解凍してフォルダのままにしておくと削除はされない
- サーバーのアップデート機能
    - MinecraftサーバーとConnectサーバーの2つのアップデートを行う
    - update.batをダブルクリックでアップデート可能
    - アップデート自体はversion.txtに記載しているバージョンと公開されている最新バージョンを比較して行われる
- 各種ポートは `docker-compose.yml` ファイルに記載してある



## 環境変数(.env)

| 変数 | 説明 |
|----------|----------|
| MC_WORLD | TODO |
| MC_SERVER_ROOT_DIR | Minecraftサーバーのルートディレクトリ名 |
| MC_SERVER_DIR | Minecraftサーバー自体のディレクトリ名 |
| MC_WORLDS_DIR | ワールドのルートディレクトリ名 |
| MC_BACKUP_WORLD_DIR | ワールドバックアップ先のディレクトリ名 |
| MC_CONNECT_SERVER_ROOT_DIR | Connectサーバーのルートディレクトリ名 |



## 使い方

1. このリポジトリをCloneしてディレクトリ移動
2. `docker-compose run --rm backup_update bash /app/scripts/update.sh`
2. `docker-compose up -d`
3. 

## TODO

- [ ] 複数ワールドのバックアップ機能
- [ ] 環境変数`MC_WORLD`を使ってワールドを切り替えできるようにしたい
- [ ] dns/hosts-dnsmasqファイルに記載してあるIPを環境変数から動的に変えたい
- [ ] 同じく、connect_server/custom_servers.jsonもIPを動的変更したい
