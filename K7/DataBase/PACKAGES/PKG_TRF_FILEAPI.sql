CREATE OR REPLACE package PKG_TRF_FILEAPI
as

  /* ������� �������� ���� �� ������ */
  function canRead
  (
    p_path  in varchar2
  )
    return number
  as
    language java name 'TRF_FileHandler.canRead (java.lang.String) return java.lang.int';


  /* ������� �������� ���� �� ������ */
  function canWrite
  (
    p_path  in varchar2
  )
    return number
  as
    language java name 'TRF_FileHandler.canWrite (java.lang.String) return java.lang.int';

  /* ������� �������� ����� */
  function createNewFile
  (
    p_path  in varchar2
  )
  return number
  as
    language java name 'TRF_FileHandler.createNewFile (java.lang.String) return java.lang.int';


  /* ������� �������� ����� ��� ���������� */
  function delete
  (
    p_path  in varchar2
  )
  return number
  as
    language java name 'TRF_FileHandler.delete (java.lang.String) return java.lang.int';


  /* ������� �������� ������� ����� ��� ����������*/
  function exists
  (
    p_path  in varchar2
  )
  return number
  as
    language java name 'TRF_FileHandler.exists (java.lang.String) return java.lang.int';


  /* ������� �������� ������� ���������� */
  function isDirectory
  (
    p_path  in varchar2
  )
  return number
  as
    language java name 'TRF_FileHandler.isDirectory (java.lang.String) return java.lang.int';

  /* ������� �������� �������� ������� ����� */
  function isFile
  (
    p_path  in varchar2
  )
  return number
  as
    language java name 'TRF_FileHandler.isFile (java.lang.String) return java.lang.int';


  /* ������� �������� �������� "�������" */
  function isHidden
  (
    p_path  in varchar2
  )
  return number
  as
    language java name 'TRF_FileHandler.isHidden (java.lang.String) return java.lang.int';


  /* ������� �������� ���� ���������� ��������� */
  function lastModified
  (
    p_path  in varchar2
  )
  return date
  as
    language java name 'TRF_FileHandler.lastModified (java.lang.String) return java.sql.Timestamp';


  /* ������� �������� ������� ����� (� ������) */
  function length
  (
    p_path  in varchar2
  )
  return number
  as
    language java name 'TRF_FileHandler.length (java.lang.String) return java.lang.long';


  /* ������� �������� ��������� � ������ */
  function list
  (
    p_path  in varchar2
  )
  return varchar2
  as
    language java name 'TRF_FileHandler.list (java.lang.String) return java.lang.String';


  /* ������� �������� ���������� */
  function mkdir
  (
    p_path  in varchar2
  )
  return number
  as
    language java name 'TRF_FileHandler.mkdir (java.lang.String) return java.lang.int';


  /* ������� �������� ���������� */
  function mkdirs
  (
    p_path  in varchar2
  )
  return number
  as
    language java name 'TRF_FileHandler.mkdirs (java.lang.String) return java.lang.int';


  /* ������� �������������� ����� ��� ���������� */
  function renameTo
  (
    p_from_path  in varchar2,
    p_to_path    in varchar2
  )
  return number
  as
    language java name 'TRF_FileHandler.renameTo (java.lang.String, java.lang.String) return java.lang.int';


  /* ������� ��������� �������� "������ ��� ������" */
  function setReadOnly
  (
    p_path  in varchar2
  )
  return number
  as
    language java name 'TRF_FileHandler.setReadOnly (java.lang.String) return java.lang.int';


  /* ������� ����������� ����� ��� ���������� */
  function copy
  (
    p_from_path  in varchar2,
    p_to_path    in varchar2
  )
  return number
  as
    language java name 'TRF_FileHandler.copy (java.lang.String, java.lang.String) return java.lang.int';

  function getFileCount
  (
    dirpath  in varchar2
  )
  return number
  as
    language java name 'TRF_FileHandler.getFileCount (java.lang.String) return java.lang.int';



END PKG_TRF_FILEAPI;
/

