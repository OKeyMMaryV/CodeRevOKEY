﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет статью затрат, используемую по умолчанию.
// 
// Возвращаемое значение:
//  СправочникСсылка.СтатьиЗатрат - основная статья.
//       Возвращается пустая ссылка, если ни одна статья не назначена основной.
//
Функция ОсновнаяСтатьяЗатрат() Экспорт
	
	Возврат ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.СтатьиЗатрат.ПрочиеЗатраты");
	
КонецФункции

// Определяет статью затрат, используемую в конкретной ситуации.
// 
// Параметры:
//  НазначениеСтатьиЗатрат - Строка - имя предопределенного элемента
//                         - Неопределено - для статьи, используемой по умолчанию
// 
// Возвращаемое значение:
//  СправочникСсылка.СтатьиЗатрат - основная статья.
//       Возвращается пустая ссылка, если ни одна статья не назначена основной.
//
Функция СтатьяЗатратПоНазначению(НазначениеСтатьиЗатрат) Экспорт
	
	Если Не ЗначениеЗаполнено(НазначениеСтатьиЗатрат) Тогда
		Возврат ОсновнаяСтатьяЗатрат();
	Иначе
		Возврат ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.СтатьиЗатрат." + НазначениеСтатьиЗатрат);
	КонецЕсли;
	
КонецФункции

// Находит, а при необходимости - создает предопределенный элемент.
// Следует использовать в алгоритмах, требующих обязательного наличия предопределенного элемента.
//
// В алгоритмах, требующих обязательного наличия предопределенного элемента,
// когда обращение к элементам выполняется в цикле по большому числу элементов,
// следует использовать методы модуля КлассификаторыДоходовРасходов
// - НовыйКешГрупповойОперации
// - ПредопределенныйЭлементГрупповойОперации.
//
// В остальных случаях
// - для получения основной статьи затрат следует использовать ОсновнаяСтатьяЗатрат()
// - для получения других статей, назначенных для использования  - СтатьяЗатратПоНазначению()
//
// Параметры:
//  ИмяПредопределенногоЭлемента - Строка - имя предопределенного элемента, заданное в метаданных.
//                                 Описание создаваемых элементов приведено в ЗаполнитьОписанияПоставляемыхЭлементов
// 
// Возвращаемое значение:
//  СправочникСсылка.СтатьиЗатрат - найденный (созданный) предопределенный элемент
//
Функция ПредопределенныйЭлемент(ИмяПредопределенногоЭлемента) Экспорт
	
	Возврат КлассификаторыДоходовРасходов.ПредопределенныйЭлемент(Справочники.СтатьиЗатрат, ИмяПредопределенногоЭлемента);
	
КонецФункции

// Возвращает массив видов расходов, используемых только для тех видов деятельности,
// к которым применяется основная система налогообложения
Функция ВидыРасходовТолькоОсновнаяСистемаНалогообложения() Экспорт
	
	// Это нормируемые расходы
	ВидыРасходов = Перечисления.ВидыРасходовНУ.НормируемыеРасходы();
	
	// ... и некоторые другие
	ВидыРасходов.Добавить(Перечисления.ВидыРасходовНУ.ТранспортныеРасходы);
	ВидыРасходов.Добавить(Перечисления.ВидыРасходовНУ.НеУчитываемыеВЦеляхНалогообложения);
	
	Возврат Новый ФиксированныйМассив(ВидыРасходов);
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область КлассификаторыДоходовРасходов

// Содержит описание поставляемых элементов, которые может (должен) содержать справочник.
//
// Параметры:
//  ОписаниеЭлементов - ТаблицаЗначений - см. КлассификаторыДоходовРасходов.НовыйПоставляемыеЭлементы,
//       описание поставляемых элементов справочника
//
Процедура ЗаполнитьОписанияПоставляемыхЭлементов(ОписаниеЭлементов) Экспорт
	
	// Элементы должны следовать в следующем порядке:
	// - статьи с уточнением "прочие" должны идти после "не прочих";
	//   Следствие: статья для использования по умолчанию ("совсем прочие") - последняя
	// - в остальном стремиться более часто используемые статьи размещать над редко используемыми;
	//   в том числе:
	//   -- статьи по более часто используемой функциональности
	//      размещать над статьями по менее часто используемой функциональности
	//   -- создаваемые заранее - до создаваемых при первом обращении.
	
	// Оплата труда
	ОписаниеЭлемента = ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		"ОплатаТруда",
		Перечисления.ВидыРасходовНУ.ОплатаТруда,
		"ru = 'Оплата труда'",
		Истина,
		"ru = 'Основное отражение начисления зарплаты'");
	ОписаниеЭлемента.Функциональность.Добавить("ВедетсяУчетЗарплатыКадров");
	
	// Оплата труда (ЕНВД)
	ОписаниеЭлемента = ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		"ОплатаТрудаЕНВД",
		Перечисления.ВидыРасходовНУ.ОплатаТруда,
		"ru = 'Оплата труда (ЕНВД)'",
		Истина,
		"ru = 'Основное отражение начисления зарплаты по деятельности ЕНВД'");
	ОписаниеЭлемента.Функциональность.Добавить("ИспользуетсяЕНВД");
	ОписаниеЭлемента.Функциональность.Добавить("ИспользуетсяУСНПатент");
	ОписаниеЭлемента.Реквизиты.Вставить(
		"ВидДеятельностиДляНалоговогоУчетаЗатрат",
		Перечисления.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения);
	
	// Страховые взносы
	ОписаниеЭлемента = ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		"СтраховыеВзносы",
		Перечисления.ВидыРасходовНУ.СтраховыеВзносы,
		"ru = 'Страховые взносы'");
	ОписаниеЭлемента.Функциональность.Добавить("ВедетсяУчетЗарплатыКадров");
	
	// Страховые взносы (ЕНВД)
	ОписаниеЭлемента = ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		"СтраховыеВзносыЕНВД",
		Перечисления.ВидыРасходовНУ.СтраховыеВзносы,
		"ru = 'Страховые взносы (ЕНВД)'");
	ОписаниеЭлемента.Функциональность.Добавить("ИспользуетсяЕНВД");
	ОписаниеЭлемента.Функциональность.Добавить("ИспользуетсяУСНПатент");
	ОписаниеЭлемента.Реквизиты.Вставить(
		"ВидДеятельностиДляНалоговогоУчетаЗатрат",
		Перечисления.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения);
		
	// Взносы в ФСС от НС и ПЗ
	ОписаниеЭлемента = ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		"ФСС_НС",
		Перечисления.ВидыРасходовНУ.ПрочиеРасходы,
		"ru = 'Взносы в ФСС от НС и ПЗ'");
	ОписаниеЭлемента.Функциональность.Добавить("ВедетсяУчетЗарплатыКадров");
	
	// Взносы в ФСС от НС и ПЗ (ЕНВД)
	ОписаниеЭлемента = ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		"ФСС_НС_ЕНВД",
		Перечисления.ВидыРасходовНУ.ПрочиеРасходы,
		"ru = 'Взносы в ФСС от НС и ПЗ (ЕНВД)'");
	ОписаниеЭлемента.Функциональность.Добавить("ИспользуетсяЕНВД");
	ОписаниеЭлемента.Функциональность.Добавить("ИспользуетсяУСНПатент");
	ОписаниеЭлемента.Реквизиты.Вставить(
		"ВидДеятельностиДляНалоговогоУчетаЗатрат",
		Перечисления.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения);
	
	// Оплата больничного
	// (ст. 264 п. 48.1 НК РФ)
	ОписаниеЭлемента = ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		"ОплатаБольничного",
		Перечисления.ВидыРасходовНУ.ПрочиеРасходы,
		"ru = 'Оплата больничного'");
	ОписаниеЭлемента.Функциональность.Добавить("ВедетсяУчетЗарплатыКадров");
	
	// Оплата больничного (ЕНВД)
	ОписаниеЭлемента = ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		"ОплатаБольничногоЕНВД",
		Перечисления.ВидыРасходовНУ.ПрочиеРасходы,
		"ru = 'Оплата больничного (ЕНВД)'");
	ОписаниеЭлемента.Функциональность.Добавить("ИспользуетсяЕНВД");
	ОписаниеЭлемента.Функциональность.Добавить("ИспользуетсяУСНПатент");
	ОписаниеЭлемента.Реквизиты.Вставить(
		"ВидДеятельностиДляНалоговогоУчетаЗатрат",
		Перечисления.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения);
		
	// Амортизация
	ОписаниеЭлемента = ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		"Амортизация",
		Перечисления.ВидыРасходовНУ.Амортизация,
		"ru = 'Амортизация'");
	ОписаниеЭлемента.Функциональность.Добавить("ВедетсяУчетОсновныхСредств");
	ОписаниеЭлемента.Функциональность.Добавить("ВедетсяУчетОсновныхСредствПростойИнтерфейс");
	
	// Амортизационная премия
	ОписаниеЭлемента = ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		"АмортизационнаяПремия",
		Перечисления.ВидыРасходовНУ.АмортизационнаяПремия,
		"ru = 'Амортизационная премия'",
		Истина,
		"ru = 'Документ «Принятие к учету ОС» (амортизационная премия)'");
	ОписаниеЭлемента.Функциональность.Добавить("ВедетсяУчетОсновныхСредств");
	ОписаниеЭлемента.Функциональность.Добавить("ВедетсяУчетОсновныхСредствПростойИнтерфейс");
	
	// Списание материалов
	ОписаниеЭлемента = ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		"СписаниеМатериалов",
		Перечисления.ВидыРасходовНУ.МатериальныеРасходы,
		"ru = 'Списание материалов'",
		Истина,
		"ru = 'Документ «Требование-накладная»'");
	ОписаниеЭлемента.Функциональность.Добавить("ИспользоватьДокументыПоступления");
	
	// Содержание служебного автотранспорта
	ОписаниеЭлемента = ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		"СлужебныйАвтотранспорт",
		Перечисления.ВидыРасходовНУ.ПрочиеРасходы,
		"ru = 'Содержание служебного автотранспорта'",
		Истина,
		"ru = 'Документ «Путевой лист»'");
	ОписаниеЭлемента.Функциональность.Добавить("ВедетсяУчетПоПутевымЛистам");
	
	// Командировочные расходы
	ОписаниеЭлемента = ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		"КомандировочныеРасходы",
		Перечисления.ВидыРасходовНУ.КомандировочныеРасходы,
		"ru = 'Командировочные расходы'",
		Истина,
		"ru = 'Документ «Авансовый отчет» (командировочные расходы)'");
	ОписаниеЭлемента.Функциональность.Добавить("ИспользоватьДокументыПоступления");
	
	// Неамортизируемое имущество
	ОписаниеЭлемента = ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		"НеамортизируемоеИмущество",
		Перечисления.ВидыРасходовНУ.МатериальныеРасходы,
		"ru = 'Неамортизируемое имущество'",
		Истина);
	ОписаниеЭлемента.СоздаватьЗаранее = Ложь;
	ОписаниеЭлемента.Реквизиты.Вставить(
		"ВидДеятельностиДляНалоговогоУчетаЗатрат",
		Перечисления.ВидыДеятельностиДляНалоговогоУчетаЗатрат.РаспределяемыеЗатраты); // Исходя из предположения, что приобретение такого имущества - обычно общие расходы
	ОписаниеЭлемента.Функциональность.Добавить("ВедетсяУчетОсновныхСредств");
	ОписаниеЭлемента.Функциональность.Добавить("ВедетсяУчетОсновныхСредствПростойИнтерфейс");
		
	// Услуги комиссионеров
	ОписаниеЭлемента = ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		"УслугиКомиссионеров",
		Перечисления.ВидыРасходовНУ.ПрочиеРасходы,
		"ru = 'Услуги комиссионеров'",
		Истина,
		"ru = 'Документ «Отчет комиссионера»'");
	ОписаниеЭлемента.Функциональность.Добавить("ОсуществляетсяЗакупкаТоваровУслугЧерезКомиссионеров");
	ОписаниеЭлемента.Функциональность.Добавить("ОсуществляетсяРеализацияТоваровУслугЧерезКомиссионеров");
	
	// Торговый сбор
	ОписаниеЭлемента = ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		"ТорговыйСбор",
		Перечисления.ВидыРасходовНУ.ТорговыйСбор,
		"ru = 'Торговый сбор'",
		Истина,
		"ru = 'Торговый сбор'");
	ОписаниеЭлемента.Функциональность.Добавить("УплачиваетсяТорговыйСбор");
	
	// Списание НДС
	ОписаниеЭлемента = ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		"СписаниеНДСНаРасходы",
		Перечисления.ВидыРасходовНУ.ПрочиеРасходы,
		"ru = 'Списание НДС'",
		Истина,
		"ru = 'Документ «Перемещение товаров» (списание НДС)'");
	ОписаниеЭлемента.Функциональность.Добавить("РаздельныйУчетНДСДо2014Года");
	
	// Списание НДС (ЕНВД)
	ОписаниеЭлемента = ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		"СписаниеНДСНаРасходыЕНВД",
		Перечисления.ВидыРасходовНУ.ПрочиеРасходы,
		"ru = 'Списание НДС (ЕНВД)'",
		Истина,
		"ru = 'Документ «Перемещение товаров» (списание НДС при применении ЕНВД)'");
	ОписаниеЭлемента.Функциональность.Добавить("РаздельныйУчетНДСДо2014Года");
	ОписаниеЭлемента.Реквизиты.Вставить(
		"ВидДеятельностиДляНалоговогоУчетаЗатрат",
		Перечисления.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения);
	
	// Прочие затраты
	ОписаниеЭлемента = ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		"ПрочиеЗатраты",
		Перечисления.ВидыРасходовНУ.ПрочиеРасходы,
		"ru = 'Прочие затраты'",
		Истина,
		"ru = 'Основная статья затрат'");
	
	// Описания новых статей НЕ следует добавлять в конец списка.
	// Рекомендации по порядку см. в начале процедуры.
	
КонецПроцедуры

// Содержит перечень реквизитов справочника, опираясь на значения которых
// можно с некоторой степенью надежности идентифицировать элемент как "подходящий".
//
// Возвращаемое значение:
//  Строка - перечень реквизитов, разделенных запятой
//
Функция НадежныеРеквизитыПоиска() Экспорт
	
	Возврат "ВидРасходовНУ";
	
КонецФункции

// Определяет статью, которая должна использоваться по умолчанию, исходя из данных связанных настроек
// или других объектов, хранящих ссылки на статьи (например, документов).
// Используется, в частности, в обработчиках обновления на версии,
// в которых появляется возможности назначить новый предопределенный элемент, если алгоритм такого определения нетривиальный.
//
// Параметры:
//  ИмяЭлемента - Строка - имя элемента, как задано в ЗаполнитьОписанияПоставляемыхЭлементов
// 
// Возвращаемое значение:
//  СправочникСсылка.СтатьиЗатрат - найденный в настройке элемент; ПустаяСсылка, если не найден.
//
Функция ПрочитатьИзСвязаннойНастройки(ИмяСтатьиЗатрат) Экспорт
	
	Если ИмяСтатьиЗатрат = "ОплатаТруда" Тогда
		
		Возврат РегистрыСведений.ПорядокОтраженияЗарплатыВБухУчете.ОсновнаяСтатьяЗатрат(Ложь);
			
	ИначеЕсли ИмяСтатьиЗатрат = "ОплатаТрудаЕНВД" Тогда
		
		Возврат РегистрыСведений.ПорядокОтраженияЗарплатыВБухУчете.ОсновнаяСтатьяЗатрат(Истина);
			
	ИначеЕсли ИмяСтатьиЗатрат = "СтраховыеВзносы" Тогда
		
		Возврат РегистрыСведений.СтатьиЗатратПоЗарплате.ОсновнаяСтатьяЗатрат(
			Перечисления.ВидыДополнительныхСтатейЗатрат.СтраховыеВзносы);
			
	ИначеЕсли ИмяСтатьиЗатрат = "ФСС_НС" Тогда
			
		Возврат РегистрыСведений.СтатьиЗатратПоЗарплате.ОсновнаяСтатьяЗатрат(
			Перечисления.ВидыДополнительныхСтатейЗатрат.ФСС_НС);
			
	ИначеЕсли ИмяСтатьиЗатрат = "ОплатаБольничного" Тогда
			
		Возврат РегистрыСведений.СтатьиЗатратПоЗарплате.ОсновнаяСтатьяЗатрат(
			Перечисления.ВидыДополнительныхСтатейЗатрат.ПособияЗаСчетРаботодателя);
			
	ИначеЕсли ИмяСтатьиЗатрат = "СтраховыеВзносыЕНВД" Тогда 
		
		Возврат РегистрыСведений.СтатьиЗатратПоЗарплате.ОсновнаяСтатьяЗатрат(
			Перечисления.ВидыДополнительныхСтатейЗатрат.СтраховыеВзносы,
			Перечисления.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения);
			
	ИначеЕсли ИмяСтатьиЗатрат = "ФСС_НС_ЕНВД" Тогда
			
		Возврат РегистрыСведений.СтатьиЗатратПоЗарплате.ОсновнаяСтатьяЗатрат(
			Перечисления.ВидыДополнительныхСтатейЗатрат.ФСС_НС,
			Перечисления.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения);
			
	ИначеЕсли ИмяСтатьиЗатрат = "ОплатаБольничногоЕНВД" Тогда
			
		Возврат РегистрыСведений.СтатьиЗатратПоЗарплате.ОсновнаяСтатьяЗатрат(
			Перечисления.ВидыДополнительныхСтатейЗатрат.ПособияЗаСчетРаботодателя,
			Перечисления.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения);
			
	ИначеЕсли ИмяСтатьиЗатрат = "ИмущественныеНалоги" Тогда
			
		Возврат РегистрыСведений.СпособыОтраженияРасходовПоНалогам.ОсновнаяСтатьяЗатрат();
		
	ИначеЕсли ИмяСтатьиЗатрат = "Амортизация" Тогда
		
		Возврат Справочники.СпособыОтраженияРасходовПоАмортизации.ОсновнаяСтатьяЗатрат();
		
	ИначеЕсли ИмяСтатьиЗатрат = "УслугиКомиссионеров" Тогда
		
		Возврат Документы.ОтчетКомиссионераОПродажах.ОсновнаяСтатьяЗатрат();
		
	Иначе
		
		Возврат ПустаяСсылка();
		
	КонецЕсли;
	
КонецФункции

// Выполняет настройки, в которых должны участвовать статьи затрат.
// Как правило, такие настройки содержат ссылки на непредопределенные элементы справочника и позволяют установить,
// в каких ситуациях эти элементы должны использоваться по умолчанию.
//
// Параметры:
//  ИдентифицированныеЭлементы - Структура - созданные или найденные ранее статьи затрат.
//    * Ключ - имя элемента, как задано в ЗаполнитьОписанияПоставляемыхЭлементов
//    * Значение - ссылка на созданный элемент
//
Процедура ВыполнитьСвязанныеНастройки(ИдентифицированныеЭлементы) Экспорт
	
	// Статьи затрат по заработной плате основного режима налогообложения - все они участвуют в одной настройке
	Если ИдентифицированныеЭлементы.Свойство("ОплатаТруда")
		И ИдентифицированныеЭлементы.Свойство("СтраховыеВзносы")
		И ИдентифицированныеЭлементы.Свойство("ФСС_НС")
		И ИдентифицированныеЭлементы.Свойство("ОплатаБольничного") Тогда
	
		РегистрыСведений.СтатьиЗатратПоЗарплате.ЗаполнитьПоУмолчанию(
			ИдентифицированныеЭлементы.ОплатаТруда,
			ИдентифицированныеЭлементы.СтраховыеВзносы,
			ИдентифицированныеЭлементы.ФСС_НС,
			ИдентифицированныеЭлементы.ОплатаБольничного);
		
	КонецЕсли;
	
	// Статьи затрат по заработной плате при ЕНВД - все они участвуют в одной настройке
	Если ИдентифицированныеЭлементы.Свойство("ОплатаТрудаЕНВД")
		И ИдентифицированныеЭлементы.Свойство("СтраховыеВзносыЕНВД")
		И ИдентифицированныеЭлементы.Свойство("ФСС_НС_ЕНВД")
		И ИдентифицированныеЭлементы.Свойство("ОплатаБольничногоЕНВД")Тогда
	
		РегистрыСведений.СтатьиЗатратПоЗарплате.ЗаполнитьПоУмолчанию(
			ИдентифицированныеЭлементы.ОплатаТрудаЕНВД,
			ИдентифицированныеЭлементы.СтраховыеВзносыЕНВД,
			ИдентифицированныеЭлементы.ФСС_НС_ЕНВД,
			ИдентифицированныеЭлементы.ОплатаБольничногоЕНВД);
		
	КонецЕсли;
	
	// "Одиночные" настройки - в каждой из которых одна статья затрат
	Если ИдентифицированныеЭлементы.Свойство("ИмущественныеНалоги") Тогда
		
		РегистрыСведений.СпособыОтраженияРасходовПоНалогам.ЗаполнитьПоУмолчанию(ИдентифицированныеЭлементы.ИмущественныеНалоги);
		
	КонецЕсли;
	
	Если ИдентифицированныеЭлементы.Свойство("Амортизация") Тогда
		
		Справочники.СпособыОтраженияРасходовПоАмортизации.ЗаполнитьПоУмолчанию(ИдентифицированныеЭлементы.Амортизация);
		
	КонецЕсли;
	
	Если ИдентифицированныеЭлементы.Свойство("ОплатаТруда") Тогда
		
		ЕНВД = Ложь;
		РегистрыСведений.ПорядокОтраженияЗарплатыВБухУчете.УстановитьСтатьюЗатрат(
			ИдентифицированныеЭлементы.ОплатаТруда,
			ЕНВД);
		
	КонецЕсли;
	
	Если ИдентифицированныеЭлементы.Свойство("ОплатаТрудаЕНВД") Тогда
		
		ЕНВД = Истина;
		РегистрыСведений.ПорядокОтраженияЗарплатыВБухУчете.УстановитьСтатьюЗатрат(
			ИдентифицированныеЭлементы.ОплатаТрудаЕНВД,
			ЕНВД);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы
// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область КлассификаторыДоходовРасходов

Функция ДобавитьОписаниеПоставляемогоЭлемента(ОписаниеЭлементов, Имя, Вид, Представление, Предопределенный = Ложь, ИспользованиеПоУмолчанию = "")
	
	ОписаниеЗначения = КлассификаторыДоходовРасходов.ДобавитьОписаниеПоставляемогоЭлемента(
		ОписаниеЭлементов,
		Имя,
		Представление);
	
	ОписаниеЗначения.Реквизиты.Вставить("ВидРасходовНУ", Вид);
	
	ОписаниеЗначения.Предопределенный         = Предопределенный;
	ОписаниеЗначения.ИспользованиеПоУмолчанию = ИспользованиеПоУмолчанию;
	ОписаниеЗначения.СоздаватьЗаранее         = Истина;
	
	Возврат ОписаниеЗначения;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ОбработчикиОбновления

Процедура СоздатьПоУмолчанию() Экспорт
	
	КлассификаторыДоходовРасходов.СоздатьПоУмолчанию(Справочники.СтатьиЗатрат);
	
КонецПроцедуры

Процедура НазначитьПредопределенныеЭлементы() Экспорт
	
	КлассификаторыДоходовРасходов.НазначитьПредопределенныеЭлементы(Справочники.СтатьиЗатрат);
		
КонецПроцедуры

// Обрабатывает добавление новой предопределенной статьи для учета торгового сбора.
// Сама статья в данных могла быть создана и ранее, но не была предопределенной.
//
Процедура УстановитьТорговыйСбор() Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		// Поставляемые данные не следует создавать в подчиненных узлах РИБ
		Возврат;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("УплачиваетсяТорговыйСбор") Тогда
		Возврат;
	КонецЕсли;
	
	КлассификаторыДоходовРасходов.ОбеспечитьФункциональность(Справочники.СтатьиЗатрат, "УплачиваетсяТорговыйСбор");
	
КонецПроцедуры

Процедура ВключитьНастройкуПорядкаЭлементов() Экспорт
	
	КлассификаторыДоходовРасходов.ВключитьНастройкуПорядкаЭлементов(Справочники.СтатьиЗатрат);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли