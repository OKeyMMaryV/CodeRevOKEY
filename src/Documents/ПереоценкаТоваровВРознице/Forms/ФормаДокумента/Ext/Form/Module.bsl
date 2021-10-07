﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;

	УстановитьУсловноеОформление();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНоменклатуры.Форма.Форма" Тогда
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, ИсточникВыбора.ИмяТаблицы);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "ПроведениеПереоценкаТоваровВРознице";
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)

	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;

	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата, 
		ТекущаяДатаДокумента);
		
	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		УстановитьФункциональныеОпцииФормы();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ПроверитьВозможностьПереоценки();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		УстановитьФункциональныеОпцииФормы();
		ПроверитьВозможностьПереоценки();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	СведенияОСкладе = СведенияОСкладе(Объект.Склад);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СведенияОСкладе);
	
	Если ТипСклада = ПредопределенноеЗначение("Перечисление.ТипыСкладов.НеавтоматизированнаяТорговаяТочка") Тогда
		ТекстВопроса     = НСтр("ru = 'Свернуть табличную часть по номенклатуре?'");
		ЗаголовокВопроса = НСтр("ru = 'Свертка по номенклатуре'");
		Оповещение		 = Новый ОписаниеОповещения("ВопросСвернутьТабличнуюЧастьЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,, ЗаголовокВопроса);
	Иначе
		ТоварыСвернуты = Ложь;
		УправлениеФормой(ЭтаФорма);
	КонецЕсли;
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Товары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)

	ПриИзмененииНоменклатурыСервер();

КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Идентификатор = Элементы.Товары.ТекущаяСтрока;

	//Услуг в этом документе быть не должно.
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда

		Услуга = ПроверитьЧтоНоменклатураУслуга(ВыбранноеЗначение);
		Если Услуга Тогда
			ТекстПричина   = НСтр("ru = 'Услуг в этом документе быть не должно.'");
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Корректность",
				НСтр("ru = 'Номенклатура'"), Идентификатор + 1,
				НСтр("ru = 'Товары'"), ТекстПричина);

			Префикс = "Товары[" + Формат(Идентификатор, "ЧН=0; ЧГ=") + "].";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ,
				Префикс + "Номенклатура", "Объект", СтандартнаяОбработка);
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	РассчитатьСуммуПереоценки(ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаВРозницеСтараяПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	РассчитатьСуммуПереоценки(ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаВРозницеПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	РассчитатьСуммуПереоценки(ТекущиеДанные);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПодборТовары(Команда)

	ПараметрыПодбора = ПолучитьПараметрыПодбора("Товары");
	Если ПараметрыПодбора <> Неопределено Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.Форма", ПараметрыПодбора,
			ЭтаФорма, УникальныйИдентификатор);
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();


	// ТоварыНоменклатура, ТоварыКоличество, ТоварыЦенаВРозницеСтарая, ТоварыЦенаВРознице

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыНоменклатура");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыКоличество");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыЦенаВРозницеСтарая");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыЦенаВРознице");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ТипСклада", ВидСравненияКомпоновкиДанных.Равно, Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);


	// ТоварыСтавкаНДСВРознице

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыСтавкаНДСВРознице");

	ГруппаОтбора1 = КомпоновкаДанныхКлиентСервер.ДобавитьГруппуОтбора(ЭлементУО.Отбор.Элементы, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора1,
			"РазделятьПоСтавкамНДС", ВидСравненияКомпоновкиДанных.Равно, Ложь);

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора1,
			"ТипСклада", ВидСравненияКомпоновкиДанных.НеРавно, Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);


	// ТоварыСуммаПереоценки

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыСуммаПереоценки");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ТипСклада", ВидСравненияКомпоновкиДанных.НеРавно, Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);


	// Учет ведется общими суммами без отображения конкретной номенклатуры.

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыНоменклатураКод");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыНоменклатураАртикул");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыНоменклатура");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыКоличество");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыЦенаВРозницеСтарая");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыЦенаВРознице");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ТоварыСвернуты", ВидСравненияКомпоновкиДанных.Равно, Истина);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	УстановитьСостояниеДокумента();

	ТекущаяДатаДокумента = Объект.Дата;
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	СведенияОСкладе = СведенияОСкладе(Объект.Склад);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СведенияОСкладе);
	
	СчетУчетаТоваровВНТТ = ПланыСчетов.Хозрасчетный.ТоварыВРозничнойТорговлеВПродажныхЦенахНТТ;
	СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СчетУчетаТоваровВНТТ);
	
	СубконтоСтавкиНДС = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтавкиНДС;
	РазделятьПоСтавкамНДС = (СвойстваСчета.ВидСубконто1 = СубконтоСтавкиНДС
		ИЛИ СвойстваСчета.ВидСубконто2 = СубконтоСтавкиНДС
		ИЛИ СвойстваСчета.ВидСубконто3 = СубконтоСтавкиНДС);
	
	Если ТипСклада = Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка
		И Объект.Товары.Количество() > 0 Тогда
		
		ТоварыСвернуты	= Истина;
		Для каждого СтрокаТовары Из Объект.Товары Цикл
			Если ЗначениеЗаполнено(СтрокаТовары.Номенклатура) Тогда
				ТоварыСвернуты	= Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		ТоварыСвернуты	= Ложь;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
	ПоСтоимостиПриобретения = УчетнаяПолитика.СпособОценкиТоваровВРознице(Объект.Организация, Объект.Дата) 
		<> Перечисления.СпособыОценкиТоваровВРознице.ПоПродажнойСтоимости;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Элементы.ДокументУстановкиЦен.Доступность = 
		(Форма.ТипСклада <> ПредопределенноеЗначение("Перечисление.ТипыСкладов.НеавтоматизированнаяТорговаяТочка"));
	
	Элементы.ПодборТовары.Доступность        = НЕ Форма.ТоварыСвернуты;
	Элементы.ЗаполнитьПоОстаткам.Доступность = НЕ Форма.ТоварыСвернуты;
	Элементы.ЗаполнитьПоЦенам.Доступность    = НЕ Форма.ТоварыСвернуты;

КонецПроцедуры

&НаСервере
Процедура ПриИзмененииСкладаНТТСервер()
	
	Перем СоответствиеСведенийОНоменклатуре;
	
	Если РазделятьПоСтавкамНДС Тогда
		
		ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
		ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
		
		СоответствиеСведенийОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОСпискеНоменклатуры(
			ОбщегоНазначения.ВыгрузитьКолонку(Объект.Товары, "Номенклатура", Истина), ДанныеОбъекта);
		
	КонецЕсли;
	
	Для каждого Строка Из Объект.Товары Цикл
		
		Если Строка.СуммаПереоценки = 0 Тогда
			Строка.СуммаПереоценки = Строка.Количество * (Строка.ЦенаВРознице - Строка.ЦенаВРозницеСтарая);
		КонецЕсли;
		
		Если РазделятьПоСтавкамНДС
			И НЕ ЗначениеЗаполнено(Строка.СтавкаНДСВРознице)
			И ЗначениеЗаполнено(Строка.Номенклатура) Тогда
			
			СведенияОНоменклатуре = СоответствиеСведенийОНоменклатуре.Получить(Строка.Номенклатура);
			Если СведенияОНоменклатуре <> Неопределено Тогда
				Строка.СтавкаНДСВРознице = СведенияОНоменклатуре.СтавкаНДСВРознице;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТоварыСвернуты Тогда
		ТаблицаТоваров = Объект.Товары.Выгрузить();
		ТаблицаТоваров.Свернуть("СтавкаНДСВРознице", "СуммаПереоценки");
		Объект.Товары.Загрузить(ТаблицаТоваров);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииНоменклатурыСервер()

	СтрокаДанных = Объект.Товары.НайтиПоИдентификатору(Элементы.Товары.ТекущаяСтрока);

	СтрокаДанных.ЦенаВРознице = Ценообразование.ПолучитьЦенуНоменклатуры(СтрокаДанных.Номенклатура,
		ТипЦенРозничнойТорговли, Объект.Дата, ВалютаРегламентированногоУчета, 1, 1);

	СтрокаДанных.ЦенаВРозницеСтарая = УчетнаяЦена(СтрокаДанных.Номенклатура);

КонецПроцедуры

&НаСервереБезКонтекста
Функция СведенияОСкладе(Склад)
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Склад, "ТипСклада, ТипЦенРозничнойТорговли");
	
КонецФункции

&НаСервере
Функция ПроверитьЧтоНоменклатураУслуга(ВыбранноеЗначение)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВыбранноеЗначение, "Услуга");
	
КонецФункции

// Функция определяет текущую розничную цену номенклатуры, учитываемой в продажных ценах.
//
// Возвращаемое значение:
//  Число - цена до переоценки.
//
&НаСервере
Функция УчетнаяЦена(Номенклатура)

	ЦенаВРозницеСтарая = 0;

	Если ЗначениеЗаполнено(Объект.Склад) Тогда

		МассивНоменклатуры = Новый Массив;
		МассивНоменклатуры.Добавить(Номенклатура);
		
		ТаблицаЦен = УчетнаяЦенаСпискаНоменклатуры(МассивНоменклатуры);
		НайденнаяСтрока = ТаблицаЦен.Найти(Номенклатура, "Номенклатура");
		Если НайденнаяСтрока <> Неопределено Тогда
			ЦенаВРозницеСтарая = НайденнаяСтрока.ЦенаВРозницеСтарая;
		КонецЕсли;

	КонецЕсли;

	Возврат ЦенаВРозницеСтарая;

КонецФункции

// Функция определяет текущую розничную цену номенклатуры, учитываемой в продажных ценах.
//
// Возвращаемое значение:
//  Число - цена до переоценки.
//
&НаСервере
Функция УчетнаяЦенаСпискаНоменклатуры(МассивНоменклатуры)

	ТаблицаЦен = Новый ТаблицаЗначений;
	ТаблицаЦен.Колонки.Добавить("Номенклатура", 		Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаЦен.Колонки.Добавить("ЦенаВРозницеСтарая", 	ОбщегоНазначения.ОписаниеТипаЧисло(15, 2));

	Если ЗначениеЗаполнено(Объект.Склад) Тогда

		Запрос = Новый Запрос;

		// Установим параметры запроса.
		ПорядокСубконто = Новый Массив();
		ПорядокСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
		ПорядокСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);

		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Номенклатура",    МассивНоменклатуры);
		Запрос.УстановитьПараметр("Склад",           Объект.Склад);
		Запрос.УстановитьПараметр("КонецПериода",    Объект.Дата);
		Запрос.УстановитьПараметр("Организация",     Объект.Организация);
		Запрос.УстановитьПараметр("Счет",     		 ПланыСчетов.Хозрасчетный.ТоварыВРозничнойТорговлеВПродажныхЦенахАТТ);
		Запрос.УстановитьПараметр("ПорядокСубконто", ПорядокСубконто);

		Запрос.Текст =
			"ВЫБРАТЬ
			|	Остатки.Субконто1 КАК Номенклатура,
			|	Остатки.СуммаОстатокДт КАК СуммаОстаток,
			|	Остатки.КоличествоОстатокДт КАК КоличествоОстаток
			|ИЗ
			|	РегистрБухгалтерии.Хозрасчетный.Остатки(
			|			&КонецПериода,
			|			Счет = &Счет,
			|			&ПорядокСубконто,
			|			Организация = &Организация
			|				И Субконто1 В (&Номенклатура)
			|				И Субконто2 = &Склад) КАК Остатки
			|ГДЕ
			|	Остатки.КоличествоОстаток > 0";

		Выборка        = Запрос.Выполнить().Выбрать();

		Пока Выборка.Следующий() Цикл
			НоваяСтрока = ТаблицаЦен.Добавить();
			НоваяСтрока.Номенклатура = Выборка.Номенклатура;
			НоваяСтрока.ЦенаВРозницеСтарая = ?(Выборка.КоличествоОстаток = 0, 0, Окр(Выборка.СуммаОстаток / Выборка.КоличествоОстаток, 2, 1));
		КонецЦикла;

	КонецЕсли;

	ТаблицаЦен.Индексы.Добавить("Номенклатура");

	Возврат ТаблицаЦен;

КонецФункции

&НаКлиенте
Процедура РассчитатьСуммуПереоценки(СтрокаДанных)

	СтрокаДанных.СуммаПереоценки = СтрокаДанных.Количество
								 * (СтрокаДанных.ЦенаВРознице - СтрокаДанных.ЦенаВРозницеСтарая);

КонецПроцедуры

// Процедура проверяет данные перед вызовом сервисного механизма
// для заполнения Табличной части Товары.
//
// Параметры:
//  РежимЗаполнения - режим заполнения
//
&НаКлиенте
Процедура ДействиеЗаполнитьТовары(РежимЗаполнения)

	Если НЕ ЗначениеЗаполнено(Объект.Склад) Тогда
		ПоказатьПредупреждение( , НСтр("ru = 'Не выбран склад!'"));
		Возврат;
	КонецЕсли;

	Если Объект.Товары.Количество() > 0 Тогда
		ТекстВопроса     = НСтр("ru = 'Перед заполнением табличная часть будет очищена. Заполнить?'");
		ЗаголовокВопроса = НСтр("ru = 'Переоценка товаров в рознице'");
		Оповещение		 = Новый ОписаниеОповещения("ВопросПередЗаполнениемТабличнойЧастиЗавершение", ЭтотОбъект, РежимЗаполнения);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, ЗаголовокВопроса);
	Иначе
		ЗаполнитьТовары(РежимЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗаполнениемТабличнойЧастиЗавершение(Результат, РежимЗаполнения) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.Товары.Очистить();
		ЗаполнитьТовары(РежимЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросСвернутьТабличнуюЧастьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ТоварыСвернуты = (Результат = КодВозвратаДиалога.Да);
	
	Если Объект.Товары.Количество() > 0 Тогда
		ПриИзмененииСкладаНТТСервер();
	КонецЕсли;
	
	Объект.ДокументУстановкиЦен = Неопределено;
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОстаткам(Команда)

	ДействиеЗаполнитьТовары("ЗаполнитьПоОстаткам");

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоЦенам(Команда)

	ДействиеЗаполнитьТовары("ЗаполнитьПоЦенам");

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВозможностьПереоценки()

	Если ПоСтоимостиПриобретения Тогда
		ТекстПредупреждения = НСтр("ru = 'Переоценка товаров в рознице возможна только при
			|учете товаров по продажным ценам!'");
		ПоказатьПредупреждение( , ТекстПредупреждения);
		Объект.Организация = Неопределено;
		Возврат;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыПодбора(ИмяТаблицы)

	ПараметрыФормы = Новый Структура;

	ДатаРасчетов 	 = ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()), Неопределено, Объект.Дата);
	ЗаголовокПодбора = НСтр("ru = 'Подбор номенклатуры в %1 (%2)'");

	ПредставлениеТаблицы = НСтр("ru = 'Товары'");
	
	Параметрыформы.Вставить("ТипЦен"             , ТипЦенРозничнойТорговли);
	Параметрыформы.Вставить("ПоказыватьЦены"     , ЗначениеЗаполнено(ТипЦенРозничнойТорговли));
	Если ТипСклада <> ПредопределенноеЗначение("Перечисление.ТипыСкладов.НеавтоматизированнаяТорговаяТочка") Тогда
		ПараметрыФормы.Вставить("ПоказыватьОстатки"    , Истина);
		ПараметрыФормы.Вставить("КомандаВыбратьОстаток", Истина);
	КонецЕсли;

	ЗаголовокПодбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокПодбора, Объект.Ссылка, ПредставлениеТаблицы);

	ПараметрыФормы.Вставить("ЕстьЦена"      , Истина);
	ПараметрыФормы.Вставить("ЕстьКоличество", Истина);
	ПараметрыФормы.Вставить("ДатаРасчетов"  , ДатаРасчетов);
	ПараметрыФормы.Вставить("Валюта"        , ВалютаРегламентированногоУчета);
	ПараметрыФормы.Вставить("Организация"   , Объект.Организация);
	ПараметрыФормы.Вставить("Подразделение" , Объект.ПодразделениеОрганизации);
	ПараметрыФормы.Вставить("Склад"         , Объект.Склад);
	ПараметрыФормы.Вставить("Заголовок"     , ЗаголовокПодбора);
	ПараметрыФормы.Вставить("ВидПодбора"    , ПолучитьВидПодбора(ИмяТаблицы));
	ПараметрыФормы.Вставить("ИмяТаблицы"    , ИмяТаблицы);
	ПараметрыФормы.Вставить("Услуги"        , ИмяТаблицы = "Услуги");

	Возврат ПараметрыФормы;

КонецФункции

&НаКлиенте
Функция ПолучитьВидПодбора(ИмяТаблицы)

	ВидПодбора = "";

	Если ЗначениеЗаполнено(Объект.Склад)
		И ТипСклада = ПредопределенноеЗначение("Перечисление.ТипыСкладов.НеавтоматизированнаяТорговаяТочка") Тогда
		ВидПодбора = "НТТ";
	КонецЕсли;

	Возврат ВидПодбора;

КонецФункции

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, ИмяТаблицы)

	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресПодобраннойНоменклатурыВХранилище);
	
	МассивНоменклатуры = ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаТоваров, "Номенклатура", Истина);
	
	ТаблицаЦен = УчетнаяЦенаСпискаНоменклатуры(МассивНоменклатуры);

	Для Каждого СтрокаТовара Из ТаблицаТоваров Цикл
		НоваяСтрока = Объект[ИмяТаблицы].Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТовара);
		НоваяСтрока.ЦенаВРознице = СтрокаТовара.Цена;
		МетаданныеДокумента = Объект.Ссылка.Метаданные();
		Если ИмяТаблицы = "Товары" Тогда
			НайденнаяСтрока = ТаблицаЦен.Найти(СтрокаТовара.Номенклатура, "Номенклатура");
			Если НайденнаяСтрока <> Неопределено Тогда
				НоваяСтрока.ЦенаВРозницеСтарая = НайденнаяСтрока.ЦенаВРозницеСтарая;
			КонецЕсли;
		 КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// Процедура выполняет заполнение табличной части по остаткам.
//
&НаСервере
Процедура ЗаполнитьТовары(РежимЗаполнения = "ЗаполнитьПоОстаткам") Экспорт

	ПорядокСубконто = Новый Массив;
	ПорядокСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	Если ПланыСчетов.Хозрасчетный.ТоварыВРозничнойТорговлеВПродажныхЦенахАТТ.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады) <> Неопределено Тогда
		ПорядокСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
		ЕстьСубконтоСклады = Истина;
	Иначе
		ЕстьСубконтоСклады = Ложь;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Склад",              Объект.Склад);
	Запрос.УстановитьПараметр("КонецПериода",       Объект.Дата);
	Запрос.УстановитьПараметр("Организация",        Объект.Организация);
	Запрос.УстановитьПараметр("Счет",               ПланыСчетов.Хозрасчетный.ТоварыВРозничнойТорговлеВПродажныхЦенахАТТ);
	Запрос.УстановитьПараметр("ПорядокСубконто",    ПорядокСубконто);

	Запрос.Текст = "
		|ВЫБРАТЬ
		|	Остатки.Субконто1 КАК Номенклатура,
		|	СУММА(Остатки.СуммаОстатокДт) КАК СуммаОстаток,
		|	СУММА(Остатки.КоличествоОстатокДт) КАК КоличествоОстаток
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&КонецПериода,
		|			Счет = &Счет,
		|			&ПорядокСубконто,
		|			Организация = &Организация
		|				И &УсловиеСклад
		|	) КАК Остатки
		|ГДЕ
		|	Остатки.КоличествоОстаток > 0
		|
		|СГРУППИРОВАТЬ ПО
		|	Остатки.Субконто1
		|";

	Если ЕстьСубконтоСклады Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСклад", "Субконто2 = &Склад");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСклад", "ИСТИНА");
	КонецЕсли;

	ТаблицаОстатков= Запрос.Выполнить().Выгрузить();
	Валюта         = Константы.ВалютаРегламентированногоУчета.Получить();
	СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Валюта, Объект.Дата);
	Курс           = СтруктураКурса.Курс;
	Кратность      = СтруктураКурса.Кратность;

	МассивНоменклатуры 	= ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаОстатков, "Номенклатура", Истина);
	ТаблицаЦен 			= Ценообразование.ПолучитьТаблицуЦенНоменклатуры(МассивНоменклатуры, ТипЦенРозничнойТорговли, Объект.Дата);

	Для Каждого Выборка Из ТаблицаОстатков Цикл

		ДобавитьСтроку = Истина;
		Номенклатура = Выборка.Номенклатура;
		Количество = Выборка.КоличествоОстаток;
		ЦенаВРозницеСтарая = ?(Выборка.КоличествоОстаток = 0, 0, Окр(Выборка.СуммаОстаток / Выборка.КоличествоОстаток, 2, 1));

		НайденнаяСтрока = ТаблицаЦен.Найти(Выборка.Номенклатура, "Номенклатура");
		Если НайденнаяСтрока <> Неопределено Тогда
			ЦенаПоТипуЦен = РаботаСКурсамиВалютБПКлиентСервер.ПересчитатьИзВалютыВВалюту(
				НайденнаяСтрока.Цена, НайденнаяСтрока.Валюта, Валюта,
				НайденнаяСтрока.Курс, Курс,
				НайденнаяСтрока.Кратность, Кратность);
		Иначе
			ЦенаПоТипуЦен = 0;
		КонецЕсли;

		Если РежимЗаполнения = "ЗаполнитьПоЦенам" Тогда
			Если ЦенаПоТипуЦен > 0
					И ЦенаПоТипуЦен <> ЦенаВРозницеСтарая
					И Количество > 0 Тогда
				ЦенаВРознице = ЦенаПоТипуЦен;
			Иначе
				ДобавитьСтроку = Ложь;
			КонецЕсли;
		Иначе
			ЦенаВРознице = ЦенаПоТипуЦен;
		КонецЕсли;

		Если ДобавитьСтроку Тогда
			СтрокаТабличнойЧасти = Объект.Товары.Добавить();
			СтрокаТабличнойЧасти.Номенклатура       = Номенклатура;
			СтрокаТабличнойЧасти.Количество         = Количество;
			СтрокаТабличнойЧасти.ЦенаВРозницеСтарая = ЦенаВРозницеСтарая;
			СтрокаТабличнойЧасти.ЦенаВРознице       = ЦенаВРознице;
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти
