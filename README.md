# moviecut_ps1
PowerShell+ffmpegで動画カットをするためのスクリプト(Windows向け)
Windows10(21H2)でのみ動作確認しています。

# 使い方
1. [PowerShellスクリプト](https://raw.githubusercontent.com/dj-kata/moviecut_ps1/main/movie_cut.ps1)を保存する。  初期フォルダやフェードの長さは必要に応じて書き換えてください。
2. ffmpeg.exeを準備する
3. 保存したmovie_cut.ps1を実行する。
4. 動画を選択する
5. カットの始点・終点を入力する。1:25:10、39:30のようなフォーマットが使用可能です。
6. スクリプトと同じフォルダにカット後の動画が出力されます。

## ffmpeg.exeの準備について
[公式サイト](https://ffmpeg.org/download.html)のWindows EXE Filesをダウンロード・解凍し、  
中にある```bin\ffmpeg.exe```をmovie_cut.ps1と同じフォルダに置いてください。

わかる人は、パスが通っているディレクトリにインストールする、でも大丈夫です。

## PowerShellスクリプトを楽に実行する方法
以下のように設定すると、ps1ファイルをダブルクリックするだけで実行可能です。
レジストリを弄る必要があるので、自己責任でお願いします。

1. レジストリエディタを起動(regeditを検索して実行)
2. ```コンピューター\HKEY_CLASSES_ROOT\Microsoft.PowerShellScript.1\Shell```に移動
3. Openとなっているデータを0に書き換える
