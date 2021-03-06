
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс
	   
// Процедура формирует список документов отражения ДДС, с указанными отборами.
//
Процедура ОбработатьДанные() Экспорт

	СКД = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных"); 
	
	
	// Формирование макета, с помощью компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	// получаем период
	
	// НачалоПериода = НачалоДня(Период.ДатаНачала);
	// КонецПериода = КонецДня(Период.ДатаОкончания);
	//
	// бит_ОтчетыСервер.УстановитьЗначениеПараметраКомпоновщика(Компоновщик, 
	//														 НачалоПериода, 
	//														 "НачалоПериода");
	//														 
	// бит_ОтчетыСервер.УстановитьЗначениеПараметраКомпоновщика(Компоновщик, 
	//														 КонецПериода, 
	//														 "КонецПериода");
	
	
	// Настройки
	Настройки = ЭтотОбъект.Компоновщик.ПолучитьНастройки();
																				  
	// Передача схемы, настроек и данных расшифровки в макет компоновки
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СКД, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	// Выполнение компоновки с помощью процессора компоновки
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	  
	Таблица = Новый ТаблицаЗначений;
	
	// Вывод таблицы         
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.ОтображатьПроцентВывода = Истина;
	ПроцессорВывода.УстановитьОбъект(Таблица);              
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);

	ЭтотОбъект.ОбрабатываемыеДокументы.Очистить();
	ЭтотОбъект.ОбрабатываемыеДокументы.Загрузить(Таблица);

	ЗаполнитьАналитикиТЧ(Настройки.Отбор.Элементы);
	
КонецПроцедуры // ОбработатьДанные()

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

// Процедура осуществляет первоначальное заполнение табличной части ФактическиеДанные.
//
Процедура ЗаполнитьАналитикиТЧ(Отбор)

	МассивАналитик = Новый Массив;
	
	АналитикиТЧ.Очистить();
	НоваяСтрока = АналитикиТЧ.Добавить();
	НоваяСтрока.Аналитика = ПланыВидовХарактеристик.бит_ВидыДополнительныхАналитик.ЦФО;
	НоваяСтрока.ИмяАналитики = "ЦФО";
	НоваяСтрока.Ключ = "ЦФО";
	МассивАналитик.Добавить(НоваяСтрока.ИмяАналитики);
	
	НоваяСтрока = АналитикиТЧ.Добавить();
	НоваяСтрока.Аналитика = ПланыВидовХарактеристик.бит_ВидыДополнительныхАналитик.СтатьяОборотов;
	НоваяСтрока.ИмяАналитики = "СтатьяОборотов";
	НоваяСтрока.Ключ = "СтатьяОборотов";
	МассивАналитик.Добавить(НоваяСтрока.ИмяАналитики);
	
	НастройкиИзмерений	= бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_НастройкиДополнительныхИзмерений");
	
	Для каждого Стр Из НастройкиИзмерений Цикл
	
		НоваяСтрока = АналитикиТЧ.Добавить();
		НоваяСтрока.Аналитика = Стр.Значение.Аналитика;
		НоваяСтрока.ИмяАналитики = Стр.Ключ;
		НоваяСтрока.Ключ = Стр.Ключ; 
		МассивАналитик.Добавить(НоваяСтрока.ИмяАналитики);
		
	КонецЦикла; 
	
	Для каждого ТекущаяСтрока Из АналитикиТЧ Цикл
		
		ИмяАналитики = ТекущаяСтрока.ИмяАналитики;
		ОписаниеТиповАналитики = ТекущаяСтрока.Аналитика.ТипЗначения;
		ТекущаяСтрока.НачальноеЗначение = ОписаниеТиповАналитики.ПривестиЗначение(ТекущаяСтрока.НачальноеЗначение);
		ТекущаяСтрока.КонечноеЗначение = ОписаниеТиповАналитики.ПривестиЗначение(ТекущаяСтрока.КонечноеЗначение);
		ТекущаяСтрока.ИмяАналитики = СокрЛП(ТекущаяСтрока.Аналитика.Код);
		
		Если МассивАналитик.Найти(ИмяАналитики)<> Неопределено Тогда
		
			Для каждого СтрокаОтбора Из Отбор Цикл
				
				ИмяОтбора = Строка(СтрокаОтбора.ЛевоеЗначение); 
				Если Найти(ИмяОтбора, "ФактическиеДанные."+ИмяАналитики) Тогда
					
					ТекущаяСтрока.НачальноеЗначение = СтрокаОтбора.ПравоеЗначение;
					Прервать;
					
				КонецЕсли; 
			
			КонецЦикла; 
		
		КонецЕсли; 
		
	КонецЦикла; 
	
КонецПроцедуры // ЗаполнитьАналитикиТЧ()

#КонецОбласти

#КонецЕсли
