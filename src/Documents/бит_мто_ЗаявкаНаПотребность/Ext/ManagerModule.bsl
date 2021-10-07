﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

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
	
    // Заявка на потребность.
    КомандаПечати = КомандыПечати.Добавить();
    КомандаПечати.Идентификатор = "ЗаявкаНаПотребность";
    КомандаПечати.Представление = НСтр("ru = 'Заявка на потребность'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок       = 10;
		
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗаявкаНаПотребность") Тогда					
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ЗаявкаНаПотребность", НСтр("ru = 'Заявка на потребность'"), 
			СформироватьПечатнуюФормуЗаявкаНаПотребность(МассивОбъектов),,"Документ.бит_мто_ЗаявкаНаПотребность.ЗаявкаНаПотребность");
	КонецЕсли;
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);	

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция получает результат запроса по массиву документов.
// 
// Параметры:
//  МассивСсылок - Массив
// 
// Возвращаемое значение:
//  Результат - ТаблицаЗначений.
// 
Функция ПолучитьРезультатЗапросаПоЗаявке(МассивСсылок)

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_мто_ЗаявкаНаПотребность.Ссылка КАК ЗаявкаНаПотребность,
	               |	бит_мто_ЗаявкаНаПотребность.Номер,
	               |	бит_мто_ЗаявкаНаПотребность.Дата,
	               |	бит_мто_ЗаявкаНаПотребность.Организация,
	               |	бит_мто_ЗаявкаНаПотребность.ВидОперации,
	               |	бит_мто_ЗаявкаНаПотребность.ДатаЗакупкиПлан,
	               |	бит_мто_ЗаявкаНаПотребность.ДатаЗакупкиНеПозднее,
	               |	бит_мто_ЗаявкаНаПотребность.СтатьяОборотов,
	               |	бит_мто_ЗаявкаНаПотребность.ЦФО,
	               |	бит_мто_ЗаявкаНаПотребность.Контрагент,
	               |	бит_мто_ЗаявкаНаПотребность.ДоговорКонтрагента,
	               |	бит_мто_ЗаявкаНаПотребность.Проект,
	               |	бит_мто_ЗаявкаНаПотребность.НоменклатурнаяГруппа,
	               |	бит_мто_ЗаявкаНаПотребность.БанковскийСчет,
	               |	бит_мто_ЗаявкаНаПотребность.Аналитика_1,
	               |	бит_мто_ЗаявкаНаПотребность.Аналитика_2,
	               |	бит_мто_ЗаявкаНаПотребность.Аналитика_3,
	               |	бит_мто_ЗаявкаНаПотребность.Аналитика_4,
	               |	бит_мто_ЗаявкаНаПотребность.Аналитика_5,
	               |	бит_мто_ЗаявкаНаПотребность.Аналитика_6,
	               |	бит_мто_ЗаявкаНаПотребность.Аналитика_7,
	               |	бит_мто_ЗаявкаНаПотребность.Важность,
	               |	бит_мто_ЗаявкаНаПотребность.Исполнитель,
	               |	бит_мто_ЗаявкаНаПотребность.Ответственный,
	               |	бит_мто_ЗаявкаНаПотребность.Комментарий,
	               |	бит_мто_ЗаявкаНаПотребность.ТипЦен,
	               |	бит_мто_ЗаявкаНаПотребность.ВалютаДокумента,
	               |	бит_мто_ЗаявкаНаПотребностьТовары.Номенклатура,
	               |	бит_мто_ЗаявкаНаПотребностьТовары.ЕдиницаИзмерения,
	               |	бит_мто_ЗаявкаНаПотребностьТовары.Количество,
	               |	бит_мто_ЗаявкаНаПотребностьТовары.Цена,
	               |	бит_мто_ЗаявкаНаПотребностьТовары.Сумма,
	               |	бит_мто_ЗаявкаНаПотребностьТовары.СтавкаНДС,
	               |	бит_мто_ЗаявкаНаПотребностьТовары.СуммаНДС,
	               |	бит_мто_ЗаявкаНаПотребностьТовары.Всего,
	               |	бит_мто_ЗаявкаНаПотребность.СтатьяОборотов.Кодификатор КАК КодСтатьи
	               |ИЗ
	               |	Документ.бит_мто_ЗаявкаНаПотребность КАК бит_мто_ЗаявкаНаПотребность
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.бит_мто_ЗаявкаНаПотребность.Товары КАК бит_мто_ЗаявкаНаПотребностьТовары
	               |		ПО бит_мто_ЗаявкаНаПотребность.Ссылка = бит_мто_ЗаявкаНаПотребностьТовары.Ссылка
	               |ГДЕ
	               |	бит_мто_ЗаявкаНаПотребность.Ссылка В(&МассивСсылок)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	бит_УстановленныеВизы.Виза,
	               |	бит_УстановленныеВизы.ФизическоеЛицо КАК ФИО,
	               |	бит_УстановленныеВизы.ДатаУстановки,
	               |	бит_УстановленныеВизы.Объект КАК ЗаявкаНаПотребность
	               |ИЗ
	               |	РегистрСведений.бит_УстановленныеВизы КАК бит_УстановленныеВизы
	               |ГДЕ
	               |	бит_УстановленныеВизы.Объект В(&МассивСсылок)";
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	
	Результат = Запрос.ВыполнитьПакет();
	
	Возврат Результат;
	
КонецФункции // ПолучитьРезультатЗапросаПоЗаявке()

// Функция формирует печатную форму заявки на закупку.
// 
// Параметры:
//  МассивСсылок 		   	  - Массив.
// 
// Возвращаемое значение:
//  ТабличныйДокумент - ТабличныйДокумент.
// 
Функция СформироватьПечатнуюФормуЗаявкаНаПотребность(МассивСсылок)

	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_бит_мто_ЗаявкаНаПотребность_ЗаявкаНаПотребность";
	
	// Формируем запрос по заявкам.
	Результат 			= ПолучитьРезультатЗапросаПоЗаявке(МассивСсылок);
	РезультатЗапроса 	= Результат[0].Выгрузить();
	РезультатЗапросаВизы = Результат[1].Выгрузить();
	
	Если РезультатЗапроса.Количество()>0 Тогда
		
		// Получаем макет и области.
		Макет = ПолучитьМакет("ЗаявкаНаПотребность");
		
		// Получаем области
		ОбластьЗаявкаШапка 	= Макет.ПолучитьОбласть("ЗаявкаШапка");
		ОбластьТоварыШапка 	= Макет.ПолучитьОбласть("ТоварыШапка");
		ОбластьТовары 		= Макет.ПолучитьОбласть("Товары");
		ОбластьШапкаВиза 	= Макет.ПолучитьОбласть("ШапкаВиза");
		ОбластьСтрокаВиза 	= Макет.ПолучитьОбласть("СтрокаВиза");
		ОбластьПодвал 		= Макет.ПолучитьОбласть("Подвал");
		
		ТаблицаДокументы = РезультатЗапроса.Скопировать();
		ТаблицаДокументы.Свернуть("ЗаявкаНаПотребность");
		
		Для каждого Документ Из ТаблицаДокументы Цикл
		
			ЗаявкаНаПотребность = Документ.ЗаявкаНаПотребность;
			
			СтрОтбор = Новый Структура;
			СтрОтбор.Вставить("ЗаявкаНаПотребность", ЗаявкаНаПотребность);
			
			МассивСтрок = РезультатЗапроса.НайтиСтроки(СтрОтбор);
			
			ОбластьЗаявкаШапка.Параметры.Заполнить(МассивСтрок[0]);
			
			НомерДок = бит_ОбщегоНазначенияКлиентСервер.ПолучитьНомерНаПечать(МассивСтрок[0].ЗаявкаНаПотребность);
			
			ОбластьЗаявкаШапка.Параметры.Заголовок = НСтр("ru = 'ЗАЯВКА НА ПОТРЕБНОСТЬ № '") + НомерДок
														+ НСтр("ru = ' от '") + Формат(МассивСтрок[0].Дата, "ДФ = дд.ММ.гггг");
			
			СуммаДокумента = 0;
			СуммаНДСДокумента = 0;
			
			Для каждого Строка Из МассивСтрок Цикл
			
				СуммаДокумента = СуммаДокумента + Строка.Всего;
				СуммаНДСДокумента = СуммаНДСДокумента + Строка.СуммаНДС;
				
			КонецЦикла; 											
			
			ОбластьЗаявкаШапка.Параметры.СуммаДокумента = СуммаДокумента;
			ОбластьЗаявкаШапка.Параметры.СуммаНДСДокумента = СуммаНДСДокумента;
			
			ОбластьЗаявкаШапка.Параметры.СуммаПрописью = бит_ФормированиеПечатныхФорм.СформироватьСуммуПрописью(СуммаДокумента
																									, ОбластьЗаявкаШапка.Параметры.ВалютаДокумента);
			
			ТабличныйДокумент.Вывести(ОбластьЗаявкаШапка);
			ТабличныйДокумент.Вывести(ОбластьТоварыШапка);
			
			Для каждого Строка Из МассивСтрок Цикл
			
				ОбластьТовары.Параметры.Заполнить(Строка);
				ТабличныйДокумент.Вывести(ОбластьТовары);
			
			КонецЦикла; 
			
			ТабличныйДокумент.Вывести(ОбластьШапкаВиза);
			
			// Заполняем визы
			МассивВиз = РезультатЗапросаВизы.НайтиСтроки(СтрОтбор);
			Для Каждого вСтрока Из МассивВиз Цикл
				ОбластьСтрокаВиза.Параметры.Заполнить(вСтрока);
				ТабличныйДокумент.Вывести(ОбластьСтрокаВиза);
			КонецЦикла;
			
			ОбластьПодвал.Параметры.Заполнить(МассивСтрок[0]);
			ТабличныйДокумент.Вывести(ОбластьПодвал);
			
		КонецЦикла; 
		
	КонецЕсли;
		
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
			
КонецФункции // СформироватьПечатнуюФормуЗаявкаНаПотребность()
	
// Функция находит аналитики тип которых совпадает 
// с типом реквизитов Заявки на потребность.
// 
// Параметры: МетаОбъект - ОбъектМетаданных.
// 
// 
// Возвращаемое значение:
//  СовпадающиеАналитики - Соответствие.
// 
Функция НайтиАналитикиСовпадающиеСРеквизитами(МетаОбъект) Экспорт 

	СовпадающиеАналитики = Новый Соответствие;
	
	МассивТипов = Новый Массив;
	
	Для каждого Реквизит Из МетаОбъект.Реквизиты Цикл
	
		Если Найти(Реквизит.Имя, "Аналитика")=0 Тогда
		
			Для каждого ТипРек Из Реквизит.Тип.Типы() Цикл
			
				Если НЕ ТипРек = Тип("Булево")
					И НЕ ТипРек = Тип("Дата")
					И НЕ ТипРек = Тип("Строка")
					И НЕ ТипРек = Тип("Число") Тогда
					
					СтрРекв = Новый Структура("Имя, Тип", Реквизит.Имя, ТипРек);
					МассивТипов.Добавить(СтрРекв);
				
				КонецЕсли; 
			
			КонецЦикла; 
		
		КонецЕсли; 
	
	КонецЦикла; 
	
	Настр = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_НастройкиДополнительныхИзмерений");
	
	Для каждого Аналит Из Настр Цикл
		
		Если НЕ Аналит.Значение.ЭтоСоставнойТип Тогда 
		
			Для каждого СтрРекв Из МассивТипов Цикл
				
				ТипРек = СтрРекв.Тип;
				Если Аналит.Значение.ТипЗначения.СодержитТип(ТипРек) Тогда 
					СовпадающиеАналитики.Вставить(Аналит.Ключ, СтрРекв.Имя);
					Прервать;
				КонецЕсли;
			
			КонецЦикла; 
			
		КонецЕсли;	
			
	КонецЦикла; 
	
	Возврат СовпадающиеАналитики;
	
КонецФункции // НайтиАналитикиСовпадающиеСРеквизитами()

// Функция получает остатки номенклатуры 
// в табличной части Товары по регистру Потребности номенклатуры.
// 
// Параметры:
//   Документ - ДокументСсылка.бит_мто_ЗаявкаНаПотребность.
// 
// Возвращаемое значение:
//  Результат - Строка.
// 
Функция ПолучитьОстаткиНоменклатурыТабЧастиТовары(Документ) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ТабДок.Номенклатура,
	               |	ЕСТЬNULL(ПотребностиНоменклатуры.КоличествоПриход, 0) КАК СуммаПлан,
	               |	ЕСТЬNULL(ПотребностиНоменклатуры.КоличествоРасход, 0) КАК СуммаФакт,
	               |	ЕСТЬNULL(ПотребностиНоменклатуры.КоличествоКонечныйОстаток, 0) КАК СуммаОстаток,
	               |	ТабДок.Ссылка
	               |ИЗ
	               |	Документ.бит_мто_ЗаявкаНаПотребность.Товары КАК ТабДок
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.бит_мто_ПотребностиНоменклатуры.ОстаткиИОбороты КАК ПотребностиНоменклатуры
	               |		ПО ТабДок.Ссылка = ПотребностиНоменклатуры.ДокументПланирования
	               |			И ТабДок.Номенклатура = ПотребностиНоменклатуры.Номенклатура
	               |ГДЕ
	               |	ТабДок.Ссылка = &Документ
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ТабДок.Номенклатура,
	               |	ТабДок.Ссылка,
	               |	ЕСТЬNULL(ПотребностиНоменклатуры.КоличествоПриход, 0),
	               |	ЕСТЬNULL(ПотребностиНоменклатуры.КоличествоРасход, 0),
	               |	ЕСТЬNULL(ПотребностиНоменклатуры.КоличествоКонечныйОстаток, 0)";
	
	Запрос.УстановитьПараметр("Документ", Документ);
		
	Результат = Запрос.Выполнить();
	ТаблицаОстатков = Результат.Выгрузить();
	
	Возврат ТаблицаОстатков;
	
КонецФункции // ПолучитьОстаткиНоменклатурыТабЧастиТовары()

// Функция получает остатки номенклатуры к выдаче 
// из регистра бит_мто_НоменклатураКВыдачеПоЗаявкамНаПотребность.
// 
// Параметры:
//   Документ - ДокументСсылка.бит_мто_ЗаявкаНаПотребность.
// 
// Возвращаемое значение:
//  ТаблицаОстатков - Таблица значений.
// 
Функция ПолучитьОстаткиНоменклатурыКВыдаче(ЗаявкаНаПотребность) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЗаявкаНаПотребность"	, ЗаявкаНаПотребность);
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	НоменклатураКВыдаче.Номенклатура,
	               |	НоменклатураКВыдаче.Потребность,
	               |	ЕСТЬNULL(НоменклатураКВыдаче.КоличествоОстаток, 0) КАК Остаток,
	               |	НоменклатураКВыдаче.ЗаявкаНаПотребность
	               |ИЗ
	               |	РегистрНакопления.бит_мто_НоменклатураКВыдачеПоЗаявкамНаПотребность.Остатки(, ЗаявкаНаПотребность = &ЗаявкаНаПотребность) КАК НоменклатураКВыдаче
	               |ГДЕ
	               |	НоменклатураКВыдаче.ЗаявкаНаПотребность = &ЗаявкаНаПотребность";
	
				   
	Результат = Запрос.Выполнить();
	ТаблицаОстатков = Результат.Выгрузить();
	
	Возврат ТаблицаОстатков;
	
КонецФункции // ПолучитьОстаткиНоменклатурыКВыдаче()

// Функция получает остатки номенклатуры в табличной части Товары
// по регистру Потребности номенклатуры и Номенклатура к выдаче.
// 
// Параметры:
//   Документ - ДокументСсылка.бит_мто_ЗаявкаНаПотребность.
//   ОстаткиПотребности - ТаблицаЗначений.
//   ОстаткиКВыдаче - ТаблицаЗначений.
//   ОстаткиПоУслуге - ТаблицаЗначений.
// 
// Возвращаемое значение:
//  Результат - Строка.
// 
Функция ПолучитьОстатки(Документ, ОстаткиПотребности, ОстаткиКВыдаче, ОстаткиПоУслуге) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ЕСТЬNULL(ПотребностиНоменклатуры.КоличествоПриход, 0) КАК КоличествоПлан,
	               |	ЕСТЬNULL(ПотребностиНоменклатуры.КоличествоРасход, 0) КАК КоличествоФакт,
	               |	ЕСТЬNULL(ПотребностиНоменклатуры.КоличествоКонечныйОстаток, 0) КАК КоличествоОстаток,
	               |	ПотребностиНоменклатуры.Номенклатура,
	               |	ПотребностиНоменклатуры.ДокументПланирования
	               |ИЗ
	               |	РегистрНакопления.бит_мто_ПотребностиНоменклатуры.ОстаткиИОбороты(, , , , ДокументПланирования = &Документ) КАК ПотребностиНоменклатуры
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЕСТЬNULL(НоменклатураКВыдаче.КоличествоПриход, 0) КАК КоличествоПлан,
	               |	ЕСТЬNULL(НоменклатураКВыдаче.КоличествоРасход, 0) КАК КоличествоФакт,
	               |	ЕСТЬNULL(НоменклатураКВыдаче.КоличествоКонечныйОстаток, 0) КАК КоличествоОстаток,
	               |	НоменклатураКВыдаче.Номенклатура,
	               |	НоменклатураКВыдаче.ЗаявкаНаПотребность
	               |ИЗ
	               |	РегистрНакопления.бит_мто_НоменклатураКВыдачеПоЗаявкамНаПотребность.ОстаткиИОбороты(, , , , ЗаявкаНаПотребность = &Документ) КАК НоменклатураКВыдаче
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЗаявкаНаЗакупку.Номенклатура,
	               |	ЗаявкаНаЗакупку.Потребность,
	               |	ЗаявкаНаЗакупку.ЗаявкаНаПотребность,
	               |	ЕСТЬNULL(бит_мто_ПланируемаяЗакупкаНоменклатурыОстаткиИОбороты.КоличествоПриход, 0) КАК КоличествоПлан,
	               |	ЕСТЬNULL(бит_мто_ПланируемаяЗакупкаНоменклатурыОстаткиИОбороты.КоличествоРасход, 0) КАК КоличествоФакт,
	               |	ЕСТЬNULL(бит_мто_ПланируемаяЗакупкаНоменклатурыОстаткиИОбороты.КоличествоКонечныйОстаток, 0) КАК КоличествоОстаток
	               |ИЗ
	               |	Документ.бит_мто_ЗаявкаНаЗакупку.Товары КАК ЗаявкаНаЗакупку
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.бит_мто_ПланируемаяЗакупкаНоменклатуры.ОстаткиИОбороты(, , , , ) КАК бит_мто_ПланируемаяЗакупкаНоменклатурыОстаткиИОбороты
	               |		ПО ЗаявкаНаЗакупку.Ссылка = бит_мто_ПланируемаяЗакупкаНоменклатурыОстаткиИОбороты.ДокументПланирования
	               |			И ЗаявкаНаЗакупку.Номенклатура = бит_мто_ПланируемаяЗакупкаНоменклатурыОстаткиИОбороты.Номенклатура
	               |			И ЗаявкаНаЗакупку.Потребность = бит_мто_ПланируемаяЗакупкаНоменклатурыОстаткиИОбороты.Потребность
	               |ГДЕ
	               |	ЗаявкаНаЗакупку.ЗаявкаНаПотребность = &Документ";
	
	Запрос.УстановитьПараметр("Документ", Документ);
		
	Результат = Запрос.ВыполнитьПакет();
	ОстаткиПотребности = Результат[0].Выгрузить();
	ОстаткиКВыдаче = Результат[1].Выгрузить();
	
	Если Документ.ВидОперации = Перечисления.бит_мто_ВидыОперацийЗаявокНаПотребность.Услуги Тогда
	
		ОстаткиПоУслуге = Результат[2].Выгрузить();
	
	КонецЕсли; 
	
КонецФункции // ПолучитьОстатки()

#КонецОбласти

#КонецЕсли
