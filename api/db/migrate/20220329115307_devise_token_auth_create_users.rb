class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[6.1]
  def change
    
    create_table(:users) do |t|
      ## Required
      t.string :provider, null: false, default: 'email', comment: '認証方法'
      t.string :uid,      null: false, default: '',      comment: 'UID'

      ## Database authenticatable
      t.string :encrypted_password, null: false, default: '', comment: '認証方法'

      ## Recoverable
      t.string   :reset_password_token,                  comment: 'パスワードリセットトークン'
      t.datetime :reset_password_sent_at,                comment: 'パスワードリセット送信日時'
      t.boolean  :allow_password_change, default: false, comment: 'パスワード再設定中'

      ## Rememberable
      t.datetime :remember_created_at, comment: 'ログイン状態維持開始日時'

      ## Confirmable
      t.string   :confirmation_token,   comment: 'メールアドレス確認トークン'
      t.datetime :confirmed_at,         comment: 'メールアドレス確認日時'
      t.datetime :confirmation_sent_at, comment: 'メールアドレス確認送信日時'
      t.string   :unconfirmed_email,    comment: '確認待ちメールアドレス' # Only if using reconfirmable

      ## Trackable
      t.integer  :sign_in_count, null: false, default: 0, comment: 'ログイン回数'
      t.datetime :current_sign_in_at,                     comment: '現在のログイン日時'
      t.datetime :last_sign_in_at,                        comment: '最終ログイン日時'
      t.string   :current_sign_in_ip,                     comment: '現在のログインIPアドレス'
      t.string   :last_sign_in_ip,                        comment: '最終ログインIPアドレス'

      ## Lockable
      t.integer  :failed_attempts, null: false, default: 0, comment: '連続ログイン失敗回数' # Only if lock strategy is :failed_attempts
      t.string   :unlock_token,                             comment: 'アカウントロック解除トークン' # Only if unlock strategy is :email or :both
      t.datetime :locked_at,                                comment: 'アカウントロック日時'

      ## User Info
      t.string :name,  null: false, limit: 30,   comment: '氏名'
      t.string :image,                           comment: '画像'
      t.string :email, null: false, default: '', comment: 'メールアドレス'

      ## Tokens
      t.text :tokens, comment: '認証トークン'

      t.timestamps
    end

    add_index :users, :email,                unique: true
    add_index :users, [:uid, :provider],     unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true
  end
end
