insert into d_news (DATE_OF_NEW, NEW_HEADER, NEW_ANNOTATION, NEW_TEXT, NEW_ENABLED, NEW_IS_ON_TOP)
values(sysdate-100, '������� 2', '���������, ��������� <b>HTML</b> ��������', '����� �������, <a href="www.tarifer.ru" target="_blank">������<p>������ ������',
1, 1);

insert into d_news (DATE_OF_NEW, NEW_HEADER, NEW_ANNOTATION, NEW_TEXT, NEW_ENABLED, NEW_IS_ON_TOP)
values(sysdate-100, '������� 3', '��������� 3', '����� �������', 1, 0);

insert into d_news (DATE_OF_NEW, NEW_HEADER, NEW_ANNOTATION, NEW_TEXT, NEW_ENABLED, NEW_IS_ON_TOP)
values(sysdate-90, '������� 4', '��������� 4', '����� �������', 1, 0);

insert into d_news (DATE_OF_NEW, NEW_HEADER, NEW_ANNOTATION, NEW_TEXT, NEW_ENABLED, NEW_IS_ON_TOP)
values(sysdate-80, '������� ������� 5', '��������� 5', '����� �������', 0, 1);

insert into d_news (DATE_OF_NEW, NEW_HEADER, NEW_ANNOTATION, NEW_TEXT, NEW_ENABLED, NEW_IS_ON_TOP)
values(sysdate-75, '������� 6', '��������� 6', '����� �������', 0, 0);

insert into d_news (DATE_OF_NEW, NEW_HEADER, NEW_ANNOTATION, NEW_TEXT, NEW_ENABLED, NEW_IS_ON_TOP)
values(sysdate-70, '������� 7', '��������� 7', '����� ������� 7', 1, 0);

begin
  for i in 10..70 loop
insert into d_news (DATE_OF_NEW, NEW_HEADER, NEW_ANNOTATION, NEW_TEXT, NEW_ENABLED, NEW_IS_ON_TOP)
values(sysdate-80+i, '������� '||i, '��������� '||i, '����� ������� '||i, 1, 0);
  end loop;
end;

commit;