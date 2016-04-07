CREATE OR REPLACE PACKAGE Pkg_Fileutil AS
--#Version=5
--
-- v5. ������� 21.10.2014 - ������� �������� � ������� blob_to_clob 
-- v4.������� 01,10,2014 - ��������� ������� blob_to_clob
-- v3. 29.09.2014  ������� ���������� - ��������� �������:
--                                          fn_ReadCLOBfromFile
--                                          fn_GetDirectoryList 
--
--v2. ��������. ���������� ��� �������.
/******************************************************************************
������������: pkg_fileutil
����������:
������� , ��������� ��� ������ � ������� � ������� � ������� Oracle ����

��������:
������ ������� ����� ��������
--------- ---------- --------------- ------------------------------------
1.0 24.12.2006 ������� �.�. 1. ������ � ������� � oracle ����
******************************************************************************/
-- ��������� � ������� ������
cv_extseparator CONSTANT VARCHAR2(1) := '.';
gv_OSseparator VARCHAR(1);


-- ���������� ����������� ������������ �������
--- '\' ��� windows ��� '/' ��� unix ������
FUNCTION fn_GetOSSeparator RETURN VARCHAR2;
-- �������� ��� ����� ,������� �������� ������ ���� � �����,
-- ������: ��� 'c:\temp\file.log' ������ 'file.log'
FUNCTION fn_ExtractFileName(p_FileName IN VARCHAR2) RETURN VARCHAR2;

-- �������� ��� ����� ,������� �������� ������ ���� � �����,
-- ������: ��� 'c:\temp\file.log' ������ 'file.log'
FUNCTION fn_ExtractFileNamevfe(p_FileName IN VARCHAR2) RETURN VARCHAR2;
-- �������� ���� , ������� �������� ������ ���� � �����
-- ������: ��� 'c:\temp\file.log' ������ 'c:\'
FUNCTION fn_ExtractRootDisk(p_FileName IN VARCHAR2) RETURN VARCHAR2;
-- ���������� ������� , ��� ���������� ��1�,
-- ������: 'c:\temp\file.log' ������ 'c:\temp\'
FUNCTION fn_ExtractFileDir(p_FileName IN VARCHAR2) RETURN VARCHAR2;
-- ���������� ���������� ��1��
-- ������: 'c:\temp\file.log' ������ '.log'
FUNCTION fn_ExtractFileExt(p_FileName IN VARCHAR2) RETURN VARCHAR2;
-- ���������� ���������� ��1��
-- ������: fn_ChangeFileExt('c:\temp\file.log' , '.bak') - ������ c:\temp\file.bak
FUNCTION fn_ChangeFileExt(p_FileName IN VARCHAR2, p_ext VARCHAR2) RETURN VARCHAR2;

-- ���������� ���������� ��1��
-- ������: fn_FileExists('c:\temp\file.log' ) - 1 ��� 0
FUNCTION fn_FileExists(p_FileName IN VARCHAR2) RETURN NUMBER;

-- �������� ���� �� ������ �������� � ������
-- ������:
-- pr_FileCopy('c:\temp\file.log' , 'c:\oracle\file.log')
-- �������� file.log � ������� oracle
PROCEDURE pr_FileCopy(p_oldFileName IN VARCHAR2, p_newfilename IN VARCHAR2);
-- ��������������� ��������� ����
-- ������: pr_FileRename('c:\temp\file.log' , '.bak') - ������ c:\temp\file.bak
PROCEDURE pr_FileRename(p_oldFileName IN VARCHAR2, p_newfilename IN VARCHAR2);
-- �������� ���� �� ������ �������� � ������
-- ������: pr_FileMove('c:\temp\file.log' , '.bak') - ������ c:\temp\file.bak
PROCEDURE pr_FileMove(p_OldFileName IN VARCHAR2, p_newfilename IN VARCHAR2);
-- �������� ���� �� ������ �������� � ������
-- ������: pr_deleteFile('c:\temp\file.log') - ������ c:\temp\file.Log
PROCEDURE pr_FileDelete(p_FileName IN VARCHAR2);

-- �������� ���� �� ������ �������� � ������
-- ������: pr_deleteFile('c:\temp\') - ����� ��� java ��� c:\temp\
PROCEDURE pr_SetJavaGrand(p_DirName VARCHAR2,p_UserName VARCHAR2);

FUNCTION  fn_ReadCLOBfromFile( p_Path  IN  VARCHAR2, p_FileName  IN  VARCHAR2  )  RETURN  CLOB;

FUNCTION  fn_ReadBLOBfromFile( p_Path  IN  VARCHAR2, p_FileName  IN  VARCHAR2  )  RETURN  BLOB;

FUNCTION   blob_to_clob( blob_in  IN BLOB, charsetID integer default 0 )  RETURN CLOB;

FUNCTION  fn_ReadVarcharFromFile( p_Path  IN  VARCHAR2, p_FileName  IN  VARCHAR2  )  RETURN  VARCHAR2;

PROCEDURE  pr_WriteCLOBtoFile( p_Path  IN  VARCHAR2, p_FileName  IN  VARCHAR2,  p_Data  CLOB);

PROCEDURE  pr_WriteVarcharToFile( p_Path  IN  VARCHAR2, p_FileName  IN  VARCHAR2,  p_Data  CLOB);

FUNCTION  fn_GetDirectoryList( p_directory  IN  VARCHAR2 )  RETURN  t_directory_list;



END Pkg_Fileutil;
/
CREATE OR REPLACE PACKAGE BODY Pkg_Fileutil AS
  /********************************************************************
  ����������:
  ������� ����������� �������� ������ �� �� Oracle �������
  ���������:
  �����������:
  �����������:
  ������:
  fn_GetOSSeparator - ��������� '/' ��� '\'
  ������ �����������:
  *********************************************************************/
  FUNCTION fn_GetOSSeparator RETURN VARCHAR2 IS
    vr_osstring    VARCHAR2(255);
    vr_returnvalue VARCHAR2(1);
  BEGIN
    BEGIN
      SELECT DBMS_UTILITY.PORT_STRING INTO vr_osstring FROM dual;
      IF INSTR(UPPER(vr_osstring), 'WIN') <> 0 THEN
        vr_returnvalue := '\';  -- '
      ELSE
        vr_returnvalue := '/';  -- '
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR('fn_GetOSSeparator ' || SQLERRM, 0);
        vr_returnvalue := '';
    END;
    RETURN vr_returnvalue;
  END fn_GetOSSeparator;

  /********************************************************************
  ����������:
  ���������� ��� ����� �� ������ � ��������� �������� ���� � ��1��
  ���������:
  p_FileName - ������ ���� � ����� � ��������� ����� � ���������
  �����������:
  �����������:
  ������:
  fn_ExtractFileName('c:\temp\file.log') ��������� 'file.log'
  ������ �����������:
  *********************************************************************/
  FUNCTION fn_ExtractFileName(p_FileName IN VARCHAR2) RETURN VARCHAR2 IS
    vr_returnvalue VARCHAR2(255);
  BEGIN
    BEGIN
      vr_returnvalue := SUBSTR(p_FileName,
                               INSTR(p_FileName, gv_OSseparator, -1) + 1);
      RETURN vr_returnvalue;
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR('fn_ExtractFileName ' || SQLERRM, 0);
    END;
  END fn_ExtractFileName;

  /********************************************************************
  ����������:
  ���������� ��� ����� �� ������ � ��������� �������� ���� � ��1��
  ���������:
  p_FileName - ������ ���� � ����� � ��������� ����� � ���������
  �����������:
  �����������:
  ������:
  fn_ExtractFileName('c:\temp\file.log') ��������� 'file.log'
  ������ �����������:
  *********************************************************************/
  FUNCTION fn_ExtractFileNamevfe(p_FileName IN VARCHAR2) RETURN VARCHAR2 IS
    vr_returnvalue VARCHAR2(255);
  BEGIN
    BEGIN
      vr_returnvalue := SUBSTR(p_FileName,
                               INSTR(p_FileName, gv_OSseparator, -1) + 1,
                               INSTR(p_FileName, '.', -1) -
                               INSTR(p_FileName, gv_OSseparator, -1) - 1);
      RETURN vr_returnvalue;
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR('fn_ExtractFileName ' || SQLERRM, 0);
    END;
  END fn_ExtractFileNamevfe;

  /********************************************************************
  ����������:
  ���������� ��� ����� �� ������� ���� � ��1��
  ���������:
  p_FileName - ������ ���� � ����� � ��������� ����� � ���������
  �����������:
  �����������:
  ������:
  fn_ExtractRootDisk('c:\temp\file.log') ��������� 'c:\'
  ������ �����������:
  *********************************************************************/
  FUNCTION fn_ExtractRootDisk(p_FileName IN VARCHAR2) RETURN VARCHAR2 IS
    vr_returnvalue VARCHAR2(255);
  BEGIN
    BEGIN
      vr_returnvalue := SUBSTR(p_FileName,
                               1,
                               INSTR(p_FileName, gv_OSseparator));
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR('fn_ExtractRootDisk ' || SQLERRM, 0);
    END;
    RETURN vr_returnvalue;
  END fn_ExtractRootDisk;

  /********************************************************************
  ����������:
  ������� ����� �� ������� ���� � ��1��
  ���������:
  p_FileName - ������ ���� � ����� � ��������� ����� � ���������
  �����������:
  �����������:
  ������:
  fn_ExtractRootDisk('c:\temp\file.log') ��������� 'c:\temp\'
  ������ �����������:
  *********************************************************************/
  FUNCTION fn_ExtractFileDir(p_FileName IN VARCHAR2) RETURN VARCHAR2 IS
    vr_returnvalue VARCHAR2(255);
  BEGIN
    BEGIN
      vr_returnvalue := SUBSTR(p_FileName,
                               1,
                               INSTR(p_FileName, gv_OSseparator, -1)-1);
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR('fn_ExtractFileDir ' || SQLERRM, 0);
    END;
    RETURN vr_returnvalue;
  END fn_ExtractFileDir;

  /********************************************************************
  ����������:
  ���������� ���������� ����� �� ������� ���� � ��1��
  ���������:
  p_FileName - ������ ���� � ����� � ��������� ����� � ���������
  �����������:
  �����������:
  ������:
  fn_ExtractFileExt('c:\temp\file.log') ��������� '.log'
  ������ �����������:
  *********************************************************************/
  FUNCTION fn_ExtractFileExt(p_FileName IN VARCHAR2) RETURN VARCHAR2 IS
    vr_returnvalue VARCHAR2(255);
  BEGIN
    BEGIN
      vr_returnvalue := SUBSTR(p_FileName,
                               INSTR(p_FileName, cv_extseparator, -1));
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR('fn_ExtractFileExt ' || SQLERRM, 0);
    END;
    RETURN vr_returnvalue;
  END fn_ExtractFileExt;
  /********************************************************************
  ����������:
  ���������� ���������� ����� �� ������� ���� � ��1��
  ���������:
  p_FileName - ������ ���� � ����� � ��������� ����� � ���������
  �����������:
  �����������:
  ������:
  fn_ExtractFileExt('c:\temp\file.log', '.bak') ��������� 'c:\temp\file.bak'
  ������ �����������:
  *********************************************************************/
  FUNCTION fn_ChangeFileExt(p_FileName IN VARCHAR2, p_ext VARCHAR2)
    RETURN VARCHAR2 IS
    vr_returnvalue VARCHAR2(255);
  BEGIN
    BEGIN
      vr_returnvalue := REPLACE(p_FileName,
                                fn_ExtractFileExt(p_FileName => p_FileName),
                                p_ext);
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR('fn_ChangeFileExt ' || SQLERRM, 0);
    END;
    RETURN vr_returnvalue;
  END fn_ChangeFileExt;
  /********************************************************************
  ����������:
  ���������� ������ � ����������� ������� �����
  ���������:
  p_FileName - ������ ���� � ����� � ��������� ����� � ���������
  �����������:
  �����������:
  ������:
  fn_FileExists('c:\temp\file.log' ) - 1 ���� ���� ��� 0 ����� ���
  ������ �����������:
  *********************************************************************/
  FUNCTION fn_FileExists(p_FileName IN VARCHAR2) RETURN NUMBER IS
    vr_returnvalue NUMBER;
    vr_exists      BOOLEAN;
    vr_temp        NUMBER;
    fileHandler UTL_FILE.FILE_TYPE;
  BEGIN
    BEGIN
      EXECUTE IMMEDIATE ' CREATE OR REPLACE DIRECTORY SDFU'||
                        UPPER(fn_extractfilenamevfe(P_FileName))||' AS ' || '''' ||
                        UPPER(fn_extractfiledir(P_FileName)) || '''';
      vr_returnvalue := 0;
      fileHandler:=UTL_FILE.fopen('SDFU'||
                        UPPER(fn_extractfilenamevfe(P_FileName)),
                     fn_extractfilename(P_FileName),
                    'r');
     UTL_FILE.fclose(fileHandler);
      EXECUTE IMMEDIATE ' DROP DIRECTORY SDFU' ||
                         UPPER(fn_extractfilenamevfe(P_FileName));
      vr_returnvalue := 1;
    EXCEPTION
      WHEN OTHERS THEN
       if  utl_file.is_open(fileHandler) then
         UTL_FILE.fclose(fileHandler);
       end if;
       EXECUTE IMMEDIATE ' DROP DIRECTORY SDFU' ||
                         UPPER(fn_extractfilenamevfe(P_FileName));
       vr_returnvalue := 0;
    END;
    RETURN vr_returnvalue;
  END fn_FileExists;

  /********************************************************************
  ����������:
  �������� ���� �� ������ �������� � ������
  ���������:
  p_FileName - ������ ���� � ����� � ��������� ����� � ���������
  �����������:
  �����������:
  ������:
  -- pr_FileCopyt('c:\temp\file.log' , 'c:\oracle\file.log')
  -- �������� file.log � ������� oracle
  ������ �����������:
  --
  *********************************************************************/
  PROCEDURE pr_FileCopy(p_oldFileName IN VARCHAR2, p_newfilename IN VARCHAR2) IS
  BEGIN
    BEGIN
      EXECUTE IMMEDIATE ' CREATE OR REPLACE DIRECTORY SEFU' ||
                        UPPER(fn_extractfilenamevfe(P_NewFileName)) || ' AS ' || '''' ||
                        UPPER(fn_extractfiledir(P_OldFileName)) || '''';
      EXECUTE IMMEDIATE ' CREATE OR REPLACE DIRECTORY SDFU' ||
                        UPPER(fn_extractfilenamevfe(P_NewFileName)) || ' AS ' || '''' ||
                        UPPER(fn_extractfiledir(P_NewFileName)) || '''';
      UTL_FILE.fcopy('SEFU' ||
                     UPPER(fn_extractfilenamevfe(P_NewFileName)),
                     fn_extractfilename(P_OldFileName),
                     'SDFU' ||
                     UPPER(fn_extractfilenamevfe(P_NewFileName)),
                     fn_extractfilename(P_NewFileName));
      EXECUTE IMMEDIATE ' DROP DIRECTORY SDFU' ||
                        UPPER(fn_extractfilenamevfe(P_NewFileName));
      EXECUTE IMMEDIATE ' DROP DIRECTORY SEFU' ||
                        UPPER(fn_extractfilenamevfe(P_NewFileName));
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR('pr_FileCopy ' || SQLERRM, 0);
    END;
  END pr_FileCopy;

  /********************************************************************
  ����������:
  �������� ���� �� ������ �������� � ������
  ���������:
  p_FileName - ������ ���� � ����� � ��������� ����� � ���������
  �����������:
  �����������:
  ������:
  -- pr_FileCopyt('c:\temp\file.log' , 'c:\oracle\file.log')
  -- �������� file.log � ������� oracle
  ������ �����������:
  --
  *********************************************************************/
  PROCEDURE pr_FileRename(p_oldFileName IN VARCHAR2,
                          p_newfilename IN VARCHAR2) IS
  BEGIN
    BEGIN
      EXECUTE IMMEDIATE ' CREATE OR REPLACE DIRECTORY SDFU' ||
                        UPPER(fn_extractfilenamevfe(P_NewFileName)) || ' AS ' || '''' ||
                        fn_extractfiledir(P_NewFileName) || '''';
      UTL_FILE.frename('SDFU' ||
                       UPPER(fn_extractfilenamevfe(P_NewFileName)),
                       fn_extractfilename(P_OldFileName),
                       'SDFU' ||
                       UPPER(fn_extractfilenamevfe(P_NewFileName)),
                       fn_extractfilename(P_NewFileName),
                       TRUE);
      EXECUTE IMMEDIATE ' DROP DIRECTORY SDFU' ||
                        UPPER(fn_extractfilenamevfe(P_NewFileName));
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR('pr_FileRename ' || SQLERRM, 0);
    END;
  END pr_FileRename;
  /********************************************************************
  ����������:
  �������� ���� �� ������ �������� � ������
  ���������:
  p_FileName - ������ ���� � ����� � ��������� ����� � ���������
  �����������:
  �����������:
  ������:
  -- pr_FileCopyt('c:\temp\file.log' , 'c:\oracle\file.log')
  -- �������� file.log � ������� oracle
  ������ �����������:
  --
  *********************************************************************/
  PROCEDURE pr_FileMove(p_oldFileName IN VARCHAR2, p_newfilename IN VARCHAR2) IS
  BEGIN
    BEGIN
      EXECUTE IMMEDIATE ' CREATE OR REPLACE DIRECTORY SEFU' ||
                        UPPER(fn_extractfilenamevfe(P_NewFileName)) || ' AS ' || '''' ||
                        fn_extractfiledir(P_OldFileName) || '''';
      EXECUTE IMMEDIATE ' CREATE OR REPLACE DIRECTORY SDFU' ||
                        UPPER(fn_extractfilenamevfe(P_NewFileName)) || ' AS ' || '''' ||
                        fn_extractfiledir(P_NewFileName) || '''';
      UTL_FILE.frename('SEFU' ||
                       UPPER(fn_extractfilenamevfe(P_NewFileName)),
                       fn_extractfilename(P_OldFileName),
                       'SDFU' ||
                       UPPER(fn_extractfilenamevfe(P_NewFileName)),
                       fn_extractfilename(P_NewFileName),
                       TRUE);
      EXECUTE IMMEDIATE ' DROP DIRECTORY SDFU' ||
                        UPPER(fn_extractfilenamevfe(P_NewFileName));
      EXECUTE IMMEDIATE ' DROP DIRECTORY SEFU' ||
                        UPPER(fn_extractfilenamevfe(P_NewFileName));
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR('pr_FileMove ' || SQLERRM, 0);
    END;
  END pr_FileMove;

  /********************************************************************
  ����������:
  ������ ���� �� ��������
  ���������:
  p_FileName - ������ ���� � ����� � ��������� ����� � ���������
  �����������:
  �����������:
  ������:
  -- pr_FileDelete('c:\temp\file.log' )
  -- ������� file.log
  ������ �����������:
  --
  *********************************************************************/
  PROCEDURE pr_FileDelete(p_FileName IN VARCHAR2) IS
  BEGIN
    BEGIN
      EXECUTE IMMEDIATE ' CREATE OR REPLACE DIRECTORY SEFU' ||
                        UPPER(fn_extractfilenamevfe(P_FileName)) || ' AS ' || '''' ||
                        UPPER(fn_extractfiledir(P_FileName)) || '''';
      UTL_FILE.fremove('SEFU' ||
                       UPPER(fn_extractfilenamevfe(P_FileName)),
                       fn_extractfilename(P_FileName));
      EXECUTE IMMEDIATE ' DROP DIRECTORY SEFU' ||
                        UPPER(fn_extractfilenamevfe(P_FileName));
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR('pr_FileDelete ' || SQLERRM, 0);
    END;
  END pr_FileDelete;
  /********************************************************************
  ����������:
  ������������ ����� ��� java ��������
  ���������:
  p_FileName - ������ ���� � ����� � ��������� ����� � ���������
  �����������:
  �����������:
  ������:
  -- pr_SetJavaGrand('c:\temp\' )
  -- ��������� ����� ��� c:\temp\
  ������ �����������:
  --
  *********************************************************************/
  PROCEDURE pr_SetJavaGrand(p_DirName VARCHAR2, p_UserName VARCHAR2) IS
    vr_script VARCHAR2(2240);
  BEGIN
    BEGIN
      -- SQLCODE
      vr_script := 'begin dbms_java.grant_permission(' || '''' ||
                   UPPER(p_UserName) || '''' || ' , ' || '''' ||
                   'java.io.FilePermission' || '''' || ' , ' || '''' ||
                   LOWER(p_DirName) || '''' || ' , ' || '''' || 'read' || '''' ||
                   '); end;';
      EXECUTE IMMEDIATE vr_script;
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR('pr_SetJavaGrand ' || SQLERRM, 0); -- ����� ���������
    END;
  END pr_SetJavaGrand;


  /********************************************************************
   fn_ReadCLOBfromFile
   ********************************************************************/

  FUNCTION  fn_ReadCLOBfromFile( p_Path  IN  VARCHAR2, p_FileName  IN  VARCHAR2  )  RETURN  CLOB  IS
      vr_data  CLOB;
      vr_bfile  bfile;
      rand_val  VARCHAR2(12);

  BEGIN
      BEGIN
          DBMS_RANDOM.INITIALIZE( (sysdate - to_date( '1970-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )) * 86400 );
          DBMS_RANDOM.SEED( (sysdate - to_date( '1970-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )) * 86400 );
          SELECT  dbms_random.string( 'U', 12 )  INTO  rand_val  FROM  dual;

          EXECUTE IMMEDIATE  'CREATE OR REPLACE DIRECTORY  "TMP' || rand_val || '"  AS  ' || '''' || p_Path || '''';

          vr_bfile := bfilename( 'TMP' || rand_val || '', p_FileName );
          BEGIN
              DBMS_LOB.FileOpen( vr_bfile );
          EXCEPTION
              WHEN OTHERS THEN
                  RETURN  NULL;
          END;
          DBMS_LOB.CreateTemporary( vr_data, FALSE );
          DBMS_LOB.LoadFromfile( vr_data, vr_bfile, dbms_lob.getlength( vr_bfile ) );
          DBMS_LOB.FileClose( vr_bfile );

          EXECUTE IMMEDIATE  'DROP DIRECTORY  "TMP' || rand_val || '"';

      EXCEPTION
          WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20001, 'fn_ReadCLOBfromFile ' || SQLERRM );
      END;

      RETURN  vr_data;
  END  fn_ReadCLOBfromFile;


  /* =================================================================== */

  FUNCTION  fn_ReadBLOBfromFile( p_Path  IN  VARCHAR2, p_FileName  IN  VARCHAR2  )  RETURN  BLOB  IS

      vr_data  BLOB;
      vr_bfile  bfile;
      rand_val  VARCHAR2(12);

  BEGIN
          DBMS_RANDOM.INITIALIZE( (sysdate - to_date( '1970-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )) * 86400 );
          DBMS_RANDOM.SEED( (sysdate - to_date( '1970-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )) * 86400 );
          SELECT  dbms_random.string( 'U', 12 )  INTO  rand_val  FROM  dual;

          EXECUTE IMMEDIATE  'CREATE OR REPLACE DIRECTORY  "TMP' || rand_val || '"  AS  ' || '''' || p_Path || '''';

          vr_bfile := bfilename( 'TMP' || rand_val || '', p_FileName );
          DBMS_LOB.CreateTemporary( vr_data, FALSE );

          BEGIN
              DBMS_LOB.OPEN( vr_bfile, DBMS_LOB.LOB_READONLY );
          EXCEPTION
              WHEN OTHERS THEN
                  RETURN  NULL;
          END;
          DBMS_LOB.OPEN( vr_data, DBMS_LOB.LOB_READWRITE );

          DBMS_LOB.LOADFROMFILE( DEST_LOB => vr_data,
                                 SRC_LOB  => vr_bfile,
                                 AMOUNT   => DBMS_LOB.GETLENGTH( vr_bfile ) );
          DBMS_LOB.CLOSE( vr_bfile );
          DBMS_LOB.CLOSE( vr_data );
          EXECUTE IMMEDIATE  'DROP DIRECTORY  "TMP' || rand_val || '"';

          RETURN  vr_data;
  END  fn_ReadBLOBfromFile;


  --����������� blob � clob ��� ��������� ���������
  FUNCTION   blob_to_clob_no_charset( blob_in  IN BLOB )  RETURN CLOB  AS
     v_clob    CLOB;
     v_varchar VARCHAR2(32767);
     v_start      PLS_INTEGER := 1;
     v_buffer  PLS_INTEGER := 32767;
    
  BEGIN
     IF  (blob_in  IS  NULL)  THEN
         RETURN  NULL;
     END IF;

     DBMS_LOB.CREATETEMPORARY( v_clob, TRUE);

     
     FOR  i  IN  1..CEIL( DBMS_LOB.GETLENGTH( blob_in ) / v_buffer )   LOOP
        v_varchar := UTL_RAW.CAST_TO_VARCHAR2( DBMS_LOB.SUBSTR( blob_in, v_buffer, v_start ) );
        DBMS_LOB.WRITEAPPEND( v_clob, LENGTH( v_varchar ), v_varchar );
        v_start := v_start + v_buffer;
     END LOOP;
     
        
     RETURN  v_clob;

  END blob_to_clob_no_charset;

  /* =================================================================== */
  FUNCTION  blob_to_clob( blob_in  IN BLOB, charsetID integer default 0 )
      RETURN CLOB IS
      Result     CLOB;
      iLen       INTEGER := Dbms_lob.lobmaxsize;
      iSrcOffs   INTEGER := 1;
      iDstOffs   INTEGER := 1;
      iCSID      INTEGER := Nls_charset_id ('CL8MSWIN1251'); 
      iLang      INTEGER := Dbms_lob.default_lang_ctx;
      iWarn      INTEGER;
   BEGIN
      
      IF  (blob_in  IS  NULL)  THEN
         RETURN  NULL;
      END IF;
      
      IF NOT ( (blob_in IS NULL) OR (Dbms_lob.GetLength (blob_in) = 0)) THEN
         Dbms_lob.CreateTemporary (Result, TRUE);
         if charsetID = 0 then
          Dbms_lob.ConvertToClob (Result, blob_in, iLen, iSrcOffs, iDstOffs, iCSID, iLang, iWarn);
         else
          Result := blob_to_clob_no_charset(blob_in);
         end if;
      ELSE
         Result   := NULL;
      END IF;
      RETURN (Result);
   END blob_to_clob;

  /********************************************************************
   fn_ReadVarcharFromFile
   ********************************************************************/

  FUNCTION  fn_ReadVarcharFromFile( p_Path  IN  VARCHAR2, p_FileName  IN  VARCHAR2  )  RETURN  VARCHAR2  IS
      vr_data  VARCHAR2(32767);
      vr_bfile  bfile;
      rand_val  VARCHAR2(12);

  BEGIN
      BEGIN
          DBMS_RANDOM.INITIALIZE( (sysdate - to_date( '1970-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )) * 86400 );
          DBMS_RANDOM.SEED( (sysdate - to_date( '1970-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )) * 86400 );
          SELECT  dbms_random.string( 'U', 12 )  INTO  rand_val  FROM  dual;

          EXECUTE IMMEDIATE  'CREATE OR REPLACE DIRECTORY  "TMP' || rand_val || '"  AS  ' || '''' || p_Path || '''';

          vr_bfile := bfilename( 'TMP' || rand_val || '', p_FileName );
          DBMS_LOB.FileOpen( vr_bfile );
          DBMS_LOB.CreateTemporary( vr_data, FALSE );
          DBMS_LOB.LoadFromfile( vr_data, vr_bfile, dbms_lob.getlength( vr_bfile ) );
          DBMS_LOB.FileClose( vr_bfile );

          EXECUTE IMMEDIATE  'DROP DIRECTORY  "TMP' || rand_val || '"';

      EXCEPTION
          WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20001, 'fn_ReadCLOBfromFile ' || SQLERRM );
      END;

      RETURN  vr_data;
  END  fn_ReadVarcharFromFile;


  /********************************************************************
   pr_WriteCLOBtoFile
   ********************************************************************/

  PROCEDURE  pr_WriteCLOBtoFile( p_Path  IN  VARCHAR2, p_FileName  IN  VARCHAR2,  p_Data  CLOB)  AS
      rand_val  VARCHAR2(12);
  BEGIN
      BEGIN
          DBMS_RANDOM.INITIALIZE( (sysdate - to_date( '1970-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )) * 86400 );
          DBMS_RANDOM.SEED( (sysdate - to_date( '1970-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )) * 86400 );
          SELECT  dbms_random.string( 'U', 12 )  INTO  rand_val  FROM  dual;
          EXECUTE IMMEDIATE  'CREATE OR REPLACE DIRECTORY  "TMP' || rand_val || '"  AS  ' || '''' || p_Path || '''';
          DBMS_XSLPROCESSOR.CLOB2FILE( p_Data, 'TMP' || rand_val || '', p_FileName );
          EXECUTE IMMEDIATE  'DROP DIRECTORY  "TMP' || rand_val || '"';

      EXCEPTION
          WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20001, 'pr_WriteCLOBtoFile ' || SQLERRM );
      END;
  END  pr_WriteCLOBtoFile;


/********************************************************************
   pr_WriteVarcharToFile
   ********************************************************************/

  PROCEDURE  pr_WriteVarcharToFile( p_Path  IN  VARCHAR2, p_FileName  IN  VARCHAR2,  p_Data  CLOB)  AS
      rand_val  VARCHAR2(12);
  BEGIN
      BEGIN
          DBMS_RANDOM.INITIALIZE( (sysdate - to_date( '1970-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )) * 86400 );
          DBMS_RANDOM.SEED( (sysdate - to_date( '1970-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )) * 86400 );
          SELECT  dbms_random.string( 'U', 12 )  INTO  rand_val  FROM  dual;
          EXECUTE IMMEDIATE  'CREATE OR REPLACE DIRECTORY  "TMP' || rand_val || '"  AS  ' || '''' || p_Path || '''';
          DBMS_XSLPROCESSOR.CLOB2FILE( p_Data, 'TMP' || rand_val || '', p_FileName );
          EXECUTE IMMEDIATE  'DROP DIRECTORY  "TMP' || rand_val || '"';

      EXCEPTION
          WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20001, 'pr_WriteVarchartoFile ' || SQLERRM );
      END;
  END  pr_WriteVarcharToFile;




  /*******************************************************************************/

  FUNCTION  fn_GetDirectoryList( p_directory  IN  VARCHAR2 )  RETURN  t_directory_list  AS
      LANGUAGE JAVA NAME 'ListDirectory.getDirectoryList( java.lang.String )  return  oracle.sql.ARRAY';

BEGIN
  Pkg_Fileutil.gv_OSseparator := fn_GetOSSeparator;
END Pkg_Fileutil;

--#end if
/