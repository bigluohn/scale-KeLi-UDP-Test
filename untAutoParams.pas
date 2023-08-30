unit untAutoParams;

interface

uses
  IniFiles, StdCtrls, ExtCtrls, SysUtils, Classes, Vcl.ComCtrls, Controls;

  procedure HandleAllComponents(ini: TIniFile; grp: TWinControl; bRead: boolean);
  procedure HandleLabeledEdit(ini: TIniFile; edt: TLabeledEdit; bRead: boolean);
  procedure HandleCheckBox(ini: TIniFile; chk: TCheckBox; bRead: boolean);
  procedure HandleRadioGroup(ini: TIniFile; rad: TRadioGroup; bRead: boolean);
  procedure HandleRadioButton(ini: TIniFile; rad: TRadioButton; bRead: boolean);
  procedure HandleComboBox(ini: TIniFile; combo: TComboBox; bRead: boolean);
  procedure HandleMemo(ini: TIniFile; memo: TMemo; bRead: boolean);

implementation

//����TLabeledEdit, bRead��ʾ�Ƕ�ȡ����д��
procedure HandleCheckBox(ini: TIniFile; chk: TCheckBox; bRead: boolean);
begin
  if chk <> nil then
  begin
    if bRead then
      chk.Checked := ini.ReadBool('����', chk.Caption, false)
    else
      ini.WriteBool('����', chk.Caption, chk.Checked);
  end;
end;

procedure HandleComboBox(ini: TIniFile; combo: TComboBox; bRead: boolean);
begin
  if combo <> nil then
  begin
    if bRead then
      combo.ItemIndex := ini.ReadInteger('����', combo.Hint, 0)
    else
      ini.WriteInteger('����', combo.Hint, combo.ItemIndex);
  end;
end;

procedure HandleLabeledEdit(ini: TIniFile; Edt: TLabeledEdit; bRead: boolean);
begin
  if Edt <> nil then
  begin
    if bRead then
      Edt.Text := ini.ReadString('����', Edt.EditLabel.Caption, '')
    else
      ini.WriteString('����', Edt.EditLabel.Caption, trim(Edt.Text));
  end;
end;

procedure HandleMemo(ini: TIniFile; memo: TMemo; bRead: boolean);
begin
  if memo <> nil then
  begin
    var sSection := memo.Hint;
    if sSection = '' then sSection := '�б�����';

    var sl := TStringList.Create;

    try
      if bRead then
      begin
        memo.Lines.Clear;
        ini.ReadSection(sSection, sl);
        if sl <> nil then
          for var s in sl do
            memo.Lines.Add(ini.ReadString(sSection, s, ''));
      end
      else
      begin
        ini.EraseSection(sSection);
        for var i := 0 to memo.Lines.Count - 1 do
          ini.WriteString(sSection, i.ToString, memo.Lines[i]);
      end;
    finally
      FreeAndNil(sl);
    end;

  end;
end;

procedure HandleRadioButton(ini: TIniFile; rad: TRadioButton; bRead: boolean);
begin
  if rad <> nil then
  begin
    if bRead then
      rad.Checked := ini.ReadBool('����', rad.Caption, false)
    else
      ini.WriteBool('����', rad.Caption, rad.Checked);
  end;
end;

procedure HandleRadioGroup(ini: TIniFile; rad: TRadioGroup; bRead: boolean);
begin
  if rad <> nil then
  begin
    if bRead then
      rad.ItemIndex := ini.ReadInteger('����', rad.Caption, 0)
    else
      ini.WriteInteger('����', rad.Caption, rad.ItemIndex);
  end;
end;

//��ȡ����д��ؼ�ֵ��ini�ļ�
procedure HandleAllComponents(ini: TIniFile; grp: TWinControl; bRead: boolean);
var
  i: Integer;
  lblEdt: TLabeledEdit;
  chk: TCheckBox;
  radioG: TRadioGroup;
  radioB: TRadioButton;
  pedt: TLabeledEdit;
  combobox: TComboBox;
  memo: TMemo;
begin
  for i := 0 to grp.ControlCount -1 do
  begin
    if grp.Controls[i] is TLabeledEdit then
    begin
      lblEdt := grp.Controls[i] AS TLabeledEdit;
      HandleLabeledEdit(ini, lblEdt, bRead);
    end;

    if grp.Controls[i] is TCheckBox then
    begin
      chk := grp.Controls[i] AS TCheckBox;
      HandleCheckBox(ini, chk, bRead);
    end;

    if grp.Controls[i] is TRadioGroup then
    begin
      radioG := grp.Controls[i] as TRadioGroup;
      HandleRadioGroup(ini, radioG, bRead);
    end;

    if grp.Controls[i] is TRadioButton then
    begin
      radioB := grp.Controls[i] as TRadioButton;
      HandleRadioButton(ini, radioB, bRead);
    end;

    if grp.Controls[i] is TComboBox then
    begin
      combobox := grp.Controls[i] as TComboBox;
      HandleComboBox(ini, combobox, bRead);
    end;

    if grp.Controls[i] is TMemo then
    begin
      memo := grp.Controls[i] as TMemo;
      HandleMemo(ini, memo, bRead);
    end;
  end;
end;

end.
