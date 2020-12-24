{*****************************************************************************
  The DEC team (see file NOTICE.txt) licenses this file
  to you under the Apache License, Version 2.0 (the
  "License"); you may not use this file except in compliance
  with the License. A copy of this licence is found in the root directory of
  this project in the file LICENCE.txt or alternatively at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing,
  software distributed under the License is distributed on an
  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  KIND, either express or implied.  See the License for the
  specific language governing permissions and limitations
  under the License.
*****************************************************************************}

/// <summary>
///   Simple demonstration of using the IDECProgress interface for displaying
///   progress of an operation
/// </summary>
unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, System.UITypes,
  DECUtil, DECCiphers, DECCipherBase;

type
  TFormMain = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    ProgressBar1: TProgressBar;
    procedure Button1Click(Sender: TObject);
  private
    procedure OnProgress(const Progress: TDECProgressParams);
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

resourcestring
  rFileNameEmptyFailure = 'No input file specified!';

procedure TFormMain.Button1Click(Sender: TObject);
var
  Cipher     : TCipher_AES;
  TargetFile : string;
begin
  if Edit1.Text = '' then
  begin
    MessageDlg(rFileNameEmptyFailure, mtError, [mbOK], -1);
    exit;
  end;

  Cipher := TCipher_AES.Create;

  try
    try
      // Init encryption
      Cipher.Init('Passwort', #1#2#3#4#5#6#7#99, 0);
      Cipher.Mode := cmCBCx;

      // replace file extension of input file
      TargetFile := Edit1.Text;
      Delete(TargetFile, pos('.', TargetFile), length(TargetFile));
      TargetFile := TargetFile + '.enc';

      Cipher.EncodeFile(Edit1.Text, TargetFile, OnProgress);
    except
      on E: Exception do
        MessageDlg(E.Message, mtError, [mbOK], -1);
    end;
  finally
    Cipher.Free;
  end;
end;

procedure TFormMain.OnProgress(const Progress: TDECProgressParams);
begin
  {
  ProgressBar1.Min := 0;
  ProgressBar1.Max := Max;
  ProgressBar1.Position := Pos;
  }
  ProgressBar1.Max := 1000;
  ProgressBar1.Position := Round(Progress.Percent * 10);

  Application.ProcessMessages;
  if Application.Terminated then
    Progress.BreakProgress;
end;

end.
