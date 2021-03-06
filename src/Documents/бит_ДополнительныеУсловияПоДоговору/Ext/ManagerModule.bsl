#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки	 - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
    // График платежей.
    КомандаПечати = КомандыПечати.Добавить();
    КомандаПечати.Идентификатор = "ГрафикПлатежей";
    КомандаПечати.Представление = НСтр("ru = 'График платежей'");
	Если НЕ бит_ОбщегоНазначения.ЭтоУТ() Тогда
		КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КонецЕсли;
	КомандаПечати.Порядок       = 10;
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов - Массив из ДокументСсылка.бит_ДополнительныеУсловияПоДоговору - ссылки на объекты,которые нужно распечатать;
//  ПараметрыПечати - Структура	 - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений	 - сформированные табличные документы (выходной параметр);
//  ОбъектыПечати - СписокЗначений	 - значение - ссылка на объект;
//  	представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода - Структура		 - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ГрафикПлатежей") Тогда					
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ГрафикПлатежей", НСтр("ru = 'График платежей'"), 
			ПечатьГрафикаПлатежей(МассивОбъектов),,"Обработка.бит_ФормированиеГрафиковПлатежейПоФинансовымДоговорам.ГрафикПлатежей");
	КонецЕсли;
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);	

КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Функция получает массив периодов для заполнения графика платежей.
//
// Параметры:
//  Периодичность	 - ПеречислениеСсылка.бит_ПереодичностьПланирования	- периодичность гарфика.
//  ДатаНачала		 - Дата - Левая граница графика.
//  ДатаОкончания	 - Дата - Правая граница графика. 
// 
// Возвращаемое значение:
//  Периоды - Массив, содержанщий периоды, входящие в границы.  
//
Функция ПолучитьПериоды(Периодичность, Знач ДатаНачала, Знач ДатаОкончания) Экспорт

	Периоды = Новый Массив;
	Смещение = 1;
	НачалоПериода = ДатаНачала; 
	Пока НачалоПериода <= ДатаОкончания Цикл
		Периоды.Добавить(НачалоПериода);
		НачалоПериода = ДобавитьИнтервал(ДатаНачала, Периодичность, Смещение);
		Смещение = Смещение + 1;
	КонецЦикла;
    
    Возврат Периоды;
    
КонецФункции

Процедура ПеренестиНазначениеПлатежаПриПереходеНаНовуюВерсию() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ГрафикПлатежей.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.бит_ДополнительныеУсловияПоДоговору.ГрафикПлатежей КАК ГрафикПлатежей
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ГрафикНачислений.Ссылка
	|ИЗ
	|	Документ.бит_ДополнительныеУсловияПоДоговору.ГрафикНачислений КАК ГрафикНачислений";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ТекущийОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		Для каждого СтрокаТаблицы Из ТекущийОбъект.ГрафикПлатежей Цикл
			СтрокаТаблицы.НазначениеПлатежа = СтрокаТаблицы.УдалитьНазначениеПлатежа;
		КонецЦикла; 
		Для каждого СтрокаТаблицы Из ТекущийОбъект.ГрафикПлатежей Цикл
			СтрокаТаблицы.НазначениеПлатежа = СтрокаТаблицы.УдалитьНазначениеПлатежа;
		КонецЦикла; 
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ТекущийОбъект);
		
	КонецЦикла;	

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция формирует табличный документ с печатной формой графика платежей.
//
// Возвращаемое значение:
//  Табличный документ - печатная форма.
//
Функция ПечатьГрафикаПлатежей(МассивСсылок)
	
	Если МассивСсылок.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДокСсылка = МассивСсылок[0];
	
	// Создаем табличный документ.
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_бит_ДополнительныеУсловияПоДоговору_ГрафикПлатежей";
	
	Если ЗначениеЗаполнено(ДокСсылка.ДоговорКонтрагента) Тогда
		ИсточникПараметров = ДокСсылка.ДоговорКонтрагента;
	Иначе
		ИсточникПараметров = ДокСсылка.ПроектДоговора;
	КонецЕсли;
	
	ДеревоСоставляющих = бит_ДоговораСервер.ПолучитьДеревоПараметровФинДоговоров(ИсточникПараметров);
	ДеревоСоставляющих.Колонки.Значение.Имя	  = "ЗначениеПараметра";
	ДеревоСоставляющих.Колонки.ТипПлатежа.Имя = "ТипПлатежаПоФинДоговору";
	
	СоставляющаяПроцент = Перечисления.бит_ТипыПлатежейПоФинансовымДоговорам.Проценты;
	// получим параметры расчета для составляющей платежа с типом "Проценты".
	ПараметрыРасчета = Обработки.бит_ФормированиеГрафиковПлатежейПоФинансовымДоговорам.ПолучитьСтруктуруПараметровРасчета(СоставляющаяПроцент, ДеревоСоставляющих);
	Если ПараметрыРасчета.ТипПроцентнойСтавки = Перечисления.бит_ТипыПроцентныхСтавокПоФинансовымДоговорам.Фиксированная Тогда
		ПроцентнаяСтавка = ПараметрыРасчета.ПроцентнаяСтавка;
	Иначе
		ПроцентнаяСтавка = 0;
	КонецЕсли;
	
	ТаблицаГрафика = ДокСсылка.ГрафикПлатежей.Выгрузить();
	ТаблицаГрафика.Колонки.Добавить("ЗадолженностьПоОсновномуДолгу", Новый ОписаниеТипов("Число"));
	
	Структура = Обработки.бит_ФормированиеГрафиковПлатежейПоФинансовымДоговорам.ПолучитьРезультатЗапросаПоГрафикуПлатежей(ТаблицаГрафика);
	
	СуммаДолга				 = ДокСсылка.ГрафикВыдачиТраншей.Итог("СуммаТранша");
	КоличествоПериодовВыплат = ДокСсылка.ГрафикВыдачиТраншей.Итог("КоличествоПериодовВыплат");

	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("СуммаДолга"				, СуммаДолга);
	СтруктураПараметров.Вставить("КоличествоПериодовВыплат"	, КоличествоПериодовВыплат);
	СтруктураПараметров.Вставить("ПроцентнаяСтавка"			, ПроцентнаяСтавка);
	СтруктураПараметров.Вставить("РезультатЗапроса"			, Структура.РезультатЗапроса);
	СтруктураПараметров.Вставить("СтруктураДопКолонок"		, Структура.СтруктураДопКолонок);
	СтруктураПараметров.Вставить("РассчитыватьЗадолженность", Истина);
	
	Обработки.бит_ФормированиеГрафиковПлатежейПоФинансовымДоговорам.Печать(СтруктураПараметров, "ГрафикПлатежей",,ТабДокумент);
	
	Возврат ТабДокумент;	
		
КонецФункции

// Функция добавляет интервал к дате
//
// Параметры:
//	Дата          - Дата - произвольная дата.
//	Периодичность - ПеречислениеСсылка.Периодичность - периодичность планирования по сценарию.
//	Смещение      - Число - определяет направление и количество периодов, в котором сдвигается дата.
//
// Возвращаемое значение:
//	Дата - дата, отстоящая от исходной на заданное количество периодов.
//
Функция ДобавитьИнтервал(Дата, Периодичность, Смещение)
	
	Если Смещение = 0 Тогда
		Результат = Дата;
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.бит_ПериодичностьПланирования.Неделя") Тогда
		Результат = Дата + Смещение * 7 * 24 * 3600;
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.бит_ПериодичностьПланирования.Декада") Тогда
		Результат = Дата + Смещение * 11 * 24 * 3600;
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.бит_ПериодичностьПланирования.Месяц") Тогда
		Результат = ДобавитьМесяц(Дата, Смещение);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.бит_ПериодичностьПланирования.Квартал") Тогда
		Результат = ДобавитьМесяц(Дата, Смещение * 3);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.бит_ПериодичностьПланирования.Полугодие") Тогда
		Результат = ДобавитьМесяц(Дата, Смещение * 6);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.бит_ПериодичностьПланирования.Год") Тогда
		Результат = ДобавитьМесяц(Дата, Смещение * 12);
		
	Иначе
		Результат = НачалоДня(Дата) + Смещение * 24 * 3600;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Процедура управляет видимостью полей назначенных аналитик.
// 
Процедура ВидимостьНазначенныхАналитик(Форма) Экспорт 
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("СправочникСсылка.Организации"));
	МассивТипов.Добавить(Тип("СправочникСсылка.Контрагенты"));
	МассивТипов.Добавить(Тип("СправочникСсылка.ДоговорыКонтрагентов"));
	МассивТипов.Добавить(Тип("СправочникСсылка.Подразделения"));
	МассивТипов.Добавить(Тип("СправочникСсылка.Проекты"));
	МассивТипов.Добавить(Тип("СправочникСсылка.НоменклатурныеГруппы"));
	МассивТипов.Добавить(Тип("СправочникСсылка.бит_СтатьиОборотов"));
	
	Объект = Форма.Объект;
	
	Настр = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_НастройкиДополнительныхИзмерений");
	
	Для каждого Аналит Из Настр Цикл
		
		Если НЕ Аналит.Значение.ЭтоСоставнойТип
			И МассивТипов.Найти(Аналит.Значение.ТипЗначения.Типы()[0]) <> Неопределено Тогда 
			
			Форма.Элементы[Аналит.Ключ].Видимость = Ложь;
			Если Аналит.Значение.ТипЗначения.Типы()[0] = Тип("СправочникСсылка.Организации") Тогда 
				Объект[Аналит.Ключ] = Объект.Организация;					
			Иначе
				Форма.Элементы["ГрафикПлатежей"+Аналит.Ключ].Видимость = Ложь;
				Форма.Элементы["ГрафикНачислений"+Аналит.Ключ].Видимость = Ложь;
			КонецЕсли;
			
		КонецЕсли;	
			
	КонецЦикла;	
		
КонецПроцедуры

#КонецОбласти	

#КонецЕсли
