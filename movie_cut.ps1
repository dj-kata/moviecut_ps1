# 実行フォルダからffmpeg.exeを実行出来るようにしておく必要があります。
# https://ffmpeg.org/download.html からWindows EXE Filesをダウンロードして解凍し、
# このスクリプトと同じフォルダにbin/ffmpeg.exeを置いてください。(他のファイルは不要)

#　アセンブリの読み込み
[void][System.Reflection.Assembly]::Load("Microsoft.VisualBasic, Version=8.0.0.0, Culture=Neutral, PublicKeyToken=b03f5f7f11d50a3a")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")

$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.Filter = "動画ファイル(*.MP4;*.MOV;*.MKV)|*.MP4;*.MOV;*.MKV;"
# 動画を置いているフォルダの絶対パスを設定してください
$dialog.Title = "ファイルを選択してください"

### ユーザ設定
##### フェードアウトの長さ(秒)
$fadelen = 2
##### 初期フォルダの設定。設定しなくてもいいですが、動画置き場フォルダを設定しておくと楽です。
$dialog.InitialDirectory = "D:\enc\otoge\"


# ファイル選択ダイアログを表示
if($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK){
  # 複数選択を許可している時は $dialog.FileNames を利用する
  Write-Output ($dialog.FileName + " が選択されました。")

  $ST = [Microsoft.VisualBasic.Interaction]::InputBox("開始位置を設定してください。形式…(h:)m:s", "開始位置の設定")
  $ED = [Microsoft.VisualBasic.Interaction]::InputBox("終了位置を設定してください。形式…(h:)m:s", "終了位置の設定")

  $arr = $ST.Split(":")
  $mul = 1 # h:m:sの変換用
  $st_sec = 0
  for ($i=$arr.Length-1; $i -ge 0; $i--){
    $st_sec += $mul * $arr[$i]
    $mul *= 60
  }
  $arr = $ED.Split(":")
  $mul = 1 # h:m:sの変換用
  $ed_sec = 0
  for ($i=$arr.Length-1; $i -ge 0; $i--){
    $ed_sec += $mul * $arr[$i]
    $mul *= 60
  }
  $duration = $ed_sec-$st_sec

  $tmp = Split-Path $dialog.Filename -Leaf

  $outputfile = $tmp + "_cut.mp4" # 出力ファイル名の設定。本スクリプトがあるフォルダ以下に生成。
  #$outputfile = $dialog.FileName + ".mp4" # 出力ファイル名を固定する場合はこちら

  $fadeoutst = $duration-$fadelen
  $fade = " -af volume=0.0dB,afade=t=in:st=0:d=$fadelen,afade=t=out:st=$fadeoutst"+":d=$fadelen -vf yadif=0:-1,fade=t=in:st=0:d=$fadelen,fade=t=out:st=$fadeoutst"+":d=$fadelen "
  # ffmpegコマンドの作成。Twitter動画向けの設定にしています。
  $cmd = "ffmpeg.exe -ss $st_sec " +"-i " + $dialog.FileName + " -hide_banner -t $duration -b:a 256k -b:v 10M -c:v h264_nvenc " + $fade + $outputfile
  Write-Output ($cmd)

  CMD /C $cmd
  [Microsoft.VisualBasic.Interaction]::MsgBox("エンコード完了!   "+$cmd) # エンコード完了のダイアログ表示。不要なら消してください。
}
