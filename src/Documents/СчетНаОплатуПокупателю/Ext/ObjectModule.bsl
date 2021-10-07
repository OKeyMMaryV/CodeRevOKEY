﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ
//

Процедура СкопироватьТовары(Основание, ИзменятьЦены = Ложь, ИсключитьУслуги = Ложь) Экспорт
	
	Схема = Новый СхемаЗапроса;
	Схема.УстановитьТекстЗапроса(
		"ВЫБРАТЬ
		|	Товары.Номенклатура КАК Номенклатура,
		|	Товары.Цена КАК Цена,
		|	Товары.Сумма КАК Сумма,
		|	Товары.СтавкаНДС КАК СтавкаНДС,
		|	Товары.СуммаНДС КАК СуммаНДС,
		|	Товары.Количество КАК Количество
		|ИЗ
		|	&ТабличнаяЧастьТовары КАК Товары
		|ГДЕ
		|	Товары.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	Товары.НомерСтроки");
	
	Если ИсключитьУслуги Тогда
		ОсновнойОператор = Схема.ПакетЗапросов[0].Операторы[0];
		ОсновнойОператор.Отбор.Добавить("Не Товары.Номенклатура.Услуга");
	КонецЕсли;
	ИмяДокумента = Основание.Метаданные().Имя;
	Запрос = Новый Запрос;
	Запрос.Текст = Схема.ПолучитьТекстЗапроса();
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст,
		"&ТабличнаяЧастьТовары",
		"Документ." + ИмяДокумента + ".Товары");
	
	Запрос.УстановитьПараметр("Ссылка", Основание);
	
	ТаблицаТоваров = Запрос.Выполнить().Выгрузить();
	
	Если ИзменятьЦены Тогда
		ПересчитатьЦеныВТаблице(Основание, ТаблицаТоваров);
	Иначе
		ПересчитатьСуммыТабличнойЧасти(Основание, ТаблицаТоваров);
	КонецЕсли;
	
	Для каждого СтрокаТовары Из ТаблицаТоваров Цикл
		СтрокаТабличнойЧасти = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТовары);
	КонецЦикла;
	
КонецПроцедуры

Процедура СкопироватьВозвратнуюТару(Основание, ИзменятьЦены = Ложь) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Основание);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВозвратнаяТара.НомерСтроки КАК НомерСтроки,
		|	ВозвратнаяТара.Номенклатура КАК Номенклатура,
		|	ВозвратнаяТара.Количество КАК Количество,
		|	ВозвратнаяТара.Сумма КАК Сумма,
		|	ВозвратнаяТара.Цена КАК Цена
		|ИЗ
		|	&ТабличнаяЧастьВозвратнаяТара КАК ВозвратнаяТара
		|ГДЕ
		|	ВозвратнаяТара.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВозвратнаяТара.НомерСтроки";
	
	ИмяДокумента = Основание.Метаданные().Имя;
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст,
		"&ТабличнаяЧастьВозвратнаяТара",
		"Документ." + ИмяДокумента + ".ВозвратнаяТара");
	Запрос.УстановитьПараметр("Ссылка", Основание);
	ТаблицаВозвратнойТары = Запрос.Выполнить().Выгрузить();
	
	Если ИзменятьЦены Тогда
		ПересчитатьЦеныВТаблице(Основание, ТаблицаВозвратнойТары);
	КонецЕсли;
	
	Для Каждого СтрокаВозвратнаяТара Из ТаблицаВозвратнойТары Цикл
		СтрокаТабличнойЧасти = ВозвратнаяТара.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаВозвратнаяТара);
	КонецЦикла;
	
КонецПроцедуры

Процедура СкопироватьУслуги(Основание, ИзменятьЦены = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Основание);
	Запрос.Текст = 
		"ВЫБРАТЬ
	|	Услуги.НомерСтроки КАК НомерСтроки,
	|	Услуги.Содержание,
	|	Услуги.Количество,
	|	Услуги.Цена,
	|	Услуги.Сумма,
	|	Услуги.СтавкаНДС,
	|	Услуги.СуммаНДС,
	|	Услуги.Номенклатура,
	|	1 КАК Порядок
	|ИЗ
	|	&ТабличнаяЧастьУслуги КАК Услуги
	|ГДЕ
	|	Услуги.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	АгентскиеУслуги.НомерСтроки,
	|	АгентскиеУслуги.Содержание,
	|	АгентскиеУслуги.Количество,
	|	АгентскиеУслуги.Цена,
	|	АгентскиеУслуги.Сумма,
	|	АгентскиеУслуги.СтавкаНДС,
	|	АгентскиеУслуги.СуммаНДС,
	|	АгентскиеУслуги.Номенклатура,
	|	2
	|ИЗ
	|	&ТабличнаяЧастьАгентскиеУслуги КАК АгентскиеУслуги
	|ГДЕ
	|	АгентскиеУслуги.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок,
	|	НомерСтроки";
	
	ИмяДокумента = Основание.Метаданные().Имя;
	
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст,
		"&ТабличнаяЧастьУслуги",
		"Документ." + ИмяДокумента + ".Услуги");
		
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст,
		"&ТабличнаяЧастьАгентскиеУслуги",
		"Документ." + ИмяДокумента + ".АгентскиеУслуги");
	
	Запрос.УстановитьПараметр("Ссылка", Основание);
	
	ТаблицаУслуг = Запрос.Выполнить().Выгрузить();
	
	Если ИзменятьЦены Тогда
		ПересчитатьЦеныВТаблице(Основание, ТаблицаУслуг, Истина);
	Иначе
		ПересчитатьСуммыТабличнойЧасти(Основание, ТаблицаУслуг);
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из ТаблицаУслуг Цикл
		НоваяСтрока = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПересчитатьЦеныВТаблице(Основание, Таблица, Услуги = Ложь)
	
	Номенклатура = Таблица.ВыгрузитьКолонку("Номенклатура");
	Если ЗначениеЗаполнено(ТипЦен) Тогда
		Цены = Ценообразование.ПолучитьТаблицуЦенНоменклатуры(Номенклатура, ТипЦен, Дата);
	Иначе
		Цены = Ценообразование.ПолучитьТаблицуЦенНоменклатурыДокументов(
			Номенклатура, Перечисления.СпособыЗаполненияЦен.ПоПродажнымЦенам, Дата);
	КонецЕсли;
	ЕстьНДС = Таблица.Колонки.Найти("СтавкаНДС") <> Неопределено;
	
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		СведенияОЦене = Цены.Найти(СтрокаТаблицы.Номенклатура, "Номенклатура");
		Если СведенияОЦене = Неопределено Тогда
			СтрокаТаблицы.Цена = 0;
		Иначе
			СтрокаТаблицы.Цена = РаботаСКурсамиВалютБПКлиентСервер.ПересчитатьИзВалютыВВалюту(
			СведенияОЦене.Цена,
			СведенияОЦене.Валюта, ВалютаДокумента,
			СведенияОЦене.Курс, КурсВзаиморасчетов,
			СведенияОЦене.Кратность, КратностьВзаиморасчетов);
			Если ЗначениеЗаполнено(ТипЦен) И (СведенияОЦене.Валюта <> ВалютаДокумента) Тогда
				СтрокаТаблицы.Цена = Ценообразование.ОкруглитьЦену(СтрокаТаблицы.Цена, ТипЦен);
			КонецЕсли;
			Если ЕстьНДС Тогда
				СтрокаТаблицы.Цена = УчетНДСКлиентСервер.ПересчитатьЦенуПриИзмененииФлаговНалогов(
					СтрокаТаблицы.Цена, СведенияОЦене.ЦенаВключаетНДС, СуммаВключаетНДС,
					УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТаблицы.СтавкаНДС));
			КонецЕсли;
		КонецЕсли;
		
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТаблицы, ?(Услуги, 1, 0));
		Если ЕстьНДС Тогда
			ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(СтрокаТаблицы, СуммаВключаетНДС);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПересчитатьСуммыТабличнойЧасти(Основание, Таблица)
	
	ОснованиеСуммаВключаетНДС = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Основание, "СуммаВключаетНДС");
	Если ОснованиеСуммаВключаетНДС <> СуммаВключаетНДС Тогда
		Для каждого СтрокаТЧ Из Таблица Цикл
			СтрокаТЧ.Сумма = СтрокаТЧ.Сумма + ?(СуммаВключаетНДС, СтрокаТЧ.СуммаНДС, -СтрокаТЧ.СуммаНДС);
			Если СтрокаТЧ.Количество = 0 Тогда
				СтрокаТЧ.Цена = 0;
			Иначе
				СтрокаТЧ.Цена = СтрокаТЧ.Сумма / СтрокаТЧ.Количество;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоДокументуОснованию(Основание)

	Если ТипЗнч(Основание) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда

		// Заполним реквизиты шапки по документу основанию.
		АдресДоставки = Основание.АдресДоставки;
		ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);

		// Заполним табличные части
		СкопироватьТовары(Основание);
		СкопироватьВозвратнуюТару(Основание);
		СкопироватьУслуги(Основание);
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.СчетНаОплатуПоставщика")
		Или ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		
		МетаданныеОснования = Основание.Метаданные();
		
		// Заполним реквизиты из стандартного набора по документу основанию.
		РеквизитыКЗаполнению = "ВалютаДокумента, ПодразделениеОрганизации, Организация"
			+ ?(ОбщегоНазначения.ЕстьРеквизитОбъекта("Склад", МетаданныеОснования), ", Склад", "");
		ДанныеОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание, РеквизитыКЗаполнению);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеОснования);
		ЗаполнениеДокументов.Заполнить(ЭтотОбъект);
		
		// Флаги включения налогов.
		Если ЗначениеЗаполнено(ТипЦен) Тогда
			СуммаВключаетНДС = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТипЦен, "ЦенаВключаетНДС");
		Иначе
			СуммаВключаетНДС = Истина;
		КонецЕсли;
		
		// Заполним табличные части
		СкопироватьТовары(Основание, Истина, Истина);
		СкопироватьВозвратнуюТару(Основание, Истина);
		//+ СБ 10-11-2011 Прудникова Татьяна перенесено из Вендора	
		Реализация = Основание;
		///
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ОтчетКомитентуОПродажах") Тогда

		// Заполним реквизиты шапки по документу основанию.
		ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);

		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Ссылка", Основание.Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СправочникНоменклатура.Ссылка КАК Номенклатура,
		|	СправочникНоменклатура.НаименованиеПолное КАК Содержание,
		|	ОтчетКомитентуОПродажах.СтавкаНДСВознаграждения КАК СтавкаНДС,
		|	СУММА(ОтчетКомитентуОПродажахТовары.СуммаВознаграждения) КАК Цена,
		|	СУММА(ОтчетКомитентуОПродажахТовары.СуммаВознаграждения) КАК Сумма,
		|	СУММА(ОтчетКомитентуОПродажахТовары.СуммаНДСВознаграждения) КАК СуммаНДС,
		|	СправочникНоменклатура.ПериодичностьУслуги КАК ПериодичностьУслуги,
		|	ОтчетКомитентуОПродажах.Дата
		|ИЗ
		|	Документ.ОтчетКомитентуОПродажах.Товары КАК ОтчетКомитентуОПродажахТовары
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
		|		ПО ОтчетКомитентуОПродажахТовары.Ссылка.УслугаПоВознаграждению = СправочникНоменклатура.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОтчетКомитентуОПродажах КАК ОтчетКомитентуОПродажах
		|		ПО ОтчетКомитентуОПродажахТовары.Ссылка = ОтчетКомитентуОПродажах.Ссылка
		|ГДЕ
		|	ОтчетКомитентуОПродажахТовары.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	СправочникНоменклатура.НаименованиеПолное,
		|	СправочникНоменклатура.ПериодичностьУслуги,
		|	СправочникНоменклатура.Ссылка,
		|	ОтчетКомитентуОПродажах.СтавкаНДСВознаграждения,
		|	ОтчетКомитентуОПродажах.Дата";
		ВыборкаУслуг = Запрос.Выполнить().Выбрать();

		Пока ВыборкаУслуг.Следующий() Цикл
			НоваяСтрока = Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаУслуг);
			НоваяСтрока.Содержание = РаботаСНоменклатуройКлиентСервер.СодержаниеУслуги(
				НоваяСтрока.Содержание,
				ВыборкаУслуг.ПериодичностьУслуги,
				ВыборкаУслуг.Дата);
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.АктОбОказанииПроизводственныхУслуг") Тогда

		// Заполним реквизиты шапки по документу основанию.
		ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);

		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Ссылка", Основание.Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	АктОбОказанииПроизводственныхУслугУслуги.Номенклатура,
		|	СправочникНоменклатура.НаименованиеПолное КАК Содержание,
		|	АктОбОказанииПроизводственныхУслугУслуги.СтавкаНДС,
		|	АктОбОказанииПроизводственныхУслугУслуги.Цена,
		|	СУММА(АктОбОказанииПроизводственныхУслугУслуги.Количество) КАК Количество,
		|	СУММА(АктОбОказанииПроизводственныхУслугУслуги.Сумма) КАК Сумма,
		|	СУММА(АктОбОказанииПроизводственныхУслугУслуги.СуммаНДС) КАК СуммаНДС,
		|	СправочникНоменклатура.ПериодичностьУслуги
		|ИЗ
		|	Документ.АктОбОказанииПроизводственныхУслуг.Услуги КАК АктОбОказанииПроизводственныхУслугУслуги
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
		|		ПО АктОбОказанииПроизводственныхУслугУслуги.Номенклатура = СправочникНоменклатура.Ссылка
		|ГДЕ
		|	АктОбОказанииПроизводственныхУслугУслуги.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	АктОбОказанииПроизводственныхУслугУслуги.Номенклатура,
		|	АктОбОказанииПроизводственныхУслугУслуги.СтавкаНДС,
		|	АктОбОказанииПроизводственныхУслугУслуги.Цена,
		|	СправочникНоменклатура.НаименованиеПолное,
		|	СправочникНоменклатура.ПериодичностьУслуги";
		ВыборкаУслуг = Запрос.Выполнить().Выбрать();

		Пока ВыборкаУслуг.Следующий() Цикл
			НоваяСтрока = Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаУслуг);
			НоваяСтрока.Содержание = РаботаСНоменклатуройКлиентСервер.СодержаниеУслуги(
				НоваяСтрока.Содержание,
				ВыборкаУслуг.ПериодичностьУслуги,
				Основание.Ссылка.Дата);
				
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ПередачаОСВАренду") Тогда

		// Заполним реквизиты шапки по документу основанию.
		ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);

		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Ссылка", Основание.Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА ПередачаОСВАрендуОС.ОсновноеСредство.НаименованиеПолное = """"
		|			ТОГДА ПередачаОСВАрендуОС.ОсновноеСредство.Наименование
		|		ИНАЧЕ ПередачаОСВАрендуОС.ОсновноеСредство.НаименованиеПолное
		|	КОНЕЦ КАК Содержание,
		|	СУММА(1) КАК Количество
		|ИЗ
		|	Документ.ПередачаОСВАренду.ОС КАК ПередачаОСВАрендуОС
		|ГДЕ
		|	ПередачаОСВАрендуОС.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ВЫБОР
		|		КОГДА ПередачаОСВАрендуОС.ОсновноеСредство.НаименованиеПолное = """"
		|			ТОГДА ПередачаОСВАрендуОС.ОсновноеСредство.Наименование
		|		ИНАЧЕ ПередачаОСВАрендуОС.ОсновноеСредство.НаименованиеПолное
		|	КОНЕЦ";
		Выборка = Запрос.Выполнить().Выбрать();

		СтавкаНДС = ?(УчетнаяПолитика.ПлательщикНДС(ЭтотОбъект.Организация, ЭтотОбъект.Дата),
						Перечисления.СтавкиНДС.НДС18, Перечисления.СтавкиНДС.БезНДС);

		Пока Выборка.Следующий() Цикл
			НоваяСтрока = Товары.Добавить();
			НоваяСтрока.Содержание = РаботаСНоменклатуройКлиентСервер.СодержаниеУслуги(
				СтрШаблон(НСтр("ru = 'Арендная плата (%1)'"), Выборка.Содержание),
				Перечисления.Периодичность.Месяц,
				ЭтотОбъект.Дата);
			НоваяСтрока.Количество = Выборка.Количество;
			НоваяСтрока.СтавкаНДС = СтавкаНДС;
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ
//

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	// Проверка табличной части "Возвратная тара"
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьВозвратнуюТару") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВозвратнаяТара.Номенклатура");
		МассивНепроверяемыхРеквизитов.Добавить("ВозвратнаяТара.Количество");
		МассивНепроверяемыхРеквизитов.Добавить("ВозвратнаяТара.Цена");
		МассивНепроверяемыхРеквизитов.Добавить("ВозвратнаяТара.Сумма");
	КонецЕсли;
	
	Если НЕ Справочники.БанковскиеСчета.ИспользуетсяНесколькоБанковскихСчетовОрганизации(ОрганизацияПолучатель) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтруктурнаяЕдиница");
		ПроверкаРеквизитовОрганизации.ОбработкаПроверкиЗаполнения(ОрганизацияПолучатель, СтруктурнаяЕдиница, Ложь, Отказ);
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Номенклатура");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Содержание");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
	
	МассивНоменклатуры = ОбщегоНазначения.ВыгрузитьКолонку(Товары,"Номенклатура", Истина);
	
	ОбщегоНазначенияБПКлиентСервер.УдалитьНеЗаполненныеЭлементыМассива(МассивНоменклатуры);
	
	РеквизитыНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(МассивНоменклатуры, "Услуга");
	
	Если УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДС(ЭтотОбъект) < 0 И СуммаСкидки > 0 Тогда
		
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,"КОРРЕКТНОСТЬ", НСтр("ru = 'Скидка'"), , , 
			НСтр("ru = 'Сумма скидки превышает сумму по документу'"));
		Поле = "СуммаСкидки";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		
	КонецЕсли; 
	
	Для каждого СтрокаТаблицы Из Товары Цикл
		
		Префикс = "Товары[%1].";
		Префикс = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Префикс, Формат(СтрокаТаблицы.НомерСтроки - 1, "ЧН=0; ЧГ="));
		
		ИмяСписка = НСтр("ru = 'Товары'");
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.Номенклатура) 
		   И ПустаяСтрока(СтрокаТаблицы.Содержание) Тогда
		
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Заполнение",
				НСтр("ru = 'Номенклатура'") , СтрокаТаблицы.НомерСтроки, ИмяСписка, ТекстСообщения);
				Поле = Префикс + "Номенклатура";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		
		КонецЕсли;
		
		Всего = СтрокаТаблицы.Сумма + ?(СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
		Если Всего > 0 И СтрокаТаблицы.СуммаСкидки > Всего Тогда
		
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка","КОРРЕКТНОСТЬ", НСтр("ru = 'Скидка'"),
					СтрокаТаблицы.НомерСтроки, ИмяСписка, НСтр("ru = 'Сумма скидки превышает сумму по строке'"));
			Поле = Префикс + "СуммаСкидки";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		
		КонецЕсли; 
		
		ЭтоУслуга = Истина;
		СвойстваНоменклатуры = РеквизитыНоменклатуры[СтрокаТаблицы.Номенклатура];
		Если СвойстваНоменклатуры <> Неопределено Тогда
			ЭтоУслуга = СвойстваНоменклатуры.Услуга;
		КонецЕсли;
			
		Если НЕ ЭтоУслуга И НЕ ЗначениеЗаполнено(СтрокаТаблицы.Количество) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Количество'"),
					СтрокаТаблицы.НомерСтроки, ИмяСписка);
			Поле = Префикс + "Количество";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура")
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура")
		И ДанныеЗаполнения.Свойство("АдресТаблицыНоменклатуры") Тогда
		СуммаВключаетНДС = ДанныеЗаполнения.СуммаВключаетНДС;
		ОбработкаТабличныхЧастей.ЗаполнитьИзТаблицыНоменклатуры(Товары,
			ДанныеЗаполнения.АдресТаблицыНоменклатуры, СуммаВключаетНДС);
	Иначе
		СуммаВключаетНДС = Истина;
	КонецЕсли;
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ЗначениеЗаполнено(СтруктурнаяЕдиница) Тогда
		ОрганизацияПолучатель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктурнаяЕдиница, "Владелец");
	Иначе
		ОрганизацияПолучатель = Организация;
	КонецЕсли;
	
	// Заполним дополнительные условия по умолчанию
	Если ЗначениеЗаполнено(Организация) Тогда
		ДополнительныеУсловия = Организация.ДополнительныеУсловияПоУмолчанию;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если НЕ ЗначениеЗаполнено(СсылочныйИдентификатор) Тогда
		СсылочныйИдентификатор = ИнтеграцияСЯндексКассойБП.СсылочныйИдентификатор();
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьВозвратнуюТару")
		И ВозвратнаяТара.Количество() > 0 Тогда
		ВозвратнаяТара.Очистить();
	КонецЕсли;
	
	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах
	СуммаДокумента = УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДС(ЭтотОбъект);
	
	Если ЗначениеЗаполнено(ОрганизацияПолучатель) И НЕ ЗначениеЗаполнено(СтруктурнаяЕдиница)
		И НЕ Справочники.БанковскиеСчета.ИспользуетсяНесколькоБанковскихСчетовОрганизации(ОрганизацияПолучатель) Тогда
		УчетДенежныхСредствБП.УстановитьБанковскийСчет(СтруктурнаяЕдиница, ОрганизацияПолучатель, ВалютаДокумента, Истина);
	КонецЕсли;
	
	// Если покупатель исполняет обязанности налогового агента, то очистим сумму НДС.
	ВедетсяУчетНДСПоФЗ335         = УчетНДС.ВедетсяУчетНДСПоФЗ335(Дата);
	ПокупательНалоговыйАгентПоНДС = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДоговорКонтрагента, "УчетАгентскогоНДСПокупателем");
	Для каждого СтрокаТаблицы Из ЭтотОбъект.Товары Цикл
		Если ПокупательНалоговыйАгентПоНДС = Истина
			И ВедетсяУчетНДСПоФЗ335 Тогда 
			СтрокаТаблицы.СтавкаНДС = УчетНДСКлиентСервер.СтавкаНДСИсчисляетсяНалоговымАгентом(Дата);
			СтрокаТаблицы.СуммаНДС = 0;
		КонецЕсли;
	КонецЦикла;
	
	РаботаСДоговорамиКонтрагентовБП.ЗаполнитьДоговорПередЗаписью(ЭтотОбъект);
	
	Если ИнтеграцияCRMПовтИсп.ИнтеграцияВИнформационнойБазеВключена() Тогда
		РегистрыСведений.ДокументыИнтеграцииCRM.ДобавитьВДополнительныеСвойстваДанныеДляОтправкиОбъекта(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ИнтеграцияCRMПовтИсп.ИнтеграцияВИнформационнойБазеВключена() Тогда
		РегистрыСведений.ДокументыИнтеграцииCRM.ПроверитьИзмененияИЗарегистрироватьКОтправке(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	
	СтруктураКурсаВзаиморасчетов = РаботаСКурсамиВалют.ПолучитьКурсВалюты(
	ВалютаДокумента, Дата);
	
	ОтветственныеЛицаБП.УстановитьОтветственныхЛиц(ЭтотОбъект);
	
	КурсВзаиморасчетов      = СтруктураКурсаВзаиморасчетов.Курс;
	КратностьВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Кратность;
	
	РаботаСНоменклатурой.ОбновитьСодержаниеУслуг(Товары, Дата);
	
	СсылочныйИдентификатор = "";
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Необходимо проверить, есть ли запись с документом в служебном регистре ДанныеМонитораРуководителя.
	// Если записи есть, необходимо очистить весь раздел данных монитора руководителя.
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеМонитораРуководителя.Организация
	|ИЗ
	|	РегистрСведений.ДанныеМонитораРуководителя КАК ДанныеМонитораРуководителя
	|ГДЕ
	|	ДанныеМонитораРуководителя.ДанныеРасшифровки = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Набор = РегистрыСведений.ДанныеМонитораРуководителя.СоздатьНаборЗаписей();
		
		Набор.Отбор.Организация.Установить(Организация);
		Набор.Отбор.РазделМонитора.Установить(Перечисления.РазделыМонитораРуководителя.НеоплаченныеСчетаПокупателям);
		
		Набор.Записать();
		
	КонецЕсли;
	
	// Очистим служебные регистры интеграции.
	Если ИнтеграцияCRMПовтИсп.ИнтеграцияВИнформационнойБазеВключена() Тогда
		СостояниеИнтеграции = РегистрыСведений.ДокументыИнтеграцииCRM.СостояниеИнтеграцииДокумента(Ссылка);
		Если СостояниеИнтеграции <> Неопределено Тогда
			ИнтеграцияОбъектовОбластейДанных.УдалитьОбъектКОтправке(
				СостояниеИнтеграции.НастройкаИнтеграции,
				СостояниеИнтеграции.Идентификатор);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
