﻿
// Возвращает через второй параметр признак что переданный контрагент является нерезидентом.
//
// Параметры:
//  Контрагент - СправочникСсылка.Контрагенты - Проверяемы контрагент
//  НеРезидент - Булево - Признак что контрагент не резидент (Истина) или резидент (Ложь).
//
Процедура ПриОпределенииКонтрагентНеРезидент(Контрагент, НеРезидент) Экспорт
	
	
КонецПроцедуры

#Область СерииНоменклатуры

// Предназначена для расчета статусов указания серий во всех строках таблицы товаров
//
// Параметры:
//  Форма        - УправляемаяФорма - форма с таблицей товаров
//  ТекстЗапроса - Строка - текст запроса для расчета статусов указания серий
Процедура ЗаполнитьСтатусыУказанияСерий(Форма, ПараметрыУказанияСерий) Экспорт
	
	
КонецПроцедуры

// Возвращает через параметр наличие права на добавление элементов справочника СерииНоменклатуры
//
// Параметры:
//  ПравоДобавлениеСерий - Булево - исходящий, наличие права на добавление.
Процедура ОпределитьПравоДобавлениеСерий(ПравоДобавлениеСерий) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ПараметрыИнтеграцииФормыПроверкиИПодбора

// Заполняет специфику интеграции формы проверки и подбора в конкретную форму.
//
// Параметры:
//  Форма - УправляемаяФорма - форма для которой настраиваются параметры интеграции.
//  ПараметрыИнтеграции - (См.ПроверкаИПодборПродукцииИС.ПараметрыИнтеграцииФормПроверкиИПодбора).
//  ВидПродукции - Перечислениессылка.ВидыПродукцииИС - вид продукции для которого проводится встраивание
//
Процедура ПриОпределенииПараметровИнтеграцииФормыПроверкиИПодбора(Форма, ПараметрыИнтеграции, ВидПродукции = Неопределено) Экспорт
	
	ИмяФормы = Форма.ИмяФормы;
	
	Если ИмяФормы = "Документ.РеализацияТоваровУслуг.Форма.ФормаДокументаОбщая"
		Или ИмяФормы = "Документ.РеализацияТоваровУслуг.Форма.ФормаДокументаТовары" Тогда
		
		ПараметрыИнтеграции.ИмяРодительскойГруппыФормы                 = "ГруппаТовары";
		//ПараметрыИнтеграции.ИмяЭлементаФормыТовары                     = "ТоварыГруппаНоменклатура";
		ПараметрыИнтеграции.ИмяСледующейКолонки                        = "ТоварыКиЗ_ГИСМ";
		ПараметрыИнтеграции.РазмещатьЭлементыИнтерфейса                = Истина;
		ПараметрыИнтеграции.ИспользоватьКолонкуСтатусаПроверкиПодбора  = Истина;
		ПараметрыИнтеграции.ИспользоватьБезМаркируемойПродукции        = Истина;
		ПараметрыИнтеграции.БлокироватьТабличнуюЧастьТоварыПриПроверке = Ложь;
		ПараметрыИнтеграции.ИспользоватьСтатусПроверкаЗавершена        = Ложь;
		ПараметрыИнтеграции.ЕстьПравоИзменение                         = ПравоДоступа("Изменение", Форма.Объект.Ссылка.Метаданные());
		ПараметрыИнтеграции.ИмяТабличнойЧастиСерии                     = "";
		
	ИначеЕсли ИмяФормы = "Документ.ПоступлениеТоваровУслуг.Форма.ФормаДокументаОбщая"
		Или ИмяФормы = "Документ.ПоступлениеТоваровУслуг.Форма.ФормаДокументаТовары" Тогда
		
		ПараметрыИнтеграции.ИмяРодительскойГруппыФормы                 = "ГруппаТовары";
		//ПараметрыИнтеграции.ИмяЭлементаФормыТовары                     = "ТоварыНоменклатура";
		ПараметрыИнтеграции.ИмяСледующейКолонки                        = "ТоварыКиЗ_ГИСМ";
		ПараметрыИнтеграции.РазмещатьЭлементыИнтерфейса                = Истина;
		ПараметрыИнтеграции.ЕстьПравоИзменение                         = ПравоДоступа("Изменение", Форма.Объект.Ссылка.Метаданные());
		ПараметрыИнтеграции.ЭтоДокументПриобретения                    = Истина;
		ПараметрыИнтеграции.ЕстьЭлектронныйДокумент                    = ЭлектронноеВзаимодействиеИСМП.ДокументСвязанСЭлектронным(Форма.Объект.Ссылка);
		ПараметрыИнтеграции.ИспользоватьКолонкуСтатусаПроверкиПодбора  = Не ПараметрыИнтеграции.ЕстьЭлектронныйДокумент;
		ПараметрыИнтеграции.БлокироватьТабличнуюЧастьТоварыПриПроверке = ПараметрыИнтеграции.ЕстьЭлектронныйДокумент;
		ПараметрыИнтеграции.ИспользоватьСтатусПроверкаЗавершена        = ПараметрыИнтеграции.ЕстьЭлектронныйДокумент;
		ПараметрыИнтеграции.ИмяТабличнойЧастиСерии                     = "";
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет специфику применения интеграции формы проверки и подбора в конкретную форму.
//
// Параметры:
//  Форма - УправляемаяФорма - форма для которой применяются параметры интеграции.
//
Процедура ПриПримененииПараметровИнтеграцииФормыПроверкиИПодбора(Форма) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСТСД

// Обрабатывает таблицу штриховых кодов и получает для каждого из них данные в информационной базе.
//   На входе имеется таблица, в которой заполнены только колонки "Номер строки", "Штриховой код" и "Количество", опционально заполнена 
//   колонка "Родитель".
//   В процедуре заполняется допустимый штрихкод упаковки из справочника или признак новой (неизвестной) упаковки.
//
// Параметры:
//  ТаблицаНеАкцизныеМарки - ТаблицаЗначение - имеет следующие колонки:
//   * ШтриховойКод        - Строка                              - штриховой код полученный с ТСД.
//   * Количество          - Число                               - сколько раз был считан данный штрихкод.
//   * ШтрихКодУпаковки    - Справочник.ШтрихкодыУпаковокТоваров - ссылка на имеющуюся в базе упаковку.
//   * Родитель            - Строка                              - штрихкод внешней упаковки.
//   * НомерСтроки         - Число                               - номер строки таблицы
//   * ЭтоУпаковка         - Булево                              - признак новой упаковки
//
Процедура РаспознатьШтрихкоды(ТаблицаНеАкцизныеМарки) Экспорт
	
	Возврат;

КонецПроцедуры

#КонецОбласти
#Область СлужебныйПрограмныйИнтерфейс

// Возвращает через третий параметр признак наличия маркируемой продукции.
//
// Параметры:
//  Коллекция                - ДанныеФормыКоллекция - ТЧ с товарами.
//  ВидМаркируемойПродукции  - ПеречислениеСсылка.ВидыПродукцииИС - вид продукции, наличие которой необходимо определить.
//  ЕстьМаркируемаяПродукция - Булево - Исходящий, признак наличия маркируемой продукции.
Процедура ЕстьМаркируемаяПродукцияВКоллекции(Коллекция, ВидМаркируемойПродукции, ЕстьМаркируемаяПродукция) Экспорт
	
	ИнтеграцияИСМПБП.ЕстьМаркируемаяПродукцияВКоллекции(Коллекция, ВидМаркируемойПродукции, ЕстьМаркируемаяПродукция);
	
КонецПроцедуры

// Возвращает через третий параметр таблицу товаров документа, являющихся маркируемой продукцией требуемого вида.
//
// Параметры:
//  * Контекст                 - УправляемаяФорма, ДокументСсылка - документ, маркируемую продукцию которого необходимо получить.
//  * ВидМаркируемойПродукции  - ПеречислениеСсылка.ВидыПродукцииИС - вид маркируемой продукции, которую необходимо получить.
//  * ТаблицаМаркируемойПродукции - ТаблицаЗначений - Исходящий, таблица с маркируемой продукцией документа. Должна содержать колонки:
//  ** GTIN           - Строка - GTIN продукции
//  ** Номенклатура   - ОпределяемыйТип.Номенклатура - номенклатура маркируемой продукции
//  ** Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - характеристика номенклатура маркируемой продукции
//  ** Серия          - ОпределяемыйТип.СерияНоменклатуры - серия номенклатура маркируемой продукции
//  ** Количество     - Число - количество маркируемой продукции
Процедура ПриОпределенииМаркируемойПродукцииДокумента(Контекст, ВидМаркируемойПродукции, ТаблицаМаркируемойПродукции) Экспорт
	
	ИнтеграцияИСМПБП.ЗаполнитьМаркируемуюПродукциюДокумента(Контекст, ВидМаркируемойПродукции, ТаблицаМаркируемойПродукции);
	
КонецПроцедуры

// Предназначена для реализации функциональности по отражению результатов проверки и подбора в документе, из которого была вызвана соотвествующая форма.
// 
// Параметры:
//  ПараметрыОкончанияПроверки - (См. ПроверкаИПодборИСМП.ЗафиксироватьРезультатПроверкиИПодбора).
Процедура ОтразитьРезультатыСканированияВДокументе(ПараметрыОкончанияПроверки) Экспорт
	
	ИнтеграцияМОТПБП.ОтразитьРезультатыСканированияВДокументе(ПараметрыОкончанияПроверки);
	
КонецПроцедуры

// Получает сформированный ранее Акт о расхождениях для переданного документа.
// 
// Параметры:
//  Документ         - ДокументСсылка - ссылка на документ, для которого необходимо получить Акт о расхождениях:
//  АктОРасхождениях - ДокументСсылка - ссылка на Акт о расхождениях:
Процедура ПолучитьСформированныйАктОРасхождениях(Документ, АктОРасхождениях) Экспорт
	
	
КонецПроцедуры

// Заполняет в табличной части служебные реквизиты, например: признак использования характеристик номенклатуры.
//
// Параметры:
//  Форма          - УправляемаяФорма - Форма.
//  ТабличнаяЧасть - ДанныеФормыКоллекция, ТаблицаЗначений - таблица для заполнения.
Процедура ЗаполнитьСлужебныеРеквизитыВКоллекции(Форма, ТабличнаяЧасть) Экспорт
	
	
КонецПроцедуры

// Устанавливает режим просмотра (доступности, для команд) элементам формы.
//   Переопределение необходимо использовать для совместной работы с аналогичными механизмами.
//   Обработанные здесь реквизиты мледует удалить из массива "Блокируемые элементы".
// 
// Параметры:
//  Форма               - УправляемаяФорма - форма в которой производится изменение доступности
//  БлокируемыеЭлементы - Массив - наименования реквизитов
//  Заблокировать       - Булево - заблокировать или разблокировать реквизиты
Процедура УстановитьТолькоПросмотрЭлементов(
		Форма,
		БлокируемыеЭлементы,
		Заблокировать) Экспорт
	
	
КонецПроцедуры

#КонецОбласти
