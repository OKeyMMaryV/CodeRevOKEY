#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

	#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
		
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		

    
    БсСоставной = бит_РаботаСМетаданными.ЭтотРеквизитСоставногоТипа("БанковскийСчет", ЭтотОбъект.Метаданные(), "НеснижаемыеОстатки");
    Если БсСоставной Тогда
        // Приведение пустого значения составного типа к Неопределено
        Для каждого СтрТаб Из НеснижаемыеОстатки Цикл
            Если НЕ ЗначениеЗаполнено(СтрТаб.БанковскийСчет) Тогда
                СтрТаб.БанковскийСчет = Неопределено;           
            КонецЕсли;                                       
        КонецЦикла;
    КонецЕсли;
    		
КонецПроцедуры // ПередЗаписью()
	
Процедура ПриЗаписи(Отказ)
		
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
	
		
КонецПроцедуры // ПриЗаписи()

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
               

	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = бит_ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	СтруктураШапкиДокумента = бит_ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
   	ТаблицыДокумента = ПодготовитьТаблицыДокумента();
	
	// Выполним движения
	Если НЕ Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицыДокумента, Заголовок, Отказ);
	КонецЕсли;
               
КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
    
    ЕстьКассы = бит_РаботаСМетаданными.ЕстьСправочник("Кассы"); // Адаптация для ERP
    Если ЕстьКассы Тогда
         ПроверяемыеРеквизиты.Добавить("НеснижаемыеОстатки.БанковскийСчет");
    КонецЕсли;
    
    // Проверка реквизитов документа 
	ПроверкаПовторяющихсяРеквизитов(ЕстьКассы, Отказ);
    
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда 	
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
// Процедура проверяет заполненность реквизитов документа и табличной части.
// 
// Параметры:
//  ЕстьКассы - Булево
//  Отказ  	  - Булево
// 
Процедура ПроверкаПовторяющихсяРеквизитов(ЕстьКассы, Отказ)

	ПустаяСсылкаБС = бит_РаботаСМетаданнымиСервер.ПолучитьПустуюСсылку_СправочникБС(); // Адаптация для ERP
	    
    ТекстПовторКассы = ?(ЕстьКассы, "кассы", "валюты кассы"); // Адаптация для ERP
    
    ТаблицаНО = ЭтотОбъект.НеснижаемыеОстатки.Выгрузить();
    
	Запрос = Новый Запрос;
    Запрос.УстановитьПараметр("ТаблицаНО", ТаблицаНО);
	Запрос.УстановитьПараметр("ПустаяСсылкаБанкСчета",  ПустаяСсылкаБС);
	
	Запрос.Текст = "
    |ВЫБРАТЬ
    |    НеснижаемыеОстатки.НомерСтроки,
    |    НеснижаемыеОстатки.БанковскийСчет КАК БанковскийСчет,
    |    НеснижаемыеОстатки.Валюта
    |ПОМЕСТИТЬ ВремТабНО
    |ИЗ
    |    &ТаблицаНО КАК НеснижаемыеОстатки
    |       
    |;
    |
    |////////////////////////////////////////////////////////////////////////////////
    |ВЫБРАТЬ
    |    ВремТабНО.НомерСтроки,
    |    ВремТабНО.БанковскийСчет КАК БанковскийСчет,
    |" + ?(ЕстьКассы,
            "    ВремТабНО.БанковскийСчет",
            "    ВЫБОР
            |        КОГДА ВремТабНО.БанковскийСчет = &ПустаяСсылкаБанкСчета
            |            ТОГДА ""Касса "" + Валюты.Наименование
            |        ИНАЧЕ ВремТабНО.БанковскийСчет
            |    КОНЕЦ") + " КАК БанковскийСчетКасса,
    |    1 КАК Количество
    |ИЗ
    |    ВремТабНО КАК ВремТабНО
    |       ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Валюты КАК Валюты
    |       ПО ВремТабНО.Валюта = Валюты.Ссылка
    |ИТОГИ
    |    МАКСИМУМ(БанковскийСчет),
    |    СУММА(Количество)
    |ПО
    |    БанковскийСчетКасса
    |";
	
	Результат = Запрос.Выполнить();
	ВыборкаВерх = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	Пока ВыборкаВерх.Следующий() Цикл
		
		Если ЕстьКассы Тогда
			ЭтоБанковскийСчет = ТипЗнч(ВыборкаВерх.БанковскийСчет) = ТипЗнч(ПустаяСсылкаБС);
		Иначе
			ЭтоБанковскийСчет = ЗначениеЗаполнено(ВыборкаВерх.БанковскийСчет);		
		КонецЕсли;
		
		ЕстьПовтор         = ВыборкаВерх.Количество > 1;
		НомераСтрок        = "";
        НомерСтрокиПовтора = 0;
		
		Выборка = ВыборкаВерх.Выбрать();
		Пока Выборка.Следующий() Цикл 			
			Если ЕстьПовтор Тогда
				НомерСтроки = Строка(Выборка.НомерСтроки);
				НомераСтрок = ?(НомераСтрок = "", НомерСтроки, НомераСтрок + ", " + НомерСтроки);                
			КонецЕсли;  		
        КонецЦикла;         
		
		Если ЕстьПовтор Тогда
            
            ТекстСообщения = Нстр("ru = 'В строках № %1% повторяется значение %2%'");
			ПовторяющиесяПоля = ?(ЭтоБанковскийСчет, "банковского счета", ТекстПовторКассы);
			ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, НомераСтрок, ПовторяющиесяПоля);
            
            НомерСтрокиПовтора = Формат(НомерСтроки - 1, "ЧН=0; ЧГ=");
            Если ЕстьКассы ИЛИ ЭтоБанковскийСчет Тогда
                ПоследнееПоле = "НеснижаемыеОстатки[" + НомерСтрокиПовтора + "].БанковскийСчет";
            Иначе	
                ПоследнееПоле = "НеснижаемыеОстатки[" + НомерСтрокиПовтора + "].Валюта";
            КонецЕсли;
            
            бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения, ЭтотОбъект, ПоследнееПоле, Отказ);
            
        КонецЕсли;
		
	КонецЦикла; 	

КонецПроцедуры // ПроверкаПовторяющихсяРеквизитов()

// Процедура формирует таблицы документа.
// 
// Параметры:
//  Нет
// 
// Возращаемое значение:
//  Структура (ТаблицыДокумента)
// 
Функция ПодготовитьТаблицыДокумента()

	ТаблицыДокумента = Новый Структура;
	
	// ТаблицаНеснижаемыхОстатков
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = "
	|ВЫБРАТЬ 
	|	НеснижаемыеОстатки.БанковскийСчет КАК БанковскийСчет,
	|	НеснижаемыеОстатки.Валюта,
	|	НеснижаемыеОстатки.СчетУчета,
	|	НеснижаемыеОстатки.Сумма,
	|	НеснижаемыеОстатки.ДатаОкончания
	|ИЗ
	|	Документ.бит_УстановкаНеснижаемыхОстатков.НеснижаемыеОстатки КАК НеснижаемыеОстатки
	|ГДЕ
	|	НеснижаемыеОстатки.Ссылка = &Ссылка
	|";

	Результат = Запрос.Выполнить();
	ТаблицаНеснижаемыхОстатков = Результат.Выгрузить();
	
	ТаблицыДокумента.Вставить("ТаблицаНеснижаемыхОстатков", ТаблицаНеснижаемыхОстатков);
	
	Возврат ТаблицыДокумента;
	
КонецФункции // ПодготовитьТаблицыДокумента()

Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицыДокумента, Заголовок, Отказ)

	ТаблицаНеснижаемыхОстатков = ТаблицыДокумента.ТаблицаНеснижаемыхОстатков;
	
	// Регистр бит_НеснижаемыеОстатки
	Движения.бит_НеснижаемыеОстатки.Записывать = Истина;
	Движения.бит_НеснижаемыеОстатки.Очистить();
	
	Для каждого СтрТаб Из ТаблицаНеснижаемыхОстатков Цикл
		
		// Регистр бит_НеснижаемыеОстатки
		Движение = Движения.бит_НеснижаемыеОстатки.Добавить();
		Движение.Период 			= СтруктураШапкиДокумента.Дата;
		Движение.Организация 		= СтруктураШапкиДокумента.Организация;
		Движение.БанковскийСчет 	= СтрТаб.БанковскийСчет;
		Движение.Валюта 			= СтрТаб.Валюта;
		Движение.СчетУчета 			= СтрТаб.СчетУчета;
		Движение.Сумма 				= СтрТаб.Сумма;
		Движение.ДатаОкончания 		= СтрТаб.ДатаОкончания;	
		
	КонецЦикла; 

КонецПроцедуры // ДвиженияПоРегистрам()

#КонецОбласти

#КонецЕсли
