require "active_support/time"
require "fileutils"
require "./scripts/ziplib"



today = Time.now.beginning_of_minute
backup_limit_day = (today - 30.days).end_of_day



# バックアップ元
src = File.join(Dir.pwd, ENV["MC_SERVER_ROOT_DIR"], ENV["MC_SERVER_DIR"])
Dir.mkdir(src) unless Dir.exist?(src)
src = File.join(src, ENV["MC_WORLDS_DIR"])
Dir.mkdir(src) unless Dir.exist?(src)
src = File.join(src, ENV["MC_WORLD"])
Dir.mkdir(src) unless Dir.exist?(src)

# バックアップ先
dst = File.join(Dir.pwd, ENV["MC_SERVER_ROOT_DIR"], ENV["MC_BACKUP_WORLD_DIR"])
Dir.mkdir(dst) unless Dir.exist?(dst)
dst = File.join(dst, today.strftime("%Y-%m-%d_%H-%M") + ".zip")

# バックアップ実行(zip)
unless File.exist?(dst)
  zip_file_generator = ZipFileGenerator.new(src, dst)
  zip_file_generator.write
end

# 古いバックアップを削除
basedir = File.join(Dir.pwd, ENV["MC_SERVER_ROOT_DIR"], ENV["MC_BACKUP_WORLD_DIR"])
Dir.glob(basedir + "/*.zip") do |file|
  stat = File::Stat.new(file)
  File.delete(file) if File.exist?(file) && stat.mtime <= backup_limit_day
end
