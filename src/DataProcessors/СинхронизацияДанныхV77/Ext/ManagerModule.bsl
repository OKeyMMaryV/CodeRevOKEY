﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	///////////////////////////////////////////////////////////////////////////////////////////////////
	
	Процедура ЗагрузитьДанныеВИБ(ПараметрыВыгрузки, АдресХранилища) Экспорт
		
		ОтчетТаблицаСоответствий = ПараметрыВыгрузки.ОтчетТаблицаСоответствий;
				
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
		ДвоичныеДанныеФайла = ПараметрыВыгрузки.ДвоичныеДанныеФайла;
		ДвоичныеДанныеФайла.Записать(ИмяВременногоФайла);
		
		ОбработкаОбмена = Обработки.УниверсальныйОбменДаннымиXML.Создать();
		ОбработкаОбмена.РежимОбмена = "Загрузка";
		ОбработкаОбмена.ИмяФайлаОбмена = ИмяВременногоФайла;
		
		Попытка
			ОбработкаОбмена.ОткрытьФайлЗагрузки(Истина);
		Исключение
			ТекстСообщения = НСтр("ru = 'При чтении данных произошла ошибка:'") + Символы.ПС
			+ ОписаниеОшибки()+ Символы.ПС 
			+ НСтр("ru = 'Ошибка в формате файла данных.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецПопытки;
		
		Если НЕ ОбработкаОбмена.мБылиПрочитаныПравилаОбменаПриЗагрузке Тогда
			ТекстСообщения = НСтр("ru = 'При чтении данных произошла ошибка.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецЕсли;
		
		ОбработкаОбмена.РежимОтладкиАлгоритмов                      = 3;
		ОбработкаОбмена.ФлагРежимОтладкиОбработчиков                = Истина;
		ОбработкаОбмена.ФлагРежимОтладки                            = Истина;
		ОбработкаОбмена.ОбрезатьСтрокиСправа                        = Истина;
		ОбработкаОбмена.ИмяФайлаВнешнейОбработкиОбработчиковСобытий = "ОбработчикиЗагрузкиИзБухгалтерии77";
		
		ОбработкаОбмена.ВыполнитьЗагрузку();
		
		//получим таблицу соответствий документов
		АдресТаблицыСоответствийДокументов = ОбработкаОбмена.Параметры.АдресТаблицыСоответствийДокументов;
		ТаблицаСоответствий = ПолучитьИзВременногоХранилища(АдресТаблицыСоответствийДокументов);
		
		ФайлОбмена = Новый ЧтениеXML();
		ФайлОбмена.ОткрытьФайл(ИмяВременногоФайла);
		ФайлОбмена.Прочитать();
		
		УдаленныеДокументы   = ФайлОбмена.ПолучитьАтрибут("УдаленныеДокументы");
		ДатаНачалаВыборки    = XMLЗначение(Тип("Дата"),ФайлОбмена.ПолучитьАтрибут("ДатаНачалаВыборки"));
		ДатаОкончанияВыборки = XMLЗначение(Тип("Дата"),ФайлОбмена.ПолучитьАтрибут("ДатаОкончанияВыборки"));
		КолДок = СтрЧислоВхождений(УдаленныеДокументы, ",");
		МассивУдаленныхДокументов = Новый Массив;
		
		Если КолДок > 0 Тогда
			Для А = 0 По КолДок Цикл
				Поз = СтрНайти(УдаленныеДокументы, ",");
				Док = Сред(УдаленныеДокументы, 0, Поз-1);
				
				Если СтрНайти(Док, "_") > 0 Тогда
					Док = СтрЗаменить(Док, "_", ",");
				КонецЕсли;	
				
				МассивУдаленныхДокументов.Добавить(Док);
				УдаленныеДокументы = Сред(УдаленныеДокументы, Поз+1);
			КонецЦикла;	
		КонецЕсли;
		
		Если МассивУдаленныхДокументов.Количество() > 0 Тогда
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("ДатаНач", НачалоДня(ДатаНачалаВыборки));
			Запрос.УстановитьПараметр("ДатаКон", КонецДня(ДатаОкончанияВыборки));
			
			Для Каждого ДокументМетаданные ИЗ Метаданные.Документы Цикл
				Условие = "";
				СтрокаПоиска = "";
				Если ДокументМетаданные.Имя = "ОперацияБух" Тогда
					Условие = "ВЫРАЗИТЬ (Ссылка.Содержание КАК СТРОКА(250)), """ + ДокументМетаданные.Имя;
					СтрокаПоиска = "ВЫРАЗИТЬ (Ссылка.Содержание КАК СТРОКА(250))";
				ИначеЕсли НЕ ДокументМетаданные.Реквизиты.Найти("Комментарий") = Неопределено Тогда
					Условие = "ВЫРАЗИТЬ (Ссылка.Комментарий КАК СТРОКА(250)), """ + ДокументМетаданные.Имя;
					СтрокаПоиска = "ВЫРАЗИТЬ (Ссылка.Комментарий КАК СТРОКА(250))";
				Иначе
					Продолжить;
				КонецЕсли;
				
				Запрос.Текст = Запрос.Текст + ?(Запрос.Текст = "", "", "
				|ОБЪЕДИНИТЬ ВСЕ
				|") + "ВЫБРАТЬ " + Условие + """ КАК ИмяДокумента, Ссылка КАК Ссылка, Дата КАК Дата ИЗ Документ." + ДокументМетаданные.Имя + " КАК Док" + "
				|ГДЕ НЕ ПометкаУдаления И Док.Дата МЕЖДУ &ДатаНач И &ДатаКон И (";
				
				Инд = 1;
				Для Каждого Строка из МассивУдаленныхДокументов Цикл
					Запрос.Текст = Запрос.Текст + ?(Инд = 1, СтрокаПоиска, " ИЛИ " + СтрокаПоиска);
					
					Запрос.Текст = Запрос.Текст + "
					|ПОДОБНО ""%" + СокрЛП(Строка) + "%""";
					
					Инд = Инд + 1;
				КонецЦикла;
				
				Запрос.Текст = Запрос.Текст + ")";
			КонецЦикла;
			
			ТаблицаДокументов = Запрос.Выполнить().Выгрузить();
			ВсегоДокументов   = ТаблицаДокументов.Количество();
			
			Для Индекс = 0 ПО ВсегоДокументов - 1 Цикл
				СтрокаТаблицы = ТаблицаДокументов[Индекс];
				ДокументОбъект = СтрокаТаблицы.Ссылка.ПолучитьОбъект();
				
				Если НЕ ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ОперацияБух") Тогда
					Попытка
						ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
					Исключение
						ТекстСообщения = НСтр("ru = 'Не удалось записать документ: %1.'");
						ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ДокументОбъект);
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
					КонецПопытки;
				КонецЕсли;
				
				ДокументОбъект.ПометкаУдаления = Истина;
				
				Попытка
					ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
				Исключение
					ТекстСообщения = НСтр("ru = 'Не удалось записать документ: %1.'");
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ДокументОбъект);
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				КонецПопытки;
				
				Док77 = СинхронизацияДанныхV77ВызовСервера.ПолучитьПредставлениеДокумента77(ДокументОбъект);
				
				НоваяСтрока = ТаблицаСоответствий.Добавить();
				НоваяСтрока.Документ77 = Док77 + " (удален из информационнной базы 1С:Бухгалтерии 7.7)";
				НоваяСтрока.Объект     = ДокументОбъект;
				НоваяСтрока.ПредставлениеОбъекта = Строка(ДокументОбъект) + " (помечен на удаление)";
			КонецЦикла;	
		КонецЕсли;
		
		Макет = Обработки.СинхронизацияДанныхV77.ПолучитьМакет("ТаблицаСоответствий");
		
		ОбластьШапка  = Макет.ПолучитьОбласть("Шапка");
		ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
		
		Для Каждого СтрокаТаблицы Из ТаблицаСоответствий Цикл
			СтрокаТаблицы.Объект = СтрокаТаблицы.Объект.Ссылка;
		КонецЦикла;
		
		ТаблицаСоответствий.Свернуть("Документ77, Объект, ПредставлениеОбъекта");
		
		ОтчетТаблицаСоответствий.Вывести(ОбластьШапка);
		НПП = 0;
		
		Для Каждого СтрокаТаблицы Из ТаблицаСоответствий Цикл
			Если (СтрокаТаблицы.Объект = Неопределено) или 
				(НЕ ЗначениеЗаполнено(СтрокаТаблицы.Документ77)) Тогда
				Продолжить;
			Иначе
				НПП = НПП + 1;
				ОбластьСтрока.Параметры.НПП = НПП;
				ОбластьСтрока.Параметры.Документ77  = СтрокаТаблицы.Документ77;
				ОбластьСтрока.Параметры.Документ8   = СтрокаТаблицы.ПредставлениеОбъекта;
				ОбластьСтрока.Параметры.Расшифровка = СтрокаТаблицы.Объект;
				
				ОтчетТаблицаСоответствий.Вывести(ОбластьСтрока);
			КонецЕсли;
		КонецЦикла;
		
		Результат = Новый Структура("ОтчетТаблицаСоответствий", ОтчетТаблицаСоответствий);
			
		ПоместитьВоВременноеХранилище(Результат, АдресХранилища);
		
	КонецПроцедуры		
	
#КонецЕсли