# ���s�t�H���_����ffmpeg.exe�����s�o����悤�ɂ��Ă����K�v������܂��B
# https://ffmpeg.org/download.html ����Windows EXE Files���_�E�����[�h���ĉ𓀂��A
# ���̃X�N���v�g�Ɠ����t�H���_��bin/ffmpeg.exe��u���Ă��������B(���̃t�@�C���͕s�v)

#�@�A�Z���u���̓ǂݍ���
[void][System.Reflection.Assembly]::Load("Microsoft.VisualBasic, Version=8.0.0.0, Culture=Neutral, PublicKeyToken=b03f5f7f11d50a3a")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")

$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.Filter = "����t�@�C��(*.MP4;*.MOV;*.MKV)|*.MP4;*.MOV;*.MKV;"
# �����u���Ă���t�H���_�̐�΃p�X��ݒ肵�Ă�������
$dialog.Title = "�t�@�C����I�����Ă�������"

### ���[�U�ݒ�
##### �t�F�[�h�A�E�g�̒���(�b)
$fadelen = 2
##### �����t�H���_�̐ݒ�B�ݒ肵�Ȃ��Ă������ł����A����u����t�H���_��ݒ肵�Ă����Ɗy�ł��B
$dialog.InitialDirectory = "D:\enc\otoge\"


# �t�@�C���I���_�C�A���O��\��
if($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK){
  # �����I���������Ă��鎞�� $dialog.FileNames �𗘗p����
  Write-Output ($dialog.FileName + " ���I������܂����B")

  $ST = [Microsoft.VisualBasic.Interaction]::InputBox("�J�n�ʒu��ݒ肵�Ă��������B�`���c(h:)m:s", "�J�n�ʒu�̐ݒ�")
  $ED = [Microsoft.VisualBasic.Interaction]::InputBox("�I���ʒu��ݒ肵�Ă��������B�`���c(h:)m:s", "�I���ʒu�̐ݒ�")

  $arr = $ST.Split(":")
  $mul = 1 # h:m:s�̕ϊ��p
  $st_sec = 0
  for ($i=$arr.Length-1; $i -ge 0; $i--){
    $st_sec += $mul * $arr[$i]
    $mul *= 60
  }
  $arr = $ED.Split(":")
  $mul = 1 # h:m:s�̕ϊ��p
  $ed_sec = 0
  for ($i=$arr.Length-1; $i -ge 0; $i--){
    $ed_sec += $mul * $arr[$i]
    $mul *= 60
  }
  $duration = $ed_sec-$st_sec

  $tmp = Split-Path $dialog.Filename -Leaf

  $outputfile = $tmp + "_cut.mp4" # �o�̓t�@�C�����̐ݒ�B�{�X�N���v�g������t�H���_�ȉ��ɐ����B
  #$outputfile = $dialog.FileName + ".mp4" # �o�̓t�@�C�������Œ肷��ꍇ�͂�����

  $fadeoutst = $duration-$fadelen
  $fade = " -af volume=0.0dB,afade=t=in:st=0:d=$fadelen,afade=t=out:st=$fadeoutst"+":d=$fadelen -vf yadif=0:-1,fade=t=in:st=0:d=$fadelen,fade=t=out:st=$fadeoutst"+":d=$fadelen "
  # ffmpeg�R�}���h�̍쐬�BTwitter��������̐ݒ�ɂ��Ă��܂��B
  $cmd = "ffmpeg.exe -ss $st_sec " +"-i " + $dialog.FileName + " -hide_banner -t $duration -b:a 256k -b:v 10M -c:v h264_nvenc " + $fade + $outputfile
  Write-Output ($cmd)

  CMD /C $cmd
  [Microsoft.VisualBasic.Interaction]::MsgBox("�G���R�[�h����!   "+$cmd) # �G���R�[�h�����̃_�C�A���O�\���B�s�v�Ȃ�����Ă��������B
}
