﻿Функция НовыйЦеныНоменклатуры()
	
	МетаданныеЦеныНоменклатуры = Метаданные.РегистрыСведений.ЦеныНоменклатуры;
	МетаданныеКурсыВалют       = Метаданные.РегистрыСведений.КурсыВалют;
	
	ЦеныНоменклатуры = Новый ТаблицаЗначений;
	ЦеныНоменклатуры.Колонки.Добавить("Номенклатура",    МетаданныеЦеныНоменклатуры.Измерения.Номенклатура.Тип);
	ЦеныНоменклатуры.Колонки.Добавить("Цена",            МетаданныеЦеныНоменклатуры.Ресурсы.Цена.Тип);
	ЦеныНоменклатуры.Колонки.Добавить("Валюта",          МетаданныеЦеныНоменклатуры.Ресурсы.Валюта.Тип);
	ЦеныНоменклатуры.Колонки.Добавить("Курс",            МетаданныеКурсыВалют.Ресурсы.Курс.Тип);
	ЦеныНоменклатуры.Колонки.Добавить("Кратность",       МетаданныеКурсыВалют.Ресурсы.Кратность.Тип);
	ЦеныНоменклатуры.Колонки.Добавить("ЦенаВключаетНДС", Новый ОписаниеТипов("Булево"));
	
	ЦеныНоменклатуры.Индексы.Добавить("Номенклатура");
	
	Возврат ЦеныНоменклатуры;
	
КонецФункции


// Функция возвращает цену компании для требуемой номенклатуры в указанном типе цен , 
// на заданную дату, за заданную единицу измерения, пересчитанную в требуемую валюту по заданному курсу.
//
// Параметры: 
//  Номенклатура         - ссылка на элемент справочника "Номенклатура", для которого надо получить цену,
//  ТипЦен               - ссылка на элемент справочника "Типы цен", определяет цену какого типа надо получить,
//  Дата                 - дата, на которую надо получить цену, если не заполнено, то берется рабочая дата
//  ЕдиницаИзмерения     - ссылка на элемент справочника "Единицы измерения", определяет для какой единицы надо получить 
//                         цену, если не заполнен, то заполняется единицей цены
//  Валюта               - ссылка на элемент справочника "Валюты", определяет валюту. в которой надо вернуть цену,
//                         если не заполнен, то заполняется валютой цены
//  Курс                 - число, курс требуемой валюты, если не заполнен, берется курс из регистра 
//                         сведений "Курсы валют",
//  Кратность            - число, кратность требуемой валюты, если не заполнена, берется курс из регистра 
//                         сведений "Курсы валют",
//
// Возвращаемое значение:
//  Число, рассчитанное значение цены.
//
Функция ПолучитьЦенуНоменклатуры(Номенклатура, ТипЦен, Дата, Валюта = Неопределено, Курс = 0, Кратность = 1) Экспорт
	
	ПолученнаяЦена = 0;
	
	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ЦеныНоменклатуры) Тогда
		Возврат ПолученнаяЦена;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата",         Дата);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("ТипЦен",       ТипЦен);
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЦеныНоменклатуры.Цена,
	|	ЦеныНоменклатуры.Валюта
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&Дата, Номенклатура = &Номенклатура И ТипЦен = &ТипЦен) КАК ЦеныНоменклатуры";

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ПолученнаяЦена = Выборка.Цена;
		ВалютаЦены     = Выборка.Валюта;
	КонецЕсли;

	Если НЕ (ВалютаЦены = Валюта) И НЕ (Валюта = Неопределено) И НЕ (ВалютаЦены = Неопределено) Тогда

		СтруктураКурсаЦены = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаЦены, Дата);
		ПолученнаяЦена     = РаботаСКурсамиВалютБПКлиентСервер.ПересчитатьИзВалютыВВалюту(
			ПолученнаяЦена, ВалютаЦены, Валюта, 
		    СтруктураКурсаЦены.Курс, Курс, 
		    СтруктураКурсаЦены.Кратность, Кратность);
			
		ПолученнаяЦена     = ОкруглитьЦену(ПолученнаяЦена, ТипЦен);

	ИначеЕсли Валюта = Неопределено Тогда
		Валюта = ВалютаЦены;
	КонецЕсли;

	Возврат ПолученнаяЦена;

КонецФункции // ПолучитьЦенуНоменклатуры()

Функция ПолучитьЦенуПоДокументам(Номенклатура, СпособЗаполненияЦены, Дата, Валюта = Неопределено, Курс = 0, Кратность = 1) Экспорт
	
	ОписаниеЦены = Новый Структура;
	ОписаниеЦены.Вставить("Цена",            0);
	ОписаниеЦены.Вставить("ЦенаВключаетНДС", Ложь);
	
	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ЦеныНоменклатурыДокументов) Тогда
		Возврат ОписаниеЦены;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Номенклатура",     	  Номенклатура);
	Запрос.УстановитьПараметр("СпособЗаполненияЦены", СпособЗаполненияЦены);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЦеныНоменклатурыДокументов.Цена КАК Цена,
	|	ЦеныНоменклатурыДокументов.Валюта КАК Валюта,
	|	ЦеныНоменклатурыДокументов.ЦенаВключаетНДС КАК ЦенаВключаетНДС
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатурыДокументов КАК ЦеныНоменклатурыДокументов
	|ГДЕ
	|	ЦеныНоменклатурыДокументов.Номенклатура = &Номенклатура
	|	И ЦеныНоменклатурыДокументов.СпособЗаполненияЦены = &СпособЗаполненияЦены";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Не Выборка.Следующий() Тогда
		Возврат ОписаниеЦены;
	КонецЕсли;
	
	ОписаниеЦены.Цена            = Выборка.Цена;
	ОписаниеЦены.ЦенаВключаетНДС = Выборка.ЦенаВключаетНДС;
	
	ВалютаЦены = Выборка.Валюта;
	
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		
		// Вернем валюту, в которой выражена цена
		Валюта = ВалютаЦены;
		
	ИначеЕсли ВалютаЦены <> Валюта И ЗначениеЗаполнено(ВалютаЦены) Тогда
		
		// Пересчитаем в переданную валюту
		
		СтруктураКурсаЦены = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаЦены, Дата);
		ОписаниеЦены.Цена = РаботаСКурсамиВалютБПКлиентСервер.ПересчитатьИзВалютыВВалюту(
			ОписаниеЦены.Цена,
			ВалютаЦены,                   Валюта,
			СтруктураКурсаЦены.Курс,      Курс,
			СтруктураКурсаЦены.Кратность, Кратность);
		
	КонецЕсли;
	
	Возврат ОписаниеЦены;
	
КонецФункции

// Возвращает таблицу цен номенклатуры
//
// Параметры:
//  МассивНоменклатуры - массив номенклатуры
//  ТипЦен             - тип цен
//  Дата               - дата цен
//
// Возвращаемое значение:
//  Таблица значений, содержащая цены, валюты цен и курсы валют на переданную дату
//
Функция ПолучитьТаблицуЦенНоменклатуры(МассивНоменклатуры, ТипЦен, Дата) Экспорт
	
	ЦеныНоменклатуры = НовыйЦеныНоменклатуры();
	
	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ЦеныНоменклатуры) Тогда
		Возврат ЦеныНоменклатуры;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период",				Дата);
	Запрос.УстановитьПараметр("ТипЦен",				ТипЦен);
	Запрос.УстановитьПараметр("МассивНоменклатуры",	МассивНоменклатуры);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЦеныНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
	|	ЦеныНоменклатурыСрезПоследних.Цена КАК Цена,
	|	ЦеныНоменклатурыСрезПоследних.Валюта КАК Валюта,
	|	ЦеныНоменклатурыСрезПоследних.ТипЦен
	|ПОМЕСТИТЬ ЦеныНоменклатуры
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	|			&Период,
	|			ТипЦен = &ТипЦен
	|				И Номенклатура В (&МассивНоменклатуры)) КАК ЦеныНоменклатурыСрезПоследних
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Валюта
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КурсыВалютСрезПоследних.Валюта КАК Валюта,
	|	КурсыВалютСрезПоследних.Курс КАК Курс,
	|	КурсыВалютСрезПоследних.Кратность КАК Кратность
	|ПОМЕСТИТЬ КурсыВалют
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&Период) КАК КурсыВалютСрезПоследних
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Валюта
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЦеныНоменклатуры.Номенклатура КАК Номенклатура,
	|	ЦеныНоменклатуры.Цена КАК Цена,
	|	ЦеныНоменклатуры.Валюта КАК Валюта,
	|	ЕСТЬNULL(КурсыВалют.Курс, 1) КАК Курс,
	|	ЕСТЬNULL(КурсыВалют.Кратность, 1) КАК Кратность,
	|	ТипыЦенНоменклатуры.ЦенаВключаетНДС
	|ИЗ
	|	ЦеныНоменклатуры КАК ЦеныНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК КурсыВалют
	|		ПО ЦеныНоменклатуры.Валюта = КурсыВалют.Валюта
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТипыЦенНоменклатуры КАК ТипыЦенНоменклатуры
	|		ПО ЦеныНоменклатуры.ТипЦен = ТипыЦенНоменклатуры.Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(ЦеныНоменклатуры.Добавить(), Выборка);
	КонецЦикла;
	
	Возврат ЦеныНоменклатуры;
	
КонецФункции

Функция ПолучитьТаблицуЦенНоменклатурыДокументов(МассивНоменклатуры, СпособЗаполненияЦены, Дата) Экспорт
	
	ЦеныНоменклатуры = НовыйЦеныНоменклатуры();
	
	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ЦеныНоменклатурыДокументов) Тогда
		Возврат ЦеныНоменклатуры;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период",					Дата);	
	Запрос.УстановитьПараметр("СпособЗаполненияЦены",	СпособЗаполненияЦены);
	Запрос.УстановитьПараметр("МассивНоменклатуры",		МассивНоменклатуры);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЦеныНоменклатурыДокументов.Номенклатура КАК Номенклатура,
	|	ЦеныНоменклатурыДокументов.Цена КАК Цена,
	|	ЦеныНоменклатурыДокументов.Валюта КАК Валюта,
	|	ЦеныНоменклатурыДокументов.ЦенаВключаетНДС
	|ПОМЕСТИТЬ ЦеныНоменклатуры
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатурыДокументов КАК ЦеныНоменклатурыДокументов
	|ГДЕ
	|	ЦеныНоменклатурыДокументов.Номенклатура В(&МассивНоменклатуры)
	|	И ЦеныНоменклатурыДокументов.СпособЗаполненияЦены = &СпособЗаполненияЦены
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Валюта
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КурсыВалютСрезПоследних.Валюта КАК Валюта,
	|	КурсыВалютСрезПоследних.Курс КАК Курс,
	|	КурсыВалютСрезПоследних.Кратность КАК Кратность
	|ПОМЕСТИТЬ КурсыВалют
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&Период, ) КАК КурсыВалютСрезПоследних
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Валюта
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЦеныНоменклатуры.Номенклатура КАК Номенклатура,
	|	ЦеныНоменклатуры.Цена КАК Цена,
	|	ЦеныНоменклатуры.Валюта КАК Валюта,
	|	ЕСТЬNULL(КурсыВалют.Курс, 1) КАК Курс,
	|	ЕСТЬNULL(КурсыВалют.Кратность, 1) КАК Кратность,
	|	ЦеныНоменклатуры.ЦенаВключаетНДС
	|ИЗ
	|	ЦеныНоменклатуры КАК ЦеныНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК КурсыВалют
	|		ПО ЦеныНоменклатуры.Валюта = КурсыВалют.Валюта";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(ЦеныНоменклатуры.Добавить(), Выборка);
	КонецЦикла;
	
	Возврат ЦеныНоменклатуры;
	
КонецФункции

Процедура ОбновитьЦеныНоменклатуры(ДокументСсылка, СпособЗаполненияЦены, Валюта = Неопределено, СуммаВключаетНДС = Ложь) Экспорт	
	
	Если Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ЦеныНоменклатурыДокументов) Тогда
		Возврат;
	КонецЕсли;
	
	Если Константы.НастройкаЗаполненияЦеныПродажи.Получить() = Перечисления.НастройкаЗаполненияЦеныПродажи.Номенклатура Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Валюта) Тогда 
		Валюта = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	КонецЕсли;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("СпособЗаполненияЦены", СпособЗаполненияЦены);
	Запрос.УстановитьПараметр("ЦенаВключаетНДС",	  СуммаВключаетНДС);
	Запрос.УстановитьПараметр("Валюта",				  Валюта);
	Запрос.УстановитьПараметр("Ссылка",				  ДокументСсылка);
	
	Запрос.Текст = Документы[ДокументСсылка.Метаданные().Имя].ТекстЗапросаДанныеДляОбновленияЦенДокументов()
	+ "ВЫБРАТЬ
	  |	ТаблицаНоменклатуры.Номенклатура,
	  |	МАКСИМУМ(ТаблицаНоменклатуры.Цена) КАК Цена,
	  |	ТаблицаНоменклатуры.Валюта,
	  |	ТаблицаНоменклатуры.СпособЗаполненияЦены,
	  |	ТаблицаНоменклатуры.ЦенаВключаетНДС
	  |ПОМЕСТИТЬ ТаблицаНоменклатурыСМаксимальнойЦеной
	  |ИЗ
	  |	ТаблицаНоменклатуры КАК ТаблицаНоменклатуры
	  |
	  |СГРУППИРОВАТЬ ПО
	  |	ТаблицаНоменклатуры.Номенклатура,
	  |	ТаблицаНоменклатуры.Валюта,
	  |	ТаблицаНоменклатуры.СпособЗаполненияЦены,
	  |	ТаблицаНоменклатуры.ЦенаВключаетНДС
	  |;
	  |
	  |////////////////////////////////////////////////////////////////////////////////
	  |ВЫБРАТЬ
	  |	ТаблицаНоменклатурыСМаксимальнойЦеной.Номенклатура,
	  |	ТаблицаНоменклатурыСМаксимальнойЦеной.Цена КАК Цена,
	  |	ТаблицаНоменклатурыСМаксимальнойЦеной.Валюта,
	  |	ТаблицаНоменклатурыСМаксимальнойЦеной.СпособЗаполненияЦены КАК СпособЗаполненияЦены,
	  |	ТаблицаНоменклатурыСМаксимальнойЦеной.ЦенаВключаетНДС
	  |ИЗ
	  |	ТаблицаНоменклатурыСМаксимальнойЦеной КАК ТаблицаНоменклатурыСМаксимальнойЦеной
	  |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыДокументов КАК ЦеныНоменклатурыДокументов
	  |		ПО ТаблицаНоменклатурыСМаксимальнойЦеной.Номенклатура = ЦеныНоменклатурыДокументов.Номенклатура
	  |			И ТаблицаНоменклатурыСМаксимальнойЦеной.Валюта = ЦеныНоменклатурыДокументов.Валюта
	  |			И ТаблицаНоменклатурыСМаксимальнойЦеной.СпособЗаполненияЦены = ЦеныНоменклатурыДокументов.СпособЗаполненияЦены
	  |			И ТаблицаНоменклатурыСМаксимальнойЦеной.ЦенаВключаетНДС = ЦеныНоменклатурыДокументов.ЦенаВключаетНДС
	  |ГДЕ
	  |	ТаблицаНоменклатурыСМаксимальнойЦеной.Цена <> ЕСТЬNULL(ЦеныНоменклатурыДокументов.Цена, 0)
	  |	И ТаблицаНоменклатурыСМаксимальнойЦеной.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)";
	
	ТаблицаЦенНоменклатуры = Запрос.Выполнить().Выгрузить();
	
	Если ТаблицаЦенНоменклатуры.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЦеныНоменклатурыДокументов");
	ЭлементБлокировки.УстановитьЗначение("СпособЗаполненияЦены", СпособЗаполненияЦены);
	ЭлементБлокировки.ИсточникДанных = ТаблицаЦенНоменклатуры;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Номенклатура", "Номенклатура");
	Блокировка.Заблокировать();
	
	Попытка
		
		Для Каждого Стр Из ТаблицаЦенНоменклатуры Цикл
			
			МенеджерЗаписи = РегистрыСведений.ЦеныНоменклатурыДокументов.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Стр);
			МенеджерЗаписи.Записать();
			
		КонецЦикла;			
		ЗафиксироватьТранзакцию();
		
	Исключение
		//Обновленные данные о ценах записываюся полностью по документу или не записываются вообще.
		ОтменитьТранзакцию();
	КонецПопытки;
	
КонецПроцедуры

// Округляет число по заданному порядку. Если задано (=Истина) "ОкруглятьВБольшуюСторону",
// то число 123.37 при порядке округление 0.5 превратиться в 123.50, а число 0.1 
// при порядке округления 5 станет равным 5.
//
// Параметры:
//  Число                    - исходное число
//  ПорядокОкругления        - элемент перечисления Порядки окгугления: 
//                             "шаг" округления (0.01 (арифметическое), 0.01, 0.05, 0.1, 0.5, 1, 5, 10, 50, 100)
//  ОкруглятьВБольшуюСторону - булево, определяет способ округления: если Истина, 
//                             то при порядке округления "5" 0.01 будет округлена до 5, 
//                             Ложь - округление по арифметическим правилам
//
// Возвращаемое значение:
//  Округленное по заданному порядку значение
//
Функция ОкруглитьЦену(Число, ТипЦен) Экспорт

	Перем Результат;
	
	Если ЗначениеЗаполнено(ТипЦен) Тогда
		РеквизитыТипаЦен 			= ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ТипЦен, "ПорядокОкругления, ОкруглятьВБольшуюСторону");
		ПараметрПорядокОкругления 	= РеквизитыТипаЦен.ПорядокОкругления;
		ОкруглятьВБольшуюСторону 	= РеквизитыТипаЦен.ОкруглятьВБольшуюСторону;
	Иначе
		Возврат Число;
	КонецЕсли;

	// Преобразуем порядок округления числа.
	// Если передали пустое значение порядка, то округлим до копеек. 
	Если НЕ ЗначениеЗаполнено(ПараметрПорядокОкругления) Тогда
		ПорядокОкругления = Перечисления.ПорядкиОкругления.Окр0_01; 
	Иначе
		ПорядокОкругления = ПараметрПорядокОкругления;
	КонецЕсли;

	Порядок = Число(Строка(ПорядокОкругления));
		
	// вычислим количество интервалов, входящих в число
	КоличествоИнтервал	= Число / Порядок;
		
	// вычислим целое количество интервалов.
	КоличествоЦелыхИнтервалов = Цел(КоличествоИнтервал);
		
	Если КоличествоИнтервал = КоличествоЦелыхИнтервалов Тогда
		
		// Числа поделились нацело. Округлять не нужно.
		Результат	= Число;
	Иначе
		Если ОкруглятьВБольшуюСторону Тогда
			
			// При порядке округления "0.05" 0.371 должно округлитья до 0.4
			Результат = Порядок * (КоличествоЦелыхИнтервалов + 1);
		Иначе

			// При порядке округления "0.05" 0.371 должно округлитья до 0.35,
			// а 0.376 до 0.4
			Результат = Порядок * Окр(КоличествоИнтервал,0,РежимОкругления.Окр15как20);
		КонецЕсли; 
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции // ОкруглитьЦену()

////////////////////////////////////////////////////////////////////////////////
// Работа с формой цен и валют.

// Позволяет получить список реквизитов документа, необходимых для дальнейшей
// передачи в обработку заполнения цен и валют.
//
// Параметры: 
//  ДокументОбъект      - объект документа, для реквизитов будет производится заполнение
//  СтруктураИсключений - структура, в которую передаются те исключения, которые или невозможно
//                        определить по метаданным, или, несмотря ни на что, нельзя включать в
//                        возвращаемую структуру.
//                        В структуре - ключ = имя реквизита, значение = истина (необходимо добавить
//                        в структуру) или ложь (нельзя добавлять в структуру)
//
// Возвращаемое значение:
//  Сформированная структура реквизитов документа.
//
Функция ПолучитьСтруктуруРеквизитовДокументаДляЦенообразования(ДокументОбъект, СтруктураИсключений = Неопределено) Экспорт

	МетаданныеДокумента = ДокументОбъект.Метаданные();

	// Зададим, какие реквизиты вообще нам могут быть нужны
	СтруктураВозможныхВариантовРеквизитов = Новый Структура();
	СтруктураВозможныхВариантовРеквизитов.Вставить("ТипЦен");
	СтруктураВозможныхВариантовРеквизитов.Вставить("ВалютаДокумента");
	СтруктураВозможныхВариантовРеквизитов.Вставить("КурсДокумента");
	СтруктураВозможныхВариантовРеквизитов.Вставить("КратностьДокумента");
	СтруктураВозможныхВариантовРеквизитов.Вставить("КурсВзаиморасчетов");
	СтруктураВозможныхВариантовРеквизитов.Вставить("КратностьВзаиморасчетов");
	СтруктураВозможныхВариантовРеквизитов.Вставить("СуммаВключаетНДС");

	// Зададим, какие реквизиты надо редактировать.
	СтруктураРеквизитовДокумента = Новый Структура();
	Для Каждого ТекущийЭлементСтруктуры Из СтруктураВозможныхВариантовРеквизитов Цикл
		НужныйРеквизитДокумента = ТекущийЭлементСтруктуры.Ключ;
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта(НужныйРеквизитДокумента, МетаданныеДокумента) Тогда
			СтруктураРеквизитовДокумента.Вставить(НужныйРеквизитДокумента);
		КонецЕсли;
	КонецЦикла;

	// теперь проверим исключения
	Если СтруктураИсключений<>Неопределено Тогда
		Для Каждого ТекущийЭлементСтруктуры Из СтруктураИсключений Цикл
			Если ТекущийЭлементСтруктуры.Значение Тогда
				// надо добавить реквизит, если его еще нет
				СтруктураРеквизитовДокумента.Вставить(ТекущийЭлементСтруктуры.Ключ);
			Иначе
				// надо удалить реквизит, если он есть
				СтруктураРеквизитовДокумента.Удалить(ТекущийЭлементСтруктуры.Ключ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Возврат СтруктураРеквизитовДокумента;

КонецФункции

// В строке табличной части заполняется плановая себестоимость номенклатуры.
//
// Параметры: 
//  СтрокаТЧ - строка табличной части, в которой надо заполнить плановую себестоимость;
//  Дата     - дата, на которую надо получить плановую себестоимость.
//
Процедура ЗаполнитьПлановуюСебестоимость(СтрокаТЧ, Дата) Экспорт

	ТипЦенПлановойСебестоимости    = Константы.ТипЦенПлановойСебестоимостиНоменклатуры.Получить();
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();

	Если ЗначениеЗаполнено(ТипЦенПлановойСебестоимости) Тогда
		СтрокаТЧ.ПлановаяСтоимость = ПолучитьЦенуНоменклатуры(
			СтрокаТЧ.Номенклатура,
			ТипЦенПлановойСебестоимости, Дата,
			ВалютаРегламентированногоУчета, 1);
	Иначе
		СтрокаТЧ.ПлановаяСтоимость = 0;	
	КонецЕсли;

КонецПроцедуры


#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьТаблицуЦенНоменклатурыПродажаИПокупка(МассивНоменклатуры, Дата) Экспорт
	
	ЦеныНоменклатуры = НовыйЦеныНоменклатуры();
	
	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ЦеныНоменклатурыДокументов) Тогда
		Возврат ЦеныНоменклатуры;
	КонецЕсли;
	
	// В первую очередь смотрим есть ли цены продажи, если цен продажи нет, то смотри цену покупки.
	ЦеныНоменклатуры = ТаблицаЦенПродажиИПокупки(
		Дата, МассивНоменклатуры, ЦеныНоменклатуры);
		
	Возврат ЦеныНоменклатуры;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТаблицаЦенПродажиИПокупки(
		Дата, МассивНоменклатуры, ЦеныНоменклатуры)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период",             Дата);
	Запрос.УстановитьПараметр("МассивНоменклатуры", МассивНоменклатуры);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЦеныНоменклатурыДокументов.Номенклатура КАК Номенклатура,
	|	ЦеныНоменклатурыДокументов.Цена КАК Цена,
	|	ЦеныНоменклатурыДокументов.Валюта КАК Валюта,
	|	ЦеныНоменклатурыДокументов.ЦенаВключаетНДС КАК ЦенаВключаетНДС
	|ПОМЕСТИТЬ ЦеныНоменклатурыПродажи
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатурыДокументов КАК ЦеныНоменклатурыДокументов
	|ГДЕ
	|	ЦеныНоменклатурыДокументов.Номенклатура В(&МассивНоменклатуры)
	|	И ЦеныНоменклатурыДокументов.СпособЗаполненияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаполненияЦен.ПоПродажнымЦенам)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЦеныНоменклатурыДокументов.Номенклатура КАК Номенклатура,
	|	ЦеныНоменклатурыДокументов.Цена КАК Цена,
	|	ЦеныНоменклатурыДокументов.Валюта КАК Валюта,
	|	ЦеныНоменклатурыДокументов.ЦенаВключаетНДС КАК ЦенаВключаетНДС
	|ПОМЕСТИТЬ ЦеныНоменклатурыПокупки
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатурыДокументов КАК ЦеныНоменклатурыДокументов
	|ГДЕ
	|	ЦеныНоменклатурыДокументов.Номенклатура В(&МассивНоменклатуры)
	|	И ЦеныНоменклатурыДокументов.СпособЗаполненияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаполненияЦен.ПоЗакупочнымЦенам)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЦеныНоменклатурыПокупки.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ ТаблицаНоменклатурыДетальная
	|ИЗ
	|	ЦеныНоменклатурыПокупки КАК ЦеныНоменклатурыПокупки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЦеныНоменклатурыПродажи.Номенклатура
	|ИЗ
	|	ЦеныНоменклатурыПродажи КАК ЦеныНоменклатурыПродажи
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаНоменклатурыДетальная.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ ТаблицаНоменклатуры
	|ИЗ
	|	ТаблицаНоменклатурыДетальная КАК ТаблицаНоменклатурыДетальная
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаНоменклатурыДетальная.Номенклатура
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаНоменклатуры.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА НЕ ЕСТЬNULL(ЦеныНоменклатурыПродажи.Номенклатура, 0) = 0
	|			ТОГДА ЦеныНоменклатурыПродажи.Цена
	|		ИНАЧЕ ЦеныНоменклатурыПокупки.Цена
	|	КОНЕЦ КАК Цена,
	|	ВЫБОР
	|		КОГДА НЕ ЕСТЬNULL(ЦеныНоменклатурыПродажи.Номенклатура, 0) = 0
	|			ТОГДА ЦеныНоменклатурыПродажи.Валюта
	|		ИНАЧЕ ЦеныНоменклатурыПокупки.Валюта
	|	КОНЕЦ КАК Валюта,
	|	ВЫБОР
	|		КОГДА НЕ ЕСТЬNULL(ЦеныНоменклатурыПродажи.Номенклатура, 0) = 0
	|			ТОГДА ЦеныНоменклатурыПродажи.ЦенаВключаетНДС
	|		ИНАЧЕ ЦеныНоменклатурыПокупки.ЦенаВключаетНДС
	|	КОНЕЦ КАК ЦенаВключаетНДС
	|ПОМЕСТИТЬ ЦеныНоменклатуры
	|ИЗ
	|	ТаблицаНоменклатуры КАК ТаблицаНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ ЦеныНоменклатурыПокупки КАК ЦеныНоменклатурыПокупки
	|		ПО ТаблицаНоменклатуры.Номенклатура = ЦеныНоменклатурыПокупки.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ ЦеныНоменклатурыПродажи КАК ЦеныНоменклатурыПродажи
	|		ПО ТаблицаНоменклатуры.Номенклатура = ЦеныНоменклатурыПродажи.Номенклатура
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Валюта
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КурсыВалютСрезПоследних.Валюта КАК Валюта,
	|	КурсыВалютСрезПоследних.Курс КАК Курс,
	|	КурсыВалютСрезПоследних.Кратность КАК Кратность
	|ПОМЕСТИТЬ КурсыВалют
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&Период, ) КАК КурсыВалютСрезПоследних
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Валюта
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЦеныНоменклатуры.Номенклатура КАК Номенклатура,
	|	ЦеныНоменклатуры.Валюта КАК Валюта,
	|	ЕСТЬNULL(КурсыВалют.Курс, 1) КАК Курс,
	|	ЕСТЬNULL(КурсыВалют.Кратность, 1) КАК Кратность,
	|	ЦеныНоменклатуры.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	|	ЦеныНоменклатуры.Цена КАК Цена
	|ИЗ
	|	ЦеныНоменклатуры КАК ЦеныНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК КурсыВалют
	|		ПО ЦеныНоменклатуры.Валюта = КурсыВалют.Валюта";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ЦеныНоменклатуры.Добавить(), Выборка);
	КонецЦикла;

	Возврат ЦеныНоменклатуры;

КонецФункции

#КонецОбласти


