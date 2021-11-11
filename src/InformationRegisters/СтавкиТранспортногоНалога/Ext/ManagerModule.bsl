﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ЗагрузитьСтавкиИзСервисаКлассификаторов(Параметры, АдресРезультата) Экспорт 

	Классификаторы = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ИдентификаторВСервисеКлассификаторов());
	РезультатЗагрузкиСтавок = РаботаСКлассификаторами.ОбновитьКлассификаторы(Классификаторы);
		
	Если НЕ ПустаяСтрока(РезультатЗагрузкиСтавок.КодОшибки) Тогда
		
		ШаблонСообщения = НСтр("ru = 'При загрузке ставок транспортного налога с сервиса классификаторов возникла ошибка:
								|%1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, РезультатЗагрузкиСтавок.ИнформацияОбОшибке);
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Обновление ставок транспортного налога'"), 
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.РегистрыСведений.СтавкиТранспортногоНалога,, 
			ТекстСообщения);
						
	КонецЕсли;	

КонецПроцедуры

Функция СтавкиНеЗаполнены() Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СтавкиТранспортногоНалога.НалоговаяСтавка КАК НалоговаяСтавка
		|ИЗ
		|	РегистрСведений.СтавкиТранспортногоНалога КАК СтавкиТранспортногоНалога";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Пустой();
	
КонецФункции 

Функция ИдентификаторВСервисеКлассификаторов() Экспорт 

	Возврат "RegionalTransportTaxRates";

КонецФункции
 
#КонецОбласти
	
#Область СлужебныйПрограммныйИнтерфейс

// ИнтернетПоддержкаПользователей.РаботаСКлассификаторами

// См. РаботаСКлассификаторамиПереопределяемый.ПриДобавленииКлассификаторов.
Процедура ПриДобавленииКлассификаторов(Классификаторы) Экспорт
	
	Описатель = РаботаСКлассификаторами.ОписаниеКлассификатора();
	Описатель.Наименование           = НСтр("ru = 'Региональные ставки транспортного налога'");
	Описатель.Идентификатор          = ИдентификаторВСервисеКлассификаторов();
	Описатель.ОбновлятьАвтоматически = Истина;
	Описатель.ОбщиеДанные            = Истина;

	Классификаторы.Добавить(Описатель);
	
КонецПроцедуры

// См. РаботаСКлассификаторамиПереопределяемый.ПриЗагрузкеКлассификатора.
Процедура ПриЗагрузкеКлассификатора(Идентификатор, Версия, Адрес, Обработан) Экспорт
	
	Если Идентификатор <> ИдентификаторВСервисеКлассификаторов() Тогда
		Возврат;
	КонецЕсли;
	
	Ставки = Новый ТаблицаЗначений;
	
	Ставки.Колонки.Добавить("НалоговыйПериод", ОбщегоНазначения.ОписаниеТипаЧисло(4,0, ДопустимыйЗнак.Неотрицательный));
    Ставки.Колонки.Добавить("НомерРегиона", ОбщегоНазначения.ОписаниеТипаЧисло(2,0, ДопустимыйЗнак.Неотрицательный));
    Ставки.Колонки.Добавить("КатегорияТС", ОбщегоНазначения.ОписаниеТипаСтрока(3));
    Ставки.Колонки.Добавить("МощностьМин", ОбщегоНазначения.ОписаниеТипаЧисло(5,2, ДопустимыйЗнак.Неотрицательный));
    Ставки.Колонки.Добавить("МощностьМакс", ОбщегоНазначения.ОписаниеТипаЧисло(5,2, ДопустимыйЗнак.Неотрицательный));
    Ставки.Колонки.Добавить("ВозрастТСМин", ОбщегоНазначения.ОписаниеТипаЧисло(2,0, ДопустимыйЗнак.Неотрицательный));
    Ставки.Колонки.Добавить("ВозрастТСМакс", ОбщегоНазначения.ОписаниеТипаЧисло(2,0, ДопустимыйЗнак.Неотрицательный));
    Ставки.Колонки.Добавить("НалоговаяСтавка", ОбщегоНазначения.ОписаниеТипаЧисло(10,2, ДопустимыйЗнак.Неотрицательный));

	ПутьКФайлу = ПолучитьИмяВременногоФайла();
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(Адрес);
	ДвоичныеДанные.Записать(ПутьКФайлу);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ПутьКФайлу);
	ЧтениеXML.ПерейтиКСодержимому();
	
	Пока ЧтениеXML.Прочитать() Цикл
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеXML.Имя = "Ставка" Тогда
			НоваяСтавка = Ставки.Добавить();
			Пока ЧтениеXML.Прочитать() Цикл
				
				Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
					ИмяКолонки = ЧтениеXML.Имя;
				ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда	
					Колонка = Ставки.Колонки.Найти(ИмяКолонки);
					// В файле есть данные, которые пока не используются
					Если Колонка = Неопределено Тогда
						Продолжить;
					КонецЕсли;	
					ТипЗначения = Колонка.ТипЗначения;
					НоваяСтавка[ИмяКолонки] = XMLЗначение(ТипЗначения.Типы()[0], ЧтениеXML.Значение);
				ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента И ЧтениеXML.Имя = "Ставка" Тогда
					Прервать;
				КонецЕсли;	
			
			КонецЦикла;
			
		КонецЕсли;
	КонецЦикла;
		
	ЧтениеXML.Закрыть();
	УдалитьФайлы(ПутьКФайлу);
	
	ПоляКлюча = "НалоговыйПериод, НомерРегиона, КатегорияТС";
	
	Ставки.Индексы.Добавить(ПоляКлюча);
	
	Группировки = Ставки.Скопировать(, ПоляКлюча);
	Группировки.Свернуть(ПоляКлюча);
	
	// Таблица ОКТМО регионов
	Макет = РегистрыСведений.СтавкиТранспортногоНалога.ПолучитьМакет("КодыОКТМОСубъектовРФ");
	КодыОКТМОСубъектовРФ = ОбщегоНазначения.ПрочитатьXMLВТаблицу(Макет.ПолучитьТекст()).Данные;
	ОКТМОРегионов = Новый Соответствие;
	
	Отбор = Новый Структура(ПоляКлюча);
	Набор = РегистрыСведений.СтавкиТранспортногоНалога.СоздатьНаборЗаписей();
	
	ЕстьОшибки = Ложь;
	
	ТаблицаРегионов = АдресныйКлассификатор.СубъектыРФ();  // вспомогательная таблица для вывода наименования региона в сообщениях
	ШаблонПредставленияРегиона = НСтр("ru='%1 %2'"); //например: "Москва г"
	
	// Обновляем все ставки для отдельной категории ТС в одном регионе единой порцией (набором записей).
	// Так как мы рассматриваем ставки по отдельной категории ТС, как неделимую порцию данных, то это гарантирует, 
	// что при изменении интервалов мощности и/или возраста ТС внутри отдельной категории ТС обновление пройдет корректно.
	Для каждого Группировка Из Группировки Цикл
		
		НачатьТранзакцию();
		Попытка
		
			КатегорияТС = Перечисления.КатегорииТранспортныхСредств[Группировка.КатегорияТС];
			
			КодОКТМО = ОКТМОРегионов.Получить(Группировка.НомерРегиона);
			Если КодОКТМО = Неопределено Тогда
				СтрокаСоответствия = КодыОКТМОСубъектовРФ.Найти(Строка(Группировка.НомерРегиона), "КодСубъектаРФ");
				Если СтрокаСоответствия = Неопределено Тогда
					
					ОтменитьТранзакцию();
										
					СтрокаРегиона = ТаблицаРегионов.Найти(Группировка.НомерРегиона, "КодСубъектаРФ");
					НаименованиеРегиона = Группировка.НомерРегиона;
					Если СтрокаРегиона <> Неопределено Тогда
						НаименованиеРегиона = СтрШаблон(ШаблонПредставленияРегиона, СтрокаРегиона.Наименование, СтрокаРегиона.Сокращение);
					КонецЕсли;	
					
					ШаблонСообщения = НСтр("ru = 'Не выполнено обновление ставок транспортного налога в регионе ""%1"" по категории ""%2"" за %3 год:
					                        |не найден код ОКТМО региона'");
					
					ТекстСообщения = СтрШаблон(ШаблонСообщения,
						НаименованиеРегиона,
						КатегорияТС,
						Формат(Группировка.НалоговыйПериод, "ЧГ=0"));
						
					ЗаписьЖурналаРегистрации(
						НСтр("ru = 'Обновление ставок транспортного налога'"), 
						УровеньЖурналаРегистрации.Ошибка,
						Метаданные.РегистрыСведений.СтавкиТранспортногоНалога,, 
						ТекстСообщения);
					
					ЕстьОшибки = Истина;
					Продолжить;
					
				КонецЕсли;	

				КодОКТМО = СтрокаСоответствия.КодОКТМО;
				ОКТМОРегионов.Вставить(Группировка.НомерРегиона, КодОКТМО);
			КонецЕсли;	
			
			Период = Дата(Группировка.НалоговыйПериод, 1, 1);
			
			// Устанавливаем исключительную блокировку на записи регистра сведений, чтобы предотвратить
			// параллельный запуск обновления ставок из другого сеанса.
			БлокировкаДанных = Новый БлокировкаДанных;
			ЭлементБлокировки = БлокировкаДанных.Добавить("РегистрСведений.СтавкиТранспортногоНалога");
			ЭлементБлокировки.УстановитьЗначение("Период", Период);
			ЭлементБлокировки.УстановитьЗначение("ОКТМО", КодОКТМО);
			ЭлементБлокировки.УстановитьЗначение("НаименованиеОбъектаНалогообложения", КатегорияТС);
			
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			БлокировкаДанных.Заблокировать();
			
			Набор.Очистить();
			
			Набор.Отбор.Период.Установить(Период);
			Набор.Отбор.ОКТМО.Установить(КодОКТМО);
			Набор.Отбор.НаименованиеОбъектаНалогообложения.Установить(КатегорияТС);
			
			ЗаполнитьЗначенияСвойств(Отбор, Группировка);
			СтавкиПоКатегории = Ставки.НайтиСтроки(Отбор);
			
			Для каждого Ставка Из СтавкиПоКатегории Цикл
				
				НоваяЗапись = Набор.Добавить();
				
				НоваяЗапись.Период = Период;
				НоваяЗапись.ОКТМО = КодОКТМО;
				НоваяЗапись.НаименованиеОбъектаНалогообложения = КатегорияТС;
				
				НоваяЗапись.МинимальноеЗначениеМощности = Ставка.МощностьМин;
				НоваяЗапись.МаксимальноеЗначениеМощности = Ставка.МощностьМакс;
				НоваяЗапись.МинимальноеКоличествоЛетСГодаВыпускаТС = Ставка.ВозрастТСМин;
				НоваяЗапись.МаксимальноеКоличествоЛетСГодаВыпускаТС = Ставка.ВозрастТСМакс;
				НоваяЗапись.НалоговаяСтавка = Ставка.НалоговаяСтавка;
							
			КонецЦикла; 
		
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
			ЗафиксироватьТранзакцию();
		Исключение
			
			ОтменитьТранзакцию();
			
			СтрокаРегиона = ТаблицаРегионов.Найти(Группировка.НомерРегиона, "КодСубъектаРФ");
			НаименованиеРегиона = Группировка.НомерРегиона;
			Если СтрокаРегиона <> Неопределено Тогда
				НаименованиеРегиона = СтрШаблон(ШаблонПредставленияРегиона, СтрокаРегиона.Наименование, СтрокаРегиона.Сокращение);
			КонецЕсли;	
	
			ШаблонСообщения = НСтр("ru = 'Не выполнено обновление ставок транспортного налога в регионе ""%1"" (ОКТМО %2) по категории ""%3"" за %4 год:
			                        |%5'");
			
			ТекстСообщения = СтрШаблон(ШаблонСообщения,
				НаименованиеРегиона,
				КодОКТМО,
				КатегорияТС,
				Формат(Группировка.НалоговыйПериод, "ЧГ=0"),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Обновление ставок транспортного налога'"), 
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.РегистрыСведений.СтавкиТранспортногоНалога,, 
				ТекстСообщения);
				
			ЕстьОшибки = Истина;
			
		КонецПопытки;
		
	КонецЦикла;  
	
	Обработан = НЕ ЕстьОшибки;
		
КонецПроцедуры

// Конец ИнтернетПоддержкаПользователей.РаботаСКлассификаторами

#КонецОбласти

#КонецЕсли