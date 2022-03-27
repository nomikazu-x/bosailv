# コンソール起動時
if defined? Rails::Console && defined? Hirb
  # Hirb.enableの有効化
  Hirb.enable
end
