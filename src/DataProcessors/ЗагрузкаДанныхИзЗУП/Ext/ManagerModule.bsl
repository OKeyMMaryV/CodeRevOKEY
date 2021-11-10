﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ЗагрузитьДанныеВИБ(ПараметрыВыгрузки, АдресХранилища) Экспорт
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	ДвоичныеДанныеФайла = ПараметрыВыгрузки.ДвоичныеДанныеФайла;
	ДвоичныеДанныеФайла.Записать(ИмяВременногоФайла);
	
	ТекстДок = Новый ТекстовыйДокумент;
	
	Попытка
		ТекстДок.Прочитать(ИмяВременногоФайла, КодировкаТекста.UTF8);
	Исключение
		ТекстСообщения = НСтр("ru = 'Загрузка из файлов данного типа не поддерживается.'");		
		ПоместитьВоВременноеХранилище(ТекстСообщения, АдресХранилища);
		Возврат;
	КонецПопытки;
	
	СодержимоеДок = ТекстДок.ПолучитьТекст();
	
	ТекстСообщения = "";
	Если СтрНайти(СодержимоеДок, "БухгалтерияПредприятия 3.0") = 0 
		И СтрНайти(СодержимоеДок, "БухгалтерияПредприятияКОРП 3.0") = 0 Тогда
		ТекстСообщения = НСтр("ru = 'При загрузке данных произошла ошибка.'");
		ТекстСообщения = ТекстСообщения + Символы.ПС + НСтр("ru = 'Данные не предназначенны для 1С:Бухгалтерии 8 ред. 3.0.'");
	КонецЕсли;
	
	Если ТекстСообщения <> "" Тогда
		Если СтрНайти(СодержимоеДок, "ЗарплатаИУправлениеПерсоналом") <> 0 Тогда
			ТекстСообщения = ТекстСообщения + Символы.ПС + НСтр("ru = 'Исправьте программу бухучета в настройках выгрузки в ЗУП, ред. 2.5.'");
			
		КонецЕсли;
		ПоместитьВоВременноеХранилище(ТекстСообщения, АдресХранилища);
		Возврат;
	КонецЕсли;
	
	СодержимоеДок = СтрЗаменить(СодержимоеДок, "ДокументСсылка.ЗарплатаКВыплатеОрганизаций","ДокументСсылка.ВедомостьНаВыплатуЗарплаты");
	СодержимоеДок = СтрЗаменить(СодержимоеДок, "ПеречислениеСсылка.СпособыВыплатыЗарплаты","ПеречислениеСсылка.ВидыМестВыплатыЗарплаты");
	СодержимоеДок = СтрЗаменить(СодержимоеДок, "СпособВыплаты","ВидМестаВыплаты");
	СодержимоеДок = СтрЗаменить(СодержимоеДок, "ЧерезКассу","Касса");
	СодержимоеДок = СтрЗаменить(СодержимоеДок, "ЧерезБанк","ЗарплатныйПроект");
	СодержимоеДок = СтрЗаменить(СодержимоеДок, "ДнейНеВыплаты","УдалитьДнейНеВыплаты");
	
	ТекстДок.УстановитьТекст(СодержимоеДок);
	ТекстДок.Записать(ИмяВременногоФайла, КодировкаТекста.UTF8);
	
	ОбработкаОбмена = Обработки.УниверсальныйОбменДаннымиXML.Создать();
	ОбработкаОбмена.РежимОбмена = "Загрузка";
	ОбработкаОбмена.ИмяФайлаОбмена = ИмяВременногоФайла;
	ОбработкаОбмена.РежимОтладкиАлгоритмов = 3;
	ОбработкаОбмена.ФлагРежимОтладкиОбработчиков = Истина;
	ОбработкаОбмена.ФлагРежимОтладки = Истина;
	ОбработкаОбмена.ИмяФайлаВнешнейОбработкиОбработчиковСобытий = "ОбработчикиЗагрузкиИзЗУП25";
	
	ОбработкаОбмена.ВыполнитьЗагрузку();
	УдалитьФайлы(ИмяВременногоФайла);
	
	Если ОбработкаОбмена.ФлагОшибки Тогда		
		ТекстСообщения = НСтр("ru = 'При загрузке данных произошла ошибка.'");
	Иначе		
		ТекстСообщения =  НСтр("ru = 'Загрузка данных завершена.'");
	КонецЕсли;
	
	
	ПоместитьВоВременноеХранилище(ТекстСообщения, АдресХранилища);
	
КонецПроцедуры

#КонецЕсли