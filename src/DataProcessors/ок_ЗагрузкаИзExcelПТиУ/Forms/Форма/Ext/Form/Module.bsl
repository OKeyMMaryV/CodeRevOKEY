﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем пExcel;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ИмяФайлаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	ОткрытьФайл(Объект.ИмяФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(ИмяФайла)
    
    Если ПустаяСтрока(ИмяФайла) Тогда
        Возврат;
    КонецЕсли;
    
    ОткрываемыйФайл = Новый Файл(СокрЛП(ИмяФайла));
	
    Если ОткрываемыйФайл.Существует() Тогда
        ЗапуститьПриложение(ИмяФайла);
    КонецЕсли;
  
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗавершениеВыбораФайла", ЭтотОбъект);
	СтруктураИмяФайла = Новый Структура("ИмяФайла","");
	ТекстФильтра = бит_ОбменДанными_Excel.ПолучитьФильтрДляВыбораФайлаExcel();
	ОбменДаннымиКлиент.ОбработчикВыбораФайла(СтруктураИмяФайла, "ИмяФайла", Ложь
											 ,Новый Структура("Фильтр, ПроверятьСуществованиеФайла", ТекстФильтра, Истина)
											 ,Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеВыбораФайла(ИмяФайла, ДополнительныеПараметры) Экспорт 
	
	Если ПустаяСтрока(ИмяФайла) тогда
		Возврат;
	КонецЕсли;	
	
	Объект.ИмяФайла = ИмяФайла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьФайл(Команда)
	
	ЕстьОшибкиЗагрукзки = Ложь;
	
	ОткрываемыйФайл = Новый Файл(СокрЛП(Объект.ИмяФайла));
    
	Если ПустаяСтрока(Объект.ИмяФайла) ИЛИ
		 НЕ ОткрываемыйФайл.Существует()		
	Тогда
		ТекстСообщения = НСтр("ru = 'Указан неверный путь к файлу'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"ИмяФайла");
		Возврат;
	КонецЕсли;	
	
	Попытка
		
		ЗагрузитьДанныеИзExcel();			
		
	Исключение   
		
		Если пExcel <> Неопределено Тогда 
			пExcel.Application.Quit();
		КонецЕсли;
		
		пExcel = Неопределено;
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ОписаниеОшибки(),,"ИмяФайла");
		
		Возврат;
		
	КонецПопытки;
		
	Если ТаблицаОшибок.Количество() Тогда 
		ВывестиЛогКлиент();		
	КонецЕсли;		
	 
	ЗаполнитьТЧДокумента();
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузитьДанныеИзExcel()
	
	ТаблицаДанных.Очистить();
	
	ТаблицаОшибок.Очистить();
	
	НастройкиЗагрузки = ПолучитьНастройкиЗагрузки();
	
	Если НастройкиЗагрузки.Количество() = 0 Тогда 
		ЕстьОшибкиЗагрукзки = Истина;
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не удалось прочитать файл по причине:
											 	   					 |Не заполнены настройки чтения Excel-файла.'"));
		Возврат;
	КонецЕсли;
	
	Попытка
		пExcel = Новый COMОбъект("Excel.Application");
	Исключение
		ЕстьОшибкиЗагрукзки = Истина;
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не удалось прочитать файл по причине
																						 |'" + ОписаниеОшибки()));
		Возврат;
	КонецПопытки;
		
	пКнига = пExcel.WorkBooks.Open(Объект.ИмяФайла); 
	
	Если Не НастройкиЗагрузки.Свойство("ИмяЛиста_Данные") Тогда 
		ЕстьОшибкиЗагрукзки = Истина;
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не уадлось прочитать файл по причине
											 	   |Не заполнена настройки ""Имя листа данных"".'"));
		пExcel.Application.Quit();	
		Возврат;
	КонецЕсли;
	
	пЛистСДанными  = пКнига.WorkSheets(НастройкиЗагрузки.ИмяЛиста_Данные);
	пЛистЦФО	   = пКнига.WorkSheets(НастройкиЗагрузки.ИмяЛиста_ЦФО);
	пЛистОбъекты   = пКнига.WorkSheets(НастройкиЗагрузки.ИмяЛиста_Объекты);
	пЛистПроекты   = пКнига.WorkSheets(НастройкиЗагрузки.ИмяЛиста_Проекты);
	пЛистСтатьи	   = пКнига.WorkSheets(НастройкиЗагрузки.ИмяЛиста_Статьи);
	пЛистСлужебный = пКнига.WorkSheets("Не загружаемые");
	
	пКэшОбъектов = Новый Соответствие;
	пКэшПроектов = Новый Соответствие;
	пКэшСтатей 	 = Новый Соответствие;
	пКэшЦФО 	 = Новый Соответствие;
	пКэшЕдИзм 	 = Новый Соответствие;
	пКэшВалюта 	 = Новый Соответствие;
	
	СоответствиеСтавокНДС = Новый Соответствие;
	СоответствиеСтавокНДС.Вставить("20%",ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС20"));
	СоответствиеСтавокНДС.Вставить("18%",ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС18"));
	СоответствиеСтавокНДС.Вставить("Без НДС",ПредопределенноеЗначение("Перечисление.СтавкиНДС.БезНДС"));
	СоответствиеСтавокНДС.Вставить("10%",ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС10"));	
	СоответствиеСтавокНДС.Вставить("0%"	,ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС0"));
		
	пВсегоСтрок = пЛистСДанными.Cells(1,1).SpecialCells(11).Row;
	
	пСтрокаНачалаДанных = НастройкиЗагрузки.НомерСтрокиШапкиТабЧасти + 1;
			
	Для НомерСтроки = пСтрокаНачалаДанных по пВсегоСтрок Цикл
		
		Период				= пЛистСДанными.Cells(НомерСтроки,НастройкиЗагрузки.НомерКолонки_Период).Value;
		ОбъектСтроительства = пЛистСДанными.Cells(НомерСтроки,НастройкиЗагрузки.НомерКолонки_Объект).Value;
		Статья 				= пЛистСДанными.Cells(НомерСтроки,НастройкиЗагрузки.НомерКолонки_СтатьяОборотов).Value;
		Проект 				= пЛистСДанными.Cells(НомерСтроки,НастройкиЗагрузки.НомерКолонки_Проект).Value;
		ЦФО 				= пЛистСДанными.Cells(НомерСтроки,НастройкиЗагрузки.НомерКолонки_ЦФО).Value;
		
		Если Не ЗначениеЗаполнено(Период) И
			 Не ЗначениеЗаполнено(ОбъектСтроительства) И
			 Не ЗначениеЗаполнено(Статья) И
			 Не ЗначениеЗаполнено(Проект) И
			 Не ЗначениеЗаполнено(ЦФО)			 
		Тогда 				
			Прервать;
		КонецЕсли;
		
		СтрокаДанных = ТаблицаДанных.Добавить();
		СтрокаДанных.НомерСтрокиФайла = НомерСтроки;
		СтрокаДанных.ок_Период		 = ПреоброзоватьЗначение("Период",Период,"Дата",НомерСтроки,Истина);
		СтрокаДанных.Сумма			 = ПреоброзоватьЗначение("Сумма"
															,пЛистСДанными.Cells(НомерСтроки,НастройкиЗагрузки.НомерКолонки_Сумма).Value
															,"Число",НомерСтроки);
		СтрокаДанных.Количество		 = ПреоброзоватьЗначение("Количество"
															,пЛистСДанными.Cells(НомерСтроки,НастройкиЗагрузки.НомерКолонки_Количество).Value
															,"Число",НомерСтроки);
		СтрокаДанных.Цена			 = ПреоброзоватьЗначение("Цена"
															,пЛистСДанными.Cells(НомерСтроки,НастройкиЗагрузки.НомерКолонки_ЦенаБезНДС).Value
															,"Число",НомерСтроки);		
		СтрокаДанных.НоменклатураКод = пЛистСДанными.Cells(НомерСтроки,НастройкиЗагрузки.НомерКолонки_Номенклатура).Value;
		СтрокаДанных.Содержание 	 = пЛистСДанными.Cells(НомерСтроки,НастройкиЗагрузки.НомерКолонки_СодержаниеУслуги).Value;
		СтрокаДанных.СуммаНДС		 = ПреоброзоватьЗначение("Сумма НДС"
															,пЛистСДанными.Cells(НомерСтроки,НастройкиЗагрузки.НомерКолонки_НДС).Value
															,"Число",НомерСтроки);
		СтрокаДанных.СчетУчетаКод	 = пЛистСДанными.Cells(НомерСтроки,НастройкиЗагрузки.НомерКолонки_СчетУчета).Value;
		СтрокаДанных.СчетНДСКод		 = пЛистСДанными.Cells(НомерСтроки,НастройкиЗагрузки.НомерКолонки_СчетНДС).Value;
		СтрокаДанных.ФВБкод			 = пЛистСДанными.Cells(НомерСтроки,НастройкиЗагрузки.НомерКолонки_ФВБ).Text;
		СтрокаДанных.IDРазноскиКод	 = пЛистСДанными.Cells(НомерСтроки,НастройкиЗагрузки.НомерКолонки_IDРазноски).Value;
		СтрокаДанных.Всего			 = ПреоброзоватьЗначение("Всего с НДС"
															,пЛистСДанными.Cells(НомерСтроки,НастройкиЗагрузки.НомерКолонки_ВсегоСНДС).Value
															,"Число",НомерСтроки);
		
		//ЦФО	
		ПараметрыПоискаExcel = Новый Структура();
		ПараметрыПоискаExcel.Вставить("Лист", пЛистЦФО);
		ПараметрыПоискаExcel.Вставить("ТекущаяСтрокаExcel", НомерСтроки);
		ПараметрыПоискаExcel.Вставить("Поле", "ЦФО");
		ПараметрыПоискаExcel.Вставить("КолонкаПоиска", 2);
		ПараметрыПоискаExcel.Вставить("КолонкаЗначения", 1);
		
		КодЦФО = ПолучитьКодЗначения(ЦФО,пКэшЦФО,ПараметрыПоискаExcel,Истина);
		СтрокаДанных.ЦФОКод =  КодЦФО;
		
		//ОбъектСтроительства	
		ПараметрыПоискаExcel = Новый Структура();
		ПараметрыПоискаExcel.Вставить("Лист", пЛистОбъекты);
		ПараметрыПоискаExcel.Вставить("ТекущаяСтрокаExcel", НомерСтроки);
		ПараметрыПоискаExcel.Вставить("Поле", "Объект");
		ПараметрыПоискаExcel.Вставить("КолонкаПоиска", 2);
		ПараметрыПоискаExcel.Вставить("КолонкаЗначения", 1);
		
		КодОбъекта = ПолучитьКодЗначения(ОбъектСтроительства,пКэшОбъектов,ПараметрыПоискаExcel,Истина);
		СтрокаДанных.ОбъектКод = КодОбъекта;
		
		//Статья	
		ПараметрыПоискаExcel = Новый Структура();
		ПараметрыПоискаExcel.Вставить("Лист", пЛистСтатьи);
		ПараметрыПоискаExcel.Вставить("ТекущаяСтрокаExcel", НомерСтроки);
		ПараметрыПоискаExcel.Вставить("Поле", "Статья");
		ПараметрыПоискаExcel.Вставить("КолонкаПоиска", 2);
		ПараметрыПоискаExcel.Вставить("КолонкаЗначения", 1);
		
		КодСтатьи = ПолучитьКодЗначения(Статья,пКэшСтатей,ПараметрыПоискаExcel,Истина);
		СтрокаДанных.СтатьяКод = КодСтатьи;
		
		//Проект	
		ПараметрыПоискаExcel = Новый Структура();
		ПараметрыПоискаExcel.Вставить("Лист", пЛистПроекты);
		ПараметрыПоискаExcel.Вставить("ТекущаяСтрокаExcel", НомерСтроки);
		ПараметрыПоискаExcel.Вставить("Поле", "Проект");
		ПараметрыПоискаExcel.Вставить("КолонкаПоиска", 2);
		ПараметрыПоискаExcel.Вставить("КолонкаЗначения", 1);
		
		КодПроекта = ПолучитьКодЗначения(Проект,пКэшПроектов,ПараметрыПоискаExcel);
		СтрокаДанных.ПроектКод = КодПроекта;
		
		//Единица измерения	
		ПараметрыПоискаExcel = Новый Структура();
		ПараметрыПоискаExcel.Вставить("Лист", пЛистСлужебный);
		ПараметрыПоискаExcel.Вставить("ТекущаяСтрокаExcel", НомерСтроки);
		ПараметрыПоискаExcel.Вставить("Поле", "Единица измерения");
		ПараметрыПоискаExcel.Вставить("КолонкаПоиска", 4);
		ПараметрыПоискаExcel.Вставить("КолонкаЗначения", 3);
		
		КодЕдиницыИзмерения = ПолучитьКодЗначения(пЛистСДанными.Cells(НомерСтроки,НастройкиЗагрузки.НомерКолонки_ЕдиницаИзмерения).Value
		                                          ,пКэшЕдИзм,ПараметрыПоискаExcel);
		СтрокаДанных.КодЕдиницыИзмерения = КодЕдиницыИзмерения;
		
		//Ставка НДС
		СтавкаНДС = пЛистСДанными.Cells(НомерСтроки,НастройкиЗагрузки.НомерКолонки_СтавкаНДС).Text; 
		СтрокаДанных.СтавкаНДС = СоответствиеСтавокНДС.Получить(СтавкаНДС);		
		
		Если Не ЗначениеЗаполнено(СтрокаДанных.СтавкаНДС) Тогда
			ДобавитьОшибкуВЛогКлиент(НомерСтроки,СтавкаНДС,"Некорректное значение в поле: Ставка НДС");
		КонецЕсли;	
							
	КонецЦикла;
	
	Если ТаблицаДанных.Количество() Тогда 
		ЗагрузитьДанныеИзExcelСервер();	
	КонецЕсли;
	   	
	пExcel.Application.Quit();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеИзExcelСервер()
	
	Таблица = ТаблицаДанных.Выгрузить(,"ФВБкод,IDРазноскиКод,ок_Период");
	
	Для Каждого ТекущаяСтрока Из Таблица Цикл
		ТекущаяСтрока.ок_Период = НачалоГода(ТекущаяСтрока.ок_Период);
	КонецЦикла;	
	
	Таблица.Свернуть("ФВБкод,IDРазноскиКод,ок_Период");
	
	Если Таблица.Количество() = 1 Тогда
		
		Если ЗначениеЗаполнено(Таблица[0].ФВБкод) И ЗначениеЗаполнено(Таблица[0].IDРазноскиКод) Тогда 
			ДобавитьОшибкуВЛогСервер("","","В файле одновременно заполнены №ФВБ и ID-разноски");
			ЕстьОшибкиЗагрукзки = Истина;
		ИначеЕсли Не ЗначениеЗаполнено(Таблица[0].ФВБкод) И Не ЗначениеЗаполнено(Таблица[0].IDРазноскиКод) Тогда
			ДобавитьОшибкуВЛогСервер("","","В файле не заполнены № ФВБ и ID-разноски");
			ЕстьОшибкиЗагрукзки = Истина;
		КонецЕсли;
		
	Иначе 	
		
		ДобавитьОшибкуВЛогСервер("","","В файле некорректно заполнена связка № ФВБ, ID-разноски, Период");
		ЕстьОшибкиЗагрукзки = Истина;
		
	КонецЕсли;	
	 	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	ТаблицаДанных.ФВБкод КАК ФВБкод,
	                      |	ТаблицаДанных.ок_Период КАК ок_Период,
	                      |	ТаблицаДанных.ЦФОКод КАК ЦФОКод,
	                      |	ТаблицаДанных.ОбъектКод КАК ОбъектКод,
	                      |	ТаблицаДанных.ПроектКод КАК ПроектКод,
	                      |	ТаблицаДанных.СтатьяКод КАК СтатьяКод,
	                      |	ТаблицаДанных.НоменклатураКод КАК НоменклатураКод,
	                      |	ТаблицаДанных.КодЕдиницыИзмерения КАК КодЕдиницыИзмерения,
	                      |	ТаблицаДанных.СчетУчетаКод КАК СчетУчетаКод,
	                      |	ТаблицаДанных.СчетНДСКод КАК СчетНДСКод,
	                      |	ТаблицаДанных.IDРазноскиКод КАК IDРазноскиКод
	                      |ПОМЕСТИТЬ ВТ_ТаблицаДанных
	                      |ИЗ
	                      |	&ТаблицаДанных КАК ТаблицаДанных
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	бит_СтатьиОборотов.Ссылка КАК Ссылка,
	                      |	бит_СтатьиОборотов.Код КАК Код
	                      |ИЗ
	                      |	Справочник.бит_СтатьиОборотов КАК бит_СтатьиОборотов
	                      |ГДЕ
	                      |	бит_СтатьиОборотов.Код В
	                      |			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |				ВТ_ТаблицаДанных.СтатьяКод
	                      |			ИЗ
	                      |				ВТ_ТаблицаДанных
	                      |			ГДЕ
	                      |				ВТ_ТаблицаДанных.СтатьяКод <> """")
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	ОбъектыСтроительства.Ссылка КАК Ссылка,
	                      |	ОбъектыСтроительства.Код КАК Код
	                      |ИЗ
	                      |	Справочник.ОбъектыСтроительства КАК ОбъектыСтроительства
	                      |ГДЕ
	                      |	ОбъектыСтроительства.Код В
	                      |			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |				ВТ_ТаблицаДанных.ОбъектКод
	                      |			ИЗ
	                      |				ВТ_ТаблицаДанных
	                      |			ГДЕ
	                      |				ВТ_ТаблицаДанных.ОбъектКод <> """")
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	Проекты.Ссылка КАК Ссылка,
	                      |	Проекты.Код КАК Код
	                      |ИЗ
	                      |	Справочник.Проекты КАК Проекты
	                      |ГДЕ
	                      |	Проекты.Код В
	                      |			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |				ВТ_ТаблицаДанных.ПроектКод
	                      |			ИЗ
	                      |				ВТ_ТаблицаДанных
	                      |			ГДЕ
	                      |				ВТ_ТаблицаДанных.ПроектКод <> """")
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	Подразделения.Ссылка КАК Ссылка,
	                      |	Подразделения.Код КАК Код
	                      |ИЗ
	                      |	Справочник.Подразделения КАК Подразделения
	                      |ГДЕ
	                      |	Подразделения.Код В
	                      |			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |				ВТ_ТаблицаДанных.ЦФОКод
	                      |			ИЗ
	                      |				ВТ_ТаблицаДанных
	                      |			ГДЕ
	                      |				ВТ_ТаблицаДанных.ЦФОКод <> """")
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	Номенклатура.Ссылка КАК Ссылка,
	                      |	ВложенныйЗапрос.НоменклатураКод КАК Код
	                      |ИЗ
	                      |	Справочник.Номенклатура КАК Номенклатура
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |			ВТ_ТаблицаДанных.НоменклатураКод КАК НоменклатураКод
	                      |		ИЗ
	                      |			ВТ_ТаблицаДанных КАК ВТ_ТаблицаДанных
	                      |		ГДЕ
	                      |			ВТ_ТаблицаДанных.НоменклатураКод <> """") КАК ВложенныйЗапрос
	                      |		ПО Номенклатура.Код = ВложенныйЗапрос.НоменклатураКод
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	КлассификаторЕдиницИзмерения.Ссылка КАК Ссылка,
	                      |	КлассификаторЕдиницИзмерения.Код КАК Код
	                      |ИЗ
	                      |	Справочник.КлассификаторЕдиницИзмерения КАК КлассификаторЕдиницИзмерения
	                      |ГДЕ
	                      |	КлассификаторЕдиницИзмерения.Код В
	                      |			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |				ВТ_ТаблицаДанных.КодЕдиницыИзмерения
	                      |			ИЗ
	                      |				ВТ_ТаблицаДанных
	                      |			ГДЕ
	                      |				ВТ_ТаблицаДанных.КодЕдиницыИзмерения <> """")
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	Хозрасчетный.Ссылка КАК Ссылка,
	                      |	Хозрасчетный.Код КАК Код
	                      |ИЗ
	                      |	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	                      |ГДЕ
	                      |	Хозрасчетный.Код В
	                      |			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |				ВТ_ТаблицаДанных.СчетУчетаКод
	                      |			ИЗ
	                      |				ВТ_ТаблицаДанных
	                      |			ГДЕ
	                      |				ВТ_ТаблицаДанных.СчетУчетаКод <> """"
	                      |		
	                      |			ОБЪЕДИНИТЬ
	                      |		
	                      |			ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |				ВТ_ТаблицаДанных.СчетНДСКод
	                      |			ИЗ
	                      |				ВТ_ТаблицаДанных
	                      |			ГДЕ
	                      |				ВТ_ТаблицаДанных.СчетНДСКод <> """")
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	                      |	бит_ФормаВводаБюджета.Ссылка КАК Ссылка,
	                      |	ТаблицаДанных.ФВБкод КАК Код
	                      |ИЗ
	                      |	Документ.бит_ФормаВводаБюджета КАК бит_ФормаВводаБюджета
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ТаблицаДанных КАК ТаблицаДанных
	                      |		ПО (бит_ФормаВводаБюджета.Проведен)
	                      |			И (ТаблицаДанных.ФВБкод <> """")
	                      |			И (ТаблицаДанных.ок_Период <> ДАТАВРЕМЯ(1, 1, 1))
	                      |			И (НАЧАЛОПЕРИОДА(бит_ФормаВводаБюджета.Дата, ГОД) = НАЧАЛОПЕРИОДА(ТаблицаДанных.ок_Период, ГОД))
	                      |			И бит_ФормаВводаБюджета.Номер = ТаблицаДанных.ФВБкод
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	рс_ЗаявкаНаДоговор.ID КАК Ссылка,
	                      |	рс_ЗаявкаНаДоговор.ID КАК Код
	                      |ИЗ
	                      |	Документ.рс_ЗаявкаНаДоговор КАК рс_ЗаявкаНаДоговор
	                      |ГДЕ
	                      |	рс_ЗаявкаНаДоговор.Проведен
	                      |	И рс_ЗаявкаНаДоговор.ID В
	                      |			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |				ВТ_ТаблицаДанных.IDРазноскиКод
	                      |			ИЗ
	                      |				ВТ_ТаблицаДанных
	                      |			ГДЕ
	                      |				ВТ_ТаблицаДанных.IDРазноскиКод <> """")");
		
	
	
	Запрос.УстановитьПараметр("ТаблицаДанных",ТаблицаДанных.Выгрузить());
		
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ТаблицаСтатей			= РезультатЗапроса[1].Выгрузить();
	ТаблицаОбъектов			= РезультатЗапроса[2].Выгрузить();
	ТаблицаПроектов			= РезультатЗапроса[3].Выгрузить();
	ТаблицаЦФО				= РезультатЗапроса[4].Выгрузить();
	ТаблицаНоменклатуры		= РезультатЗапроса[5].Выгрузить();
	ТаблицаЕдиницИзиерения	= РезультатЗапроса[6].Выгрузить();
	ТаблицаСчетовУчета		= РезультатЗапроса[7].Выгрузить();
	ТаблицаФВБ				= РезультатЗапроса[8].Выгрузить();
	ТаблицаРазноски			= РезультатЗапроса[9].Выгрузить();
	
	
	Для Каждого ТекущаяСтрока Из ТаблицаДанных Цикл 
			
		ТекущаяСтрока.ФВБ				= ПолучитьСсылкуПоКоду(ТекущаяСтрока.ФВБкод,ТаблицаФВБ
																,ТекущаяСтрока.НомерСтрокиФайла,"ФВБ",Истина);
		ТекущаяСтрока.IDРазноски		= ПолучитьСсылкуПоКоду(ТекущаяСтрока.IDРазноскиКод,ТаблицаРазноски
																,ТекущаяСтрока.НомерСтрокиФайла,"ID разноски",Истина);		
		ТекущаяСтрока.ок_ЦФО			= ПолучитьСсылкуПоКоду(ТекущаяСтрока.ЦФОКод,ТаблицаЦФО
																,ТекущаяСтрока.НомерСтрокиФайла,"ЦФО");
		ТекущаяСтрока.ок_Аналитика_2	= ПолучитьСсылкуПоКоду(ТекущаяСтрока.ОбъектКод,ТаблицаОбъектов,ТекущаяСтрока.НомерСтрокиФайла
																,"Объект строительства");
		ТекущаяСтрока.ок_Проект			= ПолучитьСсылкуПоКоду(ТекущаяСтрока.ПроектКод,ТаблицаПроектов
																,ТекущаяСтрока.НомерСтрокиФайла,"Проекта");
		ТекущаяСтрока.ок_СтатьяОборотов	= ПолучитьСсылкуПоКоду(ТекущаяСтрока.СтатьяКод,ТаблицаСтатей
																,ТекущаяСтрока.НомерСтрокиФайла,"Статьи оборотов");
		ТекущаяСтрока.Номенклатура		= ПолучитьСсылкуПоКоду(ТекущаяСтрока.НоменклатураКод,ТаблицаНоменклатуры
																,ТекущаяСтрока.НомерСтрокиФайла,"Номенклатура");
		ТекущаяСтрока.ЕдиницаИзмерения	= ПолучитьСсылкуПоКоду(ТекущаяСтрока.КодЕдиницыИзмерения,ТаблицаЕдиницИзиерения
																,ТекущаяСтрока.НомерСтрокиФайла,"Единица измерения");
		ТекущаяСтрока.СчетУчета			= ПолучитьСсылкуПоКоду(ТекущаяСтрока.СчетУчетаКод,ТаблицаСчетовУчета
																,ТекущаяСтрока.НомерСтрокиФайла,"Счет учета");
		ТекущаяСтрока.СчетУчетаНДС		= ПолучитьСсылкуПоКоду(ТекущаяСтрока.СчетНДСКод,ТаблицаСчетовУчета
																,ТекущаяСтрока.НомерСтрокиФайла,"Счет учета НДС");
		ТекущаяСтрока.СчетЗатрат		= ТекущаяСтрока.СчетУчета;
		
		Если ЗначениеЗаполнено(ТекущаяСтрока.ФВБ) 
			И ЗначениеЗаполнено(ТекущаяСтрока.ок_ЦФО)
			И ЗначениеЗаполнено(ТекущаяСтрока.ок_СтатьяОборотов)
			И ЗначениеЗаполнено(ТекущаяСтрока.ок_Аналитика_2) 
			И ЗначениеЗаполнено(ТекущаяСтрока.ок_Период) Тогда
			
			Отбор = Новый Структура();
			Отбор.Вставить("ЦФО", ТекущаяСтрока.ок_ЦФО);
			Отбор.Вставить("СтатьяОборотов", ТекущаяСтрока.ок_СтатьяОборотов);
			Отбор.Вставить("Аналитика_2", ТекущаяСтрока.ок_Аналитика_2);
			Отбор.Вставить("Период", ТекущаяСтрока.ок_Период);
			
			
			НайденныеСтроки = ТекущаяСтрока.ФВБ.БДДС.НайтиСтроки(Отбор);
			
			Если Не НайденныеСтроки.Количество() Тогда 
				ДобавитьОшибкуВЛогСервер(ТекущаяСтрока.НомерСтрокиФайла,""," В строке файла Excel управленческие аналитики 
				                                                             |не соответствуют аналитикам в заявке ФВБ");
			КонецЕсли;	
			
		КонецЕсли;	
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСсылкуПоКоду(Код,ТаблицаСсылок,НомерСтрокиФайла,Поле, ОбязательнаяАналитика = Ложь)
	
	Ссылка = Неопределено;
	
	Если Не ПустаяСтрока(Код) Тогда 
		
		НайденныеЭлементы = ТаблицаСсылок.НайтиСтроки(Новый Структура("Код",Код));
		
		КоличествоНайденныхСтрок = НайденныеЭлементы.Количество(); 
		
		Если КоличествоНайденныхСтрок = 0 
			ИЛИ КоличествоНайденныхСтрок > 1 Тогда 
			
			ДобавитьОшибкуВЛогСервер(НомерСтрокиФайла,Код,?(КоличествоНайденныхСтрок = 0
			                                                ,"Не найден элемент " + Поле + " по коду из файла"
															,"По коду из файла найдено несколько элементов " + Поле));
			
			Если ОбязательнаяАналитика Тогда 
				ЕстьОшибкиЗагрукзки = Истина;
			КонецЕсли;	
			
		Иначе
			Ссылка = НайденныеЭлементы[0].Ссылка;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ссылка;
	
КонецФункции	

&НаКлиенте
Функция ПолучитьНастройкиЗагрузки()
	
	СтруктураРезультат = Новый Структура;
		
	СписокНастроек = СБ_КазначействоПовтИсп.ПолучитьЗначениеКонстанты("НастройкаЗагрузкиДанныхПТиУИзExcelФайла");
	
	Если СписокНастроек = Неопределено Тогда 
		Возврат СтруктураРезультат;
	КонецЕсли;
		
	Для Каждого ЭлементНастройки Из СписокНастроек Цикл 
		СтруктураРезультат.Вставить(ЭлементНастройки.Представление, ЭлементНастройки.Значение);
	КонецЦикла;
	
	Возврат СтруктураРезультат;	
	
КонецФункции

&НаКлиенте
Функция ПолучитьКодЗначения(Значение,Кэш,ПараметрыПоискаExcel,ОбязательнаяАналитика = Ложь)
	
	КодЗначения = Неопределено;
	
	Если ЗначениеЗаполнено(Значение) Тогда
		
		КодЗначения = Кэш.Получить(Значение);
		
		Если КодЗначения = Неопределено Тогда 
			
			КодЗначения = ПолучитьКодСДругихЛистовExcel(Значение
			                                           ,ПараметрыПоискаExcel.Лист
													   ,ПараметрыПоискаExcel.ТекущаяСтрокаExcel
													   ,ПараметрыПоискаExcel.Поле
													   ,ПараметрыПоискаExcel.КолонкаПоиска
													   ,ПараметрыПоискаExcel.КолонкаЗначения);
			
			Если ЗначениеЗаполнено(КодЗначения) Тогда 
                КодЗначения = СокрЛП(КодЗначения);
				Кэш.Вставить(Значение, КодЗначения);
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ОбязательнаяАналитика Тогда 
		ЕстьОшибкиЗагрукзки = Истина;
		ДобавитьОшибкуВЛогКлиент(ПараметрыПоискаExcel.ТекущаяСтрокаExcel,""
		                         ,"Не заполнена обязательная аналитика: " + ПараметрыПоискаExcel.Поле);	
	КонецЕсли;
	
	Возврат КодЗначения;
	
КонецФункции

&НаКлиенте
Функция ПолучитьКодСДругихЛистовExcel(парЗначениеЯчейки,парЛист,ТекущаяСтрокаExcel,Поле,КолонкаПоиска,КолонкаЗначения)
	
	Попытка
		пКодНайденного = парЛист.Cells(пExcel.Application.WorksheetFunction.Match(парЗначениеЯчейки,парЛист.Columns(КолонкаПоиска), 0),КолонкаЗначения).Value;
	Исключение
	КонецПопытки;
			
	Если НЕ ЗначениеЗаполнено(пКодНайденного) Тогда
		
		ДобавитьОшибкуВЛогКлиент(ТекущаяСтрокаExcel,парЗначениеЯчейки,"Некорректное значение в поле: " + Поле);
			
	КонецЕсли;	
	
	Возврат пКодНайденного;
	
КонецФункции

&НаКлиенте
Функция ПреоброзоватьЗначение(Поле,Значение,ТипЗначения,НомерСтрокиФайла,ОбязательнаяАналитика = Ложь)
	
	Если ТипЗначения = "Дата" Тогда
		ПреобразованноеЗначение = Дата(1,1,1);
	Иначе 
		ПреобразованноеЗначение = 0;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Значение) Тогда
		
		Если ТипЗнч(Значение) <> Тип(ТипЗначения) Тогда 
			
			Попытка
			
				Если ТипЗначения = "Дата" Тогда
					ПреобразованноеЗначение = Дата(Значение);
				Иначе 
					ПреобразованноеЗначение = Число(Значение);
				КонецЕсли;	
								
			Исключение
				пСтрокаОшибки = ТаблицаОшибок.Добавить();
				пСтрокаОшибки.НомерСтрокиФайла    = НомерСтрокиФайла;
				пСтрокаОшибки.ЗначениеВФайле      = Значение;
				пСтрокаОшибки.РасшифровкаОшибки   = "Некорректное значение в поле: " + Поле;			
			КонецПопытки;
			
		Иначе 
			
			ПреобразованноеЗначение = Значение; 
			
		КонецЕсли;
		
	ИначеЕсли ОбязательнаяАналитика Тогда 
		
		ЕстьОшибкиЗагрукзки = Истина;
		ДобавитьОшибкуВЛогКлиент(НомерСтрокиФайла,"","Не заполнена обязательная аналитика: " + Поле);
		
	КонецЕсли;
	
	Возврат ПреобразованноеЗначение;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьОшибкуВЛогКлиент(НомерСтрокиФайла,ЗначениеВФайле,РасшифровкаОшибки)
	
	СтрокаОшибки = ТаблицаОшибок.Добавить();
	СтрокаОшибки.НомерСтрокиФайла  = НомерСтрокиФайла;
	СтрокаОшибки.ЗначениеВФайле    = ЗначениеВФайле;
	СтрокаОшибки.РасшифровкаОшибки = РасшифровкаОшибки;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьОшибкуВЛогСервер(НомерСтрокиФайла,ЗначениеВФайле,РасшифровкаОшибки)
	
	СтрокаОшибки = ТаблицаОшибок.Добавить();
	СтрокаОшибки.НомерСтрокиФайла  = НомерСтрокиФайла;
	СтрокаОшибки.ЗначениеВФайле    = ЗначениеВФайле;
	СтрокаОшибки.РасшифровкаОшибки = РасшифровкаОшибки;
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиЛогКлиент()
		
	ТаблицаОшибок.Сортировать("НомерСтрокиФайла Возр");
	
	ТабДокумент = СформироватьЛогНаСервере();
		
	ТабДокумент.Показать("Лог ошибок загрузки файла","Лог ошибок загрузки файла",Истина);
	
КонецПроцедуры

&НаСервере
Функция СформироватьЛогНаСервере()
	
	ТабДокумент = Новый ТабличныйДокумент;
	Макет = обработки.ок_ЗагрузкаИзExcelПТиУ.ПолучитьМакет("МакетЛогаОшибок");
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ТабДокумент.Вывести(ОбластьШапка);
	
	ОбластьСтрока = Макет.ПолучитьОбласть("СтрокаФайла");
	
	НПП = 1;
	
	Для Каждого СтрокаТО Из ТаблицаОшибок Цикл 
		ОбластьСтрока.Параметры.Заполнить(СтрокаТО);
		ОбластьСтрока.Параметры.НомерПП = НПП;
		ТабДокумент.Вывести(ОбластьСтрока);
		НПП = НПП + 1;
	КонецЦикла;
		
	ТабДокумент.АвтоМасштаб	= Истина;
	ТабДокумент.ОтображатьСетку	= Ложь;
	ТабДокумент.ТолькоПросмотр = Истина;
	ТабДокумент.ОтображатьЗаголовки = Ложь;
	
	Возврат ТабДокумент;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьТЧДокумента()
	
	Если Не ЕстьОшибкиЗагрукзки Тогда 
		Закрыть(ПолучитьАдресНаСервере());
	КонецЕсли;

КонецПроцедуры	

&НаСервере
Функция ПолучитьАдресНаСервере()
	
	Возврат ПоместитьВоВременноеХранилище(ТаблицаДанных.Выгрузить(),Новый УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти



									
										


