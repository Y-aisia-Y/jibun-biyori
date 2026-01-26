# スクリプトの実行中にエラーが発生した場合、即座に終了
set -o errexit

# 環境変数を強制的にproductionに設定
export RAILS_ENV=production

# 1. アセットプリコンパイルを実行
echo "--- Running assets:precompile ---"
bundle exec rake assets:precompile

# 2. データベースマイグレーションを実行
echo "--- Running db:migrate ---"
bundle exec rake db:migrate

# 3. スクリプトが成功したことを通知
echo "--- Render Build Process Complete ---"
