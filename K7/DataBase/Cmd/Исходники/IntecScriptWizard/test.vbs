
Set Connection = CreateObject("ADODB.Connection")

Connection.Open "Provider=MSDAORA;Data Source=Ora92;User ID=komitet;Password=komitet"

Set ShowScript = CreateObject("IntecScriptWizard.ShowScript")

Set ShowScript.Connection = Connection

Call ShowScript.Add("111", "select * from dual", "������ ������!!!", "111", "Critical")


Call ShowScript.Add("112", "select * from medical_organizations", "�������� ������", "112", "")

Call ShowScript.Add("121", "select * from SSS", "������ ������!!!", "121")

ShowScript.Run

Set ShowScript.Connection = Nothing
Set ShowScript = Nothing

'Connection.Close
