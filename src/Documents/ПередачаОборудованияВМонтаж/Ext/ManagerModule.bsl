﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВремяДокументаПоУмолчанию() Экспорт
	
	Возврат Новый Структура("Часы, Минуты", 12, 0);
	
КонецФункции

// Заполняет счета учета номенклатуры в строке табличной части документа
//
// Параметры:
//  ДанныеОбъекта         - структура данных объекта, используемых при заполнении счетов учета (вид операции,
//                          вид договора контрагента, признак комиссионной торговли и т.п.)
//  СтрокаТабличнойЧасти  - строка табличной части документа
//  ИмяТабличнойЧасти     - имя табличной части документа
//  СведенияОНоменклатуре - структура сведений о номенклатуре, либо стуктура счетов учета
//
Процедура ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТабличнойЧасти = "", СведенияОНоменклатуре) Экспорт

	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СведенияОНоменклатуре.Свойство("СчетаУчета") Тогда
		// СведенияОНоменклатуре - структура сведений номенклатуры
		СчетаУчета = СведенияОНоменклатуре.СчетаУчета;
	ИначеЕсли СведенияОНоменклатуре.Свойство("СчетУчета") Тогда
		// СведенияОНоменклатуре - структура счетов учета номенклатуры
		СчетаУчета = СведенияОНоменклатуре;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СчетаУчета.СчетУчета) Тогда
		СтрокаТабличнойЧасти.СчетУчета = СчетаУчета.СчетУчета;
	КонецЕсли;

КонецПроцедуры

// Заполняет счета учета номенклатуры в табличной части документа
//
Процедура ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, ИмяТабличнойЧасти) Экспорт

	ТабличнаяЧасть = Объект[ИмяТабличнойЧасти];
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	СоответствиеСчетовУчета = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаУчетаСпискаНоменклатуры(
		ДанныеОбъекта.Организация, ОбщегоНазначения.ВыгрузитьКолонку(ТабличнаяЧасть, "Номенклатура", Истина), ДанныеОбъекта.Склад, ДанныеОбъекта.Дата);
	
	Для каждого СтрокаТабличнойЧасти Из ТабличнаяЧасть Цикл
		СчетаУчета = СоответствиеСчетовУчета.Получить(СтрокаТабличнойЧасти.Номенклатура);
		ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТабличнойЧасти, СчетаУчета);
	КонецЦикла;

КонецПроцедуры

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт

	ПараметрыПроведения = Новый Структура;

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;

	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация
	|ИЗ
	|	Документ.ПередачаОборудованияВМонтаж КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();

	Если НЕ УчетнаяПолитика.Существует(Выборка.Организация, Выборка.Период, Истина, ДокументСсылка) Тогда
		Отказ = Истина;
		Возврат ПараметрыПроведения;
	КонецЕсли;
//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-14 (#4405)
	ВедетсяУчетПрослеживаемыхТоваров  = ПолучитьФункциональнуюОпцию("ВестиУчетПрослеживаемыхТоваров")
		И ПрослеживаемостьБРУ.ВедетсяУчетПрослеживаемыхТоваров(Выборка.Период);
//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-14 (#4405) 
	Запрос.УстановитьПараметр("Ссылка",                         ДокументСсылка);
	Запрос.УстановитьПараметр("СинонимОборудование",            НСтр("ru = 'Оборудование'"));
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", Константы.ВалютаРегламентированногоУчета.Получить());

	НомераТаблиц = Новый Структура;

	Запрос.Текст =
		ТекстЗапросаСписаниеТоваров(НомераТаблиц)
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-14 (#4405)
		//+ ТекстЗапросаНДС(НомераТаблиц);
		+ ТекстЗапросаНДС(НомераТаблиц)
		+ ТекстЗапросаПрослеживаемыеТовары(НомераТаблиц, ПараметрыПроведения, ВедетсяУчетПрослеживаемыхТоваров);
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-14 (#4405)

	Результат = Запрос.ВыполнитьПакет();

	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;

	Возврат ПараметрыПроведения;

КонецФункции

Процедура ДобавитьКолонкуСодержание(ТаблицаЗначений, ДокументСсылка) Экспорт

	Основание = ДокументСсылка.Комментарий;

	Для каждого СтрокаТаблицы Из ТаблицаЗначений Цикл
		Содержание = "Передача оборудования в монтаж %1: %2";
		Содержание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Содержание,
			БухгалтерскийУчетПовтИсп.НазваниеОбъектаПоСчетуУчета(СтрокаТаблицы.СчетУчета),
			Основание);
		СтрокаТаблицы.Содержание = Содержание;
	КонецЦикла;

КонецПроцедуры

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Акт о приеме-передаче оборудования (ОС-15)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ОС15";
	КомандаПечати.Представление = НСтр("ru = 'Акт о приеме-передаче оборудования (ОС-15)'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru = 'Реестр документов ""Передача оборудования в монтаж""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	// Проверяем, нужно ли для макета СчетЗаказа формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОС15") Тогда

		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ОС15", НСтр("ru = 'Акт о приемке-передаче оборудования в монтаж (ОС-15)'"), 
			ПечатьОС15(МассивОбъектов, ОбъектыПечати, ПараметрыПечати), , "Документ.ПередачаОборудованияВМонтаж.ПФ_MXL_ОС15");

	КонецЕсли;
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);	

КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "ОбъектСтроительства");
	
	Возврат Результат;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстЗапросаСписаниеТоваров(НомераТаблиц)

	НомераТаблиц.Вставить("СписаниеТоваровРеквизиты", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("СписаниеТоваровТаблицаТовары", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка                   КАК Регистратор,
	|	Реквизиты.Дата                     КАК Период,
	|	Реквизиты.Организация              КАК Организация,
	|	НЕОПРЕДЕЛЕНО                       КАК Контрагент,
	|	Реквизиты.ПодразделениеОрганизации КАК Подразделение,
	|	Реквизиты.ПодразделениеОрганизации КАК КорПодразделение,
	|	""Передача оборудования в монтаж"" КАК Содержание
	|ИЗ
	|	Документ.ПередачаОборудованияВМонтаж КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""Оборудование""                               КАК ИмяСписка,
	|	&СинонимОборудование                           КАК СинонимСписка,
	|	Реквизиты.Дата                                 КАК Период,
	|	ТаблицаТовары.НомерСтроки                      КАК НомерСтроки,
	|	ТаблицаТовары.СчетУчета                        КАК СчетУчета,
	|	ТаблицаТовары.Номенклатура                     КАК Номенклатура,
	|	Реквизиты.Склад                                КАК Склад,
	|	ТаблицаТовары.Количество                       КАК Количество,
	|	НЕОПРЕДЕЛЕНО                                   КАК ДокументОприходования,
	|	0                                              КАК Себестоимость,
	|	НЕОПРЕДЕЛЕНО                                   КАК Комитент,
	|	НЕОПРЕДЕЛЕНО                                   КАК ДоговорКомиссии,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетАвансовСКомитентом,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетРасчетовСКомитентом,
	|	НЕОПРЕДЕЛЕНО                                   КАК ВалютаРасчетовСКомитентом,
	|	0                                              КАК СуммаРасчетовСКомитентом,
	|	Реквизиты.ПодразделениеОрганизации             КАК КорПодразделение,
	|	Реквизиты.СчетУчетаОбъектаСтроительства        КАК КорСчетСписания,
	|	Реквизиты.ОбъектСтроительства                                                  КАК КорСубконто1,
	|	Реквизиты.СтатьяЗатрат                                                         КАК КорСубконто2,
	|	ЗНАЧЕНИЕ(Перечисление.СпособыСтроительства.Подрядный)                          КАК КорСубконто3,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОбъектыСтроительства) КАК ВидКорСубконто1,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиЗатрат)         КАК ВидКорСубконто2,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.СпособыСтроительства) КАК ВидКорСубконто3
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-14 (#4405)
	|	,ТаблицаТовары.ИдентификаторСтроки КАК ИдентификаторСтроки
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-14 (#4405)
	|ИЗ
	|	Документ.ПередачаОборудованияВМонтаж КАК Реквизиты
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	Документ.ПередачаОборудованияВМонтаж.Оборудование КАК ТаблицаТовары
	|		ПО Реквизиты.Ссылка = ТаблицаТовары.Ссылка
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаТовары.НомерСтроки";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-14 (#4405)
Функция ТекстЗапросаПрослеживаемыеТовары(НомераТаблиц, ПараметрыПроведения, ВедетсяУчетПрослеживаемыхТоваров)
	
	Если НЕ ВедетсяУчетПрослеживаемыхТоваров Тогда
		ПараметрыПроведения.Вставить("ПрослеживаемыеТовары",   Неопределено);
		ПараметрыПроведения.Вставить("ПрослеживаемыеОС",       Неопределено);
		Возврат "";
	КонецЕсли;
	
	НомераТаблиц.Вставить("ВТ_Прослеживаемость",    НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ПрослеживаемыеТовары",   НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ПрослеживаемыеОС",       НомераТаблиц.Количество());
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ПередачаОборудованияВМонтажОборудование.Номенклатура КАК Номенклатура,
	|	СУММА(ПередачаОборудованияВМонтажСведенияПрослеживаемости.Количество) КАК Количество,
	|	ПередачаОборудованияВМонтажОборудование.СтранаПроисхождения КАК СтранаПроисхождения,
	|	ПередачаОборудованияВМонтажСведенияПрослеживаемости.РНПТ КАК РНПТ,
	|	СУММА(ПередачаОборудованияВМонтажСведенияПрослеживаемости.КоличествоПрослеживаемости) КАК КоличествоПрослеживаемости,
	|	ПередачаОборудованияВМонтаж.ОбъектСтроительства КАК ОС
	|ПОМЕСТИТЬ ВТ_Прослеживаемость
	|ИЗ
	|	Документ.ПередачаОборудованияВМонтаж.Оборудование КАК ПередачаОборудованияВМонтажОборудование
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПередачаОборудованияВМонтаж.СведенияПрослеживаемости КАК ПередачаОборудованияВМонтажСведенияПрослеживаемости
	|		ПО ПередачаОборудованияВМонтажОборудование.Ссылка = ПередачаОборудованияВМонтажСведенияПрослеживаемости.Ссылка
	|			И ПередачаОборудованияВМонтажОборудование.ИдентификаторСтроки = ПередачаОборудованияВМонтажСведенияПрослеживаемости.ИдентификаторСтроки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПередачаОборудованияВМонтаж КАК ПередачаОборудованияВМонтаж
	|		ПО ПередачаОборудованияВМонтажОборудование.Ссылка = ПередачаОборудованияВМонтаж.Ссылка
	|ГДЕ
	|	ПередачаОборудованияВМонтажОборудование.ПрослеживаемыйТовар
	|	И ПередачаОборудованияВМонтажОборудование.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ПередачаОборудованияВМонтажОборудование.СтранаПроисхождения,
	|	ПередачаОборудованияВМонтажСведенияПрослеживаемости.РНПТ,
	|	ПередачаОборудованияВМонтажОборудование.Номенклатура,
	|	ПередачаОборудованияВМонтаж.ОбъектСтроительства
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Прослеживаемость.Номенклатура КАК Номенклатура,
	|	ВТ_Прослеживаемость.Количество КАК Количество,
	|	ВТ_Прослеживаемость.РНПТ КАК РНПТ,
	|	ВТ_Прослеживаемость.КоличествоПрослеживаемости КАК КоличествоПрослеживаемости,
	|	ВТ_Прослеживаемость.СтранаПроисхождения КАК СтранаПроисхождения,
	|	НЕОПРЕДЕЛЕНО КАК Комитент,
	|	НЕОПРЕДЕЛЕНО КАК Комиссионер,
	|	НЕОПРЕДЕЛЕНО КАК ВидЗапасов,
	|	НЕОПРЕДЕЛЕНО КАК ОснованиеДляВозврата,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаРеализации
	|ИЗ
	|	ВТ_Прослеживаемость КАК ВТ_Прослеживаемость
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Прослеживаемость.СтранаПроисхождения КАК СтранаПроисхождения,
	|	ВТ_Прослеживаемость.РНПТ КАК РНПТ,
	|	ВТ_Прослеживаемость.Количество КАК Количество,
	|	ВТ_Прослеживаемость.КоличествоПрослеживаемости КАК КоличествоПрослеживаемости,
	|	ВТ_Прослеживаемость.Номенклатура КАК Комплектующие,
	|	ВТ_Прослеживаемость.ОС КАК ОсновноеСредство
	|ИЗ
	|	ВТ_Прослеживаемость КАК ВТ_Прослеживаемость";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции
//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-14 (#4405)

Функция ТекстЗапросаНДС(НомераТаблиц)

	НомераТаблиц.Вставить("РеквизитыНДС", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ТоварыНДС",    НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.ПодразделениеОрганизации КАК Подразделение,
	|	Реквизиты.СпособУчетаНДС
	|ИЗ
	|	Документ.ПередачаОборудованияВМонтаж КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""Оборудование"" КАК ИмяСписка,
	|	ТаблицаОборудование.НомерСтроки КАК НомерСтрокиДокумента,
	|	ТаблицаОборудование.Номенклатура КАК Номенклатура,
	|	ТаблицаОборудование.Количество КАК Количество,
	|	ТаблицаОборудование.СчетУчета КАК СчетУчета,
	|	ТаблицаОборудование.Ссылка.СпособУчетаНДС КАК НовыйСпособУчетаНДС
	|ИЗ
	|	Документ.ПередачаОборудованияВМонтаж.Оборудование КАК ТаблицаОборудование
	|ГДЕ
	|	ТаблицаОборудование.Ссылка = &Ссылка";
		
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ПечатьОС15(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)

	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент();
	ТабличныйДокумент.АвтоМасштаб			= Истина;
	ТабличныйДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент.КлючПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_ПередачаОборудованияВМонтаж_ОС15";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПередачаОборудованияВМонтаж.ПФ_MXL_ОС15");

	// Области макетов
	Шапка         = Макет.ПолучитьОбласть("Шапка");
	ШапкаТаблицы  = Макет.ПолучитьОбласть("ШапкаТаблицы");
	СтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицы");
	Оборот        = Макет.ПолучитьОбласть("ОборотнаяСторона");

	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);

	Запрос.Текст = "
	|ВЫБРАТЬ
	|	МИНИМУМ(Дата) КАК ДатаНач,
	|	МАКСИМУМ(Дата) КАК ДатаКон
	|ИЗ
	|	Документ.ПередачаОборудованияВМонтаж
	|ГДЕ
	|	Ссылка В (&МассивОбъектов)
	|";
	
	Выборка = Запрос.Выполнить().Выбрать();
	ДатаНач = '00010101';
	ДатаКон = '00010101';
	Если Выборка.Следующий() Тогда
		ДатаНач = Выборка.ДатаНач;
		ДатаКон = Выборка.ДатаКон;
	КонецЕсли;
	
	ТаблицаСуммСписанияПоДокументам = БухгалтерскийУчетПереопределяемый.ПолучитьСуммуСписанияАктивов(МассивОбъектов, ДатаНач, ДатаКон);
	
	Запрос.УстановитьПараметр("ТаблицаСуммСписанияПоДокументам", ТаблицаСуммСписанияПоДокументам);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаСуммСписанияПоДокументам.Регистратор КАК Регистратор,
	|	ТаблицаСуммСписанияПоДокументам.Номенклатура КАК Номенклатура,
	|	ТаблицаСуммСписанияПоДокументам.Сумма КАК Сумма,
	|	ТаблицаСуммСписанияПоДокументам.Количество КАК Количество
	|ПОМЕСТИТЬ ТаблицаСуммСписанияПоДокументам
	|ИЗ
	|	&ТаблицаСуммСписанияПоДокументам КАК ТаблицаСуммСписанияПоДокументам
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Регистратор,
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПередачаОборудованияВМонтажОборудование.Ссылка КАК Ссылка,
	|	ПередачаОборудованияВМонтажОборудование.Номенклатура КАК Номенклатура,
	|	МИНИМУМ(ПередачаОборудованияВМонтажОборудование.НомерСтроки) КАК НомерСтроки
	|ПОМЕСТИТЬ ТаблицаОборудование
	|ИЗ
	|	Документ.ПередачаОборудованияВМонтаж.Оборудование КАК ПередачаОборудованияВМонтажОборудование
	|ГДЕ
	|	ПередачаОборудованияВМонтажОборудование.Ссылка В(&МассивОбъектов)
	|
	|СГРУППИРОВАТЬ ПО
	|	ПередачаОборудованияВМонтажОборудование.Номенклатура,
	|	ПередачаОборудованияВМонтажОборудование.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка,
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОборудование.Ссылка КАК Ссылка,
	|	ТаблицаОборудование.Ссылка.Дата КАК ДатаДокумента,
	|	ТаблицаОборудование.Ссылка.Номер КАК НомерДокумента,
	|	ТаблицаОборудование.Ссылка.Организация КАК Организация,
	|	ТаблицаОборудование.Ссылка.ОбъектСтроительства КАК ОбъектВнеоборотныхАктивов,
	|	ТаблицаОборудование.Ссылка.СтатьяЗатрат,
	|	ТаблицаОборудование.Ссылка.Склад,
	|	ВЫБОР
	|		КОГДА ТаблицаОборудование.Ссылка.ПодразделениеОрганизации.НаименованиеПолное ПОДОБНО """"""""
	|			ТОГДА ТаблицаОборудование.Ссылка.ПодразделениеОрганизации.Наименование
	|		ИНАЧЕ ТаблицаОборудование.Ссылка.ПодразделениеОрганизации.НаименованиеПолное
	|	КОНЕЦ КАК ПодразделениеНаименование,
	|	ТаблицаОборудование.Ссылка.Склад.Представление КАК СкладПредставление,
	|	ТаблицаОборудование.Номенклатура.НаименованиеПолное КАК ОборудованиеНаименование,
	|	ТаблицаОборудование.Номенклатура КАК Оборудование,
	|	ЕСТЬNULL(ТаблицаСуммСписанияПоДокументам.Сумма, 0) КАК СтоимостьВсего,
	|	ЕСТЬNULL(ТаблицаСуммСписанияПоДокументам.Количество, 0) КАК Количество
	|ИЗ
	|	ТаблицаОборудование КАК ТаблицаОборудование
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаСуммСписанияПоДокументам КАК ТаблицаСуммСписанияПоДокументам
	|		ПО ТаблицаОборудование.Ссылка = ТаблицаСуммСписанияПоДокументам.Регистратор
	|			И ТаблицаОборудование.Номенклатура = ТаблицаСуммСписанияПоДокументам.Номенклатура
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОборудование.Ссылка.Дата,
	|	ТаблицаОборудование.Ссылка,
	|	ТаблицаОборудование.НомерСтроки
	|ИТОГИ
	|	СУММА(СтоимостьВсего),
	|	СУММА(Количество)
	|ПО
	|	Ссылка";

	ВыборкаПоШапке = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Ссылка");
	ПервыйДокумент = Истина;

	Шапка.Параметры.ФормаПоОКУД = "0306007";
	Пока ВыборкаПоШапке.Следующий() Цикл

		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;

		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;


		Шапка.Параметры.Заполнить(ВыборкаПоШапке);
		Шапка.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаПоШапке.НомерДокумента, Истина, Ложь);
		СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ВыборкаПоШапке.Организация, ВыборкаПоШапке.ДатаДокумента);
		Шапка.Параметры.ОрганизацияЗаказчикНаименование = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм,");
		Шапка.Параметры.ОрганизацияЗаказчикКодПоОКПО = СведенияОбОрганизации.КодПоОКПО;
		ТабличныйДокумент.Вывести(Шапка);
		ТабличныйДокумент.Вывести(ШапкаТаблицы);

		ВыборкаПоОборудованию = ВыборкаПоШапке.Выбрать();

		Пока ВыборкаПоОборудованию.Следующий() Цикл

			Если ВыборкаПоОборудованию.Количество = 0 Тогда
				Количество = 1;
			Иначе
				Количество = ВыборкаПоОборудованию.Количество;
			КонецЕсли;

			СтрокаТаблицы.Параметры.Заполнить(ВыборкаПоОборудованию);
			СтрокаТаблицы.Параметры.СтоимостьЕдиницы = ВыборкаПоОборудованию.СтоимостьВсего / Количество;

			ТабличныйДокумент.Вывести(СтрокаТаблицы);

		Конеццикла;

		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		Оборот.Параметры.Заполнить(ВыборкаПоШапке);
		ТабличныйДокумент.Вывести(Оборот);

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоШапке.Ссылка);

	КонецЦикла;

	Возврат ТабличныйДокумент;

КонецФункции

#КонецОбласти

#КонецЕсли